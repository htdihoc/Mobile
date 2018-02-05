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

@interface BaseVC () {
    LoginVC *loginVC;
}

@end

@implementation BaseVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initBase];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self initBase];
    }
    return self;
}

- (void)initBase {
    self.view.backgroundColor = kMainAppBackgroundColor;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Left"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(showLeftView)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(showRightView)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMainAppBackgroundColor;
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

@end
