//
//  BaseViewController_iPad.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 7/28/29 H.
//  Copyright © 29 Heisei ITSOL. All rights reserved.
//

#import "BaseViewController_iPad.h"

@interface BaseViewController_iPad ()

@end

@implementation BaseViewController_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self styleNavigationBar];
    
}

- (void) styleNavigationBar {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UINavigationBar *newNavBar = [UINavigationBar new];
    newNavBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64);
    [newNavBar setBarTintColor: AppColor_MainAppTintColor];
    
    UINavigationItem *newItem = [UINavigationItem new];
    
    self.button_back = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonBackAction)];
    newItem.leftBarButtonItem = self.button_back;
    
    [newNavBar setItems:@[newItem]];
    [self.view addSubview:newNavBar];
}

- (void) buttonBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
