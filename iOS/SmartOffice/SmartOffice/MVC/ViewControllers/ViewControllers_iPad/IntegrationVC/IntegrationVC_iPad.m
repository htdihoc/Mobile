//
//  IntegrationVC_iPad.m
//  SmartOffice
//
//  Created by Kaka on 4/21/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "IntegrationVC_iPad.h"
#import "InfoHumanVC.h"
#import "SoftHumanVC.h"
#import "VOffice_MainView_iPad.h"
#import "VOffice_PersonalMainView_iPad.h"
#import "CAPSPageMenu.h"
#import "UserManagement.h"
#import "TTNSRoot.h"
#import "ListNotificationVC.h"
#import "UserManagerMainVC_iPad.h"
#import "NSException+Custom.h"
#import "TTNSProcessor.h"
#import "TTNSVC_iPad.h"
#import "MZFormSheetController.h"
#import "WYPopoverController.h"
#import "Common.h"
#import "NSException+Custom.h"
#import "VOffice_MiddelVC.h"
@interface IntegrationVC_iPad ()<CAPSPageMenuDelegate, WYPopoverControllerDelegate>{
@protected IntegrationVC_iPad *intergrationVC;
@protected WYPopoverController *popOverController;
    UserManagerMainVC_iPad *userManagerVC;
    VOffice_MiddelVC *_vOfficeMain;
//    VOffice_MainView_iPad *_vOfficeVC;
//    VOffice_PersonalMainView_iPad *_personalVOfficeVC;
    
}
@property (nonatomic, strong) CAPSPageMenu *pageMenu;

@end


static CGFloat kHeightStatusAndSpace = 35.0;
@implementation IntegrationVC_iPad
{
    BOOL isLoad;
}
#pragma mark LifeCycler

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AppDelegateAccessor.mainTabbarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (self.view.frame.size.width != 600 && !isLoad) {
        isLoad = YES;
        [self createUI];
    }
}

#pragma mark - CreateUI
- (void)createUI{
    //Hide Navigation Bar
    [self.navigationController.navigationBar setHidden:YES];
    //Setup Menu
    [self setupPageMenu];
}

- (void)setupPageMenu{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.backgroundColor = AppColor_MainAppTintColor;
    // Array to keep track of controllers in page menu
    NSMutableArray *controllerArray = [NSMutableArray array];
    // Create variables for all view controllers you want to put in the
    // page menu, initialize them, and add each to the controller array.
    // (Can be any UIViewController subclass)
    // Make sure the title property of all view controllers is set
    
    //    InfoHumanVC *_infoVC = NEW_VC_FROM_STORYBOARD(@"InfoHuman", @"InfoHumanVC");
    //    UserManagement *_infoVC = NEW_VC_FROM_NIB(UserManagement, @"UserManagement");
    
    //    TTNSRoot *_infoVC = NEW_VC_FROM_NIB(TTNSRoot, @"TTNSRoot");
    
#pragma mark user manager
    
    userManagerVC   = NEW_VC_FROM_NIB(UserManagerMainVC_iPad, @"UserManagerMainVC_iPad");
    userManagerVC.title                     = @"T.T.N.S";
    [controllerArray addObject:userManagerVC];
    
#pragma mark user nv
    
//    if (!isManager) {
//        _personalVOfficeVC = NEW_VC_FROM_NIB(VOffice_PersonalMainView_iPad, @"VOffice_PersonalMainView_iPad");
//        _personalVOfficeVC.title = @"VOFFICE";
//        [controllerArray addObject:_personalVOfficeVC];
//    }
//    else
//    {
//        _vOfficeVC = NEW_VC_FROM_NIB(VOffice_MainView_iPad, @"VOffice_MainView_iPad");
//        _vOfficeVC.title = @"VOFFICE";
//        [controllerArray addObject:_vOfficeVC];
//    }
    _vOfficeMain = NEW_VC_FROM_NIB(VOffice_MiddelVC, @"VOffice_MiddelVC");
    _vOfficeMain.title = @"VOFFICE";
    [controllerArray addObject:_vOfficeMain];
    NSDictionary *parameters = @{CAPSPageMenuOptionMenuItemSeparatorWidth: @(4.3),
                                 CAPSPageMenuOptionUseMenuLikeSegmentedControl: @(YES),
                                 CAPSPageMenuOptionMenuItemSeparatorPercentageHeight: @(0.1),
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: AppColor_MainAppTintColor,
                                 CAPSPageMenuOptionMenuItemSeparatorWidth:@(1.0),
                                 CAPSPageMenuOptionMenuItemSeparatorColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor: [UIColor whiteColor],
                                 CAPSWidthOfCustomizeTitleLabel:@(181.0)
                                 };
    
    // Initialize page menu with controller array, frame, and optional parameters
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 20.0, self.view.frame.size.width, self.view.frame.size.height - kHeightStatusAndSpace) options:parameters];
    _pageMenu.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _pageMenu.view.translatesAutoresizingMaskIntoConstraints = YES;
    _pageMenu.view.backgroundColor = [UIColor clearColor];
    _pageMenu.delegate = self;
    _pageMenu.menuItemSeparatorRoundEdges = YES;
    _pageMenu.enableHorizontalBounce = YES;
    _pageMenu.controllerScrollView.scrollEnabled = YES;
    [self.view addSubview:_pageMenu.view];
    [_pageMenu.view addSubview:[self addRingView]];
    [_pageMenu.view addSubview:[self addReloadButton]];
}

