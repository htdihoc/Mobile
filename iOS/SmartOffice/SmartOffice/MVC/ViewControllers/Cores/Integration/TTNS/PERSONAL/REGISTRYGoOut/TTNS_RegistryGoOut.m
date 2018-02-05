//
//  demo10ViewController.m
//  demo10
//
//  Created by KhacViet Dinh on 4/17/17.
//  Copyright © 2017 KhacViet Dinh. All rights reserved.
//

#import "TTNS_RegistryGoOut.h"
#import "FCAlertView.h"
#import "WYPopoverController.h"
#import "RegisterReason.h"
#import "DestinationPlaceList.h"
#import "UIButton+BorderDefault.h"
#import "UIView+BorderView.h"
#import "TTNSProcessor.h"
#import "Common.h"
#import "NSString+StringToDate.h"
#import "CheckList.h"
#import "RegisterReason.h"

@interface TTNS_RegistryGoOut () <CheckListDelegate, RegisterReasonDelegate, TimePickerVCDelegate, UITextViewDelegate>
{
@protected WYPopoverController *settingsPopoverController;
@protected NSDate *_selectedDate;
@protected NSString *_stringStartDate;
@protected NSString *_stringEndDate;
@protected NSString *_stringStartTimeDetail;
@protected NSString *_stringEndTimeDetail;
    
@protected NSInteger workplaceID;
@protected NSInteger reasonId;
    
@protected BOOL isChanged;
@protected NSString *currentTime;
}

@property (weak, nonatomic) IBOutlet UIButton *btn_Address;

@property (weak, nonatomic) IBOutlet UIButton *btn_Reason;

@property (weak, nonatomic) IBOutlet UIButton *btn_TimePeriod;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation TTNS_RegistryGoOut

#pragma mark lifecycler
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    isChanged = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
}


#pragma mark UI
- (void)setupUI{
    self.leftBtnAttribute = [[BottomButton alloc] initWithDefautBlueColor:LocalizedString(@"TTNS_TTNS_RegistryGoOut_Gửi_đăng_ký")];
    self.backTitle = LocalizedString(@"TTNS_TTNS_RegistryGoOut_Đăng_ký_mới");
    [self setBorderForViews];
    [self.clearReasonBTN setHidden:YES];
    self.reasonTV.delegate = self;
    self.reasonTV.placeholder   = LocalizedString(@"TTNS_RegisterOtherFreeDay_Nhập_lý_do_chi_tiết");
    currentTime = [NSString stringWithFormat:@"%@ -> %@", [[Common shareInstance] getCurrentTime], [[Common shareInstance] getCurrentTime]];
    [self.btn_TimePeriod setTitle:currentTime forState:UIControlStateNormal];
}

- (void)settingTextToViews
{
    _lbl_TitlePlace.text            = LocalizedString(@"TTNS_RegistryGoOut_Nơi_đến");
    _lbl_TitleReason.text           = LocalizedString(@"TTNS_RegistryGoOut_Lý_do_đăng_ký");
    _lbl_TitleReasonDetail.text     = LocalizedString(@"TTNS_RegistryGoOut_Lý_do_chi_tiết");
    _lbl_TitleTimeGoOut.text        = LocalizedString(@"TTNS_RegistryGoOut_Thời_gian_ra_ngoài");
}

- (void)setTextForTimeGoOut:(NSString *)startDate startDateDetail:(NSString *)startDateDetail endDate:(NSString *)endDate endDateDetail:(NSString *)endDateDetail
{
    NSString *startTime     = [NSString stringWithFormat:@"%@ - %@", startDateDetail, startDate];
    NSString *endTime       = [NSString stringWithFormat:@"%@ - %@", endDateDetail, endDate];
    [self.btn_TimePeriod setTitle:[NSString stringWithFormat:@"%@ -> %@", startTime, endTime] forState:UIControlStateNormal];
}

