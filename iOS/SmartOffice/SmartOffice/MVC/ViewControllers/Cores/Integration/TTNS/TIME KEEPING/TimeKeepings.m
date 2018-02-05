//
//  CheckIn.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TimeKeepings.h"
#import "InfoEmployDetailCell.h"
#import "InfoEmployCheckOut.h"
#import "SOTableViewRowAction.h"
#import "DismissTimeKeeping.h"
#import "TimeKeepingCalendarDetail.h"
@interface TimeKeepings () <UITableViewDataSource, UITableViewDelegate>
{
@protected NSMutableArray<InfoEmployCheckOut *> *infoEmployDetails;
}


@end

@implementation TimeKeepings

- (IBAction)back:(id)sender
{
    [self popToRoot];
    
}
- (void)generateData
{
    infoEmployDetails = [[NSMutableArray alloc] init];
    for(int i = 0; i < 10; i++)
    {
        NSString *name = [NSString stringWithFormat:@"Nguyễn Tuấn Anh %d", i];
        NSString *content = [NSString stringWithFormat:@"ANHVT%d@gmail.com", i];
        NSString *time = [NSString stringWithFormat:@"Tổng ngày công thực 2%d", i];
        InfoEmployCheckOut *info = [[InfoEmployCheckOut alloc]
                                    initWithImg:[UIImage new]
                                    name:name
                                    content:content
                                    time:time];
        [infoEmployDetails addObject:info];
        
    }
    [self.baseTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCellWith:@"InfoEmployDetailCell"];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    [self generateData];
    // Do any additional setup after loading the view from its nib.
}

- (void)showCarlendar
{
    TimeKeepingCalendarDetail *timekeepingCalendar = NEW_VC_FROM_NIB(TimeKeepingCalendarDetail, @"TimeKeepingCalendarDetail");
    [self pushVC:timekeepingCalendar];
}
- (void)showDismissTimeKeeping
{
    DismissTimeKeeping *content = [[DismissTimeKeeping alloc] initWithNibName:@"DismissTimeKeeping" bundle:nil];
    [self showAlert:content title:@"Huỷ chấm công" leftButtonTitle:@"Đóng" rightButtonTitle:@"Từ chối" leftHander:nil rightHander:nil];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
//UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    SOTableViewRowAction *delete = [SOTableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                      title:@"Từ chối"
                                                                       icon:[UIImage imageNamed:@"uncheck_Button"]
                                                                      color:COLOR_FROM_HEX(0xf05253)
                                                                    handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                        [self showDismissTimeKeeping];
                                                                        DLog(@"%ld",(long)indexPath.row);
                                                                        
                                                                    }];
    SOTableViewRowAction *check = [SOTableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                     title:@"Phê duyệt"
                                                                      icon:[UIImage imageNamed:@"check_Button"]
                                                                     color:COLOR_FROM_HEX(0x0380ba)
                                                                   handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                       DLog(@"%ld",(long)indexPath.row);
                                                                       [self showCarlendar];
                                                                   }];
    check.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    //    delete.backgroundColor = UIColor.orangeColor;
    return @[check, delete];
}
// UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return infoEmployDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"InfoEmployDetailCell";
    
    InfoEmployDetailCell *cell             = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[InfoEmployDetailCell alloc]initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //    cell.imgProfile.image              = [UIImage imageNamed:infoEmployDetails[indexPath.row]];
    cell.lblName.text = infoEmployDetails[indexPath.row].name;
    cell.lblTitle.text = infoEmployDetails[indexPath.row].content;
    cell.lblSubTitle.text = infoEmployDetails[indexPath.row].time;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showCarlendar];
    
}
@end
