//
//  UIButton+Ext.m
//  SpeedTest
//
//  Created by Nguyen Thanh Huy on 12/5/16.
//  Copyright © 2016 Nguyen Thanh Huy. All rights reserved.
//

#import "UIButton+Ext.h"

@implementation UIButton (UIButton)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/*- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return self;
}*/

- (CGSize)intrinsicContentSize
{
    return self.titleLabel.intrinsicContentSize;
}

/*- (void)layoutSubviews
{
    [super layoutSubviews];
    //self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.frame.size.width;
    //[super layoutSubviews];
}*/

@end
