//
//  UIViewController+Alert.m
//  SmartOffice
//
//  Created by Kaka on 5/16/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)

- (void)showAlertWithMessage:(NSString *)message{
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:LocalizedString(@"KALERT_TITLE") message:message preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:LocalizedString(@"KLOGIN_ALERT_BTN_OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
	
	[alert addAction:defaultAction];
	[self presentViewController:alert animated:YES completion:nil];
}
- (void)showErrorWithAlert:(NSString *)errorMessage{
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:LocalizedString(@"KALERT_ERROR_TITLE")
																   message:errorMessage
															preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:LocalizedString(@"KLOGIN_ALERT_BTN_OK") style:UIAlertActionStyleDefault
														  handler:^(UIAlertAction * action) {}];
	[alert addAction:defaultAction];
	[self presentViewController:alert animated:YES completion:nil];
}
@end
