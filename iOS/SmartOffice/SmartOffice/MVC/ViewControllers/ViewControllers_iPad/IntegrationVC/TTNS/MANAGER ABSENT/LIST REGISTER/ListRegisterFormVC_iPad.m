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
#import "Common.h"
#import "RegisterInOutModel.h"
#import "TTNSSessionModel.h"
#import "SOSessionManager.h"
#import "NSException+Custom.h"
#import "SVPullToRefresh.h"
#import "WorkNoDataView.h"

@interface ListRegisterFormVC_iPad ()<UITableViewDataSource, UITableViewDelegate>{
@protected NSMutableArray *leaveFormArr;
@protected LeaveFormModel *model;
@protected NSInteger _currentItems;
@protected NSInteger _increateItems;
}

@end

@implementation ListRegisterFormVC_iPad

#pragma mark Lifecycler
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mTitle.text = @"Danh sách đăng ký";
    [self loadData];
    [self setupUI];
    self.tableView.estimatedRowHeight = 112;
    [self initValues];
    [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark UI
- (void)setupUI{
    [self.tabBarController.tabBar setHidden:YES];
    leaveFormArr = [[NSMutableArray alloc]init];
}

- (void)initValues{
    _currentItems = 20;
    _increateItems = 20;
    
    // add pull to refresh
    __weak ListRegisterFormVC_iPad *weakSelf = self;
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

- (void)showWorkNoData{
    
}

- (void)showViewNoData{
    self.tableView.hidden = YES;
    WorkNoDataView *workNoDataView = (WorkNoDataView *)([[UINib nibWithNibName:@"WorkNoDataView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    workNoDataView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    workNoDataView.contenLB.text = LocalizedString(@"TTNS_NO_DATA");
    [self.view insertSubview:workNoDataView belowSubview:self.floatingButton];
}

- (void)showNoConnectedView{
    DLog(@"Show view when not connect");
}

- (void)showPopupDelete:(NSInteger)leaveformID params:(NSDictionary*)params{
    UIAlertController* alertView    = [UIAlertController alertControllerWithTitle:LocalizedString(@"TTNS_XAC_NHAN_BBBG") message:LocalizedString(@"Bạn chắc chắn muốn xoá đơn xin nghỉ này?") preferredStyle:UIAlertControllerStyleAlert];
    
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
    
    if ([Common checkNetworkAvaiable]) {
        [[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
        [TTNSProcessor getTTNS_DANH_SACH_DON_NGHI_PHEP:[GlobalObj getInstance].ttns_employID type:0 callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            [[Common shareInstance]dismissHUD];
            if(success){
                DLog(@"ListRegister completion: %@", resultDict);
                NSArray *data = resultDict[@"data"][@"entity"];
                leaveFormArr = [LeaveFormModel arrayOfModelsFromDictionaries:data error:nil];
                leaveFormArr = [self removeObjectFormArr:leaveFormArr];
                leaveFormArr = [self sortArray:leaveFormArr];
                model = leaveFormArr[0];
                // get first personal form ID to show detail in ipad
                [self.delegate getFirstPersonalFormId:model.personalFormId status:model.status];
                [self.tableView reloadData];
                if(leaveFormArr.count == 0){
                    [self showViewNoData];
                }
            } else {
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



#pragma mark : UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return leaveFormArr.count > _currentItems ? _currentItems : leaveFormArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier     = @"ListRegisterFormCell_iPad";
    ListRegisterFormCell_iPad *cell          = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell                           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    LeaveFormModel *leaveForm           = leaveFormArr[indexPath.row];
    //    cell.typeRegisterLB.text            = leaveForm.title;
    //    cell.addresLB.text                  = leaveForm.location;
    cell.timeLB.text                = [NSString stringWithFormat:@"%@ -> %@", [self convertTimeStampToDateStr:(leaveForm.fromDate) format:@"HH:mm - dd/MM/yyyy"], [self convertTimeStampToDateStr:(leaveForm.toDate) format:@"HH:mm - dd/MM/yyyy"]];
    
    
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
            cell.stateIcon.image        = [UIImage imageNamed:@"icon_chua_trinh_ky"];
            break;
    }
    
    return cell;
}

#pragma mark UITableview Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

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
                                                                    handler:^(UITableViewRowAction *action,     NSIndexPath *indexPath){
                                                                        DLog(@"%ld",(long)indexPath.row);
                                                                        
                                                                        LeaveFormModel *leaveForm = leaveFormArr[indexPath.row];
                                                                        NSDictionary *paramsmeters    = @{
                                                                                                          @"form_type_id" : @(leaveForm.type) ,
                                                                                                          @"personal_form_id" : @(leaveForm.personalFormId)
                                                                                                          };
                                                                        [self showPopupDelete:leaveForm.personalFormId params:paramsmeters];
                                                                        //                                                                      [leaveFormArr removeObjectAtIndex:indexPath.row];
                                                                        //                                                                            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
                                                                        //                                                                      [self.tableView reloadData];
                                                                    }];
    
    delete.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    return @[delete];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    model = leaveFormArr[indexPath.row];
    [self.delegate getSelectedPersonalFormId:model.personalFormId status:model.status];
}

#pragma mark IBAction

- (IBAction)createNewAction:(id)sender {
    if([Common checkNetworkAvaiable]){
        CreateNewFormVC_iPad *vc = [[CreateNewFormVC_iPad alloc]initWithNibName:@"CreateNewFormVC_iPad" bundle:nil];
        [self pushIntegrationVC:vc];
    } else {
        [[Common shareInstance] showErrorHUDWithMessage:LocalizedString(@"Không có kết nối mạng") inView:self.view];
    }
}

@end
