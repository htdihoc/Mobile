//
//  TimeKeepingDetailBase.m
//  SmartOffice
//
//  Created by NguyenVanTu on 6/23/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TimeKeepingDetailBase.h"
#import "DismissTimeKeeping.h"
#import "AlertFlatView.h"
#import "NSException+Custom.h"
#import "Common.h"
@interface TimeKeepingDetailBase ()

@end

@implementation TimeKeepingDetailBase

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backTitle = LocalizedString(@"TTNS_UMTimeKeepingDetail_Chi_tiết_công");
    // Do any additional setup after loading the view.
}

- (void)reloadData
{
    DLog(@"reload data");
}
- (void)setTimekeepingController:(TTNS_TimeKeepingCalendarDetailController *)timekeepingController
{
    _timekeepingController = timekeepingController;
}
- (void)requestTimeKeeping:(NSNumber *)employee_id timeKeeping:(NSNumber *)timeKeeping workPlaceType:(NSString *)workPlaceType workType:(NSString *)workType sourceData:(NSString *)sourceData privateKey:(NSString *)privateKey
{
    if ([Common checkNetworkAvaiable]) {
        NSNumber *currentEmployee_id = employee_id == nil ? [GlobalObj getInstance].ttns_employID : employee_id;
        NSNumber *currentTimeKeeping = timeKeeping == nil ? @0 : timeKeeping;
        NSString *currentWorkPlaceType = workPlaceType == nil ? @"" : workPlaceType;
        NSString *currentWorkType = workType == nil ? @"" : workType;
        NSString *currentSourceData = sourceData == nil ? [GlobalObj getInstance].ttns_timeKeepingSourceData : sourceData;
        NSString *currentPrivateKey = privateKey == nil ? @"" : privateKey;
        if (!self.timekeepingController) {
            self.timekeepingController = self.delegate.getTimekeepingController;
        }
        [self.timekeepingController timeKeepingWithID:currentEmployee_id timeKeeping:currentTimeKeeping workPlaceType:currentWorkPlaceType workType:currentWorkType sourceData:currentSourceData privateKey:currentPrivateKey completion:^(BOOL success, NSString *message, NSException *exception, BOOL isConnectNetwork, NSDictionary *error) {
            if (exception) {
                if ([self.delegate respondsToSelector:@selector(showError:)]) {
                    [self.delegate showError:LocalizedString(@"Không kết nối được đến máy chủ, xin vui lòng kiểm tra và thử lại sau!")];
                }else
                {
                    [self handleErrorFromResult:nil withException:exception inView:self.view];
                }
                
                return ;
            }
            if (message) {
                NSString *messContent = LocalizedString(message);
//                if ([message isEqualToString:@"Have time keeping this date"]) {
//                    messContent = LocalizedString(@"Ngày công đã được phê duyệt");
//                }
                if([self.delegate respondsToSelector:@selector(showError:)])
                {
                    [self.delegate showError:messContent];
                }
                else
                {
                    [self showToastWithMessage:messContent];
                    //                [self handleErrorFromResult:nil withException:[NSException initWithString:message] inView:self.view];
                }
                
                //            AlertFlatView *contentAlert = NEW_VC_FROM_NIB(AlertFlatView, @"AlertFlatView");
                //            contentAlert.content = message;
                //            [self showAlert:contentAlert title:LocalizedString(@"TTNS_UMTimeKeepingDetail_Thông_báo_lỗi") leftButtonTitle:nil rightButtonTitle:nil leftHander:nil rightHander:nil];
            }
            else
            {
                if([self.delegate respondsToSelector:@selector(showError:)])
                {
                    [self.delegate showError:LocalizedString(@"Chấm công thành công")];
                }
                else
                {
                    [self showToastWithMessage:LocalizedString(@"Chấm công thành công")];
                }
                
                [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
                [self.delegate getListTimeKeeping:_increseMonth];
            }
            if (!success) {
                if ([self.delegate respondsToSelector:@selector(showError:)]) {
                    [self.delegate showError:LocalizedString(@"Không kết nối được đến máy chủ, xin vui lòng kiểm tra và thử lại sau!")];
                }
                else
                {
                    [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
                }
                
            }
            
        }];
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(showError:)]) {
            [self.delegate showError:LocalizedString(@"Mất kết nối mạng")];
        }else
        {
            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
        }
        
        
    }
}

- (void)selectedDate:(NSDate *)date
{
    DLog(@"SelecedDate");
}
@end
