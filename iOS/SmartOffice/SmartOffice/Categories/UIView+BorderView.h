//
//  UIView+BorderView.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BorderView)

- (void)setBorderForView;

- (void)setBorderWithShadow:(CGFloat)borderWith cornerRadius:(CGFloat)cornerRadius;

-(void)setRectBorderForView;
@end
