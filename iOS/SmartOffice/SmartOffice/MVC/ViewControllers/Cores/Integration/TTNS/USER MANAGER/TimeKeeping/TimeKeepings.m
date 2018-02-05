//
//  CheckIn.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TimeKeepings.h"
#import "TimeKeepingCell.h"
#import "TTNS_EmployeeTimeKeeping.h"
#import "SOTableViewRowAction.h"
#import "DismissTimeKeeping.h"
#import "UMTimeKeepingDetail.h"
#import "SVPullToRefresh.h"
#import "Common.h"
#import "WorkNoDataView.h"
#import "NSException+Custom.h"
#import "EmployeeModel.h"
#import "NSDictionary+RangeOfMonth.h"
#import "TTNS_ApproveTimeKeepingController.h"
#import "NSString+Util.h"
#import "NSException+Custom.h"
@interface TimeKeepings () <UITableViewDataSource, UITableViewDelegate, TimeKeepingCalendarDetailDelegate>{
    NSInteger _currentItems;
    NSInteger _increateItems;
    NSIndexPath *_lastIndex;
    NSMutableArray<TTNS_EmployeeTimeKeeping *> *_listEmployee;
    NSMutableArray<TTNS_EmployeeTimeKeeping *> *_cacheDataWhenNetworkingError;
    NSIndexPath *_swipeIndex;
    UMTimeKeepingDetail *_timekeepingDetail;
    BOOL _actionAtMasterVC;
    BOOL _isLoadCache;
    UILabel *messageContent;
}

@end

@implementation TimeKeepings
#pragma mark LifeCycler
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self initValues];
    [self.baseTableView reloadData];
    [self loadListEmployee];
}

- (void)initValues
{
    _listEmployee = [[NSMutableArray alloc] init];
    _cacheDataWhenNetworkingError = [[NSMutableArray alloc] init];
}
#pragma mark UI
- (void)setupUI{
    self.backTitle = LocalizedString(@"TTNS_TimeKeepings_Phê_duyệt_công");
    [self registerCellWith:@"TimeKeepingCell"];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    [self addPullRefresh];
}

- (void)addPullRefresh{
    _currentItems = 20;
    _increateItems = 20;
    
    // add pull to refresh
    __weak TimeKeepings *weakSelf = self;
//    weakSelf.baseTableView.showsInfiniteScrolling = NO;
//    [weakSelf.baseTableView addInfiniteScrollingWithActionHandler: ^{
//        DLog(@"+++ scroll to load");
//        [weakSelf.baseTableView.infiniteScrollingView stopAnimating];
//        if ([Common checkNetworkAvaiable]) {
//            
//        }
//        else
//        {
//            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
//        }
//    }];
    
    weakSelf.baseTableView.showsPullToRefresh = NO;
    [weakSelf.baseTableView addPullToRefreshWithActionHandler:^{
        DLog(@"Refresh data here");
        [weakSelf.baseTableView.pullToRefreshView stopAnimating];
            [self loadListEmployee];
        //Refresh data here
        // prepend data to dataSource, insert cells at top of table view
        // call [tableView.pullToRefreshView stopAnimating] when done
    } position:SVPullToRefreshPositionTop];
}

- (void)reject:(NSIndexPath *)index
{
    _actionAtMasterVC = YES;
    _swipeIndex = index;
    [self showMessageWhenSelectUnCheckDate:index];
}

- (void)accpet:(NSIndexPath *)index
{

    _actionAtMasterVC = YES;
    _swipeIndex = index;
    [self updateAllTimeKeeping:TimeKeepingUpdateType_Approve employeeID:[NSNumber numberWithDouble:[_listEmployee[index.row].employeeId doubleValue]] managerID:[GlobalObj getInstance].ttns_managerID comment:@"" increseMonth:0];
    
}

