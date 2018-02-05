//
//  SickLeaveFormVC.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SickLeaveFormVC.h"
#import "ChoiseUserVC.h"
#import "UIView+BorderView.h"
#import "UIButton+BorderDefault.h"
#import "Common.h"
#import "TTNSProcessor.h"
#import "RegisterFormVC.h"

#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

typedef enum : NSInteger{
    nameTV_reason = 1,
    nameTV_location,
}nameTV;

@interface SickLeaveFormVC ()<UITextViewDelegate, TimePickerVCDelegate>{
@protected BOOL isChanged;
@protected NSDate *_selectedDate;
@protected NSString *_stringStartDate;
@protected NSString *_stringEndDate;
@protected NSString *_stringStartTimeDetail;
@protected NSString *_stringEndTimeDetail;
@protected  NSString *currentTime;
@protected BOOL isSickLeave;
}

@end

@implementation SickLeaveFormVC

#pragma mark LifeCycler

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    isChanged = NO;
    
}


#pragma mark UI

-(void)setupUI{
    [self setupTitleForLB];
    [self setBorderForView];
    [self hideView];
    [self setHintForTV];
    [self setTagForTV];
    [self setDelegateForTV];
     [self addTappGesture];
    currentTime = [NSString stringWithFormat:@"%@ -> %@", [[Common shareInstance] getCurrentTime], [[Common shareInstance] getCurrentTime]];
    self.phoneNumberTF.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)setupTitleForLB{
    self.backTitle  = @"Đơn xin nghỉ ốm";
    self.reasonLB.text              = LocalizedString(@"TTNS_LY_DO_NGHI");
    self.timeLB.text                = LocalizedString(@"TTNS_THOI_GIAN_NGHI");
    self.locationLB.text            = LocalizedString(@"TTNS_NOI_NGHI");
    self.phoneNumberLB.text         = LocalizedString(@"TTNS_SDT");
    self.handoverLB.text            = LocalizedString(@"TTNS_NGUOI_DUOC_BAN_GIAO");
    self.choiseHandOverLB.text      = [NSString stringWithFormat:@"- %@ -",LocalizedString(@"TTNS_CHON_NGUOI_BAN_GIAO")];
    self.managerLB.text             = LocalizedString(@"TTNS_CHI_HUY_DON_VI");
    self.choiseManagerLB.text       = [NSString stringWithFormat:@"- %@ -",LocalizedString(@"TTNS_CHON_CHI_HUY_DON_VI")];
    
    [self.timeButton setTitle:currentTime forState:UIControlStateNormal];
    
    [self.ghiLaiButton setTitle:LocalizedString(@"TTNS_GHI_LAI") forState:UIControlStateNormal];
    [self.trinhKyButton setTitle:LocalizedString(@"TTNS_TRINH_KY") forState:UIControlStateNormal];
}

- (void)setBorderForView{
    [self.reasonTV setBorderForView];
    [self.timeButton setDefaultBorder];
    [self.locationTV setBorderForView];
    [self.handOverUserView setBorderForView];
    [self.managerView setBorderForView];
    [self.handoverView setBorderForView];
}

- (void)hideView{
    [self.tabBarController.tabBar setHidden: YES];
    
    [self.managerUserView setHidden:YES];
    [self.handOverUserView setHidden:YES];
    
    [self.clearReasonBTN setHidden:YES];
    [self.clearLocationBTN setHidden:YES];
}

- (void)setHintForTV{
    self.reasonTV.placeholder       = LocalizedString(@"Nhập lý do nghỉ");
    self.locationTV.placeholder     = LocalizedString(@"Nhập nơi nghỉ");
}

- (void)setTagForTV{
    self.reasonTV.tag           = nameTV_reason;
    self.locationTV.tag         = nameTV_location;
}

- (void)setDelegateForTV{
    self.reasonTV.delegate           = self;
    self.locationTV.delegate         = self;
}