- (UIView*)addRingView{
    UIView *boundView = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 60, 0, 25, 25)];
    
    UIButton *ringButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [ringButton setImage:[UIImage imageNamed:@"inter_bell_icon"] forState:UIControlStateNormal];
    [ringButton addTarget:self action:@selector(showListNotification:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *bagedButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 15, 15)];
    bagedButton.backgroundColor = CommonColor_Red;
    bagedButton.layer.cornerRadius = bagedButton.bounds.size.height/2;
    [bagedButton setTitle:@"10" forState:UIControlStateNormal];
    bagedButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    bagedButton.tintColor = [UIColor whiteColor];
    [boundView addSubview:ringButton];
    [boundView addSubview:bagedButton];
    return boundView;
}

- (UIView *) addReloadButton {
    UIView *reloadView = [UIView new];
    reloadView.frame = CGRectMake(self.view.bounds.size.width - 93, 0, 25, 25);
    
    UIButton *reload_button = [UIButton new];
    reload_button.frame = CGRectMake(0, 0, 25, 25);
    [reload_button setImage:[UIImage imageNamed:@"refresh_button"] forState:UIControlStateNormal];
    [reload_button addTarget:self action:@selector(reloadDataVOffice) forControlEvents:UIControlEventTouchUpInside];
    [reloadView addSubview:reload_button];
    return reloadView;
}

- (void) reloadDataVOffice {
    [_vOfficeMain reloadData];
    //    [userManagerVC viewDidLoad];
//    if (isManager) {
//        [_vOfficeVC loadData];
//    }
//    else
//    {
//        [_personalVOfficeVC loadData];
//    }
    
    
}

#pragma mark - CAPSPageMenuDelegate
- (void)willMoveToPage:(UIViewController *)controller index:(NSInteger)index {
    switch (index) {
        case 0: {
            DLog(@"VOffice");
        }
            break;
        case 1: {
            DLog(@"TTNS");
        }
            break;
        default:
            break;
    }
}

- (void)didMoveToPage:(UIViewController *)controller index:(NSInteger)index {
    switch (index) {
        case 0: {
            DLog(@"VOffice show");
        }
            break;
        case 1: {
            DLog(@"TTNS show");
        }
            break;
        default:
            break;
    }
}


#pragma mark - networking
- (void)loadData{
    
    //+++ Use dispatch group to load multi service
    // Define errors to be processed when everything is complete.
    // One error per service; in this example we'll have two
    //    __block NSError *configError = nil;
    //    __block NSError *preferenceError = nil;
    
    // Create the dispatch group
    dispatch_group_t serviceGroup = dispatch_group_create();
    
    // Start the first service
    dispatch_group_enter(serviceGroup);
    
    //    [self.configService startWithCompletion:^(ConfigResponse *results, NSError* error){
    //        // Do something with the results
    //        configError = error;
    //        dispatch_group_leave(serviceGroup);
    //    }];
    
    // Start the second service
    //    dispatch_group_enter(serviceGroup);
    //    [self.preferenceService startWithCompletion:^(PreferenceResponse *results, NSError* error){
    //        // Do something with the results
    //        preferenceError = error;
    //        dispatch_group_leave(serviceGroup);
    //    }];
    
    dispatch_group_notify(serviceGroup,dispatch_get_main_queue(),^{
        // Assess any errors
        //        NSError *overallError = nil;
        //        if (configError || preferenceError)
        //        {
        //            // Either make a new error or assign one of them to the overall error
        //            overallError = configError ?: preferenceError;
        //        }
        //        // Now call the final completion block
        //        completion(overallError);
    });
}

- (void)showListNotification:(UIButton *)sender{
    if(popOverController == nil){
        ListNotificationVC *vc = NEW_VC_FROM_NIB(ListNotificationVC, @"ListNotificationVC");
        vc.title = @"";
        UINavigationController *contentVC = [[UINavigationController alloc] initWithRootViewController:vc];
        contentVC.view.backgroundColor = [UIColor whiteColor];
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.topConstraint.constant = 0;
        
        popOverController = [[WYPopoverController alloc]initWithContentViewController:contentVC];
        popOverController.delegate = self;
        popOverController.passthroughViews = @[self];
        popOverController.popoverLayoutMargins = UIEdgeInsetsMake(44, self.view.frame.size.width-260, self.view.frame.size.height-350, 16);
        
        popOverController.wantsDefaultContentAppearance = NO;
        
        [popOverController presentPopoverAsDialogAnimated:YES options:WYPopoverAnimationOptionFadeWithScale];
    } else {
        [self close: nil];
    }
}

- (void)close:(id)sender
{
    [popOverController dismissPopoverAnimated:YES completion:^{
        [self popoverControllerDidDismissPopover:popOverController];
    }];
}

#pragma mark - WYPopoverControllerDelegate

- (void)popoverControllerDidPresentPopover:(WYPopoverController *)controller
{
    NSLog(@"popoverControllerDidPresentPopover");
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    if (controller == popOverController)
    {
        popOverController.delegate = nil;
        popOverController = nil;
        // Do something
    }
}

- (BOOL)popoverControllerShouldIgnoreKeyboardBounds:(WYPopoverController *)popoverController
{
    return YES;
}

- (void)popoverController:(WYPopoverController *)popoverController willTranslatePopoverWithYOffset:(float *)value
{
    // keyboard is shown and the popover will be moved up by 163 pixels for example ( *value = 163 )
    *value = 0; // set value to 0 if you want to avoid the popover to be moved
}

@end
