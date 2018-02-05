//
//  VOfficeBottomVIew.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/20/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOfficeBottomView.h"
@interface VOfficeBottomView()
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;
@end
@implementation VOfficeBottomView
- (void)initCustom
{
	self.backgroundColor = RGB(239, 239, 244);
    CGFloat valueWidth = IS_IPHONE ? 35 : 55;
    CGFloat valueHeight = IS_IPHONE ? 35 : 55;
    CGFloat fontSize = IS_IPHONE ? 13 : 15;
    
    UILabel *lblChat = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    lblChat.text = LocalizedString(@"Chat");
    lblChat.textColor = UIColorFromHex(0x444444);
    [lblChat setFont:[UIFont fontWithName:@"Helvetica Neue" size:fontSize]];
    lblChat.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lblChat];
    lblChat.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *toplblChat = [NSLayoutConstraint
                                         constraintWithItem:lblChat
                                         attribute:NSLayoutAttributeBottom
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                         attribute:NSLayoutAttributeBottom
                                         multiplier:1.0
                                         constant:0];
    NSLayoutConstraint *heightlblChat = [NSLayoutConstraint
                                            constraintWithItem:lblChat
                                            attribute:NSLayoutAttributeHeight                                 relatedBy:NSLayoutRelationEqual
                                            toItem:nil attribute:
                                            NSLayoutAttributeNotAnAttribute multiplier:1.0
                                            constant:valueHeight/2];
    
    NSLayoutConstraint *rightlblChat = [NSLayoutConstraint
                                           constraintWithItem:lblChat
                                           attribute:NSLayoutAttributeRight
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:self attribute:
                                           NSLayoutAttributeRight multiplier:1.0
                                           constant:-20];

    /* 4. Add the constraints to button's superview*/
    [self addConstraints:@[toplblChat, heightlblChat, rightlblChat]];
    
    UILabel *lblReminder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    lblReminder.text = LocalizedString(@"Reminder");
    lblReminder.textColor = UIColorFromHex(0x444444);
    [lblReminder setFont:[UIFont fontWithName:@"Helvetica Neue" size:fontSize]];
    lblReminder.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lblReminder];
    lblReminder.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *toplblReminder = [NSLayoutConstraint
                                          constraintWithItem:lblReminder
                                          attribute:NSLayoutAttributeBottom
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self
                                          attribute:NSLayoutAttributeBottom
                                          multiplier:1.0
                                          constant:0];
    NSLayoutConstraint *heightlblReminder = [NSLayoutConstraint
                                         constraintWithItem:lblReminder
                                         attribute:NSLayoutAttributeHeight                                 relatedBy:NSLayoutRelationEqual
                                         toItem:nil attribute:
                                         NSLayoutAttributeNotAnAttribute multiplier:1.0
                                         constant:valueHeight/2];
    
    NSLayoutConstraint *rightlblReminder = [NSLayoutConstraint
                                        constraintWithItem:lblReminder
                                        attribute:NSLayoutAttributeRight
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:lblChat attribute:
                                        NSLayoutAttributeLeft multiplier:1.0
                                        constant:-20];
//    NSLayoutConstraint *widthlblReminder = [NSLayoutConstraint
//                                        constraintWithItem:lblReminder
//                                        attribute:NSLayoutAttributeWidth                                 relatedBy:NSLayoutRelationEqual
//                                        toItem:nil attribute:
//                                        NSLayoutAttributeNotAnAttribute multiplier:1.0
//                                        constant:valueWidth];
    /* 4. Add the constraints to button's superview*/
    [self addConstraints:@[toplblReminder, heightlblReminder, rightlblReminder]];
    
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn addTarget:self action:@selector(actionChat:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn.frame = CGRectMake(0, 0, 100, 100);
    [self.rightBtn setImage:[UIImage imageNamed:@"chat_action_icon"] forState:UIControlStateNormal];
    [self addSubview:self.rightBtn];
    self.rightBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *topRightButton = [NSLayoutConstraint
                                          constraintWithItem:self.rightBtn
                                          attribute:NSLayoutAttributeTop
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self
                                          attribute:NSLayoutAttributeTop
                                          multiplier:1.0
                                          constant:8];
    NSLayoutConstraint *heightRightButton = [NSLayoutConstraint
                                             constraintWithItem:self.rightBtn
                                             attribute:NSLayoutAttributeHeight                                 relatedBy:NSLayoutRelationEqual
                                             toItem:nil attribute:
                                             NSLayoutAttributeNotAnAttribute multiplier:1.0
                                             constant:valueWidth];
    
    NSLayoutConstraint *rightRightButton = [NSLayoutConstraint
                                            constraintWithItem:self.rightBtn
                                            attribute:NSLayoutAttributeCenterX
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:lblChat attribute:
                                            NSLayoutAttributeCenterX multiplier:1.0
                                            constant:0];
    NSLayoutConstraint *widthRightButton = [NSLayoutConstraint
                                            constraintWithItem:self.rightBtn
                                            attribute:NSLayoutAttributeWidth                                 relatedBy:NSLayoutRelationEqual
                                            toItem:nil attribute:
                                            NSLayoutAttributeNotAnAttribute multiplier:1.0
                                            constant:valueHeight];
    /* 4. Add the constraints to button's superview*/
    [self addConstraints:@[topRightButton, rightRightButton, heightRightButton, widthRightButton]];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = CGRectMake(0, 0, 100, 100);
    [self.leftBtn addTarget:self action:@selector(actionReminder:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn setImage:[UIImage imageNamed:@"reminder_action_icon"] forState:UIControlStateNormal];
    [self addSubview:self.leftBtn];
    self.leftBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *topLeftButton = [NSLayoutConstraint
                                         constraintWithItem:self.leftBtn
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                         attribute:NSLayoutAttributeTop
                                         multiplier:1.0
                                         constant:8];
    NSLayoutConstraint *heightLeftButton = [NSLayoutConstraint
                                            constraintWithItem:self.leftBtn
                                            attribute:NSLayoutAttributeHeight                                 relatedBy:NSLayoutRelationEqual
                                            toItem:nil attribute:
                                            NSLayoutAttributeNotAnAttribute multiplier:1.0
                                            constant:valueHeight];
    
    NSLayoutConstraint *rightLeftButton = [NSLayoutConstraint
                                           constraintWithItem:self.leftBtn
                                           attribute:NSLayoutAttributeCenterX
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:lblReminder attribute:
                                           NSLayoutAttributeCenterX multiplier:1.0
                                           constant:0];
    NSLayoutConstraint *widthLeftButton = [NSLayoutConstraint
                                           constraintWithItem:self.leftBtn
                                           attribute:NSLayoutAttributeWidth                                 relatedBy:NSLayoutRelationEqual
                                           toItem:nil attribute:
                                           NSLayoutAttributeNotAnAttribute multiplier:1.0
                                           constant:valueWidth];
    /* 4. Add the constraints to button's superview*/
    [self addConstraints:@[topLeftButton, rightLeftButton, heightLeftButton, widthLeftButton]];
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
- (void)actionChat:(id)sender {
    [self.delegate didSelectChatButton];
}
- (void)actionReminder:(id)sender {
    [self.delegate didSelectReminderButton];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
