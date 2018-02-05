//
//  CalendarButtonControlelr.h
//  TestCalendar
//
//  Created by NguyenVanTu on 4/10/17.
//  Copyright © 2017 NguyenVanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
#import "TTNS_BaseVC.h"
//DocDetailType

@protocol TimeKeepingCalendarDelegate <NSObject>
- (TimeKeepingCalendarType) getTypeOfTimeKeeping:(NSDate *)dateToCompare;
- (NSString *) getTitle;
- (NSString *)getTotalTimeKeeping;
- (void)selectedDate:(NSDate *)date;
- (BOOL)checkAvailableToTimeKeeping:(NSDate *)dateToCompare;
- (void)changeMonth:(NSInteger)increaseMonth;
- (NSInteger)getIncreaseMonth;
- (BOOL) isLoaded;

@optional
- (BOOL)isMasterRole;
@end
@interface TimeKeepingCalendar : BaseVC<JTCalendarDelegate>

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarWeekDayView *weekDayView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (weak, nonatomic) id <TimeKeepingCalendarDelegate> delegate;
@property BOOL isUserManager;

- (void)reloadData;
@end
