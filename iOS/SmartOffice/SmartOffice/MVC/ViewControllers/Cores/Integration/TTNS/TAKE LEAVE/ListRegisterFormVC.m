//
//  ListRegisterFormVC.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ListRegisterFormVC.h"
#import "ListRegisterFormCell.h"

#import "SOTableViewRowAction.h"
#import "TTNSProcessor.h"
#import "Common.h"
#import "TTNSSessionModel.h"
#import "SOSessionManager.h"
#import "NSException+Custom.h"
#import "SVPullToRefresh.h"
#import "LeaveFormModel.h"
#import "RefuseVC.h"
#import "CancelLeaveFormVC.h"
#import "RegTakeLeaveVC.h"
#import "WorkNoDataView.h"
#import "RegisterFormVC.h"
#import "DetailFormConfirmedVC.h"

@interface ListRegisterFormVC () <UITableViewDataSource, UITableViewDelegate>{
@protected NSMutableArray *leaveFormArr;
@protected NSInteger _currentItems;
@protected NSInteger _increateItems;
}

@end

@implementation ListRegisterFormVC

- (IBAction)back:(id)sender {
    [AppDelegateAccessor.navIntegrationVC popViewControllerAnimated:YES];}

- (IBAction)createNewAction:(id)sender {
    
}

#pragma mark LifeCycler
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loadData];
    [self setupUI];
    [self initValues];
    [self.tableView reloadData];
    
}

#pragma mark UI
- (void)setupUI{
    leaveFormArr = [[NSMutableArray alloc]init];
    [self.tabBarController.tabBar setHidden:YES];
    self.tableView.estimatedRowHeight = 140;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.backTitle      = LocalizedString(@"KLIST_REGISTER_FORM_BACK_TITLE");
}

