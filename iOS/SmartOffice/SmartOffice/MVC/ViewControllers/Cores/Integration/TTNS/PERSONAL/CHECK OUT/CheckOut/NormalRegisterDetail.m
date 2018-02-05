//
//  RegisterDetail.m
//  CheckINAndOUT
//
//  Created by NguyenHienTuong on 4/17/17.
//  Copyright © 2017 NguyenHienTuong. All rights reserved.
//

#import "NormalRegisterDetail.h"
#import "TTNSProcessor.h"
#import "DetailRegisterInOutModel.h"
#import "ReasonModel.h"
#import "WorkPlaceModel.h"
#import "UIView+BorderView.h"
#import "UIButton+BorderDefault.h"
#import "Common.h"
#import "NSException+Custom.h"

@interface NormalRegisterDetail ()<BottomViewDelegate, UITextViewDelegate>{
@protected BOOL isChanged;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContraintStateView;
@property (weak, nonatomic) IBOutlet UIView *stateView;
@property (weak, nonatomic) IBOutlet UIView *reasonView;
@property (weak, nonatomic) IBOutlet UIView *bossNameView;

@property (weak, nonatomic) IBOutlet UILabel *lblState;

@property (weak, nonatomic) IBOutlet UILabel *lblReason;
@property (weak, nonatomic) IBOutlet UILabel *lblBossName;
@property (weak, nonatomic) IBOutlet UITextView *tv_DestinationPlace;


@property (weak, nonatomic) IBOutlet UITextView *tv_ReasonDetail;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (weak, nonatomic) IBOutlet UIButton *btn_Reason;

@property (weak, nonatomic) IBOutlet UILabel *lbl_State;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ReasonView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_byView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_PlaceView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ReasonRegisterView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ReasonDetailView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TimeintervalView;

@property (weak, nonatomic) IBOutlet UIButton *clearLocationBTN;

@property (weak, nonatomic) IBOutlet UIButton *clearReasonBTN;

@property (assign) Boolean isReject;
@end

typedef enum : NSInteger{
    InOutStatus_Confirm = 0,
    InOutStatus_Refure,
    InOutStatus_WaitConfirm,
    InOutStatus_NoSign
}InOutStatus;

typedef enum : NSInteger{
    nameTV_Location = 1,
    nameTV_Reason
}nameTV;

@implementation NormalRegisterDetail{
    DetailRegisterInOutModel *model;
    ReasonModel *reasonModel;
    WorkPlaceModel *workPlaceModel;
}

- (IBAction)back:(id)sender
{
    [self popToIntegrationRoot];
    
}

#pragma mark lifecycler

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isChanged = NO;
    [self loadingData];
    [self setupUI];
    self.backTitle = LocalizedString(@"TTNS_NormalRegisterDetail_Chi_tiết_đăng_ký");
}

#pragma mark UI

- (void)setupUI{
    [self setupBorderForViews];
    [self setTagForTV];
    
    switch (model.status) {
        case InOutStatus_Confirm:
            self.leftBtnAttribute = nil;
            self.rightBtnAttribute = nil;
            self.containterView.userInteractionEnabled = NO;
            [self.reasonView setHidden:YES];
            [self.bossNameView setHidden:YES];
            self.heightContraintStateView.constant = 30;
            self.lblState.text = LocalizedString(@"KLIST_REGISTER_FORM_STATUS_TYPE_2");
            self.lblState.textColor = CommonColor_Blue;
            break;
        case InOutStatus_Refure:
            self.rightBtnAttribute = [[BottomButton alloc] initWithDefautBlueColor:LocalizedString(@"TTNS_TTNS_RegistryGoOut_Gửi_đăng_ký")];
            self.lblState.text = LocalizedString(@"KLIST_REGISTER_FORM_STATUS_TYPE_0");
            self.lblState.textColor = CommonColor_Red;
            break;
        case InOutStatus_WaitConfirm:
            self.leftBtnAttribute = [[BottomButton alloc] initWithDefautRedColor:LocalizedString(@"TTNS_NormalRegisterDetail_Huỷ_trình_ký")];
            [self.reasonView setHidden:YES];
            [self.bossNameView setHidden:YES];
            self.heightContraintStateView.constant = 30;
            self.lblState.text = LocalizedString(@"KLIST_REGISTER_FORM_STATUS_TYPE_1");
            //            self.rightBtnAttribute = [[BottomButton alloc] initWithDefautBlueColor:LocalizedString(@"TTNS_NormalRegisterDetail_Chi_tiết_đăng_ký")];
            break;
            
        case InOutStatus_NoSign:
            self.leftBtnAttribute = [[BottomButton alloc] initWithDefautBlueColor:LocalizedString(@"TTNS_TTNS_RegistryGoOut_Gửi_đăng_ký")];
            [self.reasonView setHidden:YES];
            [self.bossNameView setHidden:YES];
            self.heightContraintStateView.constant = 30;
            self.lblState.text = LocalizedString(@"KLIST_REGISTER_FORM_STATUS_TYPE_3");
            break;
            
        default:
            break;
    }
}

