//
//  SO_CustomTimePicker.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SO_CustomTimePicker.h"
@interface SO_CustomTimePicker() <CustomTimePickerDelegate>

@end

@implementation SO_CustomTimePicker

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _maskView = [[UIView alloc] initWithFrame:frame];
        _maskView.backgroundColor = [UIColor blackColor]; //or whatever...
        _maskView.alpha = 0.5;
        [self addSubview:_maskView];
        
        _clockView = [[CustomTimePicker alloc] initWithView:frame withDarkTheme:false];
        _clockView.delegate = self;
        _clockView.center = self.center;
        [self addSubview:_clockView];
    }
    return self;
}
#pragma mark CustomTimePickerDelegate
-(void)dismissClockViewWithHours:(NSString *)hours andMinutes:(NSString *)minutes andTimeMode:(NSString *)timeMode{
    self.clockView.delegate = nil;
    [self.maskView removeFromSuperview];
    [self.delegate SO_dismissClockViewWithHours:hours andMinutes:minutes andTimeMode:timeMode];
}
- (BOOL)isSelectedEndDate
{
    return [self.delegate calendarViewShouldSelectEndDate];
}
- (void)showStartOutOfAbsentDate
{
    [self.delegate showStartOutOfAbsentDate];
}
- (void)showStartSelectedDateError
{
    [self.delegate showStartSelectedDateError];
}
- (void)showEndSelectedDateError
{
    [self.delegate showEndSelectedDateError];
}
- (BOOL)isSameDate
{
    return [self.delegate isSameDate];
}
- (BOOL)isLockMinuteView
{
    return [self.delegate isLockMinuteView];
}
- (NSDate *)getSelectedDate
{
    return [self.delegate getSelectedDate];
}
- (NSString *)getCheckingMinutes
{
    return [self.delegate getCheckingMinutes];
}
- (NSString *)getCheckingHours
{
    return [self.delegate getCheckingHours];
}
- (BOOL)isAMMode
{
    return [self.delegate isAMMode];
}
@end