- (void)showViewNoData{
    self.tableView.hidden = YES;
    WorkNoDataView *workNoDataView  = (WorkNoDataView *)([[UINib nibWithNibName:@"WorkNoDataView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    workNoDataView.frame            = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    workNoDataView.contenLB.text    = LocalizedString(@"TTNS_NO_DATA");
//    [self.view addSubview:workNoDataView];
    [self.view insertSubview:workNoDataView belowSubview:_showRegisterButton];
}

- (void)showNoConnectedView{
    DLog(@"Show view when not connect");
}

- (void)showPopupDelete:(NSInteger)leaveformID params:(NSDictionary*)params{
    UIAlertController* alertView    = [UIAlertController alertControllerWithTitle:LocalizedString(@"TTNS_TTNS_RegistryGoOut_Xác_nhận") message:LocalizedString(@"Bạn chắc chắn muốn xoá đơn xin nghỉ này?") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* closeButton      = [UIAlertAction actionWithTitle:LocalizedString(@"Huỷ bỏ") style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction* cancleFormButton = [UIAlertAction actionWithTitle:LocalizedString(@"Đồng ý") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //Delete form
        [self deleteData:leaveformID parameters:params];
        DLog("Delete form register leave success");
        
    }];
    
//    [cancleFormButton setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [alertView addAction:closeButton];
    [alertView addAction:cancleFormButton];
    alertView.view.tintColor = AppColor_MainTextColor;
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)initValues{
    _currentItems = 20;
    _increateItems = 20;
    
    // add pull to refresh
    __weak ListRegisterFormVC *weakSelf = self;
    _tableView.showsInfiniteScrolling = NO;
    [_tableView addInfiniteScrollingWithActionHandler: ^{
        DLog(@"+++ scroll to load");
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        if ([Common checkNetworkAvaiable]) {
            if(leaveFormArr.count > _currentItems){
                _currentItems = (leaveFormArr.count - _currentItems > _increateItems ? _increateItems : leaveFormArr.count - _currentItems) + _currentItems;
                [weakSelf.tableView reloadData];
                //                [self.tableView setContentOffset:CGPointZero animated:YES]; // auto scroll top tableview
            } else {
                weakSelf.tableView.showsInfiniteScrolling = NO;
            }
        }
        else
        {
            [weakSelf handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
        }
    }];
    
    _tableView.showsPullToRefresh = NO;
    [_tableView addPullToRefreshWithActionHandler:^{
        DLog(@"Refresh data here");
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        if ([Common checkNetworkAvaiable]) {
            
        }else
        {
            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
        }
        //Refresh data here
        // prepend data to dataSource, insert cells at top of table view
        // call [tableView.pullToRefreshView stopAnimating] when done
    } position:SVPullToRefreshPositionTop];
}

#pragma mark Action

- (NSMutableArray*)sortArray:(NSMutableArray*)inputArray{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"fromDate" ascending:NO];
    
    NSArray *sortedArray = [inputArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSMutableArray *sortedMutableArr = [[NSMutableArray alloc]initWithArray:sortedArray];
    return sortedMutableArr;
}

- (NSMutableArray*)removeObjectFormArr:(NSMutableArray<LeaveFormModel *>*)inputArr{
    NSMutableArray *discardedItems = [NSMutableArray array];
    LeaveFormModel *item;
    NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    NSInteger currentTime = [timestamp integerValue];
    
    for(item in inputArr){
        if(item.toDate < currentTime){
            [discardedItems addObject:item];
        }
    }
    
    [inputArr removeObjectsInArray:discardedItems];
    return inputArr;
}

#pragma mark networking
-(void)loadData{
    if([Common checkNetworkAvaiable]){
        [[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
        [TTNSProcessor getTTNS_DANH_SACH_DON_NGHI_PHEP:[GlobalObj getInstance].ttns_employID type:0 callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if(success){
                NSArray *data   = resultDict[@"data"][@"entity"];
                leaveFormArr    = [LeaveFormModel arrayOfModelsFromDictionaries:data error:nil];
                //Tea
                /*
                leaveFormArr    = [self removeObjectFormArr:leaveFormArr];
                 */
                leaveFormArr    = [self sortArray:leaveFormArr];
                [self.tableView reloadData];
                
                if(leaveFormArr.count == 0){
                    [self showViewNoData];
                }
                [[Common shareInstance]dismissHUD];
            } else {
                [[Common shareInstance]dismissHUD];
                [self showViewNoData];
            }
        }];
    } else {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    
}

-(void)deleteData: (NSInteger)Id parameters:(NSDictionary*)parameters{
    
    [TTNSProcessor postTTNS_HUY_DON_NGHI_PHEP:Id parameters:parameters withProgress:nil completion:^(NSDictionary *response) {
        DLog(@"Completion: %@", response);
    } onError:^(NSDictionary *error) {
        DLog(@"%@", error);
    } onException:^(NSException *exception) {
        DLog(@"%@", exception);
    }];
    
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return leaveFormArr.count > _currentItems ? _currentItems : leaveFormArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier     = @"ListRegisterFormCell";
    ListRegisterFormCell *cell          = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell                            = [[ListRegisterFormCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle             = UITableViewCellSelectionStyleNone;
    }
    
    LeaveFormModel *leaveForm           = leaveFormArr[indexPath.row];
    //    cell.addresLB.text                  = leaveForm.currentAddress;
    //    NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:leaveForm.fromDate];
    //    NSDate *toDate = [NSDate dateWithTimeIntervalSince1970:leaveForm.toDate];
    cell.addresLB.text                  = @"Phòng 2304 - VP2 - Linh Đàm";
    cell.timeLB.text                    = [NSString stringWithFormat:@"%@ -> %@", [self convertTimeStampToDateStr:leaveForm.fromDate format:@"HH:mm - dd/MM/yyyy"], [self convertTimeStampToDateStr:leaveForm.toDate format:@"HH:mm - dd/MM/yyyy"]];
    [cell.reasonLB setHidden:YES];
    
    switch (leaveForm.type) {
        case TTNS_Type_NghiPhep:
            cell.typeRegisterImg.image  = [UIImage imageNamed:@"icon_home"];
            cell.typeRegisterLB.text    = LocalizedString(@"KLIST_REGISTER_FORM_TYPE_1");
            break;
        case TTNS_Type_NghiViecRieng:
            cell.typeRegisterImg.image  = [UIImage imageNamed:@"icon_ngi_viec_rieng"];
            cell.typeRegisterLB.text    = LocalizedString(@"KLIST_REGISTER_FORM_TYPE_2");
            break;
        case TTNS_Type_NghiOm:
            cell.typeRegisterImg.image  = [UIImage imageNamed:@"icon_ngi_om"];
            cell.typeRegisterLB.text    = LocalizedString(@"KLIST_REGISTER_FORM_TYPE_3");
            break;
        case TTNS_Type_NghiConOm:
            cell.typeRegisterImg.image  = [UIImage imageNamed:@"icon_children"];
            cell.typeRegisterLB.text    = LocalizedString(@"KLIST_REGISTER_FORM_TYPE_4");
            break;
    }
    
    switch (leaveForm.status) {
        case StatusType_Refuse:
            cell.stateLB.text           = LocalizedString(@"KLIST_REGISTER_FORM_STATUS_TYPE_0");
            cell.stateLB.textColor      = [UIColor redColor];
            cell.stateIcon.image        = [UIImage imageNamed:@"icon_bi_tu_choi"];
            [cell.reasonLB setHidden:NO];
            cell.reasonLB.text          = @"Lý do từ chối: Không phù hợp";
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
            cell.stateIcon.image        = [UIImage imageNamed:@"icon_chua_trinh_ky"];
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeaveFormModel *leaveForm           = leaveFormArr[indexPath.row];
    if(leaveForm.status == StatusType_Refuse){
        return UITableViewAutomaticDimension;
    } else {
        return 140;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

#pragma mark TableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    LeaveFormModel *leaveForm = leaveFormArr[indexPath.row];
    if(leaveForm.status == StatusType_SIGN){
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
                                                                        [leaveFormArr removeObjectAtIndex:indexPath.row];
                                                                        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
                                                                        LeaveFormModel *leaveForm = leaveFormArr[indexPath.row];
                                                                        
                                                                        NSDictionary *parameters    = @{
                                                                                                        @"form_type_id" : @(leaveForm.type) ,
                                                                                                        @"personal_form_id" : @(leaveForm.personalFormId)
                                                                                                        };
                                                                        [self showPopupDelete:leaveForm.personalFormId params:parameters];
                                                                        [self.tableView reloadData];
                                                                    }];
    
    delete.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    return @[delete];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LeaveFormModel *leaveForm = leaveFormArr[indexPath.row];
    
    switch (leaveForm.status) {
        case StatusType_Refuse:
            // Bị từ chối
        {
            RefuseVC * vc           = [self.storyboard instantiateViewControllerWithIdentifier:@"RefuseVC"];
            vc.personalFormId       = leaveForm.personalFormId;
            vc.typeOfForm           = leaveForm.type;
            [self pushIntegrationVC:vc];
        }
            break;
            
        case StatusType_NotApproval:
            // Đang chờ phê duyệt
        {
            CancelLeaveFormVC *vc   = [self.storyboard instantiateViewControllerWithIdentifier:@"CancelLeaveFormVC"];
            vc.personalFormId       = leaveForm.personalFormId;
            vc.typeOfForm           = leaveForm.type;
            [self pushIntegrationVC:vc];
        }
            break;
        case StatusType_Approval:
            // Đã phê duyệt
        {
            DetailFormConfirmedVC *vc = NEW_VC_FROM_NIB(DetailFormConfirmedVC, @"DetailFormConfirmedVC");
            vc.personalFormId = leaveForm.personalFormId;
            vc.typeOfForm           = leaveForm.type;
            [self pushIntegrationVC:vc];
        }
            break;
            
        default:
            // Chưa trình ký// Trạng thái chờ
        {
            RegTakeLeaveVC *vc      = [self.storyboard instantiateViewControllerWithIdentifier:@"RegTakeLeaveVC"];
            vc.personalFormId       = leaveForm.personalFormId;
            vc.typeOfForm           = leaveForm.type;
            [self pushIntegrationVC:vc];
        }
            break;
    }
    
}

#pragma mark IBAction

- (IBAction)showRegisterAction:(id)sender {
    
    if([Common checkNetworkAvaiable]){
        RegisterFormVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterFormVC"];
        [AppDelegateAccessor.navIntegrationVC pushViewController:vc animated:YES];
    } else {
        [[Common shareInstance] showErrorHUDWithMessage:LocalizedString(@"Không có kết nối mạng") inView:self.view];
    }
}

@end
