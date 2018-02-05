//
//  UIViewController+Alert.h
//  SmartOffice
//
//  Created by Kaka on 5/16/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alert)
- (void)showAlertWithMessage:(NSString *)message;
- (void)showErrorWithAlert:(NSString *)errorMessage;

@end
