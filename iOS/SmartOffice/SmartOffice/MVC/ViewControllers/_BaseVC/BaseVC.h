//
//  BaseVC.h
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 3/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNS_BaseNavView.h"
#import "QLTT_Protocol.h"
@class TTNS_BaseNavView;
@interface BaseVC : UIViewController

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) TTNS_BaseNavView *navView;
- (void)pushToReminderView;
- (void)pushToChatView;
- (void)popToIntegrationRoot;
- (void)popToMoreRoot;
- (void)pushIntegrationVC:(UIViewController *)vc;
- (void)pushMoreVC:(UIViewController *)vc;
- (void)logout;
- (void)showAlert:(UIViewController *)content
            title:(NSString *)title
  leftButtonTitle:(NSString *)leftTitle
 rightButtonTitle:(NSString *)rightTitle
leftHander:(void (^)(void))leftHander
rightHander:(void (^)(void))rightHander;

- (void)showAlert:(UIViewController *)content
            title:(NSString *)title
  leftButtonTitle:(NSString *)leftTitle
 rightButtonTitle:(NSString *)rightTitle
  leftButtonColor:(UIColor *)leftButtonColor
 rightButtonColor:(UIColor *)rightButtonColor
       leftHander:(void (^)(void))leftHander
      rightHander:(void (^)(void))rightHander;

- (void)showAlert:(UIViewController *)content
            title:(NSString *)title
       titleAlign:(NSTextAlignment)titleAlight
  leftButtonTitle:(NSString *)leftTitle
 rightButtonTitle:(NSString *)rightTitle
       leftHander:(void (^)(void))leftHander
      rightHander:(void (^)(void))rightHander;

- (void)showAlert:(UIViewController *)content
            title:(NSString *)title
       titleAlign:(NSTextAlignment)titleAlight
  leftButtonTitle:(NSString *)leftTitle
 rightButtonTitle:(NSString *)rightTitle
  leftButtonColor:(UIColor *)leftButtonColor
 rightButtonColor:(UIColor *)rightButtonColor
       leftHander:(void (^)(void))leftHander
      rightHander:(void (^)(void))rightHander;


- (void)didDismissAlert;

@property (strong, nonatomic) UIButton *btnAction;
@property (strong, nonatomic) NSString *backTitle;
@property (strong, nonatomic) NSString *subTitle;
@property (strong, nonatomic) UIButton *btnRight;
@property (strong, nonatomic) NSString *rightTitle;
@property BOOL keepAlert;
- (void)keepAlertWhenTouch:(BOOL)enable;
- (void)btnRightAction;

- (void)addNavView;

- (void)displayVC:(UIViewController *)content container:(UIView *)containerView;

- (void)addView:(UIView *)subView toView:(UIView *)mainView;

- (void)setupTextForViews;


- (void)endEditCurrentView;

- (void)didTapBackButton;

- (void)didTapRightButton;

- (void)addContentLabel:(NSString *)content;

- (void)addContentLabel:(NSString *)content forView:(UIView *)subView;

- (void)removeContentLabel;

- (void)showNotationLabel;

- (void)showHUDWithTitle:(NSString *)title inView:(UIView *)inView;

- (void)dismissHub;

- (void)showSecretAlert;
- (BOOL)checkVisibleKeyBoard;
#pragma mark - Handle Error from Result (Server)
- (void)handleErrorFromResult:(id)result withException:(NSException *)exception inView:(UIView *)inView;
- (void)handleErrorFromResult:(id)result withException:(NSException *)exception inView:(UIView *)inView isInstant:(BOOL)isInstant;
#pragma mark - UIAlertViewController
- (void)showDialog:(NSString*)title messages:(NSString*)msg leftAction:(UIAlertAction*)leftAction rightAction:(UIAlertAction*)rightAction rightBtnColor:(UIColor*)rightColor tintColor:(UIColor*)tintColor;

- (void)showToastWithMessage:(NSString*)msg;

- (void)showConfirmBackDialog:(NSString*)msg;

- (void)endEditCommentView;

- (void)dismissAlert;
#pragma mark Date Time
- (NSString*)convertTimeStampToDateStr:(NSInteger)timestamp format:(NSString*)format;
- (NSInteger)convertDateTimeToTimeStamp:(NSString*)dateString format:(NSString*)format;

@end
