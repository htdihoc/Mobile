//
//  RegisterNewFormInOutVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "RegisterNewFormInOutVC_iPad.h"
#import "RegisterReason.h"
#import "DestinationPlaceList.h"
#import "ChoiseLocationVC_iPad.h"
#import "Common.h"
#import "TTNSProcessor.h"
#import "UIButton+BorderDefault.h"
#import "UIView+BorderView.h"
#import "MZFormSheetController.h"
#import "NSException+Custom.h"

@interface RegisterNewFormInOutVC_iPad ()<RegisterReasonDelegate, ChoiseLocationDelegate,TimePickerVCDelegate, UITextViewDelegate, MZFormSheetBackgroundWindowDelegate>{
    
@protected NSInteger workplaceID;
@protected NSInteger reasonId;
@protected BOOL isChanged;
@protected NSDate *_selectedDate;
@protected NSString *_stringStartDate;
@protected NSString *_stringEndDate;
@protected NSString *_stringStartTimeDetail;
@protected NSString *_stringEndTimeDetail;
@protected NSString *currentTime;
}

@end

@implementation RegisterNewFormInOutVC_iPad

#pragma mark Lifecycler

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.mTitle.text = @"Đăng ký mới ra ngoài";
    
}

#pragma mark UI
- (void)setupUI{
    [self setupButtonClearForTextview];
    [self setBorderForButton];
    [self setHindForTextview];
    [self addTappGesture];
    
    currentTime = [NSString stringWithFormat:@"%@ -> %@", [[Common shareInstance] getCurrentTime], [[Common shareInstance] getCurrentTime]];
    [self.timeButton setTitle:currentTime forState:UIControlStateNormal];
}

- (void)setHindForTextview {
    self.detailTV.placeholder = LocalizedString(@"Nhập lý do chi tiết");
}

- (void)addTappGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)setupTextForViews{
    //
    
}

- (void)setBorderForButton {
    [self.cancelButton setBorderForButton:3 borderWidth:1 borderColor:[AppColor_BorderForCancelButton CGColor]];
    self.sendRegisterButton.layer.cornerRadius = 3;
    [self.locationButton setDefaultBorder];
    [self.reasonButton setDefaultBorder];
    [self.detailTV setBorderForView];
    self.timeButton.layer.borderColor   = AppColor_BorderForView.CGColor;
    self.timeButton.layer.borderWidth   = 1;
    self.timeButton.layer.cornerRadius  = 3;
    
}

- (void)setupButtonClearForTextview {
    isChanged = NO;
    [self.btnClearDetailReason setHidden:YES];
    [self setDelegateForTV];
}

- (void)setDelegateForTV {
    self.detailTV.delegate    = self;
}

- (void)setTextForTimeGoOut:(NSString *)startDate startDateDetail:(NSString *)startDateDetail endDate:(NSString *)endDate endDateDetail:(NSString *)endDateDetail
{
    NSString *startTime     = [NSString stringWithFormat:@"%@ - %@", startDateDetail, startDate];
    NSString *endTime       = [NSString stringWithFormat:@"%@ - %@", endDateDetail, endDate];
    [self.timeButton setTitle:[NSString stringWithFormat:@"%@ -> %@", startTime, endTime] forState:UIControlStateNormal];
}

