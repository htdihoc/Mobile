//
//  NSDictionary+RangeOfMonth.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/18/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "NSDictionary+RangeOfMonth.h"

@implementation NSDictionary (RangeOfMonth)
+ (NSDictionary *)getRangeOfMonthWith:(NSInteger)increaseMonth
{
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    NSDate *curDate = [NSDate date];
    NSInteger tmpMonth = increaseMonth;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday fromDate:curDate]; // Get necessary date components
    BOOL isIncreaseYear = NO;
    if (increaseMonth >= 0) {
        if (increaseMonth + [comps month] > 12) {
            [comps setYear:[comps year] + (increaseMonth + [comps month])/12];
            tmpMonth = (increaseMonth + [comps month])%12;
            isIncreaseYear = YES;
        }
    }
    else
    {
        if (increaseMonth + [comps month] < 0) {
            [comps setYear:[comps year] - (ABS(increaseMonth) + [comps month])/12];
            tmpMonth = (increaseMonth + [comps month])%12;
            isIncreaseYear = YES;
        }
        if (increaseMonth + [comps month] == 0) {
            [comps setYear:[comps year] - 1];
            tmpMonth = 0;
            isIncreaseYear = YES;
        }
    }
    [comps setMonth: isIncreaseYear == YES ? 12+tmpMonth : [comps month]+tmpMonth];
    [comps setDay:1];
    NSDate *tDateMonth = [calendar dateFromComponents:comps];
    NSTimeInterval firstDay = [tDateMonth timeIntervalSince1970]*1000;
    [newDict setValue:[NSNumber numberWithDouble:firstDay] forKey:@"firstDay"];

    // set last of month
    [comps setMonth:isIncreaseYear == YES ? 12+tmpMonth+1 : [comps month] + 1];
    [comps setDay:0];
    tDateMonth = [calendar dateFromComponents:comps];
    NSTimeInterval lastDay = [tDateMonth timeIntervalSince1970]*1000;
    [newDict setValue:[NSNumber numberWithDouble:lastDay] forKey:@"lastDay"];
    
    return newDict;
}
@end
