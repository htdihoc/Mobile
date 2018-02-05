//
//  DeniedRegisterVC_iPad.m
//  SmartOffice
//
//  Created by NguyenDucBien on 5/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "DeniedRegisterVC_iPad.h"
#import "TTNSProcessor.h"
#import "DetailLeaveModel.h"
#import "SearchHandler_iPad.h"
#import "Common.h"
#import "NSException+Custom.h"
#import "MZFormSheetController.h"

typedef enum : NSInteger{
    nameTV_reason = 1,
    nameTV_location,
    nameTV_handOver
}nameTV;

@interface DeniedRegisterVC_iPad () <UITextViewDelegate, TimePickerVCDelegate, MZFormSheetBackgroundWindowDelegate, ChooseHandlerDelegate> {
@protected BOOL isChanged;
@protected NSDate *_selectedDate;
@protected NSString *_stringStartDate;
@protected NSString *_stringEndDate;
@protected NSString *_stringStartTimeDetail;
@protected NSString *_stringEndTimeDetail;
@protected NSString *currentTime;
    
@protected DetailLeaveModel *model;
}
@end

@implementation DeniedRegisterVC_iPad


#pragma mark lifecycler
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];
    [self setupUI];
    self.backTitle      = @"Từ chối";
}

#pragma mark UI

-(void)setupUI{
    self.reasonTV.layer.borderColor             = AppColor_BorderForView.CGColor;
    self.reasonTV.layer.borderWidth             = 1;
    self.reasonTV.layer.cornerRadius            = 3;
    self.timeButton.layer.borderColor           = AppColor_BorderForView.CGColor;
    self.timeButtonLB.textColor                       = App_Color_MainTextBoldColor;
    [self.timeButtonLB setText:[NSString stringWithFormat:@"%@ -> %@", [[Common shareInstance] getCurrentTime], [[Common shareInstance] getCurrentTime]]];
    self.locationTV.layer.borderColor           = AppColor_BorderForView.CGColor;
    self.locationTV.layer.borderWidth           = 1;
    self.locationTV.layer.cornerRadius          = 3;
    self.handoverView.layer.borderColor         = AppColor_BorderForView.CGColor;
    self.managerView.layer.borderColor          = AppColor_BorderForView.CGColor;
    self.handoverContentTV.layer.borderColor    = AppColor_BorderForView.CGColor;
    self.handoverContentTV.layer.borderWidth    = 1;
    self.handoverContentTV.layer.cornerRadius   = 3;
    self.view.backgroundColor                   = AppColor_MainAppBackgroundColor;
    [self.handOverUserView setHidden:YES];
    [self.managerUserView setHidden:YES];
    self.mTitle.text = @"Chi tiết đăng ký";
    [self setDelegateForTV];
    [self setTagForTV];
    [self hideButton];
    [self setupLB];
    [self addTappGesture];
    currentTime = [NSString stringWithFormat:@"%@ -> %@", [[Common shareInstance] getCurrentTime], [[Common shareInstance] getCurrentTime]];
    isChanged = NO;
    
}

- (void)hideButton {
    self.phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.btnClearReason setHidden:YES];
    [self.btnClearLocation setHidden:YES];
    [self.btnClearHandoverContent setHidden:YES];
}