- (BOOL)isValidate{
    if(self.reasonTV != nil && ![self.reasonTV.text isEqualToString:@""]){
        if(self.timeButton != nil && ![self.timeButton.titleLabel.text isEqualToString:currentTime]){
            isChanged = YES;
            if(self.locationTV != nil && ![self.locationTV.text isEqualToString:@""]){
                if(self.phoneNumberTF != nil && ![self.phoneNumberTF.text isEqualToString:@""]){
                    DLog(@"Check chi huy don vi");
                    return YES;
                } else {
                    [[Common shareInstance]showErrorHUDWithMessage:[NSString stringWithFormat:@"%@ %@", LocalizedString(@"Bạn chưa nhập"), LocalizedString(@"TTNS_SDT")] inView:self.view];
                }
            } else {
                [[Common shareInstance]showErrorHUDWithMessage:[NSString stringWithFormat:@"%@ %@", LocalizedString(@"Bạn chưa nhập"), LocalizedString(@"TTNS_NOI_NGHI")] inView:self.view];
            }
        } else {
            [[Common shareInstance]showErrorHUDWithMessage:[NSString stringWithFormat:@"%@ %@", LocalizedString(@"Bạn chưa nhập"), LocalizedString(@"TTNS_THOI_GIAN_NGHI")] inView:self.view];
        }
    } else {
        [[Common shareInstance]showErrorHUDWithMessage:[NSString stringWithFormat:@"%@ %@", LocalizedString(@"Bạn chưa nhập"), LocalizedString(@"TTNS_LY_DO_NGHI")] inView:self.view];
    }
    return NO;
}

- (BOOL)isChangedValue{
    if(![self.timeButton.titleLabel.text isEqualToString:currentTime] ||
       ![self.phoneNumberTF.text isEqualToString:@""] // Check handover + manager user
       ){
        return YES;
    }
    return NO;
}

- (void)setTextForTimeGoOut:(NSString *)startDate startDateDetail:(NSString *)startDateDetail endDate:(NSString *)endDate endDateDetail:(NSString *)endDateDetail
{
    NSString *startTime     = [NSString stringWithFormat:@"%@ - %@", startDateDetail, startDate];
    NSString *endTime       = [NSString stringWithFormat:@"%@ - %@", endDateDetail, endDate];
    [self.timeButton setTitle:[NSString stringWithFormat:@"%@ -> %@", startTime, endTime] forState:UIControlStateNormal];
}

- (void)addTappGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark action

