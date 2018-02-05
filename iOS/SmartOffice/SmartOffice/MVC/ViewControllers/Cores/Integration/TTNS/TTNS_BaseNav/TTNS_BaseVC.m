//
//  TTNV_BaseVC.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseVC.h"

#import "RegisterFormVC.h"

@interface TTNS_BaseVC ()
@property (strong, nonatomic) BottomView *bottomView;
@end

@implementation TTNS_BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self replaceTabbarToBottomView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (IS_IPHONE) {
        [AppDelegateAccessor.mainTabbarController.tabBar setHidden:YES];
        [self addNavView];
        [self replaceTabbarToBottomView];
    }
    
    
}
- (void)disableButtons:(BOOL)isDisable
{
    [self.bottomView disableButton:isDisable];
}
- (void)replaceTabbarToBottomView
{
    if(self.leftBtnAttribute != nil || self.rightBtnAttribute != nil)
    {
        _bottomView = [[BottomView alloc] initWithAttributes:self.leftBtnAttribute rightAttributes:self.rightBtnAttribute];
        _bottomView.delegate = self;
        [self.view addSubview:_bottomView];
        _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *bottom = [NSLayoutConstraint
                                      constraintWithItem:_bottomView
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual toItem:self.view
                                      attribute:NSLayoutAttributeBottom multiplier:1.0f
                                      constant:0];
        
        NSLayoutConstraint *left = [NSLayoutConstraint
                                    constraintWithItem:_bottomView
                                    attribute:NSLayoutAttributeLeft
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.view attribute:
                                    NSLayoutAttributeLeft multiplier:1.0
                                    constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint
                                     constraintWithItem:_bottomView
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.view attribute:
                                     NSLayoutAttributeRight multiplier:1.0
                                     constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint
                                      constraintWithItem:_bottomView
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:nil attribute:
                                      NSLayoutAttributeNotAnAttribute multiplier:1.0
                                      constant:50];
        /* 4. Add the constraints to button's superview*/
        [self.view addConstraints:@[height, left, bottom, right]];
    }
    
}
#pragma mark - BottomViewDelegate
- (void)didselectLeftButton
{
    
}
- (void)didSelectRightButton
{
    
}
#pragma mark - TTNS_BaseNavViewDelegate
- (void)didTapBackButton
{
    [self popToIntegrationRoot];
}
@end
