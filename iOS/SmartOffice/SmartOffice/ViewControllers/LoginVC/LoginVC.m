//
//  LoginVC.m
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 3/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "LoginVC.h"
#import "MainVC.h"
#import "THNavigationVC.h"
#import "MenuRootVC.h"

@interface LoginVC () {
    MenuRootVC *mainViewController;
    MainVC *mainVC;
}

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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

- (IBAction)btnLoginPressed:(id)sender {
    /*
    mainVC = [[MainVC alloc] initWithNibName:@"MainVC" bundle:nil];
    THNavigationVC *navigationController = [[THNavigationVC alloc] initWithRootViewController:mainVC];
    
    mainViewController = [MenuRootVC new];
    mainViewController.rootViewController = navigationController;
    //@"Blurred side views backgrounds",
    [mainViewController setupWithType:6];
    
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    window.rootViewController = mainViewController;
    
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
     */
    [AppDelegateAccessor startMain];
}

@end
