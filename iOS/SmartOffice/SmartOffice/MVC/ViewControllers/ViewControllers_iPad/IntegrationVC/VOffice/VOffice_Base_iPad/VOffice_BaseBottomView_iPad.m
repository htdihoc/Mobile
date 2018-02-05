//
//  VOffice_BaseBottomView_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_BaseBottomView_iPad.h"
#import "DiscussionListVC.h"
#import "MZFormSheetController.h"
#import "CreateReminderVC_iPad.h"
#import "Common.h"
#import "NSException+Custom.h"
@interface VOffice_BaseBottomView_iPad () <DiscussionListVCDelegate, CreateReminderVC_iPadDelegate>
@property (strong, nonatomic) VOfficeBottomView *bottomView;
@property (strong, nonatomic) DiscussionListVC *discussVC;
@property (strong, nonatomic) CreateReminderVC_iPad *createReminderVC;
@property (strong, nonatomic) MZFormSheetController *formSheet;
@end

@implementation VOffice_BaseBottomView_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addBottomView];
    
}
- (void)addBottomView
{
    CGFloat heightValue = 55;
    _bottomView = [[VOfficeBottomView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _bottomView.backgroundColor = [UIColor clearColor];
    _bottomView.delegate = self;
    [self.view addSubview:_bottomView];
    _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *bottom = [NSLayoutConstraint
                                  constraintWithItem:_bottomView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual toItem:self.view
                                  attribute:NSLayoutAttributeBottom multiplier:1.0f
                                  constant:0];
    
    NSLayoutConstraint *width = [NSLayoutConstraint
                                constraintWithItem:_bottomView
                                attribute:NSLayoutAttributeWidth
                                relatedBy:NSLayoutRelationEqual
                                toItem:nil attribute:
                                NSLayoutAttributeNotAnAttribute multiplier:1.0
                                constant:2*heightValue];
    NSLayoutConstraint *right = [NSLayoutConstraint
                                 constraintWithItem:_bottomView
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.view attribute:
                                 NSLayoutAttributeRight multiplier:1.0
                                 constant:-20];
    NSLayoutConstraint *height = [NSLayoutConstraint
                                  constraintWithItem:_bottomView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:nil attribute:
                                  NSLayoutAttributeNotAnAttribute multiplier:1.0
                                  constant:1.5*heightValue + 5];
    /* 4. Add the constraints to button's superview*/
    [self.view addConstraints:@[height, width, bottom, right]];
}
- (void)showChatView
{
    if (self.discussVC == nil) {
        self.discussVC = NEW_VC_FROM_NIB(DiscussionListVC, @"DiscussionListVC");
        self.discussVC.delegate  = self;
    }
    _formSheet = [[MZFormSheetController alloc] initWithViewController:self.discussVC];
    _formSheet.presentedFormSheetSize = CGSizeMake(SCREEN_WIDTH_LANDSCAPE - (SCREEN_WIDTH_LANDSCAPE/2), SCREEN_HEIGHT_LANDSCAPE - (SCREEN_HEIGHT_LANDSCAPE/2.5));
    //    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
    _formSheet.shadowRadius = 2.0;
    _formSheet.shadowOpacity = 0.3;
    _formSheet.cornerRadius = 12;
    _formSheet.shouldDismissOnBackgroundViewTap = YES;
    _formSheet.shouldCenterVertically = YES;
    _formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    [self mz_presentFormSheetController:_formSheet animated:YES completionHandler:nil];
}
- (void)showReminder
{
    if (self.createReminderVC == nil) {
        self.createReminderVC = NEW_VC_FROM_NIB(CreateReminderVC_iPad, @"CreateReminderVC_iPad");
        self.createReminderVC.delegate  = self;
    }
    _formSheet = [[MZFormSheetController alloc] initWithViewController:self.createReminderVC];
    _formSheet.presentedFormSheetSize = CGSizeMake(SCREEN_WIDTH_LANDSCAPE - (SCREEN_WIDTH_LANDSCAPE/2), SCREEN_HEIGHT_LANDSCAPE - (SCREEN_HEIGHT_LANDSCAPE/2.5));
    //    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
    _formSheet.shadowRadius = 2.0;
    _formSheet.shadowOpacity = 0.3;
    _formSheet.cornerRadius = 12;
    _formSheet.shouldDismissOnBackgroundViewTap = YES;
    _formSheet.shouldCenterVertically = YES;
    _formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    [self mz_presentFormSheetController:_formSheet animated:YES completionHandler:nil];
}
#pragma mark BottomDelegate
- (void)didSelectChatButton
{
    if ([Common checkNetworkAvaiable]) {
        [self showChatView];
    }else{
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    
}
- (void)didSelectReminderButton
{
    if ([Common checkNetworkAvaiable]) {
        [self showReminder];
    }else{
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    
    DLog(@"push to reminder view");
}

- (void)hiddenBottomView:(BOOL)isHidden {
    [_bottomView setHidden:isHidden];
}

#pragma mark DiscussionListVCDelegate
- (void)dismissVC
{
    [self.formSheet dismissAnimated:YES completionHandler:nil];
}
@end
