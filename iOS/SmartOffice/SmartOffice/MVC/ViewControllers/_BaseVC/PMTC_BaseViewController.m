//
//  PMTC_BaseViewController.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 8/3/29 H.
//  Copyright © 29 Heisei ITSOL. All rights reserved.
//

#import "PMTC_BaseViewController.h"

@interface PMTC_BaseViewController ()

@end

@implementation PMTC_BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavi];
    self.view.backgroundColor = AppColor_MainAppBackgroundColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void) dismissKeyboard {
    [self.view endEditing:YES];
}

- (void) addNavi {
    self.view_navigation = [UIView new];
    self.view_navigation.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    self.view_navigation.backgroundColor = AppColor_MainAppTintColor;
    [self.view addSubview:self.view_navigation];
}

- (void) addTitle:(NSString *)strTitle {
    UILabel *title = [UILabel new];
    title.frame = CGRectMake(10, self.view_navigation.frame.size.height-30, self.view_navigation.frame.size.width, 30);
    title.text = strTitle;
    title.textColor = [UIColor whiteColor];
    [self.view_navigation addSubview:title];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
