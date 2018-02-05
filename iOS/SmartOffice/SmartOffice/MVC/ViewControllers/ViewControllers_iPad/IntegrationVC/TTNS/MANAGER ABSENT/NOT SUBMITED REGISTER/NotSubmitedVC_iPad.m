//
//  NotSubmitedVC_iPad.m
//  SmartOffice
//
//  Created by NguyenDucBien on 5/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "NotSubmitedVC_iPad.h"
#import "DetailLeaveModel.h"
#import "RemainDayModel.h"
#import "SearchHandler_iPad.h"
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

@interface NotSubmitedVC_iPad () <UITextViewDelegate, TimePickerVCDelegate, MZFormSheetBackgroundWindowDelegate, ChooseHandlerDelegate> {
@protected  DetailLeaveModel *detailModel;
@protected  RemainDayModel *remainDayModel;
@protected BOOL isChanged;
@protected NSDate *_selectedDate;
@protected NSString *_stringStartDate;
@protected NSString *_stringEndDate;
@protected NSString *_stringStartTimeDetail;
@protected NSString *_stringEndTimeDetail;
@protected NSString *currentTime;
}

@end

@implementation NotSubmitedVC_iPad

#pragma mark lifecycler

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];
    self.title = @"Xin nghỉ phép";
    [self setupUI];
    self.backTitle = @"Đơn ngỉ phép";
    self.employeeId = 41387;
}

#pragma mark UI

-(void)setupUI{
    self.reasonTV.layer.borderColor         = AppColor_BorderForView.CGColor;
    self.reasonTV.layer.borderWidth         = 1;
    self.reasonTV.layer.cornerRadius        = 3;
    self.btnTime.layer.borderColor          = AppColor_BorderForView.CGColor;
    self.timeLB.textColor                   = App_Color_MainTextBoldColor;
//    [self.timeLB setText:[NSString stringWithFormat:@"%@ -> %@", [[Common shareInstance] getCurrentTime], [[Common shareInstance] getCurrentTime]]];
    self.locationTV.layer.borderColor       = AppColor_BorderForView.CGColor;
    self.locationTV.layer.borderWidth       = 1;
    self.locationTV.layer.cornerRadius      = 3;
    self.phoneTF.layer.borderColor          = AppColor_BorderForView.CGColor;
    self.handoverTV.layer.borderColor       = AppColor_BorderForView.CGColor;
    self.handoverTV.layer.borderWidth       = 1;
    self.handoverTV.layer.cornerRadius      = 3;
    self.btnTime.layer.borderWidth          = 1;
    self.btnDelete.layer.borderWidth        = 1;
    self.btnHandler.layer.borderWidth       = 1;
    [self.btnHandler setDefaultBorder];
    self.btnManagerUser.layer.borderWidth   = 1;
    [self.btnManagerUser setDefaultBorder];
    self.btnDelete.layer.borderColor        = RGB(240, 82, 83).CGColor;
    [self.btnDelete setTitle:@"Xoá" forState:UIControlStateNormal];
    self.mTitle.text = @"Chi tiết đăng ký";
    [self setupLB];
    isChanged = NO;
    [self setHideButtonClear];
    [self setDelegateForTV];
    [self setTagForTV];
    [self addTappGesture];

}
- (void)setupLB {
    self.remainDayLabel.text                = LocalizedString(@"TTNS_SO_NGAY_PHEP_CON_LAI");
    self.reasonLabel.text                   = LocalizedString(@"TTNS_LY_DO_NGHI");
    self.timeLabel.text                     = LocalizedString(@"TTNS_THOI_GIAN_NGHI");
    self.sumLabel.text                      = LocalizedString(@"TTNS_TONG");
    self.dateOffLB.text                     = LocalizedString(@"TTNS_NGAY_QUA_PHEP");
    self.dateSumLB.text                     = LocalizedString(@"TTNS_NGAY_1");
    self.locationLB.text                    = LocalizedString(@"TTNS_NOI_NGHI");
    self.phoneLB.text                       = LocalizedString(@"TTNS_SDT");
    self.noteLB.text                        = LocalizedString(@"TTNS_NGUOI_DUOC_BAN_GIAO");
    self.handoverContentLB.text             = [NSString stringWithFormat:@"- %@ -", LocalizedString(@"TTNS_CHON_NGUOI_BAN_GIAO")];
    self.contentHandoverLB.text             = LocalizedString(@"TTNS_NOI_DUNG_BAN_GIAO");
    self.unitManagerLB.text                 = LocalizedString(@"TTNS_CHI_HUY_DON_VI");
    self.managerUnitContentLB.text          = [NSString stringWithFormat:@"- %@ -", LocalizedString(@"TTNS_CHON_CHI_HUY_DON_VI")];
}

