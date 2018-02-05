//
//  SOCycleView.m
//  SmartOffice
//
//  Created by Kaka on 4/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOCycleView.h"


@implementation SOCycleView

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
}
@end
