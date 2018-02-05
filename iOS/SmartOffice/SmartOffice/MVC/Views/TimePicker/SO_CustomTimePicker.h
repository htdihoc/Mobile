//
//  SO_CustomTimePicker.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTimePicker.h"
@protocol SO_CustomTimePickerDelegate <NSObject>

-(void)SO_dismissClockViewWithHours:(NSString *)hours andMinutes:(NSString *)minutes andTimeMode:(NSString *)timeMode;
- (BOOL)calendarViewShouldSelectEndDate;
- (void)showStartSelectedDateError;
- (void)showEndSelectedDateError;
- (void)showStartOutOfAbsentDate;
- (BOOL)isSameDate;
- (BOOL)isLockMinuteView;
- (NSDate *)getSelectedDate;
- (NSString *)getCheckingMinutes;
- (NSString *)getCheckingHours;
- (BOOL)isAMMode;
@end
@interface SO_CustomTimePicker : UIView
@property (nonatomic,strong) CustomTimePicker *clockView;
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,weak) id<SO_CustomTimePickerDelegate> delegate;
@end
