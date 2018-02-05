//
//  RefuseVC.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/13/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "RefuseVC.h"

#import "TTNSProcessor.h"
#import "DetailLeaveModel.h"

#import "ChoiseUserVC.h"

#import "Common.h"
#import "NSException+Custom.h"

typedef enum : NSInteger{
    nameTV_reason = 1,
    nameTV_location,
    nameTV_handOver
}nameTV;

@interface RefuseVC ()<UITextViewDelegate, TimePickerVCDelegate>{
@protected DetailLeaveModel *model;
@protected BOOL isChanged; // TRUE = data be changed ||
    
@protected NSDate *_selectedDate;
@protected NSString *_stringStartDate;
@protected NSString *_stringEndDate;
@protected NSString *_stringStartTimeDetail;
@protected NSString *_stringEndTimeDetail;
@protected  NSString *currentTime;
}


@end

@implementation RefuseVC

#pragma mark lifecycler

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadingData];
    [self setupUI];
    
}

#pragma mark UI

-(void)setupUI{
    [self setBackTitle];
    [self.tabBarController.tabBar setHidden:YES];
    
    self.reasonTV.layer.borderColor             = AppColor_BorderForView.CGColor;
    self.timeButton.layer.borderColor           = AppColor_BorderForView.CGColor;
    self.locationTV.layer.borderColor           = AppColor_BorderForView.CGColor;
    self.handoverView.layer.borderColor         = AppColor_BorderForView.CGColor;
    self.managerView.layer.borderColor          = AppColor_BorderForView.CGColor;
    self.handoverContentTV.layer.borderColor    = AppColor_BorderForView.CGColor;
    self.view.backgroundColor                   = AppColor_MainAppBackgroundColor;
    
    [self setupLB];
    [self addTappGesture];
    [self setDelegateForTV];
    [self setTagForTV];
    [self hideView];
    
    currentTime = [NSString stringWithFormat:@"%@ -> %@", [[Common shareInstance] getCurrentTime], [[Common shareInstance] getCurrentTime]];
    isChanged = NO;
}

- (void)setBackTitle{
    switch (self.typeOfForm) {
        case TTNS_Type_NghiPhep:
            self.backTitle  = LocalizedString(@"KLIST_REGISTER_FORM_TYPE_1");
            break;
            
        case TTNS_Type_NghiViecRieng:
            self.backTitle  = LocalizedString(@"KLIST_REGISTER_FORM_TYPE_2");
            break;
            
        case TTNS_Type_NghiOm:
            self.backTitle  = LocalizedString(@"KLIST_REGISTER_FORM_TYPE_3");
            break;
            
        case TTNS_Type_NghiConOm:
            self.backTitle  = LocalizedString(@"KLIST_REGISTER_FORM_TYPE_4");
            break;
            
        default:
            break;
    }
}

- (void)hideView{
    [self.handOverUserView setHidden:YES];
    [self.managerUserView setHidden:YES];
    
    self.phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.clearReasonButton setHidden:YES];
    [self.clearButtonLocation setHidden:YES];
    [self.clearHandOverContentButton setHidden:YES];
}

- (void)setTagForTV{
    self.reasonTV.tag           = nameTV_reason;
    self.locationTV.tag         = nameTV_location;
    self.handoverContentTV.tag  = nameTV_handOver;
}

- (void)setDelegateForTV{
    self.reasonTV.delegate          = self;
    self.locationTV.delegate        = self;
    self.handoverContentTV.delegate = self;
}

- (void)setupLB{
    self.stateLB.text                       = LocalizedString(@"TTNS_TRANG_THAI");
    self.stateLB.textColor                  = AppColor_MainTextColor;
    self.stateContentLB.text                = LocalizedString(@"TTNS_BI_TU_CHOI");
    self.stateContentLB.textColor           = CommonColor_Red;
    self.reasonLB.text                      = LocalizedString(@"TTNS_DismissTimeKeeping_Lý_do");
    self.reasonLB.textColor                 = AppColor_MainTextColor;
    self.nguoiTuChoiLB.text                 = LocalizedString(@"TTNS_NormalRegisterDetail_Người_từ_chối");
    self.nguoiTuChoiLB.textColor            = AppColor_MainTextColor;
    self.lyDoNghiLB.text                    = LocalizedString(@"TTNS_LY_DO_NGHI");
    self.lyDoNghiLB.textColor               = AppColor_MainTextColor;
    self.timeLB.text                        = LocalizedString(@"TTNS_THOI_GIAN_NGHI");
    self.timeLB.textColor                   = AppColor_MainTextColor;
    self.locationLB.text                    =
    LocalizedString(@"TTNS_NOI_NGHI");
    self.locationLB.textColor               = AppColor_MainTextColor;
    self.phoneLB.text                       =
    LocalizedString(@"TTNS_SDT");
    self.phoneLB.textColor                  = AppColor_MainTextColor;
    self.choiseHandoverLB.text              = [NSString stringWithFormat:@"- %@ -",LocalizedString(@"TTNS_CHON_NGUOI_BAN_GIAO")];
    self.choiseHandoverLB.textColor         = AppColor_MainTextColor;
    self.contentHandOverLB.text             = LocalizedString(@"TTNS_NOI_DUNG_BAN_GIAO");
    self.contentHandOverLB.textColor        = AppColor_MainTextColor;
    self.contentHandOverLB.text             = LocalizedString(@"TTNS_NOI_DUNG_BAN_GIAO");
    self.contentHandOverLB.textColor        = AppColor_MainTextColor;
    self.managerLB.text                     = LocalizedString(@"TTNS_CHI_HUY_DON_VI");
    self.managerLB.textColor                = AppColor_MainTextColor;
    self.choiseManagerLB.text               = [NSString stringWithFormat:@"- %@ -",LocalizedString(@"TTNS_CHON_CHI_HUY_DON_VI")];
    self.choiseManagerLB.textColor         = AppColor_MainTextColor;
    
    [self.trinhKyButton setTitle:LocalizedString(@"TTNS_TRINH_KY") forState:UIControlStateNormal];
    [self.ghiLaiButton setTitle:LocalizedString(@"TTNS_GHI_LAI") forState:UIControlStateNormal];
}


