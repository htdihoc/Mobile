//
//  SO_TitleSegment.m
//  QLTT_TitleSegment
//
//  Created by NguyenVanTu on 8/16/17.
//  Copyright © 2017 NguyenVanTu. All rights reserved.
//

#import "SO_TitleSegment.h"
#import "NSString+SizeOfString.h"
@interface SO_TitleSegment()
{
    NSLayoutConstraint *_lastNormalFirstConstraint;
    NSLayoutConstraint *_lastNormalSecondConstraint;
    NSLayoutConstraint *_lastNormalThirdConstraint;
    
    CGFloat _widthMax;
    CGFloat _widthPerButton;
}

@end
@implementation SO_TitleSegment

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}
- (void)setFontForButtons:(UIFont *)font
{
    self.btn_First.titleLabel.font = font;
    self.btn_First.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.btn_Second.titleLabel.font = font;
    self.btn_Second.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.btn_Third.titleLabel.font = font;
    self.btn_Third.titleLabel.textAlignment = NSTextAlignmentCenter;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _screenWidth = screenRect.size.width;
    _widthPerButton = 20;
    [self setValuesForLastLayouts];
    return self;
}
- (void)setTitleForButtons:(NSString *)firstTitle second:(NSString *)secondTitle third:(NSString *)thirdTitle
{
    _widthMax = MAX([firstTitle widthOfString:self.btn_First.titleLabel.font], [secondTitle widthOfString:self.btn_First.titleLabel.font]);
    _widthMax = MAX(_widthMax, [thirdTitle widthOfString:self.btn_First.titleLabel.font]) + 8;
    
    if (_widthMax+2*_widthPerButton < _screenWidth) {
        _widthPerButton = (_screenWidth-_widthMax)/2 - 8;
    }
    else
    {
        _widthMax = _screenWidth - 2*_widthPerButton;
    }
    
    [self.btn_First setTitle:firstTitle forState:UIControlStateNormal];
    [self.btn_Second setTitle:secondTitle forState:UIControlStateNormal];
    [self.btn_Third setTitle:thirdTitle forState:UIControlStateNormal];
    
    [self selectFirstItem:self.btn_First callDelegate:YES];
}
- (void)setValuesForLastLayouts
{
    self.cst_ButtonFirstNornalWidth.constant = _screenWidth/3 - 16/3;
    self.cst_ButtonSecondNornalWidth.constant = _screenWidth/3 - 16/3;
    self.cst_ButtonThirdNornalWidth.constant = _screenWidth/3 - 16/3;
    _lastNormalFirstConstraint = self.cst_ButtonFirstNornalWidth;
    _lastNormalSecondConstraint = self.cst_ButtonSecondNornalWidth;
    _lastNormalThirdConstraint = self.cst_ButtonThirdNornalWidth;
    
}
- (void)selectFirstItem:(UIButton *)sender callDelegate:(BOOL)callDelegate
{
    
    if ([sender.titleLabel.text widthOfString:sender.titleLabel.font] > _widthPerButton) {
        self.cst_ButtonFirstNornalWidth.constant = _widthMax;
        self.cst_ButtonSecondNornalWidth.constant = _widthPerButton;
        self.cst_ButtonThirdNornalWidth.constant = _widthPerButton;
    }
    
    if (callDelegate && [self.delegate respondsToSelector:@selector(didSelectFirstButton)]) {
        [self.delegate didSelectFirstButton];
    }
    
    
}
- (void)selectSecondItem:(UIButton *)sender callDelegate:(BOOL)callDelegate
{
    if ([sender.titleLabel.text widthOfString:sender.titleLabel.font] > _widthPerButton) {
        self.cst_ButtonSecondNornalWidth.constant = _widthMax;
        self.cst_ButtonFirstNornalWidth.constant = _widthPerButton;
        self.cst_ButtonThirdNornalWidth.constant = _widthPerButton;
    }
    if (callDelegate && [self.delegate respondsToSelector:@selector(didSelectSecondButton)]) {
        [self.delegate didSelectSecondButton];
    }
}
- (void)selectThirdItem:(UIButton *)sender callDelegate:(BOOL)callDelegate
{
    if ([sender.titleLabel.text widthOfString:sender.titleLabel.font] > _widthPerButton) {
        self.cst_ButtonThirdNornalWidth.constant = _widthMax;
        self.cst_ButtonSecondNornalWidth.constant = _widthPerButton;
        self.cst_ButtonFirstNornalWidth.constant = _widthPerButton;
    }
    
    if (callDelegate && [self.delegate respondsToSelector:@selector(didSelectThirdButton)]) {
        [self.delegate didSelectThirdButton];
    }
}
- (IBAction)touchFirstButton:(UIButton *)sender {
    
    [self selectFirstItem: sender callDelegate:YES];
    
}
- (IBAction)touchSecondButton:(UIButton *)sender {
    
    [self selectSecondItem:sender callDelegate:YES];
    
    
}
- (void)touchAt:(NSInteger)index
{
    switch (index) {
        case 0:
            [self touchFirstButton];
            break;
        case 1:
            [self touchSecondButton];
            break;
        default:
            [self touchThirdButton];
            break;
    }
}
- (IBAction)touchThirdButton:(UIButton *)sender {
    
    [self selectThirdItem:sender callDelegate:YES];
}
- (IBAction)touchFirstButton
{
    [self selectFirstItem:self.btn_First callDelegate:NO];
}
- (IBAction)touchSecondButton
{
    [self selectSecondItem:self.btn_Second callDelegate:NO];
}
- (IBAction)touchThirdButton
{
    [self selectThirdItem:self.btn_Third callDelegate:NO];
}
@end
