//
//  SORoundLabel.m
//  SmartOffice
//
//  Created by Kaka on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SORoundLabel.h"

@implementation SORoundLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGFloat)min:(CGFloat)valueA andOtherValue:(CGFloat)valueB{
	return valueA < valueB ? valueA : valueB;
}

- (void)layoutSubviews{
	[super layoutSubviews];
	self.layer.cornerRadius = [self min:self.frame.size.width andOtherValue:self.frame.size.height] / 2.0;
	self.clipsToBounds = true;
	
//	CGSize fitSize = [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, self.frame.size.height)];
//	CGRect labelUnreadRect = self.frame;
//	labelUnreadRect.size.width = fitSize.width + 2*4.;
//	
//	if (labelUnreadRect.size.width < 18) {
//		labelUnreadRect.size.width = 18;
//	}
//	
//	self.frame = labelUnreadRect;
//	self.layer.cornerRadius = [self min:self.frame.size.width andOtherValue:self.frame.size.height] / 2.0;
//	//[self sizeThatFits:CGSizeMake(32, 20)];
//	self.clipsToBounds = true;
//	self.layer.borderWidth = 1.0;
//	self.layer.borderColor = [UIColor whiteColor].CGColor;
//	// Performance improvement here depends on the size of your view
//	self.layer.shouldRasterize = YES;
//	self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

@end
