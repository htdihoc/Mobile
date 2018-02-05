//
//  KTTS_ConfirmProperty_iPad.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "KTTS_ConfirmProperty_iPad.h"
#import "MZFormSheetController.h"

@interface KTTS_ConfirmProperty_iPad () <UITextViewDelegate>

@end

@implementation KTTS_ConfirmProperty_iPad

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    MZFormSheetController *controller = self.navigationController.formSheetController;
    controller.shouldDismissOnBackgroundViewTap = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.containerView setBackgroundColor:[UIColor whiteColor]];
    
    self.view_kindOfReport.items = @[@"Báo không sử dụng", @"Báo mất", @"Báo hỏng"];
    
    self.view_kindOfReport.layer.borderWidth            = 1.6;
    self.view_kindOfReport.layer.borderColor            = AppColor_BorderForView.CGColor;
    self.view_kindOfReport.layer.cornerRadius           = 2;
    
    self.tv_reason.layer.borderWidth                    = 1.6;
    self.tv_reason.layer.borderColor                    = AppColor_BorderForView.CGColor;
    self.tv_reason.layer.cornerRadius                   = 2;
    
    self.tv_quantity.layer.borderWidth                  = 1.6;
    self.tv_quantity.layer.borderColor                  = AppColor_BorderForView.CGColor;
    self.tv_quantity.layer.cornerRadius                 = 2;
    
    self.view_unuseDays.layer.borderWidth                = 1.6;
    self.view_unuseDays.layer.borderColor                = AppColor_BorderForView.CGColor;
    self.view_unuseDays.layer.cornerRadius               = 2;
    
    [self.btn_ClearReason setHidden:YES];
    self.tv_reason.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.showStatusBar = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.navigationController.formSheetController setNeedsStatusBarAppearanceUpdate];
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.btn_ClearReason setHidden:NO];

}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.btn_ClearReason setHidden:YES];
}

- (IBAction)clearTvReason:(id)sender {
    self.tv_reason.text = @"";
}

- (IBAction)chooseUnuseDays:(id)sender {
}

- (IBAction)cancelAction:(id)sender {
    
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController * _Nonnull formSheetController) {
        //
    }];
}

- (IBAction)sendAction:(id)sender {
    [self showAlertConfirm];
}

- (void)showAlertConfirm {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Xác nhận"
                                 message:@"Bạn có chắc chắn gửi thông tin này cho bên KTTS ?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Gửi"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //
                                }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Đóng"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //
                               }];
    [alert addAction:noButton];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(textView.text.length + (text.length - range.length)> 256){
        DLog(@"Show Toast");
        [self showToastWithMessage:@"Không vượt quá 256 ký tự"];
    }
    return textView.text.length + (text.length - range.length) <= 256;
}

@end
