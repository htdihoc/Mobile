//
//  NSDate+Utilities.m
//  mPOS_iOS
//
//  Created by Cuong Ta on 11/29/16.
//  Copyright © 2016 Nguyen Thanh Huy. All rights reserved.
//

#import "NSDate+Utilities.h"

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926


static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);

//Date time type
#define MANAPP_DATETIME_DEFAULT_TYPE NSDateFormatterMediumStyle
#define MANAPP_DATETIME_TIME_DEFAULT_TYPE NSDateFormatterMediumStyle
#define MANAPP_TIME_DEFAULT_TYPE NSDateFormatterShortStyle
@implementation NSDate (Utilities)

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    /* Can not need set local now
     NSLocale *local;
     if ([[MPSession sharedSession].userLanguage isEqualToString:KSYS_APP_LANG_DEFAULT]) {
     local = [NSLocale localeWithLocaleIdentifier:@"vi"];
     }else{
     local = [NSLocale localeWithLocaleIdentifier:@"en"];
     }
     outputFormatter.locale = local;
     */
//    NSLocale *local = [NSLocale localeWithLocaleIdentifier:@"vi"];
//    outputFormatter.locale = local;
    outputFormatter.locale = [NSLocale currentLocale];
    NSString *timestamp_str = [outputFormatter stringFromDate:self];
    return timestamp_str;
}

- (NSString *)toString {
    return [NSDate stringFromDate:self withStyle:MANAPP_TIME_DEFAULT_TYPE];
}

- (NSString *)stringWithStyle:(NSDateFormatterStyle)style {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateStyle:style];
    /*
     NSLocale *local;
     if ([[MPSession sharedSession].userLanguage isEqualToString:KSYS_APP_LANG_DEFAULT]) {
     local = [NSLocale localeWithLocaleIdentifier:@"vi"];
     }else{
     local = [NSLocale localeWithLocaleIdentifier:@"en"];
     }
     outputFormatter.locale = local;
     */
    NSString *timestamp_str = [outputFormatter stringFromDate:self];
    return timestamp_str;
}

#pragma mark - Class Method
+ (NSString *)stringFromDate:(NSDate *)date withStyle:(NSDateFormatterStyle)style {
    return [date stringWithStyle:style];
}

+ (NSCalendar *) currentCalendar
{
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}


#pragma mark - Compare Date
#pragma mark - Comparing Dates

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:componentFlags fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}
- (NSComparisonResult) compareMonth:(NSDate *)dateToCompare
{
    NSDateComponents *componentModelDate = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    [componentModelDate setMonth:[componentModelDate month]];
    NSDateComponents *componentDateToCompare = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:dateToCompare];
    if([componentModelDate month] < [componentDateToCompare month]){
        return NSOrderedDescending;
    }
    else if([componentModelDate month] > [componentDateToCompare month])
    {
        return NSOrderedAscending;
    }
    else
    {
        return NSOrderedSame;
    }
    return 2;
}
- (NSInteger) compareSameMonthAndYearWithOtherDay:(NSDate *)dateToCompare
{
    NSDateComponents *componentModelDate = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    [componentModelDate setMonth:[componentModelDate month]];
    NSDateComponents *componentDateToCompare = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:dateToCompare];
    if([componentModelDate month] == [componentDateToCompare month] &&
       [componentModelDate year] == [componentDateToCompare year] &&
       [componentModelDate era] == [componentDateToCompare era]) {
        if ([componentModelDate day] == [componentDateToCompare day]) {
            return NSOrderedSame;
        }
        else if ([componentModelDate day] > [componentDateToCompare day])
        {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedAscending;
        }
        
    }
    return 2;
}
- (BOOL) isLessThanCurrentMonth
{
    NSDateComponents *componentDateToCompare = [[NSCalendar currentCalendar] components: NSCalendarUnitMonth fromDate:self];
    NSDateComponents *componentDateCurrentMonth = [[NSCalendar currentCalendar] components: NSCalendarUnitMonth fromDate:[NSDate date]];
    if([componentDateToCompare month] < [componentDateCurrentMonth month])
    {
        return YES;
    }
    return NO;
}
- (BOOL) isToday
{
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL)isTomorrow{
    NSDate *tomorrow = [[NSDate date] dateByAddingDays:1];
    return [self isEqualToDateIgnoringTime:tomorrow];
    
}

