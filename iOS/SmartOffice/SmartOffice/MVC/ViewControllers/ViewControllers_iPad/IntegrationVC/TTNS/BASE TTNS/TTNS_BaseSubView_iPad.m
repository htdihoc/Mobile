//
//  TTNS_BaseSubView_iPad.m
//  SmartOffice
//
//  Created by Administrator on 5/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseSubView_iPad.h"
#import "UIView+BorderView.h"

@interface TTNS_BaseSubView_iPad ()

@end

@implementation TTNS_BaseSubView_iPad

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = AppColor_MainAppBackgroundColor;
    [self addBaseViews];
}
- (void)addBaseViews
{
    self.containerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.containerView setRectBorderForView];
    [self.view addSubview:self.containerView];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *topContainerView = [NSLayoutConstraint
                                            constraintWithItem:self.containerView
                                            attribute:NSLayoutAttributeTop
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.view
                                            attribute:NSLayoutAttributeTop
                                            multiplier:1.0
                                            constant:0];
    NSLayoutConstraint *leftContainerView = [NSLayoutConstraint
                                             constraintWithItem:self.containerView
                                             attribute:NSLayoutAttributeLeft
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:self.view attribute:
                                             NSLayoutAttributeLeft multiplier:1.0
                                             constant:0];
    NSLayoutConstraint *rightContainerView = [NSLayoutConstraint
                                              constraintWithItem:self.containerView
                                              attribute:NSLayoutAttributeRight
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:self.view attribute:
                                              NSLayoutAttributeRight multiplier:1.0
                                              constant:0];
    NSLayoutConstraint *bottomContainerView = [NSLayoutConstraint
                                               constraintWithItem:self.containerView
                                               attribute:NSLayoutAttributeBottom
                                               relatedBy:NSLayoutRelationEqual
                                               toItem:self.view
                                               attribute:NSLayoutAttributeBottom
                                               multiplier:1.0
                                               constant:0];
    /* 4. Add the constraints to button's superview*/
    [self.view addConstraints:@[topContainerView, leftContainerView, bottomContainerView, rightContainerView]];
    
    
    self.mTitle = [[SOInsectTextLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.mTitle setRectBorderForView];
    self.mTitle.backgroundColor = UIColorFromHex(0xf3f4f9);
    [self.view addSubview:self.mTitle];
    self.mTitle.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:self.mTitle
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.containerView
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0
                               constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint
                                constraintWithItem:self.mTitle
                                attribute:NSLayoutAttributeLeft
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.containerView attribute:
                                NSLayoutAttributeLeft multiplier:1.0
                                constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint
                                 constraintWithItem:self.mTitle
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.containerView attribute:
                                 NSLayoutAttributeRight multiplier:1.0
                                 constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint
                                  constraintWithItem:self.mTitle
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:nil attribute:
                                  NSLayoutAttributeNotAnAttribute multiplier:1.0
                                  constant:46];
    /* 4. Add the constraints to button's superview*/
    [self.view addConstraints:@[top, left, height, right]];
}

@end