#pragma mark Networking
- (void)loadWorkPlaceWithId:(NSInteger)workPlaceId callBack:(Callback)callBack{
    [TTNSProcessor getWorkPlaceWithID:workPlaceId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}

- (void)loadReasonWithId:(NSInteger)reasID callBack:(Callback)callBack{
    [TTNSProcessor getReasonWithId:reasID callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}

- (void)registerInOut:(NSDictionary*)params callBack:(Callback)callBack{
    [TTNSProcessor postRegisterInOut:params callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}

#pragma mark action
//- (void)showReasons
//{
//    RegisterReason *reasonVC = NEW_VC_FROM_NIB(RegisterReason, @"RegisterReason");
//    reasonVC.delegate = self;
//    MZFormSheetController *formSheet = [[MZFormSheetController alloc]initWithViewController:reasonVC];
////    formSheet.presentedFormSheetSize = CGSizeMake(SCREEN_WIDTH_LANDSCAPE/4, SCREEN_WIDTH_LANDSCAPE/4);
//    formSheet.shadowRadius = 2.0;
//    formSheet.shadowOpacity = 0.3;
//    formSheet.cornerRadius = 12;
//    formSheet.shouldCenterVertically = YES;
//    formSheet.shouldDismissOnBackgroundViewTap = YES;
//    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
//
////     Test
//    formSheet.shouldCenterVertically = YES;
//    formSheet.transitionStyle   = MZFormSheetTransitionStyleSlideFromBottom;
//    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
//    }];
////    [self showAlert:reasonVC title:nil leftButtonTitle:nil rightButtonTitle:nil leftHander:nil rightHander:nil];
//}






- (void)showChoiseLocation{
    ChoiseLocationVC_iPad *choiseLocationVC = NEW_VC_FROM_NIB(ChoiseLocationVC_iPad, @"ChoiseLocationVC_iPad");
    choiseLocationVC.delegate = self;
    [self showAlert:choiseLocationVC title:nil leftButtonTitle:nil rightButtonTitle:nil leftHander:nil rightHander:nil];
}

- (void)showTimePicker {
    self.timePickerVC = NEW_VC_FROM_NIB(TimePickerVC, @"TimePickerVC");
    self.timePickerVC.delegate = self;
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:self.timePickerVC];
    formSheet.presentedFormSheetSize = CGSizeMake(SCREEN_WIDTH_LANDSCAPE/2, SCREEN_HEIGHT_LANDSCAPE - (SCREEN_HEIGHT_LANDSCAPE/2.5));
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.cornerRadius = 12;
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    }];
}

- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

- (void)sendRegisterForm{
//    NSInteger employeeId        = 44484;
    NSString *reasonDetail      = self.detailTV.text;
    
    //    NSString *fromTimeStr       = [NSString stringWithFormat:@"%@ %@", _stringStartDate, _stringStartTimeDetail];
    //    NSString *endTimeStr          = [NSString stringWithFormat:@"%@ %@", _stringEndDate, _stringEndTimeDetail];
    
    NSDictionary *parameters    = @{
                                    @"employee_id" : [GlobalObj getInstance].ttns_employID ,
                                    @"from_time" :  @1495731600000,
                                    @"end_time" : @1495818000000,
                                    @"reason_out_id" : @(reasonId) ,
                                    @"work_place_id" : @(workplaceID),
                                    @"reason_detail" : reasonDetail
                                    };
    
    [[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
    [self registerInOut:parameters callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        if(success){
            DLog(@"Register success: %@", resultDict);
            [[Common shareInstance]dismissHUD];
        } else {
            DLog(@"Register fail");
            [self handleErrorFromResult:resultDict withException:exception inView:self.view];
        }
    }];
}

- (void)showDialogConfirm{
    
    UIAlertAction *cancelButton     = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmButton    = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        DLog(@"Register Ok")
        [self sendRegisterForm];
        [AppDelegateAccessor.navIntegrationVC popViewControllerAnimated:YES];
    }];
    
    NSString *startTime     = [NSString stringWithFormat:@"%@ - %@",_stringStartTimeDetail, _stringStartDate];
    NSString *endTime       = [NSString stringWithFormat:@"%@ - %@",_stringEndTimeDetail, _stringEndDate];
    
    NSString *msg = [NSString stringWithFormat:@"Đ/c muốn thực hiện đăng ký ra ngoài từ thời gian %@ đến %@", startTime, endTime];
    
    [self showDialog:@"Xác nhận" messages:msg leftAction:cancelButton rightAction:confirmButton rightBtnColor:CommonColor_Blue tintColor:CommonColor_Gray];
}

