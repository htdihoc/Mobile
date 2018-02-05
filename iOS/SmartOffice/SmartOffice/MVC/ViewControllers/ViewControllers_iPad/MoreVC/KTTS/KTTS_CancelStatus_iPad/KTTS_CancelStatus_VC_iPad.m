//
//  KTTS_CancelStatus_VC_iPad.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 6/7/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "KTTS_CancelStatus_VC_iPad.h"
#import "MZFormSheetController.h"
#import "KTTSProcessor.h"

@interface KTTS_CancelStatus_VC_iPad () <UIAlertViewDelegate> {
    UIImage *btnImage;
    NSString *message;
}

@property (nonatomic) BOOL setCancel;

@end

@implementation KTTS_CancelStatus_VC_iPad

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    MZFormSheetController *controller = self.navigationController.formSheetController;
    controller.shouldDismissOnBackgroundViewTap = NO;
    _setCancel = NO;
    btnImage = [UIImage imageNamed:@"icon_check.png"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.strStatus rangeOfString:@"KSD"].location != NSNotFound) {
            self.constraint_ksd.constant = 40;
            if (_setCancel == NO) {
                [_img_Check_1 setImage:btnImage];
                self.typeCancel = 3;
                message = @"Không sử dụng";
                _setCancel = YES;
            }
        } else {
            self.constraint_ksd.constant = 0;
            self.view_ksd.hidden = YES;
        }
        
        if ([self.strStatus rangeOfString:@"mất"].location != NSNotFound) {
            self.constraint_mat.constant = 40;
            if (_setCancel == NO) {
                [_img_Check_2 setImage:btnImage];
                self.typeCancel = 1;
                message = @"Đã báo mất";
                _setCancel = YES;
            }
        } else {
            self.constraint_mat.constant = 0;
            self.view_mat.hidden = YES;
        }
        
        if ([self.strStatus rangeOfString:@"hỏng"].location != NSNotFound) {
            self.constraint_bao_hong.constant = 40;
            if (_setCancel == NO) {
                [_img_Check_3 setImage:btnImage];
                self.typeCancel = 2;
                message = @"Đã báo hỏng";
                _setCancel = YES;
            }
        } else {
            self.constraint_bao_hong.constant = 0;
            self.view_bao_hong.hidden = YES;
        }
        
        //Your entry string
        NSString *myString = [NSString stringWithFormat:@"%@ %@ %@", @"Bạn chắc chắn muốn hủy thông báo ", message, @" với tài sản này?"];
        //Create mutable string from original one
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
        //Fing range of the string you want to change colour
        //If you need to change colour in more that one place just repeat it
        NSRange range = [myString rangeOfString:message];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:36.0f/255.0f green:152.0f/255.0f blue:218.0f/255.0f alpha:1.0f] range:range];
        //Add it to the label - notice its not text property but it's attributeText
        self.descriptionLabel.attributedText = attString;
        
        [self.view layoutIfNeeded];
    });
    //    36/152/218
    
//    message = @"Đã báo mất";
    

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    btnImage = [UIImage imageNamed:@"icon_check.png"];
//    [_img_Check_1 setImage:btnImage];
//    self.typeCancel = 3;
//    message = @"Không sử dụng";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)actionCheck_1:(id)sender {
    // Không sử dụng
    [_img_Check_1 setImage:btnImage];
    [_img_Check_2 setImage:nil];
    [_img_Check_3 setImage:nil];
    self.typeCancel = 3;
    message = @"Không sử dụng";
}

- (IBAction)actionCheck_2:(id)sender {
    // đã báo mất
    [_img_Check_1 setImage:nil];
    [_img_Check_2 setImage:btnImage];
    [_img_Check_3 setImage:nil];
    self.typeCancel = 1;
    message = @"Đã báo mất";
}

- (IBAction)actionCheck_3:(id)sender {
    // đã báo hỏng
    [_img_Check_1 setImage:nil];
    [_img_Check_2 setImage:nil];
    [_img_Check_3 setImage:btnImage];
    self.typeCancel = 2;
    message = @"Đã báo hỏng";
}

- (IBAction)actionDismiss:(id)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController * _Nonnull formSheetController) {
        
    }];
}

- (IBAction)actionAgree:(id)sender {
    [self.delegate actionShowConfirmTTTSlert];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Xác nhận" message:[NSString stringWithFormat:@"Bạn chắc chắn muốn hủy thông báo \"%@\" với tài sản này?", message] delegate:self cancelButtonTitle:@"Đóng" otherButtonTitles:@"Xác nhận", nil];
//    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
        {
            NSDictionary *parameter = @{
                                        @"merEntityId": self.merEntityId,
                                        @"type": IntToString(self.typeCancel)
                                        };
            [KTTSProcessor postKTTS_CANCEL_TTTS:parameter handle:^(id result, NSString *error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Hủy thành công." delegate:self cancelButtonTitle:@"Đóng" otherButtonTitles:nil, nil];
                [alert show];
            } onError:^(NSString *Error) {
                [self showAlertFailure:@"Có lỗi xảy ra. Vui lòng kiểm tra lại."];
            } onException:^(NSString *Exception) {
                [self showAlertFailure:@"Mất kết nối mạng"];
            }];
        }
            break;
        default:
            break;
    }
}

- (void) showAlertFailure:(NSString *)mess {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message: mess delegate:self cancelButtonTitle:@"Đóng" otherButtonTitles:nil, nil];
    [alert show];
}

@end
