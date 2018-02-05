//
//  VOfficeBaseSubView.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_BaseSubView_iPad.h"
#import "UIView+BorderView.h"
#import "MBProgressHUD.h"
@interface VOffice_BaseSubView_iPad ()

@end

@implementation VOffice_BaseSubView_iPad

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
//    [self.containerView setRectBorderForView];
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
    /* 4. Add the constraints to view's superview*/
    [self.view addConstraints:@[topContainerView, leftContainerView, bottomContainerView, rightContainerView]];
    
    self.lblTitle = [[SOInsectTextLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.lblTitle.edgeInsets = UIEdgeInsetsMake(0, 20, 0, 80);
//    [self.lblTitle setRectBorderForView];
    self.lblTitle.backgroundColor = UIColorFromHex(0xf3f4f9);
    [self.view addSubview:self.lblTitle];
    self.lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *top = [NSLayoutConstraint
                              constraintWithItem:self.lblTitle
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.containerView
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint
                                constraintWithItem:self.lblTitle
                                attribute:NSLayoutAttributeLeft
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.containerView attribute:
                                NSLayoutAttributeLeft multiplier:1.0
                                constant:1];
    NSLayoutConstraint *right = [NSLayoutConstraint
                                 constraintWithItem:self.lblTitle
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.containerView attribute:
                                 NSLayoutAttributeRight multiplier:1.0
                                 constant:-1];
    NSLayoutConstraint *height = [NSLayoutConstraint
                                 constraintWithItem:self.lblTitle
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:nil attribute:
                                 NSLayoutAttributeNotAnAttribute multiplier:1.0
                                 constant:46];
    /* 4. Add the constraints to Label's superview*/
    [self.view addConstraints:@[top, left, height, right]];
    
    
    self.btn_VOffice = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.btn_VOffice addTarget:self action:@selector(showVOffice:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_VOffice setTitle:LocalizedString(@"kVOFF_GOTO_VOFFICE_TITLE_BUTTON") forState:UIControlStateNormal];
    [self.btn_VOffice setTitleColor:AppColor_MainAppTintColor forState:UIControlStateNormal];
    [self.btn_VOffice setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    self.btn_VOffice.titleLabel.font = [UIFont systemFontOfSize:14];
    self.btn_VOffice.backgroundColor = UIColorFromHex(0xf3f4f9);
    [self.view addSubview:self.btn_VOffice];
    self.btn_VOffice.translatesAutoresizingMaskIntoConstraints = NO;
    self.btn_VOffice.hidden = YES;
    NSLayoutConstraint *topButton = [NSLayoutConstraint
                                     constraintWithItem:self.btn_VOffice
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.containerView
                                     attribute:NSLayoutAttributeTop
                                     multiplier:1.0
                                     constant:1];
    NSLayoutConstraint *widthButton = [NSLayoutConstraint
                                       constraintWithItem:self.btn_VOffice
                                       attribute:NSLayoutAttributeWidth
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:nil attribute:
                                       NSLayoutAttributeNotAnAttribute multiplier:1.0
                                       constant:80];
    NSLayoutConstraint *rightButton = [NSLayoutConstraint
                                       constraintWithItem:self.btn_VOffice
                                       attribute:NSLayoutAttributeRight
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:self.containerView attribute:
                                       NSLayoutAttributeRight multiplier:1.0
                                       constant:-1];
    NSLayoutConstraint *heightButton = [NSLayoutConstraint
                                        constraintWithItem:self.btn_VOffice
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:nil attribute:
                                        NSLayoutAttributeNotAnAttribute multiplier:1.0
                                        constant:44];
    /* 4. Add the constraints to button's superview*/
    [self.view addConstraints:@[topButton, widthButton, heightButton, rightButton]];
}

- (void)showVOffice:(id)sender {
    [self didSelectVOffice];
}

- (void)didSelectVOffice
{
    
}
@end
