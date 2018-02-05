//
//  UIButton+BorderDefault.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/21/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BorderDefault)
- (void)setDefaultBorder;
- (void)setBorderForButton:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(CGColorRef)borderColor;
@end
