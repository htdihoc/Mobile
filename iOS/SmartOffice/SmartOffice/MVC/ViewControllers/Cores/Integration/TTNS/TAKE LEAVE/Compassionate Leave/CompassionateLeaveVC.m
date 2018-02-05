//
//  CompassionateLeaveVC.m
//  SmartOffice
//
//  Created by Administrator on 5/22/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "CompassionateLeaveVC.h"

#import "UIButton+BorderDefault.h"
#import "UIView+BorderView.h"
#import "ChoiseUserVC.h"
#import "Common.h"
#import "TTNSProcessor.h"
#import "NSException+Custom.h"
#import "RemainDayModel.h"

typedef enum : NSInteger{
    nameTV_reason = 1,
    nameTV_location,
    nameTV_note,
    nameTV_handOver
}nameTV;

@interface CompassionateLeaveVC ()<UITextViewDelegate, TimePickerVCDelegate>{
@protected RemainDayModel *remainDayModel;
    
@protected BOOL isChanged;
    
@protected NSDate *_selectedDate;
@protected NSString *_stringStartDate;
@protected NSString *_stringEndDate;
@protected NSString *_stringStartTimeDetail;
@protected NSString *_stringEndTimeDetail;
@protected  NSString *currentTime;
}

@end

@implementation CompassionateLeaveVC

#pragma mark LifeCycler

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getRemainDay];
    [self setupUI];
}

#pragma mark UI
- (void)setupUI{
    [self setupBorderForViews];
    [self hideView];
    [self addTappGesture];
    [self setTagForTV];
    [self setDelegateForTV];
    [self setHintForTV];
    self.phoneNumberTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    isChanged = NO;
    currentTime = [NSString stringWithFormat:@"%@ -> %@", [[Common shareInstance] getCurrentTime], [[Common shareInstance] getCurrentTime]];
    [self.timeButton setTitle:currentTime forState:UIControlStateNormal];
    [self.starNote setHidden:YES];
    [self.choiseHandOverLB setHidden:YES];
    self.cstChooseHandlerLabel.constant = 0;
    [self.starNoteChooseHandler setHidden:YES];
}

- (void)setupTextForViews{
    
    self.backTitle = LocalizedString(@"TTNS_XIN_NGHI_PHEP");
    
    self.totalSabaticalDaysLB.textColor     = App_Color_MainTextBoldColor;
    self.reasonLB.textColor                 = App_Color_MainTextBoldColor;
    self.resonTV.textColor                  = App_Color_MainTextBoldColor;
    self.timeLB.textColor                   = App_Color_MainTextBoldColor;
    [self.timeButton setTitleColor:App_Color_MainTextBoldColor forState:UIControlStateNormal];
    self.countLB.textColor                  = App_Color_MainTextBoldColor;
    self.ngay_qua_phepLB.textColor          = App_Color_MainTextBoldColor;
    self.dayLB.textColor                    = App_Color_MainTextBoldColor;
    self.totalNumOfDayLeaveLB.textColor     = [UIColor redColor];
    self.remainingAnnualDayLB.textColor     = [UIColor redColor];
    self.locationLB.textColor               = App_Color_MainTextBoldColor;
    self.locationTV.textColor               = App_Color_MainTextBoldColor;
    self.phoneNumberLB.textColor            = App_Color_MainTextBoldColor;
    self.phoneNumberTF.textColor            = App_Color_MainTextBoldColor;
    self.noteLB.textColor                   = App_Color_MainTextBoldColor;
    self.noteTV.textColor                   = App_Color_MainTextBoldColor;
    self.handoverLB.textColor               = App_Color_MainTextBoldColor;
    self.choiseHandOverLB.textColor         = App_Color_MainTextBoldColor;
    [self.handoverButton setTitleColor:App_Color_MainTextBoldColor forState:UIControlStateNormal];
    self.nameHandOverLB.textColor           = App_Color_MainTextBoldColor;
    self.positionHandOverLB.textColor       = App_Color_MainTextBoldColor;
    self.contentHandOverLB.textColor        = App_Color_MainTextBoldColor;
    self.contentHandOverTV.textColor        = App_Color_MainTextBoldColor;
    self.managerLB.textColor                = App_Color_MainTextBoldColor;
    self.nameManagerLB.textColor            = App_Color_MainTextBoldColor;
    self.positionManagerLB.textColor        = App_Color_MainTextBoldColor;
    [self.managerUserButton setTitleColor:App_Color_MainTextBoldColor forState:UIControlStateNormal];
    
    self.totalSabaticalDaysLB.text          = LocalizedString(@"TTNS_SO_NGAY_PHEP_CON_LAI");
    self.reasonLB.text                      = LocalizedString(@"TTNS_LY_DO_NGHI");
    self.timeLB.text                        = LocalizedString(@"TTNS_THOI_GIAN_NGHI");
    self.countLB.text                       = LocalizedString(@"TTNS_TONG");
    self.ngay_qua_phepLB.text               = LocalizedString(@"TTNS_NGAY_QUA_PHEP");
    self.dayLB.text                         = LocalizedString(@"TTNS_NGAY_1");
    self.locationLB.text                    = LocalizedString(@"TTNS_NOI_NGHI");
    self.phoneNumberLB.text                 = LocalizedString(@"TTNS_SDT");
    self.noteLB.text                        = LocalizedString(@"TTNS_GHI_CHU");
    self.choiseHandOverLB.text              = LocalizedString(@"TTNS_CHON_NGUOI_BAN_GIAO");
    self.handoverLB.text                    = LocalizedString(@"TTNS_NGUOI_DUOC_BAN_GIAO");
    self.contentHandOverLB.text             = LocalizedString(@"TTNS_NOI_DUNG_BAN_GIAO");
    self.managerLB.text                     = LocalizedString(@"TTNS_CHI_HUY_DON_VI");
    self.choiseManagerUserContentLB.text    = [NSString stringWithFormat:@"- %@ -", LocalizedString(@"TTNS_CHON_CHI_HUY_DON_VI")];
    self.choiseHandOverContentLB.text       = [NSString stringWithFormat:@"- %@ -", LocalizedString(@"TTNS_CHON_NGUOI_BAN_GIAO")];
    [self.saveButton setTitle:LocalizedString(@"TTNS_GHI_LAI") forState:UIControlStateNormal];
    [self.signButton setTitle:LocalizedString(@"TTNS_TRINH_KY") forState:UIControlStateNormal];
}