-(BOOL) isLaterThanOrEqualTo:(NSDate*)date {
	return !([self compare:date] == NSOrderedAscending);
}

-(BOOL) isEarlierThanOrEqualTo:(NSDate*)date {
	return !([self compare:date] == NSOrderedDescending);
}
-(BOOL) isLaterThan:(NSDate*)date {
	return ([self compare:date] == NSOrderedDescending);
	
}
-(BOOL) isEarlierThan:(NSDate*)date {
	return ([self compare:date] == NSOrderedAscending);
}

#pragma mark Adjusting Date
#pragma mark - Adjusting Dates

// Thaks, rsjohnson
- (NSDate *) dateByAddingYears: (NSInteger) dYears
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:dYears];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) dateBySubtractingYears: (NSInteger) dYears
{
    return [self dateByAddingYears:-dYears];
}

- (NSDate *) dateByAddingMonths: (NSInteger) dMonths
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:dMonths];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) dateBySubtractingMonths: (NSInteger) dMonths
{
    return [self dateByAddingMonths:-dMonths];
}

// Courtesy of dedan who mentions issues with Daylight Savings
- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
    return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *) dateByAddingHours: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) dateBySubtractingHours: (NSInteger) dHours
{
    return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes
{
    return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate
{
    NSDateComponents *dTime = [[NSDate currentCalendar] components:componentFlags fromDate:aDate toDate:self options:0];
    return dTime;
}

- (NSInteger)totalDayInThisMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}
+ (NSDateComponents *)currentComponentDate
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear fromDate:now];
    return components;
}
+ (NSInteger)currentHour
{
    NSInteger hour = [[self currentComponentDate] hour] == 12 ? 12 : [[self currentComponentDate] hour]%12;
    return hour;
}
+ (NSInteger)currentMinute
{
    NSInteger minute = [[self currentComponentDate] minute];
    return minute;
}

+ (NSInteger)getCurrentYear
{
    return [NSDate getYear:[NSDate date]];
}
+ (NSInteger)getCurrentMonth
{
    return [NSDate getMonth:[NSDate date]];
}

+ (NSInteger)getYear:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    [formatter setDateFormat:@"yyyy"];
    return [[formatter stringFromDate:date] integerValue];
}
+ (NSInteger)getMonth:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    [formatter setDateFormat:@"MM"];
    return [[formatter stringFromDate:date] integerValue];
}

+ (NSInteger)getTotalDayOfMonth:(NSInteger)month year:(NSInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    // Set your year and month here
    [components setYear:year];
    [components setMonth:month];
    
    NSDate *date = [calendar dateFromComponents:components];
    return [date totalDayInThisMonth];
}
+ (NSArray *)getDaysInThisWeekTotal
{
    NSMutableArray *dayInWeek = [[NSMutableArray alloc] init];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSCalendarUnitWeekOfYear |NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger increaseDay = 0;
    [comps setWeekday:1];
    NSDate *currentDate = [calendar dateFromComponents:comps];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    [comps setDay:1];
    for (int i = 0; i < 7; i++) {
         // 2: monday
        [comps setDay:[comps day] + 1];
        currentDate = [calendar dateFromComponents:comps];
        [dayInWeek addObject:currentDate];
        components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
        if ([[calendar dateFromComponents:comps] totalDayInThisMonth] == [components day]) {
            increaseDay = i;
            if ([comps month] == 12) {
                [comps setYear:[comps year] + 1];
                [comps setMonth:1];
            }
            else
            {
                [comps setMonth:[comps month] + 1];
            }
            [comps setDay:0];
        }
    }
    return dayInWeek;
}
+ (NSString *)dateMode
{
    if ([[self currentComponentDate] hour] >= 12) {
        return LocalizedString(@"PM");
    }
    else
    {
        return LocalizedString(@"AM");
    }
}

#pragma mark - Current Day
- (NSInteger)getCurrenDayByDate:(NSDate *)curDate{
	NSInteger dayInt = [[[NSCalendar currentCalendar] components: NSCalendarUnitWeekday fromDate: curDate] weekday];
	return dayInt;
}
@end
