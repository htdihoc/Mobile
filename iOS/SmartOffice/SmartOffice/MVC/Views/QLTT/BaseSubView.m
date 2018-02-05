//
//  BaseSubView.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BaseSubView.h"

@implementation BaseSubView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    if(CGRectIsEmpty(frame)) {
        self.bounds = self.view.bounds;
    }
    return self;
}
- (void)setup {
    self.view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    self.view.frame = self.bounds;
    [self addSubview:self.view];

//    self.view.translatesAutoresizingMaskIntoConstraints = NO;
//    NSLayoutConstraint *top= [NSLayoutConstraint
//                              constraintWithItem:self.view
//                              attribute:NSLayoutAttributeTop
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self
//                              attribute:NSLayoutAttributeTop
//                              multiplier:1.0
//                              constant:0];
//    NSLayoutConstraint *bottom = [NSLayoutConstraint
//                                  constraintWithItem:self.view
//                                  attribute:NSLayoutAttributeBottom
//                                  relatedBy:NSLayoutRelationEqual toItem:self
//                                  attribute:NSLayoutAttributeBottom multiplier:1.0f
//                                  constant:0];
//    NSLayoutConstraint *left = [NSLayoutConstraint
//                                constraintWithItem:self.view
//                                attribute:NSLayoutAttributeLeft
//                                relatedBy:NSLayoutRelationEqual
//                                toItem:self attribute:
//                                NSLayoutAttributeLeft multiplier:1.0
//                                constant:0];
//    NSLayoutConstraint *right = [NSLayoutConstraint
//                                 constraintWithItem:self.view
//                                 attribute:NSLayoutAttributeRight
//                                 relatedBy:NSLayoutRelationEqual
//                                 toItem:self attribute:
//                                 NSLayoutAttributeRight multiplier:1.0
//                                 constant:0];
//    
//    /* 4. Add the constraints to button's superview*/
//    [self addConstraints:@[top, left, bottom, right]];
}

@end
