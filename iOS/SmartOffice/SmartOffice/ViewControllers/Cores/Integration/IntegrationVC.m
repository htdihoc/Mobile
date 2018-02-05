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

@interface IntegrationVC ()<CAPSPageMenuDelegate>{
    
}
@property (nonatomic, strong) CAPSPageMenu *pageMenu;
@end

@implementation IntegrationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - CreateUI
- (void)createUI{
    //Hide Navigation Bar
    [self.navigationController.navigationBar setHidden:YES];
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

    InfoHumanVC *_infoVC = NEW_VC_FROM_STORYBOARD(@"InfoHuman", @"InfoHumanVC");
    _infoVC.title = @"T.T.N.S";
    [controllerArray addObject:_infoVC];
    
    VOfficeVC *_vOfficeVC = NEW_VC_FROM_STORYBOARD(@"VOffice", @"VOfficeVC");
    _vOfficeVC.title = @"VOFFICE";
    [controllerArray addObject:_vOfficeVC];
    
    SoftHumanVC *_softVC = NEW_VC_FROM_STORYBOARD(@"SoftHuman", @"SoftHumanVC");
    _softVC.title = @"P.M.N.S";
    [controllerArray addObject:_softVC];
    NSDictionary *parameters = @{CAPSPageMenuOptionMenuItemSeparatorWidth: @(4.3),
                                 CAPSPageMenuOptionUseMenuLikeSegmentedControl: @(YES),
                                 CAPSPageMenuOptionMenuItemSeparatorPercentageHeight: @(0.1),
                                 CAPSPageMenuOptionSelectionIndicatorColor: kMainAppTintColor,
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: kMainAppBackgroundColor,
                                 CAPSPageMenuOptionMenuItemSeparatorWidth:@(1.0),
                                 CAPSPageMenuOptionMenuItemSeparatorColor: [UIColor blackColor],
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor: [UIColor blackColor],
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor: [UIColor blackColor]
                                 };
    
    // Initialize page menu with controller array, frame, and optional parameters
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 64.0, self.view.frame.size.width, self.view.frame.size.height - 64) options:parameters];
    _pageMenu.delegate = self;
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


@end