- (void)updateUI{
    
    // remainDay
    self.remainDay.text = [NSString stringWithFormat:@"%ld", (long)remainDayModel.remainingAnnualDay];
    
    // detail
    //    NSDate *fromDate                = [NSDate dateWithTimeIntervalSince1970:detailModel.fromDate];
    //    NSDate *toDate                  = [NSDate dateWithTimeIntervalSince1970:detailModel.toDate];
    //
    //    NSString *timeStr = [NSString stringWithFormat:@"%@  ->   %@",[self convertDate:fromDate format:@"HH:mm dd/mm/yyyy"]  , [self convertDate:toDate format:@"HH:mm dd/mm/yyyy"]];
    
    //    NSString *timeStr = [NSString stringWithFormat:@"%@ -> %@", [self convertTimeStampToDateStr:detailModel.fromDate format:@"HH'h':mm - dd/MM/yyyy"], [self convertTimeStampToDateStr:detailModel.toDate format:@"HH'h':mm - dd/MM/yyyy"]];
    
    //    [self.btnTime setTitle:timeStr forState:UIControlStateNormal];
    currentTime = [NSString stringWithFormat:@"%@ -> %@", [self convertTimeStampToDateStr:detailModel.fromDate format:@"HH'h':mm - dd/MM/yyyy"], [self convertTimeStampToDateStr:detailModel.toDate format:@"HH'h':mm - dd/MM/yyyy"]];
    [self.timeLB setText:currentTime];
    
    self.reasonTV.text      = detailModel.reason;
    self.locationTV.text    = detailModel.stayAddress;
    self.phoneTF.text       = [NSString stringWithFormat:@"%ld", (long)detailModel.phoneNumber];
    self.handoverTV.text    = detailModel.department;
}

- (void)setHideButtonClear {
    self.phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.btnClearReason setHidden:YES];
    [self.btnClearLocation setHidden:YES];
    [self.btnClearHandoverContent setHidden:YES];
}

- (void)setTagForTV{
    self.reasonTV.tag           = nameTV_reason;
    self.locationTV.tag         = nameTV_location;
    self.handoverTV.tag         = nameTV_handOver;
}

- (void)setDelegateForTV{
    self.reasonTV.delegate          = self;
    self.locationTV.delegate        = self;
    self.handoverTV.delegate        = self;
}

- (void)addTappGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)setTextForTimeGoOut:(NSString *)startDate startDateDetail:(NSString *)startDateDetail endDate:(NSString *)endDate endDateDetail:(NSString *)endDateDetail
{
    NSString *startTime     = [NSString stringWithFormat:@"%@ - %@", startDateDetail, startDate];
    NSString *endTime       = [NSString stringWithFormat:@"%@ - %@", endDateDetail, endDate];
    [self.timeLB setText:[NSString stringWithFormat:@"%@ -> %@", startTime, endTime]];
}

- (BOOL)isValidate{
    if(self.reasonTV != nil && ![self.reasonTV.text isEqualToString:@""]){
        NSString *currentTimeBTN = [NSString stringWithFormat:@"%@ -> %@", [[Common shareInstance] getCurrentTime], [[Common shareInstance] getCurrentTime]];
        if(self.timeLB != nil && ![self.timeLB.text isEqualToString:currentTimeBTN]){
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
- (void)passingString:(ChooseHandler *)controller didFinishChooseItem:(NSString *)item {
    [self.handoverContentLB setText:item];
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


#pragma mark multithread

- (void)loadingData:(NSInteger)personalFormId{
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
    [self loadDetailRegister:personalFormId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
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

#pragma mark request Server

- (void)loadRemainDay:(NSNumber*)employeeId callBack:(Callback)callBack{
    [TTNSProcessor getRemainingAnnual:employeeId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}

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

- (IBAction)backAction:(id)sender {
    [AppDelegateAccessor.navIntegrationVC popViewControllerAnimated:YES];
}

- (IBAction)handoverAction:(id)sender {
    // Choise handover User
    [self showPopupChooseHandler];
}

- (IBAction)managerUserAction:(id)sender {
    // Choise Manager User
}

- (IBAction)ghiLaiAction:(id)sender {
    if([self isValidate]){
        DLog(@"Save Action")
    }
//    [self registerOrUpdate:detailModel.type iD:self.personalFormId from_date:detailModel.fromDate to_date:detailModel.toDate reason:detailModel.reason type_resign:@"" callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
//        if(success){
//            DLog(@"register update success");
//        } else{
//            [self handleErrorFromResult:resultDict withException:exception inView:self.view];
//        }
//    }];
}

- (IBAction)trinhKyAction:(id)sender {
    if([self isValidate]){
        DLog(@"SignAction")
    }
//    [self signRegister:self.personalFormId type:detailModel.type callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
//        if(success){
//            DLog(@"Sign success");
//        }else {
//            [self handleErrorFromResult:resultDict withException:exception inView:self.view];
//        }
//    }];
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

- (IBAction)clearReasonAction:(id)sender {
    self.reasonTV.text = @"";
}

- (IBAction)clearLocationAction:(id)sender {
    self.locationTV.text = @"";
}

- (IBAction)clearHandOverContentAction:(id)sender {
    self.handoverTV.text = @"";
}

- (IBAction)chooseTimeAction:(id)sender {
    [self showTimePicker];
}

- (IBAction)deleteAction:(id)sender {
    
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

- (void)dismissKeyboard{
    //    [self.reasonTV resignFirstResponder];
    [self.view endEditing:YES];
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
