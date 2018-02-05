//
//  THTextField.m
//  SpeedTest
//
//  Created by Nguyen Thanh Huy on 7/7/16.
//  Copyright © 2016 Nguyen Thanh Huy. All rights reserved.
//

#import "THTextField.h"

@implementation THTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 5.0f, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

@end