- (void)dismissKeyboard{
    //    [self.reasonTV resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark networking
//- (void)postSignRegister{
//    if([Common checkNetworkAvaiable]){
//        [[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
//        [self signRegister:self.personalFormId type:StatusType_Refuse callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
//            [[Common shareInstance]dismissHUD];
//            if(success){
//                DLog(@"Show dialog success");
//            } else {
//                [self handleErrorFromResult:resultDict withException:exception inView:self.view];
//            }
//        }];
//
//    } else {
//        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
//    }
//}
//
//- (void)postRegisterOrUpdate{
//    NSString *from_date_str     = [NSString stringWithFormat:@"%@ - %@",_stringStartTimeDetail, _stringStartDate];
//    NSString *to_date_str       = [NSString stringWithFormat:@"%@ - %@", _stringEndTimeDetail, _stringEndDate];
//    NSInteger from_date        = [self convertDateTimeToTimeStamp:from_date_str format:@"HH:mm - dd/MM/yyyy"];
//    NSInteger to_date          = [self convertDateTimeToTimeStamp:to_date_str format:@"HH:mm - dd/MM/yyyy"];
//
//    NSDictionary *params = @{@"type" : [NSNumber numberWithInteger:StatusType_Refuse],
//                             @"from_date" : [NSNumber numberWithInteger:from_date],
//                             @"to_date" : [NSNumber numberWithInteger:to_date]
//                             };
//
//    if([Common checkNetworkAvaiable]){
//        [[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
//        [self registerOrUpdate:params personalFormId:self.personalFormId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
//            [[Common shareInstance]dismissHUD];
//            if(success){
//                DLog(@"Show dialog");
//            } else {
//                [self handleErrorFromResult:resultDict withException:exception inView:self.view];
//            }
//        }];
//    } else {
//        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
//    }
//}

#pragma mark request server
- (void)signRegister:(NSInteger)personalFormId type:(NSInteger)type callBack:(Callback)callBack{
    [TTNSProcessor postCompassionateLeaveSign:personalFormId type:type callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}

- (void)registerOrUpdate:(NSDictionary*)params personalFormId:(NSInteger)personalFormId callBack:(Callback)callBack{
    [TTNSProcessor postRegisterOrUpdateLeave:params personalFormId:personalFormId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}

#pragma mark IBAction
- (IBAction)clearReasonAction:(id)sender {
    self.reasonTV.text      = @"";
}

- (IBAction)clearLocationAction:(id)sender {
    self.locationTV.text    = @"";
}

- (IBAction)choiseTimeAction:(id)sender {
    if (self.timePickerVC == nil) {
        self.timePickerVC = NEW_VC_FROM_NIB(TimePickerVC, @"TimePickerVC");
        self.timePickerVC.delegate = self;
    }
    [self presentViewController:self.timePickerVC animated:YES completion:nil];
}

- (IBAction)handOverAction:(id)sender {
    ChoiseUserVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChoiseUserVC"];
    [AppDelegateAccessor.navIntegrationVC pushViewController:vc animated:YES];
}

- (IBAction)managerAction:(id)sender {
    ChoiseUserVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChoiseUserVC"];
    [AppDelegateAccessor.navIntegrationVC pushViewController:vc animated:YES];
}

- (IBAction)ghiLaiAction:(id)sender {
    if([self isValidate]){
        DLog(@"Show dialog");
    }
}

- (IBAction)trinhKyAction:(id)sender {
    if([self isValidate]){
        DLog(@"Show Dialog");
    }
}

- (void)didTapBackButton{
    isChanged = [self isChangedValue];
    if(isChanged){
        [self showConfirmBackDialog:@"Bạn muốn huỷ thao tác?"];
    } else {
        [AppDelegateAccessor.navIntegrationVC popViewControllerAnimated:YES];
    }
}

#pragma mark TimePickerDelegate
- (void)didDismissView:(NSString *)startDate startDateDetail:(NSString *)startDateDetail endDate:(NSString *)endDate endDateDetail:(NSString *)endDateDetail
{
    _stringStartDate = startDate;
    _stringStartTimeDetail = startDateDetail;
    _stringEndDate = endDate;
    _stringEndTimeDetail = endDateDetail;
    [self setTextForTimeGoOut:startDate startDateDetail:startDateDetail endDate:endDate endDateDetail:endDateDetail];
}

- (NSString *)getStartDate
{
    return _stringStartDate;
}
- (NSString *)getStartDateDetail
{
    return _stringStartTimeDetail;
}
- (NSString *)getEndDate
{
    return _stringEndDate;
}
- (NSString *)getEndDateDetail
{
    return _stringEndTimeDetail;
}

#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    isChanged = YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    switch (textView.tag) {
        case nameTV_reason:
            [self.clearReasonBTN setHidden:NO];
            break;
        case nameTV_location:
            [self.clearLocationBTN setHidden:NO];
            break;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    switch (textView.tag) {
        case nameTV_reason:
            [self.clearReasonBTN setHidden:YES];
            break;
        case nameTV_location:
            [self.clearLocationBTN setHidden:YES];
            break;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        // Disable return key in keyboard
        //[textView resignFirstResponder];
        return NO;
    }
    
    if(textView.text.length + (text.length - range.length)> 256){
        DLog(@"Show Toast");
        [self showToastWithMessage:@"Không vượt quá 256 ký tự"];
    }
    return textView.text.length + (text.length - range.length) <= 256;
}

@end
