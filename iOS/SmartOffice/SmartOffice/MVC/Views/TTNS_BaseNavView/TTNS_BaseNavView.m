//
//  TTNS_BaseNavView.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseNavView.h"
#import "NSString+SizeOfString.h"
@interface TTNS_BaseNavView()
{
    CGFloat titleWidth;
    CGFloat subTitleWidth;
    NSLayoutConstraint *cst_width;
    CGFloat leftMargin;
}
@property (strong, nonatomic) UIButton *btnBack;
@property (strong, nonatomic) UIButton *btnRightButton;
@end

@implementation TTNS_BaseNavView

- (instancetype)init
{
    self = [super init];
    if (self) {
        leftMargin = 32;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        leftMargin = 32;
    }
    return self;
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    [self setAttributeTextForButton:[self getAttribute]];
}
- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    [self setAttributeTextForButton:[self getAttribute]];
    if (cst_width) {
        [self reloadBackButtonLayout];
    }
}
- (NSAttributedString *)getAttribute
{
    DLog(@"%f", self.btnRightButton.frame.size.width);
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentLeft];
    [style setLineBreakMode:NSLineBreakByTruncatingTail];
    
    UIFont *font1 = AppFont_MainFontWithSize(18);
    UIFont *font2 = AppFont_MainFontWithSize(12);
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width - 8;
    CGFloat maxCharacters = ((screenWidth) - self.btnRightButton.frame.size.width)/[@"D" widthOfString:font1];
    CGFloat maxSubCharacters = ((screenWidth) - self.btnRightButton.frame.size.width)/[@"D" widthOfString:font2];
    
    UIColor *tintColorButton = [UIColor whiteColor];
    NSDictionary *dict1 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font1,
                            NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:tintColorButton}; // Added line
    NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font2,
                            NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:tintColorButton}; // Added line
    
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    
    NSString *titleNoNewLine = [[self.title componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    NSString *subTitleNoNewLine = [[self.subTitle componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    
    if(self.subTitle == nil){
        // add A Title no SubTitle
        _title = [NSString stringWithFormat:@"%@\n", titleNoNewLine.length > maxCharacters ? [NSString stringWithFormat:@"%@...",[titleNoNewLine substringToIndex:maxCharacters-3]] : titleNoNewLine];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:self.title attributes:dict1]];
    } else {
        
        // Add Title + SubTitle
        _title = [NSString stringWithFormat:@"%@\n", titleNoNewLine.length > maxCharacters ? [NSString stringWithFormat:@"%@...",[titleNoNewLine substringToIndex:maxCharacters-3]] : titleNoNewLine];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:_title attributes:dict1]];
        
        _subTitle = [NSString stringWithFormat:@"%@", subTitleNoNewLine.length > maxSubCharacters ? [NSString stringWithFormat:@"%@...",[subTitleNoNewLine substringToIndex:maxSubCharacters-3]] : subTitleNoNewLine];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:_subTitle attributes:dict2]];
    }
    titleWidth = [_title widthOfString:font1];
    subTitleWidth = [_subTitle widthOfString:font2];
    return attString;
}
- (void)customInit:(NSString *)title subTitle:(NSString *)subTitle rightTitle:(NSString*)rightTitle
{
    self.backgroundColor    = AppColor_MainAppTintColor;
    leftMargin = 32;
    if (rightTitle) {
        self.btnRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnRightButton.frame = CGRectMake(0, 0, self.frame.size.width/2, 44);
        self.btnRightButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        [self.btnRightButton setTitle:rightTitle forState:UIControlStateNormal];
        [self addRightBarButton:self.btnRightButton isButtonTile:YES];
        [self.btnRightButton layoutIfNeeded];
    }
    [self addBackButton:title subTitle:subTitle];
}
- (void)addBackButton:(NSString *)title subTitle:(NSString*)subTitle
{
    self.subTitle = subTitle;
    self.title = title;
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBack.frame = CGRectMake(0, 0, 0, 44);
    [self.btnBack setImage:[UIImage imageNamed:@"nav_BackButton"] forState:UIControlStateNormal];
    
    if(subTitle == nil){
        self.btnBack.titleEdgeInsets = UIEdgeInsetsMake(20, leftMargin, 0, 0);
    } else {
        self.btnBack.titleEdgeInsets = UIEdgeInsetsMake(0, leftMargin, 0, 0);
    }
    self.btnBack.imageEdgeInsets = UIEdgeInsetsMake(0, leftMargin/2, 0, 0);
    [self setAttributeTextForButton:[self getAttribute]];
    [[self.btnBack titleLabel] setNumberOfLines:0];
    [[self.btnBack titleLabel] setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.btnBack setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.btnBack addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnBack];
    self.btnBack.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self reloadBackButtonLayout];
    NSLayoutConstraint *left    = [NSLayoutConstraint constraintWithItem:self.btnBack attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *bottom  = [NSLayoutConstraint constraintWithItem:self.btnBack attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:20];
    NSLayoutConstraint *height  = [NSLayoutConstraint constraintWithItem:self.btnBack attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44];
    
    
    [self addConstraints:@[left, bottom, height, cst_width]];
}
- (void)reloadBackButtonLayout
{
    CGFloat widthSize = MAX(titleWidth, subTitleWidth);
    CGFloat buttonWidth = (widthSize + 1.5*leftMargin);
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    if (screenWidth -  buttonWidth < (self.btnRightButton.frame.size.width - 8)) {
        buttonWidth = widthSize + 1.5*leftMargin - self.btnRightButton.frame.size.width - 8;
    }
    if (!cst_width) {
        cst_width  = [NSLayoutConstraint constraintWithItem:self.btnBack attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:buttonWidth];
    }
    else
    {
        cst_width.constant = buttonWidth;
    }
    
}
- (void)setAttributeTextForButton:(NSAttributedString *)attString
{
    [self.btnBack setAttributedTitle:attString forState:UIControlStateNormal];
    [self.btnBack layoutIfNeeded];
}
- (void)actionBack
{
    [self.delegate didTapBackButton];
}
- (void)rightAction
{
    [self.delegate didTapRightButton];
}
- (void)addRightBarButton:(UIButton *)rightView isButtonTile:(BOOL)isButtonTile
{
    if (self.btnRightButton == nil) {
        self.btnRightButton = rightView;
    }
    [rightView addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    rightView.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 15);
    [self addSubview:rightView];
    rightView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *left    = [NSLayoutConstraint constraintWithItem:rightView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-8];
    NSLayoutConstraint *bottom  = [NSLayoutConstraint constraintWithItem:rightView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *height  = [NSLayoutConstraint constraintWithItem:rightView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44];
    NSLayoutConstraint *width  = [NSLayoutConstraint constraintWithItem:rightView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40];
    if (isButtonTile) {
        [self addConstraints:@[left, bottom, height]];
    }
    else
    {
        [self addConstraints:@[left, bottom, height, width]];
    }
}
@end
