//
//  SO_CustomDatePicker.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SO_CustomDatePicker.h"

@interface SO_CustomDatePicker () <MNCalendarViewDelegate>

@property(nonatomic,strong) NSCalendar     *calendar;
@property(nonatomic,strong) NSDate         *currentDate;

@end

@implementation SO_CustomDatePicker

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self addDatePicker];
}
- (void)addDatePicker {
    self.backgroundColor = UIColor.whiteColor;
    
    self.currentDate = [NSDate date];
    
    self.calendarView = [[MNCalendarView alloc] initWithFrame:self.bounds];
    self.calendarView.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.calendarView.separatorColor = [UIColor colorWithRed:179/255 green:184/225 blue:190/255 alpha:0.5f];
    self.calendarView.selectedDate = [NSDate date];
    self.calendarView.delegate = self;
    
    self.calendarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.calendarView.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.calendarView];
}


#pragma mark - MNCalendarViewDelegate

- (void)calendarView:(MNCalendarView *)calendarView didSelectDate:(NSDate *)date {
    if (self.delegate) {
        [self.delegate calendarSelectedDate:date];
    }
}

- (BOOL)calendarView:(MNCalendarView *)calendarView shouldSelectDate:(NSDate *)date {
    //    NSTimeInterval timeInterval = [date timeIntervalSinceDate:self.currentDate];
    
    //    if (timeInterval > MN_WEEK && timeInterval < (MN_WEEK * 2)) {
    //        return NO;
    //    }
    
    return YES;
}
- (BOOL)calendarViewShouldSelectEndDate
{
    if (self.delegate) {
        return [self.delegate calendarViewShouldSelectEndDate];
    }
    return NO;
}


@end
