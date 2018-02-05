//
//  RegTakeLeaveVC.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "RegTakeLeaveVC.h"

#import "ChoiseUserVC.h"
#import "DetailLeaveModel.h"
#import "RemainDayModel.h"

#import "Common.h"
#import "TTNSProcessor.h"
#import "NSException+Custom.h"

typedef enum : NSInteger{
    nameTV_reason = 1,
    nameTV_location,
    nameTV_note,
    nameTV_handOver
}nameTV;

@interface RegTakeLeaveVC ()<UITextViewDelegate, TimePickerVCDelegate>{
@protected  DetailLeaveModel *detailModel;
@protected  RemainDayModel *remainDayModel;
@protected BOOL isChanged; // TRUE = data be changed ||
    
@protected NSDate *_selectedDate;
@protected NSString *_stringStartDate;
@protected NSString *_stringEndDate;
@protected NSString *_stringStartTimeDetail;
@protected NSString *_stringEndTimeDetail;
@protected NSString *currentTime;
}
@end

@implementation RegTakeLeaveVC

#pragma mark lifecycler

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];
    self.title = @"Xin nghỉ phép";
    [self setupUI];
    [self loadingData];
    [self setBackTitle];
    self.employeeId = 41387;
}

#pragma mark UI

-(void)setupUI{
    self.reasonTV.layer.borderColor         = AppColor_BorderForView.CGColor;
    self.timeTV.layer.borderColor           = AppColor_BorderForView.CGColor;
    self.locationTV.layer.borderColor       = AppColor_BorderForView.CGColor;
    self.phoneTF.layer.borderColor          = AppColor_BorderForView.CGColor;
    self.noteTV.layer.borderColor           = AppColor_BorderForView.CGColor;
    self.view_handover.layer.borderColor    = AppColor_BorderForView.CGColor;
    self.handoverTV.layer.borderColor       = AppColor_BorderForView.CGColor;
    self.view_manager.layer.borderColor     = AppColor_BorderForView.CGColor;
    
    [self.handoverUserView setHidden:YES];
    [self.managerUserView setHidden:YES];
    [self addTappGesture];
    [self setDelegateForTV];
    [self setTagForTV];
    [self hideButtonClear];
    isChanged = NO;
}

- (void)updateUI{
    self.remainDay.text = [NSString stringWithFormat:@"%ld", (long)remainDayModel.remainingAnnualDay];
    
    currentTime = [NSString stringWithFormat:@"%@ -> %@", [self convertTimeStampToDateStr:detailModel.fromDate format:@"HH'h':mm - dd/MM/yyyy"], [self convertTimeStampToDateStr:detailModel.toDate format:@"HH'h':mm - dd/MM/yyyy"]];
    
    [self.timeTV setTitle:currentTime forState:UIControlStateNormal];
    
    self.reasonTV.text      = detailModel.reason;
    self.locationTV.text    = detailModel.stayAddress;
    self.phoneTF.text       = [NSString stringWithFormat:@"%ld", (long)detailModel.phoneNumber];
    self.noteTV.text        = @"";
    self.handoverTV.text    = detailModel.department;
    
    [self.view_handover setHidden:YES];
    [self.view_manager setHidden:YES];
    [self.handoverUserView setHidden:NO];
    [self.managerUserView setHidden:NO];
}

