//
//  CustomTimePicker.h
//  CustomTimePicker
//
//  Created by Amboj Goyal on 21/05/14.
//  Copyright (c) 2014 Amboj Goyal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol CustomTimePickerDelegate <NSObject>

-(void)dismissClockViewWithHours:(NSString *)hours andMinutes:(NSString *)minutes andTimeMode:(NSString *)timeMode;
- (BOOL)isSelectedEndDate;
- (BOOL)isSameDate;
- (void)showEndSelectedDateError;
- (void)showStartSelectedDateError;
- (void)showStartOutOfAbsentDate;
- (BOOL)isLockMinuteView;
- (NSDate *)getSelectedDate;
- (NSString *)getCheckingHours;
- (NSString *)getCheckingMinutes;
- (BOOL)isAMMode;
@end


@interface CustomTimePicker : UIView <UIGestureRecognizerDelegate>

@property (nonatomic,unsafe_unretained) id<CustomTimePickerDelegate> delegate;
- (id)initWithView:(CGRect)parentFrame withDarkTheme:(BOOL)isDarkTheme ;
- (void)selectCurrentDate;
- (void)checkValidAbsentStartDate:(NSInteger)hoursToCheck;
- (void)checkValidAbsentEndDate:(NSInteger)hoursToCheck;
- (void)iniValuesForMode;
@end