- (void)setTagForTV{
    self.tv_DestinationPlace.tag        = nameTV_Location;
    self.tv_DestinationPlace.delegate   = self;
    [self.clearLocationBTN setHidden:YES];
    
    self.tv_ReasonDetail.tag            = nameTV_Reason;
    self.tv_ReasonDetail.delegate       = self;
    [self.clearReasonBTN setHidden:YES];
}

- (void)setupTextForViews
{
    _lbl_State.textColor                = AppColor_MainTextColor;
    _lblState.textColor                 = AppColor_MainTextColor;
    _lbl_ReasonView.textColor           = AppColor_MainTextColor;
    _lbl_byView.textColor               = AppColor_MainTextColor;
    _lbl_PlaceView.textColor            = AppColor_MainTextColor;
    _lbl_ReasonRegisterView.textColor   = AppColor_MainTextColor;
    _lbl_ReasonDetailView.textColor     = AppColor_MainTextColor;
    _lbl_TimeintervalView.textColor     = AppColor_MainTextColor;
    [_btn_Reason setTitleColor:AppColor_MainTextColor forState:UIControlStateNormal];
    [_timeButton setTitleColor:AppColor_MainTextColor forState:UIControlStateNormal];
    
    _lbl_State.text                     = LocalizedString(@"TTNS_NormalRegisterDetail_Trạng_thái");
    _lbl_ReasonView.text                = LocalizedString(@"TTNS_NormalRegisterDetail_Lý_do");
    _lbl_byView.text                    = LocalizedString(@"TTNS_NormalRegisterDetail_Người_từ_chối");
    _lbl_PlaceView.text                 = LocalizedString(@"TTNS_NormalRegisterDetail_Nơi_đến");
    _lbl_ReasonRegisterView.text        = LocalizedString(@"TTNS_NormalRegisterDetail_Lý_do_đăng_ký");
    _lbl_ReasonDetailView.text          = LocalizedString(@"TTNS_NormalRegisterDetail_Lý_do_chi_tiết");
    _lbl_TimeintervalView.text          = LocalizedString(@"TTNS_NormalRegisterDetail_Thời_gian_đăng_ký_ra_ngoài");
}
- (void)setupBorderForViews
{
    [self.tv_DestinationPlace setBorderForView];
    [self.tv_ReasonDetail setBorderForView];
    [self.timeButton setDefaultBorder];
    [self.btn_Reason setDefaultBorder];
}
- (void)removeElementsWhenRjecting
{
    [self.reasonView removeFromSuperview];
    [self.bossNameView removeFromSuperview];
}

- (void)updateUI{
    NSString *workPlace             = [NSString stringWithFormat:@"%@ %@", workPlaceModel.dataSource, workPlaceModel.name];
    NSString *reasonName            =  reasonModel.name;
    self.tv_DestinationPlace.text   = workPlace;
    [self.btn_Reason setTitle:reasonName forState:UIControlStateNormal];
}

- (BOOL)isChangedValue{
    return NO;
}

#pragma mark networking
- (void)loadingData{
    if([Common checkNetworkAvaiable]){
        [[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
        [TTNSProcessor getListRegisterWithId:self.empOutRegId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if(success){
                DLog("Detail form Register In Out Success: %@", resultDict);
                NSDictionary *data = [resultDict valueForKey:@"data"];
                model = [[DetailRegisterInOutModel alloc]initWithDictionary:data
                                                                      error:nil];
                DLog(@"%@", model);
                [self loadDetailReason:model.reasonOutId workPlaceDetail:model.workPlaceId];
                [[Common shareInstance]dismissHUD];
            } else {
                [[Common shareInstance]dismissHUD];
                [self handleErrorFromResult:resultDict withException:exception inView:self.view];
            }
        }];
    } else {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
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
        // loading ( )
        
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

#pragma mark Action
- (void)didTapBackButton{
    isChanged = [self isChangedValue];
    if(isChanged){
        [self showConfirmBackDialog:LocalizedString(@"Bạn muốn huỷ thao tác")];
    } else {
        DLog(@"Nothing here");
        [super didTapBackButton];
    }
}

#pragma mark IBAction
- (IBAction)clearLocationAction:(id)sender {
    self.tv_DestinationPlace.text = @"";
}

- (IBAction)clearReasonAction:(id)sender {
    self.tv_ReasonDetail.text = @"";
}


#pragma mark BottomButtonDelegate

- (void)didselectLeftButton{
    DLog(@"Left button action");
}

- (void)didSelectRightButton{
    DLog(@"Right Button Action");
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    isChanged = TRUE;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    switch (textView.tag) {
        case nameTV_Location:
            [self.clearLocationBTN setHidden:NO];
            break;
        case nameTV_Reason:
            [self.clearReasonBTN setHidden:NO];
            break;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    switch (textView.tag) {
        case nameTV_Location:
            [self.clearLocationBTN setHidden:YES];
            break;
        case nameTV_Reason:
            [self.clearReasonBTN setHidden:YES];
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
