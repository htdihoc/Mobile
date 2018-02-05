//
//  RegisterFurloughDetail.m
//  SmartOffice
//
//  Created by NguyenDucBien on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "RegisterFurloughDetail.h"
#import "SearchHandler_iPad.h"
#import "ChoiseUserVC.h"
#import "DetailLeaveModel.h"
#import "RemainDayModel.h"
#import "UIButton+BorderDefault.h"
#import "UIView+BorderView.h"
#import "Common.h"
#import "TTNSProcessor.h"
#import "NSException+Custom.h"
#import "MZFormSheetController.h"

typedef enum : NSInteger{
    nameTV_reason = 1,
    nameTV_location,
    nameTV_handOver
}nameTV;

@interface RegisterFurloughDetail () <ChooseHandlerDelegate, UITextViewDelegate, TimePickerVCDelegate, MZFormSheetBackgroundWindowDelegate> {
@protected BOOL isChanged;
@protected  RemainDayModel *remainDayModel;
    
@protected NSDate *_selectedDate;
@protected NSString *_stringStartDate;
@protected NSString *_stringEndDate;
@protected NSString *_stringStartTimeDetail;
@protected NSString *_stringEndTimeDetail;
@protected NSString *currentTime;
}

@end

@implementation RegisterFurloughDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTittleLabel];
    [self setupUI];
    [self setupButtonClearForTextview];
    self.mTitle.text = @"Chi tiết đăng ký";
}

#pragma mark UI
- (void)setupTittleLabel {
    self.remainingDays.text = LocalizedString(@"TTNS_SO_NGAY_PHEP_CON_LAI");
    self.offReason.text = LocalizedString(@"TTNS_LY_DO_NGHI");
    self.timeOff.text = LocalizedString(@"TTNS_THOI_GIAN_NGHI");
    self.timeOffDetail.text = LocalizedString(@"TTNS_TONG");
    self.dateOver.text = LocalizedString(@"TTNS_NGAY_QUA_PHEP");
    self.dateNumber.text = LocalizedString(@"TTNS_NGAY_1");
    self.offPlace.text = LocalizedString(@"TTNS_NOI_NGHI");
    self.telNumber.text = LocalizedString(@"TTNS_SDT");
    self.noteLabel.text = LocalizedString(@"TTNS_NGUOI_DUOC_BAN_GIAO");
    self.contentHandlerChoose.text = [NSString stringWithFormat:@"- %@ -", LocalizedString(@"TTNS_CHON_NGUOI_BAN_GIAO")];
    self.handOverLabel.text = LocalizedString(@"TTNS_NOI_DUNG_BAN_GIAO");
    self.unitCommanderLabel.text = LocalizedString(@"TTNS_CHI_HUY_DON_VI");
    self.contentManagerUnit.text = [NSString stringWithFormat:@"- %@ -", LocalizedString(@"TTNS_CHON_CHI_HUY_DON_VI")];
    [self.registryButton setTitle:LocalizedString(@"TTNS_TRINH_KY") forState:UIControlStateNormal];
    [self.recordButton setTitle: LocalizedString(@"TTNS_GHI_LAI") forState:UIControlStateNormal];
    
    
    
}

