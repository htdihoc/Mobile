//
//  ListRegisterFormVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ListRegisterFormVC_iPad.h"
#import "LeaveFormModel.h"
#import "TTNSProcessor.h"
#import "SOTableViewRowAction.h"
#import "ListRegisterFormCell_iPad.h"
#import "WorkNoDataView.h"
#import "CreateNewFormVC_iPad.h"

@interface ListRegisterFormVC_iPad ()<UITableViewDataSource, UITableViewDelegate>{
@protected NSMutableArray *leaveFormArr;
}

@end

@implementation ListRegisterFormVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 112;
    
    [self.tableView reloadData];
    
}

-(void)loadData{
    
    [TTNSProcessor getTTNS_DANH_SACH_DON_NGHI_PHEP:^(NSDictionary *response) {
        // Success
        DLog(@"ListRegister completion: %@", response);
        NSArray *data   = response[@"data"];
        leaveFormArr    = [LeaveFormModel arrayOfModelsFromDictionaries:data error:nil];
        [self.tableView reloadData];
    } onError:^(NSDictionary *error) {
        DLog(@"%@", error);
    } onException:^(NSException *exception) {
        DLog(@"%@", exception);
//        [self showViewNoData];
        // Show View when empty data
    }];
}

- (void)showWorkNoData{
    
}

- (void)showViewNoData{
    
    self.tableView.hidden = YES;
    WorkNoDataView *workNoDataView = (WorkNoDataView *)([[UINib nibWithNibName:@"WorkNoDataView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    workNoDataView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    workNoDataView.contenLB.text = LocalizedString(@"TTNS_NO_DATA");
    [self.view addSubview:workNoDataView];
//    WorkNoDataView *workNoDataView = [[WorkNoDataView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) contentData:LocalizedString(@"TTNS_NO_DATA")];
//    [self.view addSubview:workNoDataView];
}

-(void)deleteData: (NSInteger)Id{
    // Delete leave form
    [TTNSProcessor getTTNS_HUY_DON_NGHI_PHEP:Id :^(NSDictionary *response) {
        // Success
        DLog(@"Completion: %@", response);
    } onError:^(NSDictionary *error) {
        DLog(@"%@", error);
    } onException:^(NSException *exception) {
        DLog(@"%@", exception);
    }];
}


#pragma mark : UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return leaveFormArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier     = @"ListRegisterFormCell_iPad";
    ListRegisterFormCell_iPad *cell          = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell                            = [[ListRegisterFormCell_iPad alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle             = UITableViewCellSelectionStyleNone;
    }
    
    LeaveFormModel *leaveForm           = leaveFormArr[indexPath.row];
    cell.typeRegisterLB.text            = leaveForm.title;
    cell.addresLB.text                  = leaveForm.location;
    cell.timeLB.text                    = [NSString stringWithFormat:@"%ld -> %ld", leaveForm.timeStart, leaveForm.timeEnd];
    
    switch (leaveForm.type) {
        case TTNS_Type_NghiPhep:
            cell.typeRegisterImg.image  = [UIImage imageNamed:@"icon_home"];
            break;
        case TTNS_Type_NghiViecRieng:
            cell.typeRegisterImg.image  = [UIImage imageNamed:@"icon_children"];
            break;
        case TTNS_Type_NghiOm:
            cell.typeRegisterImg.image  = [UIImage imageNamed:@"icon_home"];
            break;
        case TTNS_Type_NghiConOm:
            cell.typeRegisterImg.image  = [UIImage imageNamed:@"icon_home"];
            break;
        case TTNS_Type_NghiVoSinh:
            cell.typeRegisterImg.image  = [UIImage imageNamed:@"icon_home"];
            break;
    }
    switch (leaveForm.status) {
        case StatusType_Refuse:
            cell.stateLB.text           = LocalizedString(@"KLIST_REGISTER_FORM_STATUS_TYPE_0");
            cell.stateLB.textColor      = [UIColor redColor];
            cell.stateIcon.image        = [UIImage imageNamed:@"icon_bi_tu_choi"];
            break;
        case StatusType_NotApproval:
            cell.stateLB.text           = LocalizedString(@"KLIST_REGISTER_FORM_STATUS_TYPE_1");
            cell.stateLB.textColor      = [UIColor orangeColor];
            cell.stateIcon.image        = [UIImage imageNamed:@"icon_cho_ky_duyet"];
            break;
        case StatusType_Approval:
            cell.stateLB.text           = LocalizedString(@"KLIST_REGISTER_FORM_STATUS_TYPE_2");
            cell.stateLB.textColor      = [UIColor blueColor];
            cell.stateIcon.image        = [UIImage imageNamed:@"icon_da_phe_duyet"];
            break;
        default:
            cell.stateLB.text           = LocalizedString(@"KLIST_REGISTER_FORM_STATUS_TYPE_3");
            cell.stateLB.textColor      = [UIColor grayColor];
            cell.stateIcon.image        = [UIImage imageNamed:@"icon_chua_ky_duyet"];
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    LeaveFormModel *leaveForm = leaveFormArr[indexPath.row];
    if(leaveForm.status == StatusType_Refuse){
        return YES;
    }
    return NO;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    SOTableViewRowAction *delete = [SOTableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                      title:@"   Huỷ   "
                                                                       icon:[UIImage imageNamed:@"icon_swipe_cancel"]
                                                                      color:[UIColor redColor]
                                                                    handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                        DLog(@"%ld",(long)indexPath.row);
                                                                        //                                                                     [leaveFormArr removeObjectAtIndex:indexPath.row];
                                                                        //                                                                     [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                                                        //                                                                     LeaveFormModel *leaveForm = leaveFormArr[indexPath.row];
                                                                        //                                                                     [self deleteData:(int)leaveForm.id];
                                                                        //                                                                     [tableView reloadData];
                                                                        [self deleteData:1]; // TEST DELETE FORM WITH ID = 1
                                                                        //                                                                        [self loadData];
                                                                        //                                                                        [self.tableView reloadData];
                                                                    }];
    
    delete.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    //    delete.backgroundColor = UIColor.orangeColor;
    return @[delete];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112;
}


- (IBAction)createNewAction:(id)sender {
    CreateNewFormVC_iPad *vc = [[CreateNewFormVC_iPad alloc]initWithNibName:@"CreateNewFormVC_iPad" bundle:nil];
    [self pushIntegrationVC:vc];
}
@end
