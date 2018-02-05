//
//  BottomView.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/19/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BottomView.h"
@interface BottomView()
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;
@end
@implementation BottomView
- (void)initCustom
{
    if(self.leftBtnAttribute)
    {
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBtn.frame = CGRectMake(0, 0, 100, 100);
        [self.leftBtn setTitle:self.leftBtnAttribute.title forState:UIControlStateNormal];
        self.leftBtn.backgroundColor = self.leftBtnAttribute.color;
        [self addSubview:self.leftBtn];
        self.leftBtn.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *topLeftButton = [NSLayoutConstraint
                                             constraintWithItem:self.leftBtn
                                             attribute:NSLayoutAttributeTop
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:self
                                             attribute:NSLayoutAttributeTop
                                             multiplier:1.0
                                             constant:0];
        NSLayoutConstraint *bottomLeftButton = [NSLayoutConstraint
                                                constraintWithItem:self.leftBtn
                                                attribute:NSLayoutAttributeBottom
                                                relatedBy:NSLayoutRelationEqual toItem:self
                                                attribute:NSLayoutAttributeBottom multiplier:1.0f
                                                constant:0];
        
        NSLayoutConstraint *leftLeftButton = [NSLayoutConstraint
                                              constraintWithItem:self.leftBtn
                                              attribute:NSLayoutAttributeLeft
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:self attribute:
                                              NSLayoutAttributeLeft multiplier:1.0
                                              constant:0];
        NSLayoutConstraint *widthLeftButton = [NSLayoutConstraint
                                               constraintWithItem:self.leftBtn
                                               attribute:NSLayoutAttributeWidth                                 relatedBy:NSLayoutRelationEqual
                                               toItem:self attribute:
                                               NSLayoutAttributeWidth multiplier:self.rightBtnAttribute == nil ? 1.0:0.5
                                               constant:0];
        /* 4. Add the constraints to button's superview*/
        [self addConstraints:@[topLeftButton, leftLeftButton, bottomLeftButton, widthLeftButton]];
    }
    if(self.rightBtnAttribute)
    {
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn.frame = CGRectMake(0, 0, 100, 100);
        [self.rightBtn setTitle:self.rightBtnAttribute.title forState:UIControlStateNormal];
        self.rightBtn.backgroundColor = self.rightBtnAttribute.color;
        [self addSubview:self.rightBtn];
        self.rightBtn.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *topRightButton = [NSLayoutConstraint
                                              constraintWithItem:self.rightBtn
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:self
                                              attribute:NSLayoutAttributeTop
                                              multiplier:1.0
                                              constant:0];
        NSLayoutConstraint *bottomRightButton = [NSLayoutConstraint
                                                 constraintWithItem:self.rightBtn
                                                 attribute:NSLayoutAttributeBottom
                                                 relatedBy:NSLayoutRelationEqual toItem:self
                                                 attribute:NSLayoutAttributeBottom multiplier:1.0f
                                                 constant:0];
        
        NSLayoutConstraint *rightRightButton = [NSLayoutConstraint
                                                constraintWithItem:self.rightBtn
                                                attribute:NSLayoutAttributeRight
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:self attribute:
                                                NSLayoutAttributeRight multiplier:1.0
                                                constant:0];
        NSLayoutConstraint *widthRightButton = [NSLayoutConstraint
                                                constraintWithItem:self.rightBtn
                                                attribute:NSLayoutAttributeWidth                                 relatedBy:NSLayoutRelationEqual
                                                toItem:self attribute:
                                                NSLayoutAttributeWidth multiplier:self.leftBtnAttribute == nil ? 1.0:0.5
                                                constant:0];
        /* 4. Add the constraints to button's superview*/
        [self addConstraints:@[topRightButton, rightRightButton, bottomRightButton, widthRightButton]];
        
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCustom];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initCustom];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initCustom];
    }
    return self;
}
- (instancetype)initWithAttributes:(BottomButton *)leftBtnAttribute rightAttributes:(BottomButton*)rightBtnAttribute
{
    self = [super init];
    self.leftBtnAttribute = leftBtnAttribute;
    self.rightBtnAttribute = rightBtnAttribute;
    if (self) {
        [self initCustom];
    }
    return self;
}
- (IBAction)leftAction:(id)sender {
}
- (IBAction)rightAction:(id)sender {
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