- (void)setDelegateForTV {
    self.reasonTV.delegate          = self;
    self.locationTV.delegate        = self;
    self.handoverContentTV.delegate = self;
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

- (void)setupLB{
    self.stateLB.text                       = LocalizedString(@"TTNS_TRANG_THAI");
    self.stateContentLB.text                = LocalizedString(@"TTNS_BI_TU_CHOI");
    self.reasonLB.text                      = LocalizedString(@"TTNS_DismissTimeKeeping_Lý_do");
    self.nguoiTuChoiLB.text                 = LocalizedString(@"Người từ chối");
    self.lyDoNghiLB.text                    = LocalizedString(@"TTNS_LY_DO_NGHI");
    self.timeLB.text                        = LocalizedString(@"TTNS_THOI_GIAN_NGHI");
    self.locationLB.text                    = LocalizedString(@"TTNS_NOI_NGHI");
    self.phoneLB.text                       = LocalizedString(@"TTNS_SDT");
    self.choiseHandoverLB.text              = [NSString stringWithFormat:@"- %@ -", LocalizedString(@"TTNS_CHON_NGUOI_BAN_GIAO")];
    self.contentHandOverLB.text             = LocalizedString(@"TTNS_NOI_DUNG_BAN_GIAO");
    self.managerLB.text                     = LocalizedString(@"TTNS_CHI_HUY_DON_VI");
    self.choiseManagerLB.text               = [NSString stringWithFormat:@"- %@ -", LocalizedString(@"TTNS_CHON_CHI_HUY_DON_VI")];
    
    [self.trinhKyButton setTitle:LocalizedString(@"TTNS_TRINH_KY") forState:UIControlStateNormal];
    [self.ghiLaiButton setTitle:LocalizedString(@"TTNS_GHI_LAI") forState:UIControlStateNormal];
}
- (BOOL)isValidate{
    if(self.reasonTV != nil && ![self.reasonTV.text isEqualToString:@""]){
        NSString *currentTimeBTN = [NSString stringWithFormat:@"%@ -> %@", [[Common shareInstance] getCurrentTime], [[Common shareInstance] getCurrentTime]];
        if(self.timeButtonLB != nil && ![self.timeButtonLB.text isEqualToString:currentTimeBTN]){
            isChanged = YES;
            if(self.locationTV != nil && ![self.locationTV.text isEqualToString:@""]){
                if(self.phoneTF != nil && ![self.phoneTF.text isEqualToString:@""]){
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
// show datePicker
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

- (void)updateUI{
    NSString *from_date = [self convertTimeStampToDateStr:model.fromDate format:@"HH:mm - dd/MM/yyyy"];
    NSString *to_date = [self convertTimeStampToDateStr:model.toDate format:@"HH:mm - dd/MM/yyyy"];
    
    [self.timeButtonLB setText:[NSString stringWithFormat:@"%@ -> %@", from_date, to_date]];
}
- (void)setTextForTimeGoOut:(NSString *)startDate startDateDetail:(NSString *)startDateDetail endDate:(NSString *)endDate endDateDetail:(NSString *)endDateDetail
{
    NSString *startTime     = [NSString stringWithFormat:@"%@ - %@", startDateDetail, startDate];
    NSString *endTime       = [NSString stringWithFormat:@"%@ - %@", endDateDetail, endDate];
    [self.timeButtonLB setText:[NSString stringWithFormat:@"%@ -> %@",startTime, endTime]];
}

- (void)passingString:(ChooseHandler *)controller didFinishChooseItem:(NSString *)item {
    [self.choiseHandoverLB setText:item];
}

#pragma mark action
- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

#pragma mark multithread

- (void)loadingData:(NSInteger)personalFormId{
    if([Common checkNetworkAvaiable]){
        [[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
        [self loadDetailRegister:personalFormId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if(success){
                DLog(@"Get detail register success");
                NSDictionary *data = [resultDict valueForKey:@"data"];
                NSDictionary *entity = [data valueForKey:@"entity"][0];
                model = [[DetailLeaveModel alloc]initWithDictionary:entity error:nil];
                [self updateUI];
                NSLog(@"");
            } else {
                [self handleErrorFromResult:resultDict withException:exception inView:self.view];
            }
            [[Common shareInstance]dismissHUD];
        }];
        
    } else {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}

- (void)postSignRegister{
    if([Common checkNetworkAvaiable]){
        [[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
        [self signRegister:self.personalFormId type:StatusType_Refuse callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            [[Common shareInstance]dismissHUD];
            if(success){
                DLog(@"Show dialog success");
            } else {
                [self handleErrorFromResult:resultDict withException:exception inView:self.view];
            }
        }];
        
    } else {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}

- (void)postRegisterOrUpdate{
    NSString *from_date_str     = [NSString stringWithFormat:@"%@ - %@",_stringStartTimeDetail, _stringStartDate];
    NSString *to_date_str       = [NSString stringWithFormat:@"%@ - %@", _stringEndTimeDetail, _stringEndDate];
    NSInteger from_date         = [self convertDateTimeToTimeStamp:from_date_str format:@"HH:mm - dd/MM/yyyy"];
    NSInteger to_date           = [self convertDateTimeToTimeStamp:to_date_str format:@"HH:mm - dd/MM/yyyy"];
    
    NSDictionary *params = @{@"type" : [NSNumber numberWithInteger:StatusType_Refuse],
                             @"from_date" : [NSNumber numberWithInteger:from_date],
                             @"to_date" : [NSNumber numberWithInteger:to_date]
                             };
    
    if([Common checkNetworkAvaiable]){
        [[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
        [self registerOrUpdate:params personalFormId:self.personalFormId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            [[Common shareInstance]dismissHUD];
            if(success){
                DLog(@"Show dialog");
            } else {
                [self handleErrorFromResult:resultDict withException:exception inView:self.view];
            }
        }];
    } else {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}


#pragma mark request Server

- (void)loadDetailRegister:(NSInteger)personalFormId callBack:(Callback)callBack{
    [TTNSProcessor getTTNS_CHI_TIET_DON_NGHI_PHEP:personalFormId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}

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


- (IBAction)chooseTimeOff:(id)sender {
    [self showTimePicker];
}

- (IBAction)handoverAction:(id)sender {
    [self showPopupChooseHandler];
}

- (IBAction)managerAction:(id)sender {
}

- (IBAction)ghiLaiAction:(id)sender {
    if([self isValidate]){
        DLog(@"Save Action")
    }
}

- (IBAction)trinhKyAction:(id)sender {
    if([self isValidate]){
        DLog(@"Show Dialog Sign");
        [self postRegisterOrUpdate];
    }
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

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    isChanged = TRUE;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
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

- (void)textViewDidEndEditing:(UITextView *)textView {
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]){
        // Disable return key in keyboard
        //[textView resignFirstResponder];
        return NO;
    }
    if (textView.text.length + (text.length - range.length) > 256) {
        DLog(@"Show Toast");
        [self showToastWithMessage:@"Không vượt quá 256 ký tự"];
    }
    return textView.text.length + (text.length - range.length) <= 256;
}


@end
