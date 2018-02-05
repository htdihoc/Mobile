//
//  CalendarButtonControlelr.h
//  TestCalendar
//
//  Created by NguyenVanTu on 4/10/17.
//  Copyright © 2017 NguyenVanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "JTCalendar.h"

@interface TimeKeepingCalendarDetail : BaseVC<JTCalendarDelegate>

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarWeekDayView *weekDayView;
@property (weak, nonatomic) IBOutlet JTVerticalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@end