- (void)updateUI{
    NSString *from_date = [self convertTimeStampToDateStr:model.fromDate format:@"HH:mm - dd/MM/yyyy"];
    NSString *to_date = [self convertTimeStampToDateStr:model.toDate format:@"HH:mm - dd/MM/yyyy"];
    [self.timeButton setTitle:[NSString stringWithFormat:@"%@ -> %@", from_date, to_date] forState:UIControlStateNormal];
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

#pragma mark networking

- (void)loadingData{
    if([Common checkNetworkAvaiable]){
        [[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
        [self loadDetailRegister:self.personalFormId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            [[Common shareInstance]dismissHUD];
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
    NSInteger from_date        = [self convertDateTimeToTimeStamp:from_date_str format:@"HH:mm - dd/MM/yyyy"];
    NSInteger to_date          = [self convertDateTimeToTimeStamp:to_date_str format:@"HH:mm - dd/MM/yyyy"];
    
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
    [TTNSProcessor getTTNS_CHI_TIET_DON_NGHI_PHEP:self.personalFormId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
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

- (IBAction)showDatePicker:(id)sender {
    [self showDatePicker];
}

- (IBAction)handoverAction:(id)sender {
    ChoiseUserVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChoiseUserVC"];
    [AppDelegateAccessor.navIntegrationVC pushViewController:vc animated:YES];
}

- (IBAction)managerAction:(id)sender {
    ChoiseUserVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChoiseUserVC"];
    [AppDelegateAccessor.navIntegrationVC pushViewController:vc animated:YES];
}

- (IBAction)ghiLaiAction:(id)sender {
    if([self validateValue]){
        [self postSignRegister];
    }
}

- (IBAction)trinhKyAction:(id)sender {
    
    if([self validateValue]){
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

- (IBAction)clearHandOverContentAction:(id)sender {
    self.handoverContentTV.text = @"";
}

#pragma mark action

- (void)dismissKeyboard{
//    [self.reasonTV resignFirstResponder];
    [self.view endEditing:YES];
}

- (void)didTapBackButton{
    isChanged = [self isChangedValue];
    if(isChanged){
        [self showConfirmBackDialog:LocalizedString(@"Bạn muốn huỷ thao tác")];
        
    } else {
        DLog(@"nothing here");
        [super didTapBackButton];
    }
}

// show datePicker
-(void)showDatePicker{
    if (self.timePickerVC == nil) {
        self.timePickerVC = NEW_VC_FROM_NIB(TimePickerVC, @"TimePickerVC");
        self.timePickerVC.delegate = self;
    }
    [self presentViewController:self.timePickerVC animated:YES completion:nil];
}

- (BOOL)validateValue{
    if(self.reasonTV != nil && ![self.reasonTV.text isEqualToString:@""]){
        if(![self.timeButton.titleLabel.text isEqualToString:currentTime]){
            if(![self.locationTV.text isEqualToString:@""] && self.locationTV != nil){
                if(self.phoneTF != nil && ![self.phoneTF.text isEqualToString:@""]){
                    DLog(@"Chon chi huy don vi");
                    return YES;
                } else {
                    [[Common shareInstance] showErrorHUDWithMessage:[NSString stringWithFormat:@"%@ %@",LocalizedString(@"Bạn chưa nhập"), LocalizedString(@"TTNS_SDT")] inView:self.view];
                }
            } else {
                [[Common shareInstance] showErrorHUDWithMessage:[NSString stringWithFormat:@"%@ %@",LocalizedString(@"Bạn chưa nhập"), LocalizedString(@"TTNS_NOI_NGHI")] inView:self.view];
            }
        } else {
            [[Common shareInstance] showErrorHUDWithMessage:[NSString stringWithFormat:@"%@ %@",LocalizedString(@"Bạn chưa nhập"), LocalizedString(@"TimePickerVC_Thời_gian_nghỉ")] inView:self.view];
        }
    } else {
        [[Common shareInstance] showErrorHUDWithMessage:[NSString stringWithFormat:@"%@ %@",LocalizedString(@"Bạn chưa nhập"), LocalizedString(@"TTNS_LY_DO_NGHI")] inView:self.view];
    }
    return NO;
}

- (BOOL)isChangedValue{
    if(![self.timeButton.titleLabel.text isEqualToString:currentTime] ||
       ![self.phoneTF.text isEqualToString:@""]){
        return YES;
    }
    return NO;
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
    isChanged = TRUE;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    switch (textView.tag) {
        case nameTV_reason:
            [self.clearReasonButton setHidden:NO];
            break;
        case nameTV_location:
            [self.clearButtonLocation setHidden:NO];
            break;
            
        case nameTV_handOver:
            [self.clearHandOverContentButton setHidden:NO];
            break;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    switch (textView.tag) {
        case nameTV_reason:
            [self.clearReasonButton setHidden:YES];
            break;
        case nameTV_location:
            [self.clearButtonLocation setHidden:YES];
            break;
            
        case nameTV_handOver:
            [self.clearHandOverContentButton setHidden:YES];
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

