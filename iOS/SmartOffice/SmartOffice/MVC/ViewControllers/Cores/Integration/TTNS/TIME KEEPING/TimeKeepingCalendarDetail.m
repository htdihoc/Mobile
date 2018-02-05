
//
//  CalendarButtonControlelr.h
//  TestCalendar
//
//  Created by NguyenVanTu on 4/10/17.
//  Copyright © 2017 NguyenVanTu. All rights reserved.
//

#import "TimeKeepingCalendarDetail.h"
#import "ProcessTimeKeeping.h"
#import "DismissTimeKeeping.h"
@interface TimeKeepingCalendarDetail (){
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_dateSelected;
}

@end

@implementation TimeKeepingCalendarDetail

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(!self){
        return nil;
    }
    
    self.title = @"Vertical";
    
    return self;
}
- (IBAction)back:(id)sender {
    [self popToRoot];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    _calendarManager.settings.pageViewHaveWeekDaysView = NO;
    _calendarManager.settings.pageViewNumberOfWeeks = 0; // Automatic
    
    _weekDayView.manager = _calendarManager;
    [_weekDayView reload];
    
    // Generate random events sort by date using a dateformatter for the demonstration
    [self createRandomEvents];
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
    _calendarMenuView.scrollView.scrollEnabled = NO; // Scroll not supported with JTVerticalCalendarView
}
- (void)showCenterTimeKeeping
{
    ProcessTimeKeeping *content = [[ProcessTimeKeeping alloc] initWithNibName:@"ProcessTimeKeeping" bundle:nil];
    [self showAlert:content title:@"Thực hiện chấm công" leftButtonTitle:@"Đóng" rightButtonTitle:@"Chấm công" leftHander:nil rightHander:nil];
}
- (void)showDismissTimeKeeping
{
    DismissTimeKeeping *content = [[DismissTimeKeeping alloc] initWithNibName:@"DismissTimeKeeping" bundle:nil];
    [self showAlert:content title:@"Huỷ chấm công" leftButtonTitle:@"Đóng" rightButtonTitle:@"Huỷ chấm công" leftHander:nil rightHander:nil];
}
- (void) action{
    
    [self.calendarContentView loadNextPage];
    
}
#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    dayView.textLabel.textColor = [UIColor blackColor];
//    dayView.dotView.backgroundColor = [UIColor redColor];
    // Hide if from another month
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
//        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        
        if(dayView.dotView.backgroundColor == [UIColor blueColor])
        {
            [self showDismissTimeKeeping];
        }
        else
        {
            [self showCenterTimeKeeping];
        }
        
        
        dayView.circleView.hidden = NO;
        UIGraphicsBeginImageContext(dayView.dotView.frame.size);
        [[UIImage imageNamed:@"lock"] drawInRect:dayView.dotView.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dayView.circleView.backgroundColor = [UIColor redColor];
//        dayView.dotView.backgroundColor = [UIColor colorWithPatternImage:image];
//        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor blueColor];
        
    }
    
    
    //check the lastweek
    if([_calendarManager.dateHelper isAnotherMonth:dayView.date]){
        //        dayView.hidden = YES;
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    else if ([_calendarManager.dateHelper isWeekend:dayView.date])
    {
        dayView.textLabel.textColor = [UIColor redColor];
    }
    
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dayView.date];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    NSLog(@"Selected %ld %ld %ld", (long)day, (long)month, (long)year)
    ;
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
//            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
//            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}
- (void)calendarLoadNextPage
{
    [self.calendarContentView loadNextPageWithAnimation];
}
- (void)calendarLoadPreviousPage
{
    [self.calendarContentView loadPreviousPageWithAnimation];
}

#pragma mark - Fake data

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}

- (void)createRandomEvents
{
    _eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!_eventsByDate[key]){
            _eventsByDate[key] = [NSMutableArray new];
        }
        
        [_eventsByDate[key] addObject:randomDate];
    }
}

@end
