//
//  RegisterWifeSpawnDetail.m
//  SmartOffice
//
//  Created by NguyenDucBien on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "RegisterWifeSpawnDetail.h"
#import "SearchHandler_iPad.h"
#import "MZFormSheetController.h"
#import "Common.h"
#import "NSException+Custom.h"
#import "UIButton+BorderDefault.h"
#import "UIView+BorderView.h"

@interface RegisterWifeSpawnDetail () <ChooseHandlerDelegate, UITextViewDelegate, MZFormSheetBackgroundWindowDelegate> {
@protected BOOL isChanged;
@protected NSString *currentTime;
}

@end

@implementation RegisterWifeSpawnDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupButtonClearForTextview];
    [self addTappGesture];
    self.mTitle.text = @"Chi tiết đăng ký";
    
}

- (void)setupUI{
    [self fisrtSetup];
    [self setDelegateForTV];
}

- (void)fisrtSetup {
    self.timeOff.text = LocalizedString(@"TTNS_THOI_GIAN_NGHI");
    self.offPlace.text = LocalizedString(@"TTNS_NOI_NGHI");
    self.offPlaceTextview.layer.borderWidth = 0.3;
    self.offPlaceTextview.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.offPlaceTextview.layer.cornerRadius = 3;
    self.offPlaceTextview.placeholder = LocalizedString(@"Nhập nơi nghỉ");
    self.telNumberTextfile.placeholder = LocalizedString(@"Nhập số điện thoại");
    self.telNumber.text = LocalizedString(@"TTNS_SDT");
    self.noteLabel.text = LocalizedString(@"TTNS_NGUOI_DUOC_BAN_GIAO");
    self.contentHandlerChoose.text = [NSString stringWithFormat:@"- %@ -",LocalizedString(@"TTNS_CHON_NGUOI_BAN_GIAO")];
    self.chooseHandlerButton.layer.borderWidth = 0.3;
    self.chooseHandlerButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.chooseHandlerButton.layer.cornerRadius = 3;
    self.unitCommanderLabel.text = LocalizedString(@"TTNS_CHI_HUY_DON_VI");
    self.contentManagerUnit.text = [NSString stringWithFormat:@"- %@ -",LocalizedString(@"TTNS_CHON_CHI_HUY_DON_VI")];
    self.unitCommanderButton.layer.borderWidth = 0.3;
    self.unitCommanderButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.unitCommanderButton.layer.cornerRadius = 3;
    [self.registryButton setTitle:LocalizedString(@"TTNS_TRINH_KY") forState:UIControlStateNormal];
    self.registryButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.recordButton setTitle:LocalizedString(@"TTNS_GHI_LAI") forState:UIControlStateNormal];
    self.recordButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (void)setupButtonClearForTextview {
    isChanged = NO;
    self.telNumberTextfile.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.btnClearLocation setHidden:YES];
    [self.TimeButton setDefaultBorder];
    
    currentTime = [NSString stringWithFormat:@"%@ -> %@", [[Common shareInstance] getCurrentTime], [[Common shareInstance]getCurrentTime]];
//    [self.TimeButton setTitle:currentTime forState:UIControlStateNormal];
    self.lbTimeOff.text = currentTime;
}

- (void)setDelegateForTV {
    self.offPlaceTextview.delegate    = self;
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

- (void)addTappGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark action
- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

- (BOOL)isValidate{
    if(self.TimeButton != nil && ![self.TimeButton.titleLabel.text isEqualToString:currentTime]){
        if(self.offPlace != nil && ![[self.offPlace.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
            if(self.telNumberTextfile != nil && ![[self.telNumberTextfile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
                DLog(@"Check chi huy don vi");
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
    return NO;
}

#pragma mark IBActiton
- (IBAction)clearLocationAction:(id)sender {
    self.offPlaceTextview.text = @"";
}

- (IBAction)handlerButtonAction:(id)sender {
    [self showPopupChooseHandler];
}

- (IBAction)commanderButtonAction:(id)sender {
//    [self showPopupChooseHandler];
}

- (IBAction)registryButtonAction:(id)sender {
    if([Common checkNetworkAvaiable]){
        if([self isValidate]){
            DLog(@"Register Wife");
        }
    } else {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}

- (IBAction)recordButtonAction:(id)sender {
    if([Common checkNetworkAvaiable]){
        if([self isValidate]){
            DLog(@"Save Wife");
        }
    } else {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}

- (IBAction)TimeAction:(id)sender {
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    isChanged = TRUE;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self.btnClearLocation setHidden:NO];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.btnClearLocation setHidden:YES];
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
