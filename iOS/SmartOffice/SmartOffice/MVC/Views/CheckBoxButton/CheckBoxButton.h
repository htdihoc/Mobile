//
//  CheckBoxButton.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/18/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBoxButton : UIControl

- (void)setChecked : (BOOL)isChecked;
- (void)setEnabled:(BOOL)isEnabled;
- (void)setText: (NSString*)stringValue;

@property IBInspectable UIColor *checkColor;
@property IBInspectable UIColor *boxFillColor;
@property IBInspectable UIColor *boxBorderColor;
@property IBInspectable UIFont *labelFont;
@property IBInspectable UIColor *labelTextColor;
@property IBInspectable UIImage *imgCheck;
@property IBInspectable UIImage *imgUnCheck;

@property IBInspectable BOOL isEnabled;
@property IBInspectable BOOL isChecked;
@property IBInspectable BOOL showTextLabel;
@property (nonatomic, strong) IBInspectable NSString *text;

@end
