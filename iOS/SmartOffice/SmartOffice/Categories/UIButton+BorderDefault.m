//
//  UIButton+BorderDefault.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/21/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "UIButton+BorderDefault.h"

@implementation UIButton (BorderDefault)
- (void)setDefaultBorder
{
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [AppColor_BorderForView CGColor];
}

- (void)setBorderForButton:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(CGColorRef)borderColor{
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth  = borderWidth;
    self.layer.borderColor = borderColor;
}

@end