- (BOOL)isValidate{
    if(self.locationButton != nil && ![self.locationButton.titleLabel.text isEqualToString:LocalizedString(@"Tầng 15 Crowne - Trần Hữu Dực")]){
        if(self.reasonButton != nil && ![self.reasonButton.titleLabel.text isEqualToString:LocalizedString(@"TTNS_RegisterWatchCell_Chọn")]){
            if(self.timeButton != nil && ![self.timeButton.titleLabel.text isEqualToString:currentTime]){
                if(self.detailTV != nil && ![[self.detailTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
                    return YES;
                } else {
                    [[Common shareInstance]showErrorHUDWithMessage:[NSString stringWithFormat:@"%@ %@", LocalizedString(@"Bạn chưa nhập"), LocalizedString(@"TTNS_NormalRegisterDetail_Lý_do_chi_tiết")] inView:self.view];
                }
            } else {
                [[Common shareInstance]showErrorHUDWithMessage:[NSString stringWithFormat:@"%@ %@", LocalizedString(@"Bạn chưa nhập"), LocalizedString(@"TTNS_THOI_GIAN_NGHI")] inView:self.view];
            }
        } else {
            [[Common shareInstance]showErrorHUDWithMessage:[NSString stringWithFormat:@"%@ %@", LocalizedString(@"Bạn chưa nhập"), LocalizedString(@"TTNS_LY_DO_NGHI")] inView:self.view];
        }
    } else {
        [[Common shareInstance]showErrorHUDWithMessage:[NSString stringWithFormat:@"%@ %@", LocalizedString(@"Bạn chưa nhập"), LocalizedString(@"CheckOutDetail_Nơi_đến")] inView:self.view];
    }
    return NO;
}

#pragma mark IBAction

- (IBAction)choiseRegisterReasonAction:(id)sender {
//    [self showReasons];
    
    RegisterReason *reasonVC = NEW_VC_FROM_NIB(RegisterReason, @"RegisterReason");
    reasonVC.delegate = self;
    
    UIPopoverController *formSheet = [[UIPopoverController alloc]initWithContentViewController:reasonVC];
    formSheet.popoverContentSize = CGSizeMake(320, 400);
    CGRect frameView = CGRectMake(16, 700, 524, 30);
    [formSheet presentPopoverFromRect:frameView inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionUp animated:YES];
    DLog(@"");
}

- (IBAction)choiseLocationAction:(id)sender {
    [self showChoiseLocation];
}

- (IBAction)choiseTimeAction:(id)sender {
    self.timePickerVC.delegate = self;
    [self showTimePicker];
}

- (IBAction)sendRegisterAction:(id)sender {
    DLog(@"didselectLeftButton");
    if([Common checkNetworkAvaiable]){
        if([self isValidate]){
            [self showDialogConfirm];
        }
    } else {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}

- (IBAction)cancelAction:(id)sender {
    if([Common checkNetworkAvaiable]){
        [self.locationButton setTitle:LocalizedString(@"Tầng 15 Crowne - Trần Hữu Dực") forState:UIControlStateNormal];
        [self.reasonButton setTitle:LocalizedString(@"TTNS_RegisterWatchCell_Chọn") forState:UIControlStateNormal];
        [self.timeButton setTitle:currentTime forState:UIControlStateNormal];
        self.detailTV.text = @"";
    } else {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}

- (IBAction)clearDetailReasonAction:(id)sender {
    self.detailTV.text = @"";
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

#pragma mark Reason Delegate
- (void)didFinishSelectReason:(RegisterReason *)vc reasonID:(NSInteger)reasonID title:(NSString *)title{
    [self.reasonButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark WorkPlace Delegate
- (void)passingLocation:(ChoiseLocationVC_iPad *)controller didFinishSelectItem:(NSString *)item{
    [self.locationButton setTitle:item forState:UIControlStateNormal];
}

#pragma mark TimePickerVCDelegate

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    isChanged = TRUE;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self.btnClearDetailReason setHidden:NO];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.btnClearDetailReason setHidden:YES];
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
