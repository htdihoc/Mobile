//
//  UMTimeKeepingDetail.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/19/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "UMTimeKeepingDetail.h"
#import "TimeKeepingCalendar.h"
#import "ApproveTimeKeeping.h"
#import "DismissTimeKeeping.h"
#import "AlertFlatView.h"
#import "NSDictionary+RangeOfMonth.h"
#import "NSDate+Utilities.h"
#import "NSException+Custom.h"
#import "Common.h"
#import "TTNS_ApproveTimeKeepingController.h"
#import "TTNS_EmployeeTimeKeeping.h"
#import "NSString+Util.h"
@interface UMTimeKeepingDetail () <ApproveTimeKeepingDelegate, TimeKeepingCalendarDelegate>
{
    NSDate *_selectedDate;
    BOOL _isLoaded;
    NSString *_selectedTimekeeping;
}
@property (weak, nonatomic) IBOutlet UIImageView *img_Profile;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Email;


@property (weak, nonatomic) IBOutlet UIView *timeKeepingDetail;
@property (strong, nonatomic) TimeKeepingCalendar *timeKeepingCalendars;
@property (strong, nonatomic) ApproveTimeKeeping *approveVC;
@end

@implementation UMTimeKeepingDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timekeepingController = [[TTNS_TimeKeepingCalendarDetailController alloc] init];
    self.leftBtnAttribute = [[BottomButton alloc] initWithDefautRedColor:LocalizedString(@"TTNS_UMTimeKeepingDetail_Từ_chối_toàn_bộ")];
    self.rightBtnAttribute = [[BottomButton alloc] initWithDefautBlueColor:LocalizedString(@"TTNS_UMTimeKeepingDetail_Phê_duyệt_toàn_bộ")];
    [self addTimeKeepingDetailVC];
    self.lbl_Name.text = LocalizedString(@"N/A");
    self.lbl_Email.text = LocalizedString(@"N/A");
    //    [self loadDataToComponents:[self.delegate getEmployee]];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.delegate respondsToSelector:@selector(getEmployeeID)]) {
        [self loadEmployeeInfo:[self.delegate getEmployeeID]];
    }
}
- (void)loadEmployeeInfo:(NSNumber *)employeeID
{
    
    [TTNS_ApproveTimeKeepingController loadDetailEmployee:employeeID.stringValue completion:^(BOOL success, NSDictionary *emloyeeDetail, NSException *exception, BOOL isConnectNetwork, NSDictionary *error) {
        TTNS_EmployeeTimeKeeping *model = [[TTNS_EmployeeTimeKeeping alloc] initWithDictionary:emloyeeDetail error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setDataForViews:model];
        });
    }];
}
- (void)setDataForViews:(TTNS_EmployeeTimeKeeping*)model;
{
    self.lbl_Name.text = model.fullName;
    self.lbl_Email.text = model.email;
}
- (void)loadDataToComponents:(EmployeeModel *)model
{
    //    self.img_Profile.image =
    self.lbl_Name.text = model.memberName;
    self.lbl_Email.text = model.email;
}
- (void)addTimeKeepingDetailVC
{
    self.timeKeepingCalendars = NEW_VC_FROM_NIB(TimeKeepingCalendar, @"TimeKeepingCalendar");
    self.timeKeepingCalendars.isUserManager = true;
    self.timeKeepingCalendars.delegate = self;
    [self displayVC:self.timeKeepingCalendars container:self.timeKeepingDetail];
}