- (void)setupUI {
    self.reasonTV.layer.borderColor                = AppColor_BorderForView.CGColor;
    self.reasonTV.layer.borderWidth                = 1;
    self.reasonTV.layer.cornerRadius               = 3;
    self.btnTimeOff.layer.borderColor              = AppColor_BorderForView.CGColor;
    self.btnTimeOff.layer.borderWidth              = 1;
    self.btnTimeOff.layer.cornerRadius             = 3;
    [self.btnTimeOff setTintColor:App_Color_MainTextBoldColor];
    self.timeContentLB.text = [NSString stringWithFormat:@"%@ -> %@", [[Common shareInstance] getCurrentTime], [[Common shareInstance] getCurrentTime]];
    self.locationTV.layer.borderColor              = AppColor_BorderForView.CGColor;
    self.locationTV.layer.borderWidth              = 1;
    self.locationTV.layer.cornerRadius             = 3;
    self.telNumberTextfile.layer.borderColor       = AppColor_BorderForView.CGColor;
    self.handoverContentTV.layer.borderColor       = AppColor_BorderForView.CGColor;
    self.handoverContentTV.layer.borderWidth       = 1;
    self.handoverContentTV.layer.cornerRadius      = 3;
    self.chooseHandlerButton.layer.borderColor     = AppColor_BorderForView.CGColor;
    self.chooseHandlerButton.layer.borderWidth     = 1;
    self.chooseHandlerButton.layer.cornerRadius    = 3;
    self.unitCommanderButton.layer.borderColor     = AppColor_BorderForView.CGColor;
    self.unitCommanderButton.layer.borderWidth     = 1;
    self.unitCommanderButton.layer.cornerRadius    = 3;
    
    
    
    [self setHindForTextview];
    [self setColorForText];
    
    [self addTappGesture];
}

- (void)setColorForText{
    self.contentHandlerChoose.textColor = AppColor_MainTextColor;
    self.contentManagerUnit.textColor   = AppColor_MainTextColor;
}

- (void)setHindForTextview {
    self.reasonTV.placeholder                       = LocalizedString(@"Nhập lý do nghỉ");
    self.locationTV.placeholder                     = LocalizedString(@"Nhập nơi nghỉ");
    self.telNumberTextfile.placeholder              = LocalizedString(@"Nhập số điện thoại");
    self.handoverContentTV.placeholder              = LocalizedString(@"Nhập nội dung bàn giao");
}

- (void)setupButtonClearForTextview {
    isChanged = NO;
    self.telNumberTextfile.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.btnClearReason setHidden:YES];
    [self.btnClearLocation setHidden:YES];
    [self.btnClearHandoverContent setHidden:YES];
    [self setDelegateForTV];
    [self setTagForTV];
}

- (void)setDelegateForTV {
    self.reasonTV.delegate                = self;
    self.locationTV.delegate              = self;
    self.handoverContentTV.delegate       = self;
}

- (void)setTagForTV {
    self.reasonTV.tag               = nameTV_reason;
    self.locationTV.tag             = nameTV_location;
    self.handoverContentTV.tag      = nameTV_handOver;
}

- (void)addTappGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}


- (void)showPopupChooseHandler {
    SearchHandler_iPad *vc = NEW_VC_FROM_NIB(SearchHandler_iPad, @"SearchHandler_iPad");
    vc.delegate = self;
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    formSheet.presentedFormSheetSize = CGSizeMake(SCREEN_WIDTH_LANDSCAPE/3, SCREEN_HEIGHT_LANDSCAPE/3);
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.cornerRadius = 12;
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    }];
}

- (void)passingString:(ChooseHandler *)controller didFinishChooseItem:(NSString *)item {
    [self.chooseHandlerButton setTitle:@"" forState:UIControlStateNormal];
    [self.contentHandlerChoose setText:item];
}

- (void)setTextForTimeGoOut:(NSString *)startDate startDateDetail:(NSString *)startDateDetail endDate:(NSString *)endDate endDateDetail:(NSString *)endDateDetail
{
    NSString *startTime     = [NSString stringWithFormat:@"%@ - %@", startDateDetail, startDate];
    NSString *endTime       = [NSString stringWithFormat:@"%@ - %@", endDateDetail, endDate];
    [self.timeContentLB setText:[NSString stringWithFormat:@"%@ -> %@", startTime, endTime]];
}

