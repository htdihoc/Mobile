//
//  RegisterDetailVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "RegisterDetailVC_iPad.h"
#import "UIButton+BorderDefault.h"
#import "UIView+BorderView.h"
#import "TTNSProcessor.h"
#import "DetailRegisterInOutModel.h"
#import "ReasonModel.h"
#import "WorkPlaceModel.h"
#import "Common.h"
#import "NSException+Custom.h"



@interface RegisterDetailVC_iPad () <UITextViewDelegate>{
@protected  DetailRegisterInOutModel *model;
@protected  ReasonModel *reasonModel;
@protected  WorkPlaceModel *workPlaceModel;
@protected BOOL isChanged;
}

@end

typedef enum : NSInteger{
    InOutStatus_Confirm = 0,
    InOutStatus_Refure,
    InOutStatus_WaitConfirm,
    InOutStatus_NoSign
}InOutStatus;

@implementation RegisterDetailVC_iPad

//@synthesize delegate;

#pragma mark LifeCycler

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupButtonClearForTextview];
}

#pragma mark UI
- (void)setupUI{
    [self.cancelButton setBorderForButton:3 borderWidth:1 borderColor:[AppColor_BorderForCancelButton CGColor]];
    [self.cancelButton setTitle:LocalizedString(@"Huỷ") forState:UIControlStateNormal];
    [self.sendRegisterButton setTitle:LocalizedString(@"TTNS_TTNS_RegistryGoOut_Gửi_đăng_ký") forState:UIControlStateNormal];
    self.sendRegisterButton.layer.cornerRadius = 3;
//    [self.bottomView setHidden:YES];
    self.mTitle.text = @"Chi tiết đăng ký";
    [self setupTextForViews];
    [self setupBorderForViews];
    
    
    switch (model.status) {
        case InOutStatus_Confirm:
            self.containerView.userInteractionEnabled = NO;
            [self.reasonView setHidden:YES];
            [self.botView setHidden:YES];
            [self.cancelButton setHidden:YES];
            [self.sendRegisterButton setHidden:YES];
            self.heightContraintStateView.constant = 30;
            self.statusContentLB.text = LocalizedString(@"KLIST_REGISTER_FORM_STATUS_TYPE_2");
            self.detailReasonTV.editable = NO;
            self.statusContentLB.textColor = CommonColor_Blue;
            break;
        case InOutStatus_Refure:
            [self.sendRegisterButton setTitle:@"TTNS_TTNS_RegistryGoOut_Gửi_lại_đăng_ký" forState:UIControlStateNormal];
            [self.cancelButton setHidden:YES];
            self.statusContentLB.text = LocalizedString(@"KLIST_REGISTER_FORM_STATUS_TYPE_0");
            self.statusContentLB.textColor = CommonColor_Red;
            break;
        case InOutStatus_WaitConfirm:
            [self.cancelButton setTitle:LocalizedString(@"TTNS_TTNS_RegistryGoOut_Huỷ_đăng_ký") forState:UIControlStateNormal];
            [self.reasonView setHidden:YES];
            [self.botView setHidden:YES];
            self.heightContraintStateView.constant = 30;
            self.statusContentLB.text = LocalizedString(@"KLIST_REGISTER_FORM_STATUS_TYPE_1");
            self.statusContentLB.textColor = CommonColor_Orange;
            break;
        case InOutStatus_NoSign:
            [self.cancelButton setTitle:LocalizedString(@"TTNS_TTNS_RegistryGoOut_Huỷ_đăng_ký") forState:UIControlStateNormal];
            [self.stateView setHidden:YES];
            [self.reasonView setHidden:YES];
            [self.botView setHidden:YES];
            break;
            
        default:
            break;
    }
    
    [self addTappGesture];

}

- (void)updateUI{
    NSString *workPlace = [NSString stringWithFormat:@"%@ %@", workPlaceModel.dataSource, workPlaceModel.name];
    NSString *reasonName = reasonModel.name;
    [self.locationButton setTitle:workPlace forState:UIControlStateNormal];
    [self.reasonRegisterButton setTitle:reasonName forState:UIControlStateNormal];
}

- (void)setupButtonClearForTextview {
    isChanged = NO;
    [self.btnClearDetailReason setHidden:YES];
    [self setDelegateForTV];
}

- (void)setDelegateForTV {
    self.detailReasonTV.delegate    = self;
}

- (void)setupTextForViews{
    
}

- (void)setupBorderForViews{
    [self.locationButton setDefaultBorder];
    [self.reasonRegisterButton setDefaultBorder];
    [self.timeButton setDefaultBorder];
    [self.detailReasonTV setBorderForView];
}

- (void)addTappGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark action

- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

#pragma mark networking

- (void)loadingData:(NSInteger)empOutRegId{
       [[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
    [TTNSProcessor getListRegisterWithId:empOutRegId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        if(success){
            DLog("Detail form Register In Out Success: %@", resultDict);
            NSDictionary *data = [resultDict valueForKey:@"data"];
            model = [[DetailRegisterInOutModel alloc]initWithDictionary:data
                                                                  error:nil];
            [self loadDetailReason:model.reasonOutId workPlaceDetail:model.workPlaceId];
             [[Common shareInstance]dismissHUD];
        } else {
            [[Common shareInstance]dismissHUD];
            [self handleErrorFromResult:resultDict withException:exception inView:self.view];
        }
    }];
   
}

- (IBAction)clearDetailReasonAction:(id)sender {
    self.detailReasonTV.text = @"";
}

- (void)loadDetailReason:(NSInteger)reasonId workPlaceDetail:(NSInteger)workPlaceId{
    
    dispatch_group_t group = dispatch_group_create();
    // 1.
    dispatch_group_enter(group);
    [self getReasonDetail:reasonId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        if(success){
            NSDictionary *data = [resultDict valueForKey:@"data"];
            reasonModel = [[ReasonModel alloc]initWithDictionary:data error:nil];
        } else {
            [self handleErrorFromResult:resultDict withException:exception inView:self.view];
        }
        dispatch_group_leave(group);
    }];
    
    // 2.
    dispatch_group_enter(group);
    [self getWorkPlace:workPlaceId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        if(success){
            NSDictionary *data = [resultDict valueForKey:@"data"];
            workPlaceModel = [[WorkPlaceModel alloc]initWithDictionary:data error:nil];
        } else {
            [self handleErrorFromResult:resultDict withException:exception inView:self.view];
        }
        dispatch_group_leave(group);
    }];
    // all task complete
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self updateUI];
    });
}

#pragma mark request server

- (void)getRegisterDetail:(NSInteger)empOutRegId callBack:(Callback)callBack{
    [TTNSProcessor getListRegisterWithId:empOutRegId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
        // loading ()
        
    }];
}

- (void)getReasonDetail:(NSInteger)reasonId callBack:(Callback)callBack{
    [TTNSProcessor getReasonWithId:reasonId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}

- (void)getWorkPlace:(NSInteger)workPlaceId callBack:(Callback)callBack{
    [TTNSProcessor getWorkPlaceWithID:workPlaceId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}


#pragma mark IBAction
- (IBAction)locationAction:(id)sender {
}

- (IBAction)reasonRegisterAction:(id)sender {
}

- (IBAction)choiseTimeAction:(id)sender {
}

- (IBAction)sendRegisterAction:(id)sender {
}

- (IBAction)cancelAction:(id)sender {
}

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
        [self showToastWithMessage:@"Không vượt quá 256 ký tự"];
    }
    return textView.text.length + (text.length - range.length) <= 256;
}
@end
