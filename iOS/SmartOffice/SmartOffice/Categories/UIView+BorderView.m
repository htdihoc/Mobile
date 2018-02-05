//
//  UIView+BorderView.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "UIView+BorderView.h"

@implementation UIView (BorderView)

-(void)setBorderForView
{
    self.layer.cornerRadius = 5;
    [self setRectBorderForView];
}
-(void)setRectBorderForView
{
    self.layer.borderWidth = 1;
    self.layer.borderColor = [AppColor_BorderForView CGColor];
}

- (void)setBorderWithShadow:(CGFloat)borderWith cornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius     = cornerRadius;
    self.layer.borderWidth      = borderWith;
    self.layer.borderColor      = [AppColor_BorderForView CGColor];
    self.layer.shadowColor      = [UIColor.whiteColor CGColor];
    self.layer.shadowOpacity    = 1;
    self.layer.shadowOffset     = CGSizeZero;
}

@end
