//
//  VOfficeBaseWithBottomView.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/20/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOfficeBaseWithBottomView.h"

@interface VOfficeBaseWithBottomView ()
@property (strong, nonatomic) VOfficeBottomView *bottomView;
@end

@implementation VOfficeBaseWithBottomView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:AppColor_MainAppBackgroundColor];
    [self addBottomView];
    // Do any additional setup after loading the view.
}

- (void)addBottomView
{
    _bottomView = [[VOfficeBottomView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	_bottomView.backgroundColor = RGB(239, 239, 244);
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
                                  constant:60];
    /* 4. Add the constraints to button's superview*/
    [self.view addConstraints:@[height, left, bottom, right]];
}
#pragma mark BottomDelegate
- (void)didSelectChatButton
{
    DLog(@"push to chat view");
}
- (void)didSelectReminderButton
{

}
@end
