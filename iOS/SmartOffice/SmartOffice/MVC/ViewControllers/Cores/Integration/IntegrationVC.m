//
//  ToolVC.m
//  SmartOffice
//
//  Created by Kaka on 4/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "IntegrationVC.h"
#import "InfoHumanVC.h"
#import "SoftHumanVC.h"
#import "VOfficeVC.h"
#import "CAPSPageMenu.h"
#import "UserManagement.h"
#import "TTNSRoot.h"

#import "ListNotificationVC.h"

@interface IntegrationVC ()<CAPSPageMenuDelegate>{
    TTNSRoot *_infoVC;
    VOfficeVC *_vOfficeVC;
    ViewType _currentIndex;
}
@property (nonatomic, strong) CAPSPageMenu *pageMenu;
@end


static CGFloat kHeightStatusAndNavigationBar = 64.0;
static CGFloat kHeightTabbar = 49.0;
@implementation IntegrationVC

#pragma mark LifeCycler
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AppDelegateAccessor.mainTabbarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

#pragma mark - CreateUI
- (void)createUI{
    //Hide Navigation Bar
    [self.navigationController.navigationBar setHidden:YES];
    _topView.backgroundColor = AppColor_MainAppTintColor;
    //Setup Menu
    [self setupPageMenu];
}

- (void)setupPageMenu{
    // Array to keep track of controllers in page menu
    NSMutableArray *controllerArray = [NSMutableArray array];
    
    // Create variables for all view controllers you want to put in the
    // page menu, initialize them, and add each to the controller array.
    // (Can be any UIViewController subclass)
    // Make sure the title property of all view controllers is set
    
    //    InfoHumanVC *_infoVC = NEW_VC_FROM_STORYBOARD(@"InfoHuman", @"InfoHumanVC");
    //    UserManagement *_infoVC = NEW_VC_FROM_NIB(UserManagement, @"UserManagement");
    
    _infoVC = NEW_VC_FROM_NIB(TTNSRoot, @"TTNSRoot");
    _infoVC.title = @"T.T.N.S";
    [controllerArray addObject:_infoVC];
    
    _vOfficeVC = NEW_VC_FROM_STORYBOARD(@"VOffice", @"VOfficeVC");
    _vOfficeVC.title = @"VOFFICE";
    [controllerArray addObject:_vOfficeVC];
    
	NSDictionary *parameters = @{CAPSPageMenuOptionMenuItemSeparatorWidth: @(4.3),
                                 CAPSPageMenuOptionUseMenuLikeSegmentedControl: @(YES),
								 CAPSPageMenuOptionMenuItemFont: AppFont_MainFontWithSize(18),
								 CAPSPageMenuOptionMenuItemSeparatorPercentageHeight: @(0.1),
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: AppColor_MainAppTintColor,
                                 CAPSPageMenuOptionMenuItemSeparatorWidth:@(1.0),
                                 CAPSPageMenuOptionMenuItemSeparatorColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor: [UIColor whiteColor],
								 CAPSPageMenuOptionAddBottomMenuHairline: @YES,
								 CAPSPageMenuOptionBottomMenuHairlineColor: AppColor_MainAppTintColor
                                 };
    
    // Initialize page menu with controller array, frame, and optional parameters
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 64.0, self.view.frame.size.width, self.view.frame.size.height - kHeightStatusAndNavigationBar - kHeightTabbar) options:parameters];
    _pageMenu.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    _pageMenu.view.translatesAutoresizingMaskIntoConstraints = YES;
    _pageMenu.view.backgroundColor = [UIColor clearColor];
    _pageMenu.delegate = self;
    _pageMenu.menuItemSeparatorRoundEdges = YES;
    _pageMenu.enableHorizontalBounce = YES;
    _pageMenu.controllerScrollView.scrollEnabled = YES;
	
    [self.view addSubview:_pageMenu.view];
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
    _currentIndex = index;
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


#pragma mark - Load Data

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

#pragma mark IBAction

- (IBAction)showListNotification:(id)sender {
    ListNotificationVC *vc = [[ListNotificationVC alloc]initWithNibName:@"ListNotificationVC" bundle:nil];
    [AppDelegateAccessor.navIntegrationVC pushViewController:vc animated:YES];
}

- (IBAction)buttonReloadAction:(id)sender {
    if (_currentIndex == ViewType_TTNS) {
		[_infoVC reloadData];// Tiệp viết lại hàm reload
    }
    else
    {
        [_vOfficeVC loadCurrentSegment];
    }
}

@end
