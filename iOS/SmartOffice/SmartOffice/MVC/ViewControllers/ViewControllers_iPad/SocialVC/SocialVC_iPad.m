//
//  SocialVC_iPad.m
//  SmartOffice
//
//  Created by Kaka on 4/21/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SocialVC_iPad.h"
#import "IntegrationVC_iPad.h"

@interface SocialVC_iPad ()

@end

@implementation SocialVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self.navigationController.navigationBar setHidden:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLayoutSubviews{
	[super viewDidLayoutSubviews];
	//self.view.backgroundColor = AppColor_MainAppTintColor;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)next:(id)sender {
	IntegrationVC_iPad *demo = [[IntegrationVC_iPad alloc] initWithNibName:@"IntegrationVC_iPad" bundle:nil];
	[self.navigationController pushViewController:demo animated:YES];
}

@end
