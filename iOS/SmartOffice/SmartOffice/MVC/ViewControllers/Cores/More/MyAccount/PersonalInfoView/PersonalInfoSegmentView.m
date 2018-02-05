//
//  PersonalInfoSegmentView.m
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "PersonalInfoSegmentView.h"
#import "PersonalAssetInfoVC.h"
#import "BBBGInfoVC.h"

@interface PersonalInfoSegmentView ()

@end

@implementation PersonalInfoSegmentView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIViewController *vc = [self viewControllerForSegmentIndex:self.segAssetView.selectedSegmentIndex];
    [self addChildViewController:vc];
    vc.view.frame = self.viewContainer.bounds;
    [self.viewContainer addSubview:vc.view];
    self.currentVC = vc;
    
    [self.segAssetView addTarget:self action:@selector(segChangeView:) forControlEvents:UIControlEventValueChanged];
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

- (void)segChangeView:(id)sender {
    UISegmentedControl *segView = (UISegmentedControl *)sender;
    UIViewController *vc = [self viewControllerForSegmentIndex:segView.selectedSegmentIndex];
    [self addChildViewController:vc];
    [self transitionFromViewController:self.currentVC toViewController:vc duration:0.5 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
        [self.currentVC.view removeFromSuperview];
        vc.view.frame = self.viewContainer.bounds;
        [self.viewContainer addSubview:vc.view];
    } completion:^(BOOL finished) {
        [vc didMoveToParentViewController:self];
        [self.currentVC removeFromParentViewController];
        self.currentVC = vc;
    }];
    self.navigationItem.title = vc.title;
}

- (UIViewController *)viewControllerForSegmentIndex:(NSInteger)index {
    UIViewController *vc;
    switch (index) {
        case 0:
            vc = [[PersonalAssetInfoVC alloc] initWithNibName:@"PersonalAssetInfoVC" bundle:nil];
            break;
        case 1:
            vc = [[BBBGInfoVC alloc] initWithNibName:@"BBBGInfoVC" bundle:nil];
            break;
    }
    return vc;
}

@end
