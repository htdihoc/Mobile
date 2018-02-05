//
//  MainVC.m
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 3/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "MainVC.h"
#import "VOfficeMainVC.h"
#import "TTNSMainVC.h"

@interface MainVC () {
    //TabBar *tabBar;
    //NSMutableArray *arrTabBarButtons;
}

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imageRoot"]];
//    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.imageView.clipsToBounds = YES;
//    [self.view addSubview:self.imageView];
    
//    self.button = [UIButton new];
//    self.button.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
//    [self.button setTitle:@"Show Choose Controller" forState:UIControlStateNormal];
//    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.button setTitleColor:[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0] forState:UIControlStateHighlighted];
//    [self.button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
//    [self.button setFrame:CGRectMake(50, 250, 200, 40)];
//    [self.view addSubview:self.button];
    
    [self initPageTab];
    [self initTabbar];
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

- (void)initPageTab {
    NSMutableArray *controllerArray = [NSMutableArray array];
    //NSMutableArray *menuPageArray = [NSMutableArray array];
    
    VOfficeMainVC *vOffice = [[VOfficeMainVC alloc] initWithNibName:@"VOfficeMainVC" bundle:nil];
    [controllerArray addObject:vOffice];
    TTNSMainVC *ttNS = [[TTNSMainVC alloc] initWithNibName:@"TTNSMainVC" bundle:nil];
    [controllerArray addObject:ttNS];
    
    NSDictionary *parameters = @{CAPSPageMenuOptionMenuItemSeparatorWidth: @(4.3),
                                 CAPSPageMenuOptionUseMenuLikeSegmentedControl: @(YES),
                                 CAPSPageMenuOptionMenuItemSeparatorPercentageHeight: @(0.1)
                                 };
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 60, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    _pageMenu.delegate = self;
    _pageMenu.viewBackgroundColor = [UIColor groupTableViewBackgroundColor];
    for (int i=0; i < [_pageMenu.menuItems count]; i++) {
        MenuItemView *tmpMenu = [_pageMenu.menuItems objectAtIndex:i];
        switch (i) {
            case 0:
            {
                [tmpMenu setTitleText:@"VOffice"];
            }
                break;
            case 1:
            {
                [tmpMenu setTitleText:@"TTNS"];
            }
                break;
            default:
                break;
        }
    }
    
    [self.view addSubview:_pageMenu.view];
    
}

- (void)initTabbarButtons {
    
}

- (void)initTabbar {
    [self initTabbarButtons];
}

- (IBAction)btnLogoutPressed:(id)sender {
    [self logout];
}

#pragma mark -

- (void)willMoveToPage:(UIViewController *)controller index:(NSInteger)index {
    switch (index) {
        case 0: {
            NSLog(@"VOffice");
        }
            break;
        case 1: {
            NSLog(@"TTNS");
        }
            break;
        default:
            break;
    }
}

- (void)didMoveToPage:(UIViewController *)controller index:(NSInteger)index {
    switch (index) {
        case 0: {
            NSLog(@"VOffice show");
        }
            break;
        case 1: {
            NSLog(@"TTNS show");
        }
            break;
        default:
            break;
    }
}

@end