- (void)showPopup
{
    //    self.lbl_Title.text = LocalizedString(@"TTNS_TimeKeepingPopup_Phê_duyệt_Công_ngày");
    //    self.lbl_Title.textColor = AppColor_MainTextColor;
    //
    //    self.lbl_TitleDate.text = _dateTitle;
    //    self.lbl_TitleDate.textColor = AppColor_MainTextColor;
    if (self.approveVC == nil) {
        self.approveVC = NEW_VC_FROM_NIB(ApproveTimeKeeping, @"ApproveTimeKeeping");
        self.approveVC.preferredContentSize = CGSizeMake(375, 80);
        self.approveVC.delegate = self;
    }
    [self showAlert:_approveVC title:[NSString stringWithFormat:@"%@ %@",LocalizedString(@"TTNS_TimeKeepingPopup_Phê_duyệt_Công_ngày"), [_selectedDate stringWithFormat:@"dd/MM/yyyy"]] titleAlign:NSTextAlignmentCenter leftButtonTitle:nil rightButtonTitle:nil leftHander:nil rightHander:nil];
    //    [self showAlert:_approveVC title:[NSString stringWithFormat:@"%@ %@",LocalizedString(@"TTNS_TimeKeepingPopup_Phê_duyệt_Công_ngày"), [_selectedDate stringWithFormat:@"\n dd/MM/yyyy"]] leftButtonTitle:nil rightButtonTitle:nil leftHander:nil rightHander:nil];
}
- (void)showMessageWhenSelectUnCheckDate:(NSDate *)date
{
    [self keepAlertWhenTouch:YES];
    DismissTimeKeeping *content = [[DismissTimeKeeping alloc]
                                   initWithNibName:@"DismissTimeKeeping" bundle:nil];
    content.isManager = YES;
    [self showAlert:content title:LocalizedString(@"Từ chối phê duyệt") leftButtonTitle: LocalizedString(@"TTNS_TimeKeepingCalendar_Đóng") rightButtonTitle:LocalizedString(@"Từ chối") leftHander:^{
        [self keepAlertWhenTouch:NO];
        
        
    } rightHander:^{
        if ([content.tv_Content.text checkSpace]) {
            [self showToastWithMessage:LocalizedString(@"Bạn phải nhập lý do từ chối")];
            return ;
        }
        else
        {
            [self keepAlertWhenTouch:NO];
        }
        [self disableButtons:YES];
        //Từ chối phê duyệt ở đây
        if ([Common checkNetworkAvaiable]) {
            [self disableButtons:YES];
            if (date) {
                if ([self.delegate respondsToSelector:@selector(updateATimeKeeping:managerID:timeKeepingID:reason:increseMonth:)]) {
                    [self.delegate updateATimeKeeping:TimeKeepingUpdateType_Reject managerID:[GlobalObj getInstance].ttns_managerID timeKeepingID:_selectedTimekeeping reason:content.tv_Content.text increseMonth:self.increseMonth];
                }
                
            }
            else
            {
                if ([self.delegate respondsToSelector:@selector(updateAllTimeKeeping:employeeID:managerID:comment:increseMonth:)]) {
                    [self.delegate updateAllTimeKeeping:TimeKeepingUpdateType_Reject employeeID:[GlobalObj getInstance].ttns_employID managerID:[GlobalObj getInstance].ttns_managerID comment:content.tv_Content.text increseMonth:self.increseMonth];
                }
                
            }
        }
        else
        {
            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
        }
        
    }];
}
- (void)didselectLeftButton
{
    [self showMessageWhenSelectUnCheckDate:nil];
}
- (void)didSelectRightButton
{
    if ([Common checkNetworkAvaiable]) {
        if ([self.delegate respondsToSelector:@selector(updateAllTimeKeeping:employeeID:managerID:comment:increseMonth:)]) {
            [self.delegate updateAllTimeKeeping:TimeKeepingUpdateType_Approve employeeID:[GlobalObj getInstance].ttns_employID managerID:[GlobalObj getInstance].ttns_managerID comment:@"" increseMonth:self.increseMonth];
        }
        [self disableButtons:YES];
    }
    else
    {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    
    
}

#pragma API CALL


- (void)getListTimeKeeping:(NSInteger)increseMonth
{
    if (increseMonth < 0) {
        [self disableButtons:YES];
    }
    else
    {
        [self disableButtons:NO];
    }
    //call API
    //    NSDictionary *params = @{@"employee_id":@41652, @"manager_id":@41652, @"from_time":@1493596800000, @"to_time":@1496188800000};
    //params here
    NSDictionary *rangeOfMonth = [NSDictionary getRangeOfMonthWith:increseMonth];
    //    [self.delegate getEmployee].memberId;
    [[Common shareInstance] showCustomTTNSHudInView:self.view];
    NSNumber *employeeID;
    if ([self.delegate respondsToSelector:@selector(getEmployeeID)]) {
        employeeID = [self.delegate getEmployeeID];
    }
    else
    {
        employeeID = [GlobalObj getInstance].ttns_employID;
    }
    [self.timekeepingController loadData:employeeID managerID:[GlobalObj getInstance].ttns_managerID fromTime:[rangeOfMonth valueForKey:@"firstDay"] toTime:[rangeOfMonth valueForKey:@"lastDay"] completion:^(BOOL success, NSArray *resultArray, NSException *exception, BOOL isConnectNetwork, NSDictionary *error) {
        [[Common shareInstance] dismissTTNSCustomHUD];
        _isLoaded = YES;
        [_timeKeepingCalendars reloadData];
        if (exception) {
            [self handleErrorFromResult:nil withException:exception inView:self.view];
            return ;
        }
        if (!success) {
            [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
        }
        
    }];
}
#pragma mark ApproveTimeKeepingDelegate
- (void)selectedAccept
{
    [self dismissAlert];
    if ([Common checkNetworkAvaiable]) {
        [self disableButtons:YES];
        if ([self.delegate respondsToSelector:@selector(updateAllTimeKeeping:employeeID:managerID:comment:increseMonth:)]) {
            [self.delegate updateATimeKeeping:TimeKeepingUpdateType_Approve managerID:[GlobalObj getInstance].ttns_managerID timeKeepingID:_selectedTimekeeping reason:nil increseMonth:self.increseMonth];
        }
    }
    else
    {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    
}

- (void)selectedReject
{
    [self dismissAlert];
    if ([Common checkNetworkAvaiable]) {
        [self showMessageWhenSelectUnCheckDate:_selectedDate];
    }
    else
    {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    
}

#pragma mark TimeKeepingCalendarDelegate
- (TimeKeepingCalendarType) getTypeOfTimeKeeping:(NSDate *)dateToCompare
{
    return [self.timekeepingController getState:dateToCompare];
}
- (NSString *)getTitle
{
    return [self.timekeepingController getTitle];
}
- (NSString *)getTotalTimeKeeping
{
    return [self.timekeepingController getTotalTimeKeeping];
}
- (void)selectedDate:(NSDate *)date
{
    _selectedDate = date;
    TimeKeepingCalendarType status = [self.timekeepingController getState:date];
    _selectedTimekeeping = [self.timekeepingController getTimeKeepingID:date];
    
    switch (status) {
        case Lock:
            [self showToastWithMessage:LocalizedString(@"Ngày công đã bị khoá")];
            break;
        case UnKnown:
            break;
        case Approved:
            [self showToastWithMessage:LocalizedString(@"Ngày công đã được phê duyệt")];
            break;
        case Approved2:
            [self showToastWithMessage:LocalizedString(@"Ngày công đã được phê duyệt")];
            break;
        case LatedDay:
            [self showToastWithMessage:LocalizedString(@"Ngày công đã được phê duyệt")];
            break;
        case Reject:
            [self showToastWithMessage:LocalizedString(@"Ngày công đã bị từ chối")];
            break;
        default:
        {
            [self showPopup];
            break;
        }
            
    }
    //    switch (status) {
    //        case Lock:
    //            [self showToastWithMessage:LocalizedString(@"UMTimeKeepingDetail_ngày_công_đã_bị_khoá_không_thể_phê_duyệt")];
    //            break;
    //        case Waiting:
    //            //bật ra pop up phê duyệt hoặc từ chối
    //            [self showPopup];
    //            break;
    //        case Approved | LatedDay:
    //            [self dismissHub];
    //            [self showToastWithMessage:LocalizedString(@"Ngày công đã được phê duyệt")];
    //            break;
    //        case Reject:
    //            [self dismissHub];
    //            [self showToastWithMessage:LocalizedString(@"Ngày công đã bị từ chối")];
    //            break;
    //        default:
    //            break;
    //    }
    
}
- (BOOL)checkAvailableToTimeKeeping:(NSDate *)dateToCompare
{
    if ([[NSDate date] compareSameMonthAndYearWithOtherDay:dateToCompare] == NSOrderedDescending || [[NSDate date] compareSameMonthAndYearWithOtherDay:dateToCompare] == NSOrderedSame || [[NSDate date] compareMonth:dateToCompare] == NSOrderedAscending)
    {
        return YES;
    }
    return NO;
}
- (void)changeMonth:(NSInteger)increaseMonth
{
    self.increseMonth = self.increseMonth + increaseMonth;
    _isLoaded = NO;
    [self getListTimeKeeping:self.increseMonth];
}
- (NSInteger)getIncreaseMonth
{
    return self.increseMonth;
}
- (BOOL)isLoaded
{
    return _isLoaded;
}
- (BOOL)isMasterRole
{
    return YES;
}
@end
