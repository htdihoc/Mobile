//
//  NavBase.m
//  SampleNav
//
//  Created by NguyenVanTu on 4/27/17.
//  Copyright © 2017 NguyenVanTu. All rights reserved.
//

#import "VOffice_NavBase_iPad.h"
#import "UIImage+Resize.h"
#import "ListNotificationVC.h"
#import "WYPopoverController.h"
#import "NSString+Util.h"

@interface VOffice_NavBase_iPad()<WYPopoverControllerDelegate>{
@protected WYPopoverController *popOverController;
}
@property (strong, nonnull) UIButton *rightView;
@property (nonatomic, assign) BOOL isTTNSVC;
@end

@implementation VOffice_NavBase_iPad
{
    NSArray *_titles;
}

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
        self.bounds = self.mainView.bounds;
    }
    return self;
}
- (void)setIsTTNSVC:(BOOL)isTTNSVC
{
    _isTTNSVC = isTTNSVC;
    [self.navRightView setHidden:!_isTTNSVC];
}

- (void)setup {
    NSString *className = NSStringFromClass([self class]);
    self.mainView = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
    self.mainView.frame = self.bounds;
    [self addSubview:self.mainView];
    self.backgroundColor = AppColor_MainAppTintColor;
    self.lbl_subTitle.textColor = [UIColor whiteColor];
    self.lbl_Title.textColor = [UIColor whiteColor];
}
- (void)setHiddenForBtn_TreeMode:(BOOL)isHidden
{
    self.rightView.hidden = isHidden;
}

- (IBAction)showPopupNotification:(id)sender {
    if(self.delegate){
        [self.delegate didTapNotificationButton:sender];
    }
}