- (void)showMessageWhenSelectUnCheckDate:(NSIndexPath *)index
{
    [self keepAlertWhenTouch:YES];
    DismissTimeKeeping *content = [[DismissTimeKeeping alloc] initWithNibName:@"DismissTimeKeeping" bundle:nil];
    [self showAlert:content title:LocalizedString(@"Từ chối phê duyệt") leftButtonTitle: LocalizedString(@"TTNS_TimeKeepingCalendar_Đóng") rightButtonTitle:LocalizedString(@"Từ chối") leftHander:^{
        [self keepAlertWhenTouch:NO];
        
        
    } rightHander:^{
        [self updateAllTimeKeeping:TimeKeepingUpdateType_Reject employeeID:[NSNumber numberWithDouble:[_listEmployee[index.row].employeeId doubleValue]] managerID:[GlobalObj getInstance].ttns_managerID comment:content.tv_Content.text increseMonth:0];
        
        DLog(@"%@", content.tv_Content.text);
        //Từ chối phê duyệt ở đây
        
    }];
}
#pragma mark

- (void)updateAllTimeKeeping:(TimeKeepingUpdateType)type employeeID:(NSNumber *)employeeID managerID:(NSNumber *)managerID
                     comment:(NSString *)comment increseMonth:(NSInteger)increseMonth
{
    if (type == TimeKeepingUpdateType_Reject && [comment checkSpace]) {
        [self showToastWithMessage:LocalizedString(@"Bạn phải nhập lý do từ chối")];
        return;
    }
    else
    {
        [self keepAlertWhenTouch:NO];
    }
    if ([Common checkNetworkAvaiable]) {
        if (_actionAtMasterVC) {
            [[Common shareInstance] showCustomTTNSHudInView:self.view];
        }
        else
        {
            [[Common shareInstance] showCustomTTNSHudInView:_timekeepingDetail.view];
        }
        NSDictionary *rangeOfMonth = [NSDictionary getRangeOfMonthWith:increseMonth];
        [TTNS_TimeKeepingCalendarDetailController updateTimeKeeping:[self getEmployeeID] managerID:managerID updateType:type fromTime:[rangeOfMonth valueForKey:@"firstDay"] toTime:[rangeOfMonth valueForKey:@"lastDay"] comment:comment completion:^(BOOL success, NSException *exception, NSDictionary *error) {
            //catch 2001 here
            
            [[Common shareInstance] dismissTTNSCustomHUD];
            if (exception) {
                [self handleErrorFromResult:nil withException:exception inView:self.view];
            }
            if (success) {
                if (type == TimeKeepingUpdateType_Approve) {
                    [self showToastWithMessage:LocalizedString(@"Phê duyệt thành công")];
                }
                else
                {
                    [self showToastWithMessage:LocalizedString(@"Từ chối phê duyệt thành công")];
                    
                }
                [_timekeepingDetail getListTimeKeeping:increseMonth];
                [_listEmployee removeObjectAtIndex:_swipeIndex.row];
                _swipeIndex = nil;
                [self.baseTableView reloadData];
            }
            else
            {
                [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
            }
        }];
    }
    else
    {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    
}
- (void)updateATimeKeeping:(TimeKeepingUpdateType)type managerID:(NSNumber *)managerID timeKeepingID:(NSString *)timeKeepingID reason:(NSString *)reason increseMonth:(NSInteger)increseMonth
{
//    [_timekeepingDetail showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
    [[Common shareInstance] showCustomTTNSHudInView:_timekeepingDetail.view];
    [TTNS_TimeKeepingCalendarDetailController updateTimeKeeping:managerID timeKeeping:timeKeepingID updateType:type reason:reason completion:^(BOOL success, NSException *exception, NSDictionary *error) {
        [[Common shareInstance] dismissTTNSCustomHUD];
//        [_timekeepingDetail dismissHub];
        
        if (exception) {
            [self handleErrorFromResult:nil withException:exception inView:self.view];
            return;
        }
        if (error.allKeys.count == 1) {
            if (type == TimeKeepingUpdateType_Approve) {
                [self showToastWithMessage:LocalizedString(@"Phê duyệt không thành công")];
            }
            else
            {
                [self showToastWithMessage:LocalizedString(@"Từ chối không thành công")];
            }
            
            return;
        }
        if (success) {
            if (type == TimeKeepingUpdateType_Approve) {
                [self showToastWithMessage:LocalizedString(@"Phê duyệt thành công")];
            }
            else
            {
                [self showToastWithMessage:LocalizedString(@"Từ chối thành công")];
            }
            [_timekeepingDetail getListTimeKeeping:increseMonth];
        }
        else
        {
            [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
        }
    }];
}

#pragma mark TimeKeepingCalendarDetailDelegate
- (NSNumber *)getEmployeeID
{
    return [NSNumber numberWithDouble:[_listEmployee[_lastIndex.row].employeeId doubleValue]];
}

#pragma mark Action
- (void)showCarlendar
{
    //truyền employeeID sang.
    if (!_timekeepingDetail) {
        _timekeepingDetail = NEW_VC_FROM_NIB(UMTimeKeepingDetail, @"UMTimeKeepingDetail");
        _timekeepingDetail.delegate = self;
    }
    
    [self pushIntegrationVC:_timekeepingDetail];
}

- (IBAction)back:(id)sender
{
    [self popToIntegrationRoot];
    
}
- (void)loadListEmployee
{
    if ([Common checkNetworkAvaiable]) {
        [_cacheDataWhenNetworkingError removeAllObjects];
        [[Common shareInstance] showCustomTTNSHudInView:self.view];
        [TTNS_ApproveTimeKeepingController loadListEmployeeByManagerID:[GlobalObj getInstance].ttns_managerID fromTime:[[NSDictionary getRangeOfMonthWith:0]
                                                           valueForKey:@"firstDay"] endTime:[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]*1000] status:[NSNumber numberWithInt:0] completion:^(BOOL success, NSArray *resultArray, NSException *exception, BOOL isConnectNetwork, NSDictionary *error) {
            [[Common shareInstance] dismissTTNSCustomHUD];
            [self hideMessage];
            if (exception) {
                [self handleErrorFromResult:nil withException:exception inView:self.view];
                return ;
            }
            if (success) {
                [_listEmployee removeAllObjects];
                if ([resultArray isKindOfClass:[NSArray class]]) {
                    [self initModel:resultArray];
                }else
                {
                    [self showMessage:LocalizedString(@"Không có nhân viên nào")];
                }
            }
            else
            {
                if ([[error valueForKey:@"resultCode"] integerValue] == 2001) {
                    [self showToastWithMessage:LocalizedString(@"Hết thời gian đăng nhập xin hãy refresh lại ứng dụng")];
                }
                else
                {
                    [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
                }
                
            }
        }];
    }
    else
    {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
        [self getCacheModel];
    }
    
}
- (void)showMessage:(NSString *)message
{
    if (!messageContent) {
        messageContent = [[UILabel alloc] initWithFrame:self.view.frame];
        messageContent.textAlignment = NSTextAlignmentCenter;
        messageContent.font = [UIFont systemFontOfSize:16];
        [self.view addSubview:messageContent];
    }
    messageContent.hidden = NO;
    messageContent.text = message;
}
- (void)hideMessage
{
    messageContent.hidden = YES;
}
- (void)initModel:(NSArray *)employeeIDs
{
    for(NSNumber *employeeId in employeeIDs)
    {
        TTNS_EmployeeTimeKeeping *model = [[TTNS_EmployeeTimeKeeping alloc] init];
        model.employeeId = [employeeId stringValue];
        [_listEmployee addObject:model];
    }
    [self.baseTableView reloadData];
}
- (void)getCacheModel
{
    for(TTNS_EmployeeTimeKeeping *employee in _listEmployee)
    {
        if ([employee isLoaded]) {
            [_cacheDataWhenNetworkingError addObject:employee];
        }
    }
    [self.baseTableView reloadData];
    
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 89;
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cacheDataWhenNetworkingError.count > 0 ? _cacheDataWhenNetworkingError.count : _listEmployee.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TimeKeepingCell";
    if (![Common checkNetworkAvaiable] && _cacheDataWhenNetworkingError.count == 0) {
        
        [self getCacheModel];
        [tableView reloadData];
        return [UITableViewCell new];
    }
    
    TimeKeepingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TimeKeepingCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_cacheDataWhenNetworkingError.count > 0) {
        [cell loadEmployeeInfo:_cacheDataWhenNetworkingError[indexPath.row]];
    }
    else
    {
        [cell loadEmployeeInfo:_listEmployee[indexPath.row]];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _lastIndex = indexPath;
    _actionAtMasterVC = NO;
    if([Common checkNetworkAvaiable]){
        [[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self showCarlendar];
        [[Common shareInstance]dismissHUD];
    } else {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}
@end