- (void)setBorderForViews
{
    [self.btn_Address setTitleColor:AppColor_MainTextColor forState:UIControlStateNormal];
    [self.btn_Reason setTitleColor:AppColor_MainTextColor forState:UIControlStateNormal];
    [self.btn_TimePeriod setTitleColor:AppColor_MainTextColor forState:UIControlStateNormal];
    [self.btn_Address setDefaultBorder];
    [self.btn_Reason setDefaultBorder];
    [self.btn_TimePeriod setDefaultBorder];
    [self.reasonTV setBorderForView];
}


#pragma mark networking
- (void)loadingData{
    
}

- (void)sendRegisterForm{
//    NSInteger employeeId        = 44484;
    NSString *reasonDetail      = self.reasonTV.text;
    
    //    NSString *fromTimeStr       = [NSString stringWithFormat:@"%@ %@", _stringStartDate, _stringStartTimeDetail];
    //    NSString *endTimeStr          = [NSString stringWithFormat:@"%@ %@", _stringEndDate, _stringEndTimeDetail];
    NSString *format = @"dd/MM/yyyy-hh:mm a";
    NSDictionary *parameters    = @{
                                    @"employee_id" : [GlobalObj getInstance].ttns_employID ,
                                    @"from_time" :  @((long)[[[NSString stringWithFormat:@"%@-%@", _stringStartDate, _stringStartTimeDetail] convertStringToDateWith:format] timeIntervalSince1970]*1000),
                                    @"end_time" : @((long)[[[NSString stringWithFormat:@"%@-%@", _stringEndDate, _stringEndTimeDetail] convertStringToDateWith:format] timeIntervalSince1970]*1000),
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
            [[Common shareInstance]dismissHUD];
        }
    }];
}

#pragma mark request Server

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
- (void) dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)actionCheckInAndOut
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.dismissOnOutsideTouch = 1;
    alert.hideDoneButton = 0;
    [alert showAlertWithTitle:LocalizedString(@"TTNS_TTNS_RegistryGoOut_Xác_nhận")
       withSubtitle:@"Đ/c muốn thực hiện đăng ký ra ngoài từ thời gian 8h00 - 25/01/2017 đến 8h00-25/01/2017"
              withCustomImage:nil
          withDoneButtonTitle:nil
                   andButtons:@[LocalizedString(@"TTNS_TTNS_RegistryGoOut_Đóng"), LocalizedString(@"TTNS_TTNS_RegistryGoOut_Gửi_đăng_ký")]];
    alert.firstButtonTitleColor = [UIColor grayColor];
    alert.secondButtonTitleColor = [UIColor blueColor];
//    SO_AlrertView *alert = [SO_AlrertView alertControllerWithTitle:LocalizedString(@"TTNS_TTNS_RegistryGoOut_Xác_nhận") message:@"Đ/c muốn thực hiện đăng ký ra ngoài từ thời gian 8h00 - 25/01/2017 đến 8h00-25/01/2017" preferredStyle:UIAlertControllerStyleAlert];
//    [alert addButton:LocalizedString(@"TTNS_TTNS_RegistryGoOut_Đóng") textColor:[UIColor grayColor] hander:nil];
//    [alert addButton:LocalizedString(@"TTNS_TTNS_RegistryGoOut_Gửi_đăng_ký") textColor:[UIColor blueColor] hander:nil];
//    [self presentViewController:alert animated:YES completion:nil];
}

// Show ListReason
- (void)showReasons
{
    RegisterReason *reasons = NEW_VC_FROM_NIB(RegisterReason, @"RegisterReason");
    reasons.delegate = self;
    [self showAlert:reasons title:nil leftButtonTitle:nil rightButtonTitle:nil leftHander:nil rightHander:nil];
}

// show datePicker
-(void)showDatePicker{
    if (self.timePickerVC == nil) {
        self.timePickerVC = NEW_VC_FROM_NIB(TimePickerVC, @"TimePickerVC");
        self.timePickerVC.delegate = self;
    }
    [self presentViewController:self.timePickerVC animated:YES completion:nil];
}

