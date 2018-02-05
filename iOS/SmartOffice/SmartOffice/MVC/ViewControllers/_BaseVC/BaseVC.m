//
//  BaseVC.m
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 3/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BaseVC.h"
#import "UIViewController+LGSideMenuController.h"
#import "LoginVC.h"
#import "MenuRootVC.h"
#import "FCAlertView.h"
#import "ReminderViewController.h"
#import "DiscussionListVC.h"
#import "MBProgressHUD.h"
#import "UIViewController+Alert.h"
#import "Common.h"
#import "NSDictionary+Utilities.h"
#import "NSException+Custom.h"
#import "QLTT_AlertVC.h"
#import "MZFormSheetController.h"
#import "CacheController.h"
#import "SO_HUDCustomView.h"
@interface BaseVC ()<TTNS_BaseNavViewDelegate> {
    LoginVC *loginVC;
    MBProgressHUD *_hud;
    BOOL _isVisibleKeyBoard;
    UILabel *_lbl_Content;
    FCAlertView *alert;
    CGSize _keyboardSize;
}
@end

@implementation BaseVC

- (void)initBase {
    [self.navigationController.navigationBar setHidden:YES];
//    self.view.backgroundColor = AppColor_MainAppBackgroundColor;
    [self.navigationController.navigationBar setBarTintColor:AppColor_MainAppTintColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    /*self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Left"
     style:UIBarButtonItemStylePlain
     target:self
     action:@selector(showLeftView)];
     
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right"
     style:UIBarButtonItemStylePlain
     target:self
     action:@selector(showRightView)];
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardDidShow: (NSNotification *) notifyKeyBoardShow{
    
    [self keyboardSize:notifyKeyBoardShow];
    CGFloat alertHeight = [self heightToPullUp];
    if (alertHeight > 0) {
        alert.frame = CGRectMake(alert.frame.origin.x, alert.frame.origin.y - [self heightToPullUp], alert.frame.size.width, alert.frame.size.height);
    }
    
    _isVisibleKeyBoard = YES;
}

- (void)keyboardDidHide: (NSNotification *) notifyKeyBoardHide{
    alert.frame = CGRectMake(alert.frame.origin.x, alert.frame.origin.y + [self heightToPullUp], alert.frame.size.width, alert.frame.size.height);
    _isVisibleKeyBoard = NO;
}
- (CGFloat)heightToPullUp
{
    CGFloat bottomAlert = [alert getAlertViewFrame].origin.y + [alert getAlertViewFrame].size.height;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    return (_keyboardSize.height - (screenHeight - bottomAlert));
    
}
- (CGSize)keyboardSize:(NSNotification *) notifyKeyBoardShow
{
    if (_keyboardSize.height == 0) {
        _keyboardSize = [[[notifyKeyBoardShow userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        //Given size may not account for screen rotation
        int height = MIN(_keyboardSize.height,_keyboardSize.width);
        int width = MAX(_keyboardSize.height,_keyboardSize.width);
        
        _keyboardSize = CGSizeMake(width, height);
    }
    return _keyboardSize;
}
- (BOOL)checkVisibleKeyBoard
{
    return _isVisibleKeyBoard;
}
- (void)addNavView
{
    [self.navView removeFromSuperview];
    self.navView = [[TTNS_BaseNavView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    self.navView.delegate = self;
    //    [self.navView customInit: self.backTitle];
    [self.navView customInit:self.backTitle subTitle:self.subTitle rightTitle:self.rightTitle];
    [self.view addSubview:self.navView];
    [self.navView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.navView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.navView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.navView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.navView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:64];
    [self.view addConstraints:@[left, height, right, top]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self endEditCurrentView];
}

- (void)endEditCurrentView
{
    [[self view] endEditing:TRUE];
	[self endEditCommentView];
}
- (void)endEditCommentView
{
	
}
- (void)btnRightAction{
	DLog(@"Right Action");
}
- (void)actionCheckInAndOut
{
    DLog(@"action");
}
- (void)showAlert:(UIViewController *)content
            title:(NSString *)title
       titleAlign:(NSTextAlignment)titleAlight
  leftButtonTitle:(NSString *)leftTitle
 rightButtonTitle:(NSString *)rightTitle
  leftButtonColor:(UIColor *)leftButtonColor
 rightButtonColor:(UIColor *)rightButtonColor
       leftHander:(void (^)(void))leftHander
      rightHander:(void (^)(void))rightHander
{
    
    alert = [[FCAlertView alloc] init];
    //    alert.delegate = self;
    alert.titleAlight = titleAlight;
    alert.titleColor = UIColorFromHex(0x353535);
    alert.keepAlert = self.keepAlert;
    alert.dismissOnOutsideTouch = 1;
    alert.hideDoneButton = 1;
    if (leftTitle) {
        [alert addButton:leftTitle withActionBlock:^{
            if (leftHander) {
                leftHander();
            }
            
        }];
    }
    if (rightTitle) {
        [alert addButton:rightTitle withActionBlock:^{
            if (rightHander) {
                rightHander();
            }
            
        }];
    }
    if (!leftTitle && !rightTitle) {
        //        alert.autoHideSeconds = 1;
    }
    if (leftButtonColor) {
        alert.firstButtonTitleColor = leftButtonColor;
    }
    if (rightButtonColor) {
        alert.secondButtonTitleColor = rightButtonColor;
    }
    [alert showAlertWithTitle:title
                  withSubView:content
                   andButtons:nil];
}
- (void)showAlert:(UIViewController *)content
            title:(NSString *)title
  leftButtonTitle:(NSString *)leftTitle
 rightButtonTitle:(NSString *)rightTitle
  leftButtonColor:(UIColor *)leftButtonColor
 rightButtonColor:(UIColor *)rightButtonColor
       leftHander:(void (^)(void))leftHander
      rightHander:(void (^)(void))rightHander;
{
    [self showAlert:content title:title titleAlign:NSTextAlignmentCenter leftButtonTitle:leftTitle rightButtonTitle:rightTitle leftButtonColor:leftButtonColor rightButtonColor:rightButtonColor leftHander:leftHander rightHander:rightHander];
}
- (void)keepAlertWhenTouch:(BOOL)enable
{
    self.keepAlert = enable;
    alert.keepAlert = enable;
}
- (void)dismissAlert
{
    [alert dismissAlertView];
}

- (void)showAlert:(UIViewController *)content
            title:(NSString *)title
  leftButtonTitle:(NSString *)leftTitle
 rightButtonTitle:(NSString *)rightTitle
       leftHander:(void (^ _Nullable )(void))leftHander
      rightHander:(void (^ _Nullable )(void))rightHander
{
    [self showAlert:content title:title titleAlign:NSTextAlignmentCenter leftButtonTitle:leftTitle rightButtonTitle:rightTitle leftHander:leftHander rightHander:rightHander];
}
- (void)showAlert:(UIViewController *)content
            title:(NSString *)title
       titleAlign:(NSTextAlignment)titleAlight
  leftButtonTitle:(NSString *)leftTitle
 rightButtonTitle:(NSString *)rightTitle
       leftHander:(void (^ _Nullable )(void))leftHander
      rightHander:(void (^ _Nullable )(void))rightHander
{

    [self showAlert:content title:title titleAlign:titleAlight leftButtonTitle:leftTitle rightButtonTitle:rightTitle leftButtonColor:AppColor_MainTextColor rightButtonColor:CommonColor_Red leftHander:leftHander rightHander:rightHander];
}

- (void)alertControllerBackgroundTapped
{
    //Tea
    
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated: YES
                                                                                       completion: nil];
    [self didDismissAlert];
}

- (void)didDismissAlert
{
    DLog(@"DidDismiss");
}

- (void)pushToReminderView
{
    if ([Common checkNetworkAvaiable]) {
        ReminderViewController *rm = NEW_VC_FROM_STORYBOARD(@"Reminder", @"ReminderViewController");
        [self pushIntegrationVC:rm];
    }
    else
    {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    
}

- (void)pushToChatView
{
    if ([Common checkNetworkAvaiable]) {
        DiscussionListVC *dcl = NEW_VC_FROM_NIB(DiscussionListVC, @"DiscussionListVC");
        [self presentViewController:dcl animated:YES completion:nil];
    }
    else
    {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBase];
    [self setupTextForViews];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = AppColor_MainAppBackgroundColor;
    
    //Setup Segmented Control
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:AppFont_MainFontWithSize(13), NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTintColor:AppColor_MainAppTintColor];
}

/*
 Add UIViewController in UIView
 */

- (void)displayVC:(UIViewController *)content container:(UIView *)containerView{
    [self addChildViewController:content];
    content.view.frame = containerView.bounds;
    [containerView addSubview:content.view];
    [content didMoveToParentViewController:self];
	content.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
}
- (void)addView:(UIView *)subView toView:(UIView *)mainView
{
    [mainView addSubview:subView];
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *top= [NSLayoutConstraint
                              constraintWithItem:subView
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:mainView
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint
                                  constraintWithItem:subView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual toItem:self.view
                                  attribute:NSLayoutAttributeBottom multiplier:1.0f
                                  constant:0];
    
    NSLayoutConstraint *left = [NSLayoutConstraint
                                constraintWithItem:subView
                                attribute:NSLayoutAttributeLeft
                                relatedBy:NSLayoutRelationEqual
                                toItem:mainView attribute:
                                NSLayoutAttributeLeft multiplier:1.0
                                constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint
                                 constraintWithItem:subView
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:mainView attribute:
                                 NSLayoutAttributeRight multiplier:1.0
                                 constant:0];
    /* 4. Add the constraints to button's superview*/
    [self.view addConstraints:@[top, left, bottom, right]];
}
- (void)setupTextForViews
{
    
}

- (void)pushIntegrationVC:(UIViewController *)vc{
    [AppDelegateAccessor.navIntegrationVC pushViewController:vc animated:YES];
}

- (void)pushMoreVC:(UIViewController *)vc{
    [AppDelegateAccessor.navMoreVC pushViewController:vc animated:YES];
}
- (void)popToIntegrationRoot
{
    [AppDelegateAccessor.navIntegrationVC popViewControllerAnimated:YES];
}

- (void)popToMoreRoot
{
    [AppDelegateAccessor.navMoreVC popViewControllerAnimated:YES];
}
#pragma mark TTNS_BaseNavViewDelegate

-(void)didTapBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didTapRightButton
{
    
}
#pragma mark - Show Left-right menu

- (void)showLeftView {
    [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
}

- (void)showRightView {
    [self.sideMenuController showRightViewAnimated:YES completionHandler:nil];
}

- (void)logout {
    if (loginVC == nil) {
        loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
    }
    THNavigationVC *navigationController = [[THNavigationVC alloc] initWithRootViewController:loginVC];
    
    MenuRootVC *mainViewController = [MenuRootVC new];
    mainViewController.rootViewController = navigationController;
    [mainViewController setupWithType:6];
    
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    window.rootViewController = navigationController;
    
    [UIView transitionWithView:[AppDelegate getInstance].window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}

#pragma mark - Handle Error from server
- (void)addContentLabel:(NSString *)content forView:(UIView *)subView
{
    [self removeContentLabel];
    if (!_lbl_Content) {
        _lbl_Content = [[UILabel alloc] initWithFrame:subView.bounds];
        _lbl_Content.numberOfLines = 0;
        _lbl_Content.center = subView.center;
        _lbl_Content.textColor = AppColor_MainTextColor;
        _lbl_Content.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_lbl_Content];
    }
    [_lbl_Content setHidden:NO];
    _lbl_Content.text = content;
    
    _lbl_Content.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *top= [NSLayoutConstraint
                              constraintWithItem:_lbl_Content
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:subView
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:64];
    NSLayoutConstraint *bottom = [NSLayoutConstraint
                                  constraintWithItem:_lbl_Content
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual toItem:subView
                                  attribute:NSLayoutAttributeBottom multiplier:1.0f
                                  constant:0];
    
    NSLayoutConstraint *left = [NSLayoutConstraint
                                constraintWithItem:_lbl_Content
                                attribute:NSLayoutAttributeLeft
                                relatedBy:NSLayoutRelationEqual
                                toItem:subView attribute:
                                NSLayoutAttributeLeft multiplier:1.0
                                constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint
                                 constraintWithItem:_lbl_Content
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:subView attribute:
                                 NSLayoutAttributeRight multiplier:1.0
                                 constant:0];
    /* 4. Add the constraints to button's superview*/
    [self.view addConstraints:@[top, left, bottom, right]];
}
- (void)addContentLabel:(NSString *)content
{
    [self addContentLabel:content forView:self.view];
}
- (void)removeContentLabel
{
    if (_lbl_Content) {
        [_lbl_Content setHidden:YES];
    }
}
- (void)showNotationLabel{
	if (_lbl_Content) {
		[_lbl_Content setHidden:NO];
	}
}
- (void)handleErrorFromResult:(id)result withException:(NSException *)exception inView:(UIView *)inView
{
    [self handleErrorFromResult:result withException:exception inView:inView isInstant:NO];
}
- (void)handleErrorFromResult:(id)result withException:(NSException *)exception inView:(UIView *)inView isInstant:(BOOL)isInstant{
    if (result != nil) {
        //NSInteger statusCode = [result[@"resultCode"] integerValue];
        //NSString *message = result[@"message"];
        //Canbe parse statusCode to show message here
        //DLog(@"Error with code: %ld", (long)statusCode);
        //[self showErrorWithAlert:message];
        [[Common shareInstance] showErrorHUDWithMessage:LocalizedString(@"Không kết nối được đến máy chủ, xin vui lòng kiểm tra và thử lại sau!") inView:inView];
    }else{
        //Parse/ from Exception
        //Error Exception
        //"Mất kết nối mạng"		   = "Mất kết nối mạng";
        //"Không kết nối được đến máy chủ, xin vui lòng kiểm tra và thử lại sau!" = "Không kết nối được đến máy chủ, xin vui lòng kiểm tra và thử lại sau!";
        
        if ([exception.userInfo[@"_kCFStreamErrorCodeKey"] integerValue] == RESP_CODE_EXCEPTION_NO_INTERNET || [exception.userInfo[@"_kCFStreamErrorCodeKey"] integerValue] ==  RESP_CODE_DOMAIN_NOT_COMPLETE) {
            [[Common shareInstance] showErrorHUDWithMessage:LocalizedString(@"Mất kết nối mạng") inView:inView];
            
        }
        else if ([exception.userInfo[@"_kCFStreamErrorCodeKey"] integerValue] == RESP_CODE_EXCEPTION_ERROR_SERVER || [exception.userInfo[@"_kCFStreamErrorCodeKey"] integerValue] == RESP_CODE_REQUEST_NOTCONNECT) {
            [[Common shareInstance] showErrorHUDWithMessage:LocalizedString(@"Không kết nối được đến máy chủ, xin vui lòng kiểm tra và thử lại sau!") inView:inView];
        }
        else
        {
            if (![exception.userInfo[@"_kCFStreamErrorCodeKey"] integerValue]) {
                if ([exception.userInfo checkKey: @"NSLocalizedDescription"]) {
                    [[Common shareInstance] showErrorHUDWithMessage:[exception.userInfo valueForKey:@"NSLocalizedDescription"] inView:inView];
                    return;
                }
                
            }
            [[Common shareInstance] showErrorHUDWithMessage:LocalizedString(@"Không kết nối được đến máy chủ, xin vui lòng kiểm tra và thử lại sau!") inView:inView];
			/* +++ Show Custom Message
            NSString *content = exception.description;
            
            if ([exception.userInfo checkKey: @"NSLocalizedDescription"]) {
                content = [exception.userInfo valueForKey:@"NSLocalizedDescription"];
            }
            else if ([exception.userInfo checkKey: @"NSTargetObjectUserInfoKey"]) {
                content = [exception.userInfo valueForKey:@"NSTargetObjectUserInfoKey"];
            }
            [[Common shareInstance] showErrorHUDWithMessage:content inView:inView];
			 */
        }
        
    }
    if (isInstant) {
        [Common shareInstance].canShowHub = NO;
    }
}


/*
 Convert Date to TimeStamp
 */

//- (NSInteger)convertDateToTimeStamp:(NSString*)strDate format:(NSString*)format{
//    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
//    [dateFormater setDateFormat:format];
//    NSDate *date = [dateFormater dateFromString:strDate];
//    NSTimeInterval interval = [date timeIntervalSince1970];
//
//}

#pragma mark AddHub
- (void)showHUDWithTitle:(NSString *)title inView:(UIView *)inView{
    [self dismissHub];
    //use this to show new hud
    _hud = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    // Set the custom view mode to show any view.
    _hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    //UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    SO_HUDCustomView *animateView = [[SO_HUDCustomView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    animateView.backgroundColor = [UIColor clearColor];
    _hud.customView = animateView;
    _hud.customView.backgroundColor = [UIColor clearColor];
    
    //Remove color on square
    _hud.bezelView.color = [UIColor clearColor];
    _hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    //Clear color
    //_hud.backgroundView.backgroundColor = [UIColor clearColor];
    //_hud.contentColor = [UIColor clearColor];
    
    // Looks a bit nicer if we make it square.
    _hud.square = YES;
}

- (void)dismissHub
{
    if (_hud) {
        [_hud hideAnimated:YES];
        ((SO_HUDCustomView *)_hud.customView).stop = true;
        [_hud removeFromSuperview];
        _hud.removeFromSuperViewOnHide = YES;
        _hud = nil;
    }
}

#pragma mark UIAlertViewController

- (void)showDialog:(NSString*)title messages:(NSString*)msg leftAction:(UIAlertAction*)leftAction rightAction:(UIAlertAction*)rightAction rightBtnColor:(UIColor*)rightColor tintColor:(UIColor*)tintColor{
    UIAlertController* alertView= [UIAlertController
                                   alertControllerWithTitle:title
                                   message:msg
                                   preferredStyle:UIAlertControllerStyleAlert];
//    [rightAction setValue:rightColor forKey:@"titleTextColor"];
    [alertView addAction:leftAction];
    [alertView addAction:rightAction];
    alertView.view.tintColor = tintColor;
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)showToastWithMessage:(NSString*)msg{
    msg = LocalizedString(msg);
    if (alert.isShowing == YES) {
        return;
    }
    alert = [[FCAlertView alloc] init];
    alert.isShowing = YES;
    //    alert.delegate = self;
    alert.dismissOnOutsideTouch = 1;
    alert.hideDoneButton = 1;
    alert.autoHideSeconds = 1;
    alert.subTitleColor = AppColor_MainAppTintColor;
    alert.subtitleFont = [UIFont boldSystemFontOfSize:15];
    [alert showAlertWithTitle:nil withSubtitle:msg withCustomImage:nil withDoneButtonTitle:nil andButtons:nil];
    
}

- (void)showConfirmBackDialog:(NSString*)msg{
    UIAlertAction* closeButton = [UIAlertAction actionWithTitle:LocalizedString(@"Huỷ bỏ") style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction* confirmButton = [UIAlertAction actionWithTitle:LocalizedString(@"Đồng ý") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [AppDelegateAccessor.navIntegrationVC popViewControllerAnimated:YES];
    }];
    
    [self showDialog:nil messages:msg leftAction:closeButton rightAction:confirmButton rightBtnColor:CommonColor_Red tintColor:AppColor_MainAppTintColor];
}

/*
 Convert TimeStamp to Date
 */

- (NSString*)convertTimeStampToDateStr:(NSInteger)timestamp format:(NSString*)format{
    NSDate *date                = [NSDate dateWithTimeIntervalSince1970:(timestamp/1000)];
    NSDateFormatter *formatter  = [[NSDateFormatter alloc]init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:format];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

- (NSInteger)convertDateTimeToTimeStamp:(NSString*)dateString format:(NSString*)format{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:format];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSDate *date = [df dateFromString:dateString];
    NSTimeInterval since1970 = [date timeIntervalSince1970];
    NSInteger result = since1970 * 1000;
    return result;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)showSecretAlert {
    QLTT_AlertVC *vc = NEW_VC_FROM_NIB(QLTT_AlertVC, @"QLTT_AlertVC");
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    CGSize size;
    
    if (IS_IPHONE) {
        size = CGSizeMake(0.8*SCREEN_WIDTH_PORTRAIT, 210);
    }
    else
    {
        size = CGSizeMake(300, 210);
    }
    formSheet.presentedFormSheetSize = size;
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.cornerRadius = 12;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    }];
}
@end
