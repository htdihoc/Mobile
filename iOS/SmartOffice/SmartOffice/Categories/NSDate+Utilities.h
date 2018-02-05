//
//  NSDate+Utilities.h
//  mPOS_iOS
//
//  Created by Cuong Ta on 11/29/16.
//  Copyright © 2016 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utilities)
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)toString;
#pragma mark - Compare Date
- (BOOL) isToday;
- (BOOL)isTomorrow;
- (NSInteger) compareSameMonthAndYearWithOtherDay:(NSDate *)dateToCompare;
- (NSComparisonResult) compareMonth:(NSDate *)dateToCompare;
- (BOOL) isLessThanCurrentMonth;

//CompareDate later or early
- (BOOL) isLaterThanOrEqualTo:(NSDate*)date;
- (BOOL) isEarlierThanOrEqualTo:(NSDate*)date;
- (BOOL) isLaterThan:(NSDate*)date;
- (BOOL) isEarlierThan:(NSDate*)date;
#pragma mark - Current Day
- (NSInteger)getCurrenDayByDate:(NSDate *)curDate;

#pragma mark - Adjusting date
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSInteger)totalDayInThisMonth;
+ (NSInteger)currentHour;
+ (NSInteger)currentMinute;
+ (NSInteger)getCurrentYear;
+ (NSInteger)getCurrentMonth;
+ (NSInteger)getYear:(NSDate *)date;
+ (NSInteger)getMonth:(NSDate *)date;
+ (NSInteger)getTotalDayOfMonth:(NSInteger)month year:(NSInteger)year;
+ (NSArray *)getDaysInThisWeekTotal;
+ (NSString *)dateMode;
@end