- (void)addTappGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)setBackTitle{
    switch (_typeOfForm) {
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

- (void)hideButtonClear{
    
    self.phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.btnClearReason setHidden:YES];
    [self.btnClearLocation setHidden:YES];
    [self.btnClearNote setHidden:YES];
    [self.btnClearHandoverContent setHidden:YES];
}

- (void)setTagForTV{
    self.reasonTV.tag           = nameTV_reason;
    self.locationTV.tag         = nameTV_location;
    self.noteTV.tag             = nameTV_note;
    self.handoverTV.tag         = nameTV_handOver;
}

- (void)setDelegateForTV{
    self.reasonTV.delegate          = self;
    self.locationTV.delegate        = self;
    self.noteTV.delegate            = self;
    self.handoverTV.delegate        = self;
}

- (void)setTextForTimeGoOut:(NSString *)startDate startDateDetail:(NSString *)startDateDetail endDate:(NSString *)endDate endDateDetail:(NSString *)endDateDetail
{
    NSString *startTime     = [NSString stringWithFormat:@"%@ - %@", startDateDetail, startDate];
    NSString *endTime       = [NSString stringWithFormat:@"%@ - %@", endDateDetail, endDate];
    [self.timeTV setTitle:[NSString stringWithFormat:@"%@ -> %@", startTime, endTime] forState:UIControlStateNormal];
}

#pragma mark action

- (void)dismissKeyboard{
    //    [self.reasonTV resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark multithread

- (void)loadingData{
    [[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
    dispatch_group_t group = dispatch_group_create();
    
    // .1
    dispatch_group_enter(group);
    [self loadRemainDay:[GlobalObj getInstance].ttns_employID callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        if(success){
            DLog("Get Remain day success");
            NSDictionary *data = [resultDict valueForKey:@"data"];
            NSDictionary *entity = [data valueForKey:@"entity"];
            remainDayModel = [[RemainDayModel alloc]initWithDictionary:entity error:nil];
        } else {
            [self handleErrorFromResult:resultDict withException:exception inView:self.view];
        }
        dispatch_group_leave(group);
    }];
    
    // .2
    dispatch_group_enter(group);
    [self loadDetailRegister:self.personalFormId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        if(success){
            DLog(@"Get detail register success");
            NSDictionary *data = [resultDict valueForKey:@"data"];
            NSDictionary *entity = [data valueForKey:@"entity"][0];
            detailModel = [[DetailLeaveModel alloc]initWithDictionary:entity error:nil];
            NSLog(@"");
        }
        dispatch_group_leave(group);
    }];
    
    // all task completed
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [[Common shareInstance]dismissHUD];
        [self updateUI];
    });
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

- (void)loadRemainDay:(NSNumber*)employeeId callBack:(Callback)callBack{
    [TTNSProcessor getRemainingAnnual:employeeId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}

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

#pragma mark Action
-(void)showDatePicker{
    if (self.timePickerVC == nil) {
        self.timePickerVC = NEW_VC_FROM_NIB(TimePickerVC, @"TimePickerVC");
        self.timePickerVC.delegate = self;
    }
    [self presentViewController:self.timePickerVC animated:YES completion:nil];
}

- (BOOL)validateValue{
    if(self.reasonTV != nil && ![self.reasonTV.text isEqualToString:@""]){
        if(![self.timeTV.titleLabel.text isEqualToString:currentTime]){
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
    if(![self.timeTV.titleLabel.text isEqualToString:currentTime] ||
       ![self.phoneTF.text isEqualToString:@""]){
        // check Chi huy don vi
        return YES;
    }
    return NO;
}

#pragma mark IBAction

- (IBAction)backAction:(id)sender {
    isChanged = [self isChangedValue];
    if(isChanged){
        [self showConfirmBackDialog:LocalizedString(@"Bạn muốn huỷ thao tác")];
    } else {
        [AppDelegateAccessor.navIntegrationVC popViewControllerAnimated:YES];
    }
}

- (IBAction)showTimePicker:(id)sender {
    [self showDatePicker];
}

- (IBAction)handoverAction:(id)sender {
    // Choise handover User
    ChoiseUserVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChoiseUserVC"];
    [AppDelegateAccessor.navIntegrationVC pushViewController:vc animated:YES];
}

- (IBAction)managerUserAction:(id)sender {
    // Choise Manager User
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
        [self postRegisterOrUpdate];
    }
}

- (IBAction)clearReasonAction:(id)sender {
    self.reasonTV.text = @"";
}

- (IBAction)clearLocationAction:(id)sender {
    self.locationTV.text = @"";
}

- (IBAction)clearNoteAction:(id)sender {
    self.noteTV.text = @"";
}

- (IBAction)clearHandoverContentAction:(id)sender {
    self.handoverTV.text = @"";
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
    
    switch (textView.tag) {
        case nameTV_reason:
            [self.btnClearReason setHidden:NO];
            break;
        case nameTV_location:
            [self.btnClearLocation setHidden:NO];
            break;
            
        case nameTV_note:
            [self.btnClearNote setHidden:NO];
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
            
        case nameTV_note:
            [self.btnClearNote setHidden:YES];
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
