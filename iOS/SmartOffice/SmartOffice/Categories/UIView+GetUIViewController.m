//
//  UIView+GetUIViewController.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/31/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "UIView+GetUIViewController.h"

@implementation UIView (GetUIViewController)
- (UIViewController *)viewController;
{
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else {
        return nil;
    }
}
@end