#pragma mark Networking
- (void)getRemainDay{
    if([Common checkNetworkAvaiable]){
        [[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
        [self loadRemainDay:[GlobalObj getInstance].ttns_employID callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            [[Common shareInstance]dismissHUD];
            if(success){
                DLog("Get Remain day success");
                NSDictionary *data = [resultDict valueForKey:@"data"];
                NSDictionary *entity = [data valueForKey:@"entity"];
                remainDayModel = [[RemainDayModel alloc]initWithDictionary:entity error:nil];
                self.remainingDaysValue.text = [NSString stringWithFormat:@"%ld", (long)remainDayModel.remainingAnnualDay];
            } else {
                [self handleErrorFromResult:resultDict withException:exception inView:self.view];
                
            }
        }];
    } else {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}

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
- (void)loadRemainDay:(NSNumber*)employeeId callBack:(Callback)callBack{
    [TTNSProcessor getRemainingAnnual:employeeId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}

- (void)postSignRegister:(NSInteger)personalFormId type:(NSInteger)type callBack:(Callback)callBack{
    [TTNSProcessor postCompassionateLeaveSign:personalFormId type:type callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}

- (void)postRegisterOrUpdate:(NSDictionary*)params personalFormId:(NSInteger)personalFormId callBack:(Callback)callBack{
    [TTNSProcessor postRegisterOrUpdateLeave:params personalFormId:personalFormId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}

#pragma mark action
- (void)dismissKeyboard{
    [self.view endEditing:YES];
}



- (void)showTimePicker {
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

#pragma mark IBAction

- (IBAction)chooseTimeOff:(id)sender {
    if (self.timePickerVC == nil) {
        self.timePickerVC = NEW_VC_FROM_NIB(TimePickerVC, @"TimePickerVC");
        self.timePickerVC.delegate = self;
        self.timePickerVC.isLockMinuteView = YES;
    }
    [self showTimePicker];
}

- (IBAction)clearReasonAction:(id)sender {
    self.reasonTV.text = @"";
}

- (IBAction)clearLocationAction:(id)sender {
    self.locationTV.text = @"";
}

- (IBAction)clearHandoverContentAction:(id)sender {
    self.handoverContentTV.text = @"";
}

- (IBAction)handlerButtonAction:(id)sender {
    [self showPopupChooseHandler];
}

- (IBAction)commanderButtonAction:(id)sender {
}

- (IBAction)registryButtonAction:(id)sender {
    if([Common checkNetworkAvaiable]){
        if([self isValidate]){
            DLog(@"SignAction")
        }
    } else {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    
}

- (IBAction)recordButtonAction:(id)sender {
    if([Common checkNetworkAvaiable]){
        if([self isValidate]){
            DLog(@"Save Action")
        }
    } else {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    
}

#pragma mark action
- (void)didTapBackButton{
    isChanged = [self isValidate];
    if(isChanged){
        [self showConfirmBackDialog:LocalizedString(@"Bạn muốn huỷ thao tác")];
        
    } else {
        DLog(@"nothing here");
        [super didTapBackButton];
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

#pragma mark checkTextview

- (BOOL)isValidate{
    if(self.reasonTV != nil && ![[self.reasonTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        NSString *currentTimeBTN = [NSString stringWithFormat:@"%@ -> %@", [[Common shareInstance] getCurrentTime], [[Common shareInstance] getCurrentTime]];
        if(self.timeContentLB != nil && ![self.timeContentLB.text isEqualToString:currentTimeBTN]){
            isChanged = YES;
            if(self.locationTV != nil && ![[self.locationTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
                if(self.telNumberTextfile != nil && ![[self.telNumberTextfile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
                    DLog(@"Check chi huy don vi")
                    isChanged = YES;
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

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    isChanged = TRUE;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    switch (textView.tag) {
        case nameTV_reason:
            [self.btnClearReason setHidden:NO];
            break;
        case nameTV_location:
            [self.btnClearLocation setHidden:NO];
            break;
        case nameTV_handOver:
            [self.btnClearHandoverContent setHidden:NO];
            break;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    switch (textView.tag) {
        case nameTV_reason:
            [self.btnClearReason setHidden:YES];
            break;
        case nameTV_location:
            [self.btnClearLocation setHidden:YES];
            break;
        case nameTV_handOver:
            [self.btnClearHandoverContent setHidden:YES];
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