- (void)setHintForTV{
    self.resonTV.placeholder                = LocalizedString(@"Nhập lý do nghỉ");
    self.locationTV.placeholder             = LocalizedString(@"Nhập nơi nghỉ");
    self.phoneNumberTF.placeholder          = LocalizedString(@"Nhập số điện thoại");
    self.noteTV.placeholder                 = LocalizedString(@"Nhập ghi chú");
    self.contentHandOverTV.placeholder      = LocalizedString(@"Nhập nội dung bàn giao");
}

-(void)hideView{
    [self.handoverView setHidden:YES];
    [self.managerView setHidden:YES];
    
    [self.clearReasonBTN setHidden:YES];
    [self.clearLocationBTN setHidden:YES];
    [self.clearNoteBTN setHidden:YES];
    [self.clearContentHandOverBTN setHidden:YES];
}

- (void)setDelegateForTV{
    self.resonTV.delegate               = self;
    self.locationTV.delegate            = self;
    self.noteTV.delegate                = self;
    self.contentHandOverTV.delegate     = self;
}

- (void)setTagForTV{
    self.resonTV.tag               = nameTV_reason;
    self.locationTV.tag            = nameTV_location;
    self.noteTV.tag                = nameTV_note;
    self.contentHandOverTV.tag     = nameTV_handOver;
}

- (void)setupBorderForViews{
    [self.resonTV setBorderForView];
    [self.timeButton setDefaultBorder];
    [self.locationTV setBorderForView];
    [self.phoneNumberTF setBorderForView];
    [self.noteTV setBorderForView];
    [self.contentHandOverTV setBorderForView];
    [self.choiseHandoverUserView setBorderForView];
    [self.choiseManagerUserView setBorderForView];
}

- (void)addTappGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (BOOL)isValidate{
    if(self.resonTV != nil && ![self.resonTV.text isEqualToString:@""]){
        
        if(self.timeButton != nil && ![self.timeButton.titleLabel.text isEqualToString:currentTime]){
            isChanged = YES;
            if(self.locationTV != nil && ![self.locationTV.text isEqualToString:@""]){
                if(self.phoneNumberTF != nil && ![self.phoneNumberTF.text isEqualToString:@""]){
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

#pragma mark action

- (void)dismissKeyboard{
    //    [self.reasonTV resignFirstResponder];
    [self.view endEditing:YES];
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
                self.totalRemainDay.text = [NSString stringWithFormat:@"%ld", (long)remainDayModel.remainingAnnualDay];
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

#pragma mark IBAction

- (IBAction)clearReasonAction:(id)sender {
    self.resonTV.text = @"";
}

- (IBAction)clearLocationAction:(id)sender {
    self.locationTV.text = @"";
}

- (IBAction)clearNoteAction:(id)sender {
    self.noteTV.text = @"";
}


- (IBAction)clearContentHandOverAction:(id)sender {
    self.contentHandOverTV.text = @"";
}

- (IBAction)choiseTimeAction:(id)sender {
    if (self.timePickerVC == nil) {
        self.timePickerVC = NEW_VC_FROM_NIB(TimePickerVC, @"TimePickerVC");
        self.timePickerVC.delegate = self;
    }
    [self presentViewController:self.timePickerVC animated:YES completion:nil];
}

- (IBAction)handOverUserAction:(id)sender {
    ChoiseUserVC *vc = NEW_VC_FROM_STORYBOARD(@"InfoHuman", @"ChoiseUserVC");
    [AppDelegateAccessor.navIntegrationVC pushViewController:vc animated:YES];
}

- (IBAction)managerUserAction:(id)sender {
    ChoiseUserVC *vc = NEW_VC_FROM_STORYBOARD(@"InfoHuman", @"ChoiseUserVC");
    [AppDelegateAccessor.navIntegrationVC pushViewController:vc animated:YES];
}

- (IBAction)saveAction:(id)sender {
    if([self isValidate]){
        DLog(@"Save Action")
    }
}

- (IBAction)signAction:(id)sender {
    if([self isValidate]){
        DLog(@"SignAction")
    }
}

- (void)didTapBackButton{
    isChanged = [self isValidate];
    if(isChanged){
        [self showConfirmBackDialog:LocalizedString(@"Bạn muốn huỷ thao tác ?")];
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
            
        case nameTV_note:
            [self.clearNoteBTN setHidden:NO];
            break;
            
        case nameTV_handOver:
            [self.clearContentHandOverBTN setHidden:NO];
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
            
        case nameTV_note:
            [self.clearNoteBTN setHidden:YES];
            break;
            
        case nameTV_handOver:
            [self.clearContentHandOverBTN setHidden:YES];
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
