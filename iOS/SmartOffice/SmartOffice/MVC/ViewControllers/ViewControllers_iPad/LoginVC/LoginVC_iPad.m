//
//  LoginVC_iPad.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 4/24/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "LoginVC_iPad.h"

@interface LoginVC_iPad ()

@end

@implementation LoginVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [AppDelegateAccessor startMainIpad];
}
@end
