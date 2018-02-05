//
//  LoginVC.m
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 3/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "LoginVC.h"
#import "THNavigationVC.h"
#import "MenuRootVC.h"
#import <Charts/Charts.h>
#import "TTNSProcessor.h"
#import "VOfficeProcessor.h"
@interface LoginVC () {
}
@property (weak, nonatomic) IBOutlet UIButton *btn_Login;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.text_username.text = @"010993"; //010993
    self.text_password.text = @"222222a@";
//    self.text_password.enabled = NO;
    [self.btn_Login setTitle:LocalizedString(@"Login") forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap];
    
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}

- (void)setupButtonLogin {
    [self.btn_Login.layer setCornerRadius:8];
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
	if (self.text_username.text.length > 0) {
        [self passLogin];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Vui lòng nhập Username." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void) passLogin {
	[GlobalObj getInstance].username = self.text_username.text;
    
    if (![self.text_username.text isEqualToString:@"010993"]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *employeeID = [f numberFromString:self.text_username.text];
        [GlobalObj getInstance].ttns_employID = employeeID;
        
        if (![self.text_password.text isEqualToString:@"222222a@"]) {
            [GlobalObj getInstance].ttns_userName = self.text_username.text;
            [GlobalObj getInstance].ttns_password = self.text_password.text;
        }
        
    }
    
    if (IS_PAD) {
        [AppDelegateAccessor startMainIpad];
        
    } else {
        [AppDelegateAccessor startMain];
    }
}


@end
