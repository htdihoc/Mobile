//
//  TimeKeepingCalendarDetail.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/19/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TimeKeepingCalendarDetail.h"
#import "TimeKeepingCalendar.h"
#import "TTNS_TimeKeepingDayModel.h"
#import "ProcessTimeKeeping.h"
#import "DismissTimeKeeping.h"
#import "AlertFlatView.h"
#import "SOSessionManager.h"
#import "NSDictionary+RangeOfMonth.h"
#import "NSException+Custom.h"
#import "GlobalObj.h"
#import "FCAlertView.h"
#import "NSDate+Utilities.h"
#import "NSString+Util.h"
#import "Common.h"
#import "NSException+Custom.h"
@interface TimeKeepingCalendarDetail () <TimeKeepingCalendarDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerTimeKeepingView;

@property (strong, nonatomic) TimeKeepingCalendar *timeKeepingView;

@end

@implementation TimeKeepingCalendarDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backTitle = LocalizedString(@"TTNS_UMTimeKeepingDetail_Chi_tiết_công");
    if ([Common checkNetworkAvaiable]) {
        self.timekeepingController = [self.delegate getTimekeepingController];
        [self addTimeKeepingVC];
    }
    else
    {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    
}

- (void)addTimeKeepingVC
{
    self.timeKeepingView = NEW_VC_FROM_NIB(TimeKeepingCalendar, @"TimeKeepingCalendar");
    self.timeKeepingView.delegate = self;
    [self displayVC:self.timeKeepingView container:self.containerTimeKeepingView];
}

- (void)reloadData
{
    [self dismissHub];
    [self.timeKeepingView reloadData];
}
- (void)showPopupTimeKeeping:(NSDate *)date
{
    NSString *title = LocalizedString(@"TTNS_TimeKeepingCalendar_Thực_hiện_chấm_công");
    if (![date isToday]) {
        title = [NSString stringWithFormat:@"%@ \n (%@)", title, [date stringWithFormat:@"dd/MM/yyyy"]];
    }
    ProcessTimeKeeping *content = NEW_VC_FROM_NIB(ProcessTimeKeeping, @"ProcessTimeKeeping");
    [self showAlert:content title:title leftButtonTitle: LocalizedString(@"TTNS_InfoHumanVC_Đóng") rightButtonTitle:LocalizedString(@"TTNS_InfoHumanVC_Chấm_công") leftButtonColor:UIColorFromHex(0x303030) rightButtonColor:UIColorFromHex(0x027eba) leftHander:nil rightHander:^{
        //call API
        NSDictionary *contentValue = [content getValue];
        [self requestTimeKeeping:nil timeKeeping:[NSNumber numberWithDouble:[date timeIntervalSince1970]*1000] workPlaceType:[contentValue valueForKey:@"valueAddress"] workType:[contentValue valueForKey:@"valueTypeWork"] sourceData:nil privateKey:[SOSessionManager sharedSession].ttnsSession.privateKey];
    }];
}

