//
//  SOInsectTextLabel.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOInsectTextLabel.h"

@implementation SOInsectTextLabel
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup:NO];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:NO];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame isSubLabel:(BOOL)isSubLabel
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:isSubLabel];
    }
    return self;
}
- (void)setup:(BOOL)isSubLabel{
    if (isSubLabel) {
        self.edgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    }
    else
    {
       self.edgeInsets = UIEdgeInsetsMake(0, 16, 0, 0);
    }
    
}
- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    size.width  += self.edgeInsets.left + self.edgeInsets.right;
    size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return size;
}
@end
