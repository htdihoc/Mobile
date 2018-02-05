//
//  BottomButton.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/19/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BottomButton : NSObject
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) UIColor *color;
- (instancetype)initWithTitle:(NSString *)title color:(UIColor *)color;
- (instancetype)initWithDefautRedColor:(NSString *)title;
- (instancetype)initWithDefautBlueColor:(NSString *)title;
@end