- (void)showMessageWhenSelectUnCheckDate:(NSDate *)date increseMonth:(NSInteger)increseMonth
{
    DismissTimeKeeping *content = [[DismissTimeKeeping alloc] initWithNibName:@"DismissTimeKeeping" bundle:nil];
    [self keepAlertWhenTouch:YES];
    [self showAlert:content title:[NSString stringWithFormat:@"%@ %@", LocalizedString(@"TTNS_TimeKeepingCalendar_Huỷ_chấm_công"), [date stringWithFormat:@"dd/MM/yyyy"]] leftButtonTitle: LocalizedString(@"TTNS_TimeKeepingCalendar_Đóng") rightButtonTitle:LocalizedString(@"TTNS_TimeKeepingCalendar_Huỷ_chấm_công") leftHander:^{
        [self keepAlertWhenTouch:NO];
        
        
    } rightHander:^{
        DLog(@"%@", content.tv_Content.text);
        if ([content.tv_Content.text checkSpace]) {
            [self showToastWithMessage:LocalizedString(@"Bạn phải nhập lí do hủy chấm công")];
            return;
        }
        else
        {
            [self keepAlertWhenTouch:NO];
        }
        if ([Common checkNetworkAvaiable]) {
            [self.timekeepingController deleteTimeKeeping:[GlobalObj getInstance].ttns_employID content:content.tv_Content.text date:date increaseMonth:increseMonth completion:^(BOOL success, NSString *message, NSException *exception, BOOL isConnectNetwork, NSDictionary *error) {
                if (exception) {
                    [self handleErrorFromResult:nil withException:exception inView:self.view];
                    return ;
                }
                if (message) {
                    if ([message isEqualToString:@"Comment not found"]) {
                        [self showToastWithMessage:LocalizedString(@"Bạn phải nhập lí do hủy chấm công")];
                    }
                    else
                    {
                        [self showToastWithMessage:message];
                    }
                    
                }
                else
                {
                    if([self.delegate respondsToSelector:@selector(showError:)])
                    {
                        [self.delegate showError:LocalizedString(@"Huỷ chấm công thành công")];
                    }
                    else
                    {
                        [self showToastWithMessage:LocalizedString(@"Huỷ chấm công thành công")];
                    }
                    
                    [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
                    [self.delegate getListTimeKeeping:increseMonth];
                }
                if (!success) {
                    [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
                }
            }];
        }
        else
        {
            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
        }
        
    }];
}

- (void)showNotAvailableMessage
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.dismissOnOutsideTouch = 1;
    alert.hideDoneButton = 1;
    [alert showAlertWithTitle:LocalizedString(@"TTNS_UMTimeKeepingDetail_Cảnh_báo") withSubtitle:LocalizedString(@"TTNS_UMTimeKeepingDetail_Đ/c_chưa_có_quyền_chấm_công_cho_ngày_này") withCustomImage:nil withDoneButtonTitle:nil andButtons:nil];
}
- (void)showMessageWhenSelectLockedDate
{
    
}
#pragma mark TimeKeepingCalendarDelegate
- (BOOL)isLoaded
{
    return [self.delegate isLoaded];
}
- (void)changeMonth:(NSInteger)increaseMonth
{
    self.increseMonth = self.increseMonth + increaseMonth;
    
    if ([Common checkNetworkAvaiable]) {
        [[Common shareInstance] showCustomTTNSHudInView:self.view];
        [self.delegate getListTimeKeeping:self.increseMonth];
    }
    else
    {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    
}
- (NSInteger)getIncreaseMonth
{
    return self.increseMonth;
}
- (TimeKeepingCalendarType)getTypeOfTimeKeeping:(NSDate *)dateToCompare
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
- (BOOL)checkAvailableToTimeKeeping:(NSDate *)dateToCompare
{
    if (self.increseMonth <= 0) {
        return [self.timekeepingController checkAvailableToTimeKeeping:dateToCompare increaseMonth:self.increseMonth];
    }
    return NO;
}
- (void)selectedDate:(NSDate *)date
{
    TimeKeepingCalendarType status = [self.timekeepingController getState:date];
    if (status == Lock) {
        [self showToastWithMessage:LocalizedString(@"Ngày công đã bị khoá")];
    }
    else if (status == Waiting ||status == Reject)
    {
        [self showMessageWhenSelectUnCheckDate:date increseMonth:self.increseMonth];
    }
    else if (status == Approved ||
             status == LatedDay ||
             status == Approved2)
    {

        [self showToastWithMessage:@"Ngày công đã được duyệt"];
    }
    else
    {
        if ([self checkAvailableToTimeKeeping:date]) {
            [self showPopupTimeKeeping:date];
        }
        else
        {
            [self showNotAvailableMessage];
        }
    }
    //    switch (status) {
    //        case Lock:
    //            [self requestTimeKeeping:nil timeKeeping:[NSNumber numberWithDouble:[date timeIntervalSince1970]*1000] workPlaceType:nil workType:nil sourceData:nil privateKey:nil];
    //            break;
    //        case Waiting:
    //            [self dismissHub];
    //            [self showMessageWhenSelectUnCheckDate:date increseMonth:self.increseMonth];
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
    //        {
    //            [self dismissHub];
    //            if (status != Reject) {
    //                if ([self checkAvailableToTimeKeeping:date]) {
    //                    [self showPopupTimeKeeping:date];
    //                }
    //                else
    //                {
    //                    [self showNotAvailableMessage];
    //                }
    //            }
    //        }
    //            break;
    //    }
}
@end