- (void)showDialogConfirm{
    
    UIAlertAction *cancelButton     = [UIAlertAction actionWithTitle: LocalizedString(@"TTNS_CheckOut_Đóng")  style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmButton    = [UIAlertAction actionWithTitle: LocalizedString(@"TTNS_TTNS_RegistryGoOut_Gửi_đăng_ký") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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

- (BOOL)validateValue{
    if(![self.btn_Address.titleLabel.text isEqualToString:LocalizedString(@"Tầng 15 Crowne - Trần Hữu Dực")]){
        if(![self.btn_Reason.titleLabel.text isEqualToString:LocalizedString(@"TTNS_RegisterWatchCell_Chọn")]){
            if(![self.btn_TimePeriod.titleLabel.text isEqualToString:currentTime]){
                DLog(@"Send register");
                return YES;
            }else {
                [[Common shareInstance] showErrorHUDWithMessage:@"Bạn phải nhập thời gian ra ngoài" inView:self.view];
            }
        } else {
            [[Common shareInstance]showErrorHUDWithMessage:@"Bạn phải nhập lý do" inView:self.view];
        }
    } else {
        [[Common shareInstance] showErrorHUDWithMessage:@"Bạn chưa nhập nơi đến" inView:self.view];
    }
    return NO;
}

- (BOOL)isChangeValue{
    if(![self.btn_Address.titleLabel.text isEqualToString:@"Tầng 15 Crowne - Trần Hữu Dực"] ||
       ![self.btn_Reason.titleLabel.text isEqualToString:@" - Chọn -"] ||
       ![self.btn_TimePeriod.titleLabel.text isEqualToString:currentTime]){
        
        return YES;
    }
    return NO;
}

- (void)didTapBackButton{
    isChanged = [self isChangeValue];
    if(isChanged){
        [self showConfirmBackDialog:LocalizedString(@"Bạn muốn huỷ thao tác ?")];
    } else {
        [AppDelegateAccessor.navIntegrationVC popViewControllerAnimated:YES];
    }
}

#pragma mark IBAction
// show list workplace
- (IBAction)SelectDestination:(id)sender {
    DestinationPlaceList *destinationsVC = NEW_VC_FROM_NIB(DestinationPlaceList, @"DestinationPlaceList");
    destinationsVC.delegate = self;
    [self pushIntegrationVC:destinationsVC];
}

- (IBAction)SelectReason:(id)sender {
    [self showReasons];
}

- (IBAction)SelectPeriod:(id)sender {
    [self showDatePicker];
}

- (IBAction)clearReasonAction:(id)sender {
    self.reasonTV.text = @"";
}


#pragma mark - BottomViewDelegate
- (void)didselectLeftButton
{
    DLog(@"didselectLeftButton");
    if([self validateValue]){
        [self showDialogConfirm];
    }
    else {
        return;
    }
}
- (void)didSelectRightButton
{
    DLog(@"didSelectRightButton");
}

#pragma mark WorkPlace Delegate

- (void)didFinishChoiseWorkPlace:(CheckList *)vc workPlaceId:(NSInteger)workPlaceId address:(NSString *)address{
    [self.btn_Address setTitle:address forState:UIControlStateNormal];
    workplaceID = workPlaceId;
}

#pragma mark RegisterReason Delegate

- (void)didFinishSelectReason:(RegisterReason *)vc reasonID:(NSInteger)reasonID title:(NSString *)title{
    [self.btn_Reason setTitle:title forState:UIControlStateNormal];
    reasonId = reasonID;
}

#pragma mark TimePickerVCDelegate
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
    isChanged = TRUE;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self.clearReasonBTN setHidden:NO];
    
    if([textView.text isEqualToString:LocalizedString(@"Nhập lý do từ chối")]){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.clearReasonBTN setHidden:YES];
    
    if([textView.text isEqualToString:@""]){
        textView.text = LocalizedString(@"Nhập lý do từ chối");
        textView.textColor = CommonColor_Gray;
    }
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        // Disable return key in keyboard
        //[textView resignFirstResponder];
        return NO;
    }
    
    if(textView.text.length + (text.length - range.length)> 256){
        DLog(@"Show Toast");
        [[Common shareInstance]showErrorHUDWithMessage:LocalizedString(@"Không vượt quá 256 ký tự") inView:self.view];
    }
    return textView.text.length + (text.length - range.length) <= 256;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

@end
