//
//  SONoteLabel.m
//  SmartOffice
//
//  Created by Kaka on 4/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SONoteButton.h"

@implementation SONoteButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.borderWidth    = 0.0;
        self.cornerRadious  = 0.0;
        self.borderColor = [UIColor clearColor];
        [self customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [self customInit];
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    [self setNeedsDisplay];
    //self.textAlignment = NSTextAlignmentCenter;
}


- (void)prepareForInterfaceBuilder {
    
    [self customInit];
}

- (void)customInit {
    self.layer.cornerRadius = self.cornerRadious;
    self.layer.borderWidth = self.borderWidth;
    self.layer.borderColor = self.borderColor.CGColor;

    if (self.cornerRadious > 0) {
        //self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
    }
}



//- (void)setBorderColor:(UIColor *)borderColor {
//    self.borderColor = borderColor;
//    self.layer.borderColor = self.borderColor.CGColor;
//}
//
//- (void)setBorderWidth:(NSInteger)borderWidth {
//    _borderWidth = borderWidth;
//    self.layer.borderWidth = borderWidth;
//}
//
//- (void)setCornerRadius:(CGFloat)cornerRadius {
//    _cornerRadious = cornerRadius;
//    self.layer.cornerRadius = cornerRadius;
//    if (cornerRadius > 0) {
//        self.layer.masksToBounds = YES;
//    }
//}

@end
