//
//  ConfirmRefueAllVC_iPad.m
//  SmartOffice
//
//  Created by NguyenDucBien on 6/22/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "ConfirmRefueAllVC_iPad.h"
#import "UIButton+BorderDefault.h"
#import "UIView+BorderView.h"
#import "Common.h"
#import "MZFormSheetController.h"

@interface ConfirmRefueAllVC_iPad ()<UITextViewDelegate> {
@protected BOOL isChanged;
}

@end

@implementation ConfirmRefueAllVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupButtonClearForTextview];
}


- (void)setupUI {
    self.tittleLB.text = LocalizedString(@"Xác nhận từ chối phê duyệt");
    self.reasonLB.text = LocalizedString(@"TTNS_LY_DO");
    self.reasonTV.layer.borderWidth = 1;
    self.reasonTV.layer.cornerRadius = 3;
    self.reasonTV.layer.borderColor = AppColor_BorderForView.CGColor;
    [self.reasonTV becomeFirstResponder];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setHindForTextview];
    [self setDelegateForTV];
    
}

- (void)setHindForTextview {
    self.reasonTV.placeholder = LocalizedString(@"Nhập lý do từ chối phê duyệt");
}

- (void)setupButtonClearForTextview {
    isChanged = NO;
    [self.btnClearTV setHidden:YES];
}

- (void)setDelegateForTV {
    self.reasonTV.delegate = self;
}

- (IBAction)clearTVButtonAction:(id)sender {
    self.reasonTV.text = @"";
}


- (BOOL)isValidate{
    if(self.reasonTV != nil && ![self.reasonTV.text isEqualToString:@""]){
        [[Common shareInstance]showErrorHUDWithMessage:[NSString stringWithFormat:@"%@ %@", LocalizedString(@"Bạn chưa nhập"), LocalizedString(@"TTNS_LY_DO")] inView:self.view];
    }
    return NO;
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    isChanged = TRUE;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self.btnClearTV setHidden:NO];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.btnClearTV setHidden:YES];
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

- (IBAction)okButtonAction:(id)sender {
    
    if([self isValidate]){
        DLog(@"SignAction")
    }
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController * _Nonnull formSheetController) {
    }];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController * _Nonnull formSheetController) {
    }];
}
@end
