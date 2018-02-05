//
//  SegmentChartView.m
//  SmartOffice
//
//  Created by Kaka on 4/7/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SegmentChartView.h"

@implementation SegmentChartView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)init
{
    self = [super init];
    if(self){
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    return self;
}

- (void)setup{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 3.0;
    _slowProgress = [[UIButton alloc] init];;
    _slowProgress.backgroundColor = AppColor_SlowProgressPersonalChartColor;
    [_slowProgress setTitle:@"Slow" forState:UIControlStateNormal];
    _slowProgress.translatesAutoresizingMaskIntoConstraints = NO;
    _slowProgress.titleLabel.font = AppFont_MainFontWithSize(13);
    _slowProgress.titleLabel.textColor = [UIColor whiteColor];
    _slowProgress.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_slowProgress setUserInteractionEnabled:NO];
    [self addSubview:_slowProgress];
    
    _notProgress = [[UIButton alloc] init];
    _notProgress.backgroundColor = AppColor_NotProgressPersonalChartColor;
    [_notProgress setTitle:@"Not" forState:UIControlStateNormal];
    _notProgress.translatesAutoresizingMaskIntoConstraints = NO;
    _notProgress.titleLabel.font = AppFont_MainFontWithSize(13);
    _notProgress.titleLabel.textColor = [UIColor whiteColor];
    [_notProgress setUserInteractionEnabled:NO];
    _notProgress.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_notProgress];
    self.backgroundColor = [UIColor lightGrayColor];
    
    //Use Constrain
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:_slowProgress
                                                               attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0];
    
    NSLayoutConstraint *topSlowConstrain = [NSLayoutConstraint constraintWithItem:_slowProgress
                                                                        attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0];
    NSLayoutConstraint *bottomSlowConstrain = [NSLayoutConstraint constraintWithItem:_slowProgress
                                                                           attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0];
    
    
    _widthSlowConstrain = [NSLayoutConstraint constraintWithItem:_slowProgress
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self
                                                       attribute:NSLayoutAttributeWidth
                                                      multiplier:1.0
                                                        constant:0];
    
    NSArray *arrConstrain = [NSArray arrayWithObjects:leading, topSlowConstrain, bottomSlowConstrain, _widthSlowConstrain, nil];
    [NSLayoutConstraint activateConstraints:arrConstrain];
    NSLayoutConstraint *leadingNotConstrain = [NSLayoutConstraint constraintWithItem:_notProgress
                                                                           attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_slowProgress attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0];
    
    NSLayoutConstraint *rightNotConstrain = [NSLayoutConstraint constraintWithItem:_notProgress
                                                                         attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0];
    
    NSLayoutConstraint *topNotConstrain = [NSLayoutConstraint constraintWithItem:_notProgress
                                                                       attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0];
    NSLayoutConstraint *bottomNotConstrain = [NSLayoutConstraint constraintWithItem:_notProgress
                                                                          attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0];
    
    [NSLayoutConstraint activateConstraints:@[leadingNotConstrain, rightNotConstrain, topNotConstrain, bottomNotConstrain]];
    
}

- (void)updateChartWithValue:(float)delayValue unInprogress:(float)unInprogressValue{
    NSInteger sumValue = delayValue + unInprogressValue;
    if (sumValue == 0) {
        //_widthSlowConstrain.constant = 0;
        _slowProgress.hidden = YES;
        _notProgress.hidden = YES;
    }else{
        _slowProgress.hidden = NO;
        _notProgress.hidden = NO;
        double slowPercent = delayValue / (double)sumValue;
        //		NSInteger slowWidthProgress = slowPercent * self.frame.size.width / 100;
        [self removeConstraint:_widthSlowConstrain];
        _widthSlowConstrain = [NSLayoutConstraint constraintWithItem:_slowProgress
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeWidth
                                                          multiplier:slowPercent
                                                            constant:0];
        [self addConstraint:_widthSlowConstrain];
        
        [_slowProgress setTitle:[NSString stringWithFormat:@"%.0ld", (long)delayValue] forState:UIControlStateNormal];
        [_notProgress setTitle:[NSString stringWithFormat:@"%.0ld", (long)unInprogressValue] forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.7 animations:^{
        [self updateConstraints];
        [self setNeedsLayout];
    }];
}

@end
