//
//  CheckIn.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "CheckOutDetail.h"
#import "InfoEmployDetailCell.h"
#import "InfoEmployCheckOut.h"
#import "SOTableViewRowAction.h"
#import "DismissTimeKeeping.h"
#import "CheckOutDetailModel.h"
#import "CheckOutDetailCell.h"
@interface CheckOutDetail () <UITableViewDataSource, UITableViewDelegate>
{
@protected CheckOutDetailModel *infoEmployDetail;
@protected NSArray *keys;
@protected NSArray *values;
}


@end

@implementation CheckOutDetail

- (IBAction)back:(id)sender
{
    [self popToRoot];
    
}
- (void)generateData
{
    keys = @[@"Nơi đến", @"Lý do đăng ký", @"Lý do chi tiết", @"Thời gian ra ngoài"];
    values = @[@"Linh đàm hoàng mai",
             @"Gặp đối tác",
             @"Bàn về UX và UI",
             @"8h00 - 9hh00"];
    infoEmployDetail = [[CheckOutDetailModel alloc] initWithDesticationPlace:@"Linh đàm hoàng mai" reason:@"Gặp đối tác" reasonDetail:@"Bàn về UX và UI" timeInterval:@"8h00 - 9hh00"];
    [self.baseTableView reloadData];
}
- (NSString *)getValueWithKey:(NSString *)key
{
    return [infoEmployDetail valueForKey:key];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCellWith:@"CheckOutDetailCell"];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    [self generateData];
    // Do any additional setup after loading the view from its nib.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
// UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return keys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"CheckOutDetailCell";
    
    CheckOutDetailCell *cell             = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CheckOutDetailCell alloc]initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.lblTitle.text = keys[indexPath.row];
    cell.lblContent.text = values[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
@end
