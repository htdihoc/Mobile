//
//  KTTS_CancelStatus_VC_iPad.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 6/7/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTTS_CancelStatus_VC_Delehate_iPad <NSObject>

- (void)actionShowConfirmTTTSlert;

@end


@interface KTTS_CancelStatus_VC_iPad : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *lbl_Title;

@property (weak, nonatomic) IBOutlet UIButton *btn_check_1;

@property (weak, nonatomic) IBOutlet UIButton *btn_check_2;

@property (weak, nonatomic) IBOutlet UIButton *btn_check_3;

@property (weak, nonatomic) IBOutlet UIImageView *img_Check_1;

@property (weak, nonatomic) IBOutlet UIImageView *img_Check_2;

@property (weak, nonatomic) IBOutlet UIImageView *img_Check_3;

- (IBAction)actionCheck_1:(id)sender;

- (IBAction)actionCheck_2:(id)sender;

- (IBAction)actionCheck_3:(id)sender;

- (IBAction)actionDismiss:(id)sender;

- (IBAction)actionAgree:(id)sender;

@property (weak, nonatomic) id<KTTS_CancelStatus_VC_Delehate_iPad> delegate;

@property (strong, nonatomic) NSString *merEntityId;
@property (strong, nonatomic) NSString *strStatus;
@property (nonatomic) NSInteger typeCancel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_ksd;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_mat;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_bao_hong;

@property (weak, nonatomic) IBOutlet UIView *view_ksd;
@property (weak, nonatomic) IBOutlet UIView *view_mat;
@property (weak, nonatomic) IBOutlet UIView *view_bao_hong;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
