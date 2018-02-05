//
//  PARoundImageView.m
//  PlastApp
//
//  Created by Kaka on 7/17/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "PARoundImageView.h"


@implementation PARoundImageView

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

- (void)awakeFromNib{
	[super awakeFromNib];
	

}
- (void)layoutSubviews{
	[super layoutSubviews];

	self.layer.cornerRadius = [self min:self.frame.size.width andOtherValue:self.frame.size.height] / 2.0;
	self.clipsToBounds = YES;
	//self.layer.masksToBounds = YES;
	self.layer.borderWidth = 0.0;
}
@end