- (void)setHiddenForBtn_Filter:(BOOL)isHidden
{
    self.btn_Filter.hidden = isHidden;
}
//- (void)clearButton
//{
//    for (UIView *subview in self.subviews) {
//        if ([subview isKindOfClass:[UIButton class]] ) {
//            [subview removeFromSuperview];
//        }
//    }
//}
- (void)addButtons:(NSArray *)titles margin:(NSInteger )marginLeft fontSize:(NSInteger )fontSize disableBackIcon:(BOOL)disableBackIcon
{
    if(!self.lbl_subTitle.text)
    {
        [self setHiddenForBtn_Filter:YES];
    }
    else
    {
        [self setHiddenForBtn_Filter:NO];
    }
    
    [self.navView layoutIfNeeded];
    _titles = titles;
    UIButton *lastBackButton;
    
    //addBorderView
    UIView *borderView;
    borderView = [[UIView alloc] initWithFrame: CGRectMake(4, 20, 300.f, 30.0f)];
    borderView.layer.cornerRadius = 4;
    borderView.layer.borderColor = [[UIColor whiteColor] CGColor];
    borderView.layer.borderWidth = 1;
    borderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.navView addSubview:borderView];

    NSString *totalString = @"";
    CGFloat widthPerButton = -1;
    CGFloat insetAmount = 4;
    CGSize imgSize = titles.count == 1 ? CGSizeMake(25, 30) : CGSizeMake(15, 30);
    for (NSString *title in titles)
    {
        totalString = [NSString stringWithFormat:@"%@%@", totalString, title];
    }
    
    CGFloat stringSize = [totalString widthOfString:[UIFont systemFontOfSize:fontSize]];
    CGFloat navWidth = self.navView.frame.size.width;
    CGFloat sizeToCompare = navWidth - (titles.count-1)*marginLeft - (titles.count-1)*imgSize.width;
    if(sizeToCompare < stringSize)
    {
        widthPerButton = 1.0/titles.count;
    }
    for(int index = 0; index < titles.count; index++)
    {
        UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(4, 20, 300.f, 30.0f)];
        backButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [backButton setTitleColor:[UIColor grayColor]
                         forState:UIControlStateHighlighted];
        NSString *title;
        NSString *iconName;
        if ([titles[index] isKindOfClass:[NavButton_iPad class]]) {
            title = ((NavButton_iPad *)titles[index]).title;
            iconName = ((NavButton_iPad *)titles[index]).iconName;
        }
        else
        {
            title = titles[index];
            iconName = @"nav_bulkHead";
        }
        
        [backButton setTitle:title forState:UIControlStateNormal];
        if (widthPerButton != -1) {
            backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
        else
        {
            backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
//        backButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        UIImage *backImage = [UIImage imageWithImage:[UIImage imageNamed:iconName] scaledToSize:[title checkSpace] ? CGSizeMake(imgSize.height * 2, imgSize.height) : imgSize];
        if (titles.count > 1) {
            if (index != titles.count - 1) {
                [backButton setImage:backImage forState:UIControlStateNormal];
                if (![title checkSpace]) {
                    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, insetAmount/2, 0, -insetAmount/2)];
                    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, insetAmount, 0, insetAmount)];
                }
                else
                {
                    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 2*insetAmount, 0, 0)];
                }
            }
            else
            {
                backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, imgSize.width + insetAmount, 0, -insetAmount)];
            }
        }
        else if([title isEqualToString:@""])
        {
            [backButton setImage:backImage forState:UIControlStateNormal];
            [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, insetAmount, 0, insetAmount)];
        }
        else
        {
            backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//            backButton.semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
            if (!disableBackIcon) {
                [backButton setImage:[UIImage imageNamed:@"icon_back_nav"] forState:UIControlStateNormal];
                [backButton setImageEdgeInsets:UIEdgeInsetsMake(2*insetAmount, 2*insetAmount, 2*insetAmount, 8*insetAmount)];
                [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 3*insetAmount, 0, 0)];
            }
            else
            {
                [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6*insetAmount, 0, 0)];
            }
            
            
        }
        
        [backButton addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.navView addSubview:backButton];
        backButton.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *top = [NSLayoutConstraint
                                  constraintWithItem:backButton
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.navView
                                  attribute:NSLayoutAttributeTop
                                  multiplier:1.0
                                  constant:0];
        
        NSLayoutConstraint *left = [NSLayoutConstraint
                                    constraintWithItem:backButton
                                    attribute:NSLayoutAttributeLeft
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:index == 0 ? self.navView:lastBackButton attribute:
                                    index == 0 ? NSLayoutAttributeLeft:NSLayoutAttributeRight multiplier:1.0
                                    constant:0];
        
        NSLayoutConstraint *width = [NSLayoutConstraint
                                     constraintWithItem:backButton
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.navView attribute:
                                     NSLayoutAttributeWidth multiplier:widthPerButton
                                     constant:0];
        
        NSLayoutConstraint *bottom = [NSLayoutConstraint
                                     constraintWithItem:backButton
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.navView
                                     attribute:NSLayoutAttributeBottom
                                     multiplier:1.0
                                     constant:0];
        /* 4. Add the constraints to button's superview*/
        if(widthPerButton == -1)
        {
            width = [NSLayoutConstraint
                     constraintWithItem:backButton
                     attribute:NSLayoutAttributeWidth
                     relatedBy:NSLayoutRelationEqual
                     toItem:nil attribute:
                     NSLayoutAttributeNotAnAttribute multiplier:0
                     constant:[title widthOfString:[UIFont systemFontOfSize:fontSize]]+imgSize.width+6*insetAmount];
            
            
        }
        if (width) {
            [self addConstraints:@[top, left, bottom, width]];
        }
        else
        {
            [self addConstraints:@[top, left, bottom]];
        }
        lastBackButton = backButton;
        
        //autolayout for BorderView
        if (index == 0) {
            backButton.translatesAutoresizingMaskIntoConstraints = NO;
            
            NSLayoutConstraint *topBorderView = [NSLayoutConstraint
                                      constraintWithItem:borderView
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.navView
                                      attribute:NSLayoutAttributeTop
                                      multiplier:1.0
                                      constant:0];
            
            NSLayoutConstraint *leftBorderView = [NSLayoutConstraint
                                        constraintWithItem:borderView
                                        attribute:NSLayoutAttributeLeft
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:backButton attribute:
                                        NSLayoutAttributeLeft multiplier:1.0
                                        constant:0];
            NSLayoutConstraint *bottomBorderView = [NSLayoutConstraint
                                         constraintWithItem:borderView
                                         attribute:NSLayoutAttributeBottom
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self.navView
                                         attribute:NSLayoutAttributeBottom
                                         multiplier:1.0
                                         constant:0];
            [self addConstraints:@[topBorderView, leftBorderView, bottomBorderView]];
        }
        
        if (index == titles.count - 1 || titles.count == 1) {
            NSLayoutConstraint *rightBorderView = [NSLayoutConstraint
                     constraintWithItem:borderView
                     attribute:NSLayoutAttributeRight
                     relatedBy:NSLayoutRelationEqual
                     toItem:backButton attribute:
                     NSLayoutAttributeRight multiplier:1.0
                     constant:0];
            [self addConstraint:rightBorderView];
        }
    }
}
- (void)actionButton:(UIButton *)sender
{
    if(self.delegate)
    {
        NSInteger index = [_titles indexOfObject:sender.titleLabel.text];
        [self.delegate didSelectButton:index == NSNotFound ? -1 : index];
    }
}
- (IBAction)actionFilter:(UIButton *)sender {
    [self.delegate didSelectFilterButton: sender];
}

- (void)addRightBarButton:(UIButton *)rightView
{
    self.rightView = rightView;
    [self.rightView addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    self.rightView.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 15);
    [self addSubview:rightView];
    self.rightView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *left    = [NSLayoutConstraint constraintWithItem:rightView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-16];
    NSLayoutConstraint *top  = [NSLayoutConstraint
                                constraintWithItem:rightView
                                attribute:NSLayoutAttributeTop
                                relatedBy:NSLayoutRelationEqual
                                toItem:self
                                attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                constant:20];
    NSLayoutConstraint *height  = [NSLayoutConstraint constraintWithItem:rightView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44];
    NSLayoutConstraint *width  = [NSLayoutConstraint constraintWithItem:rightView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44];
    [self addConstraints:@[left, top, height, width]];
}

- (void)rightAction:(UIButton *)sender
{
    [self.delegate didTapRightButton: sender];
}
@end
