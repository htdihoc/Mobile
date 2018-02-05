
//
//  CalendarButtonControlelr.h
//  TestCalendar
//
//  Created by NguyenVanTu on 4/10/17.
//  Copyright © 2017 NguyenVanTu. All rights reserved.
//

#import "TimeKeepingCalendar.h"
#import "SOCycleView.h"
#import "NSDate+Utilities.h"
@interface TimeKeepingCalendar (){
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_dateSelected;
}
@property (weak, nonatomic) IBOutlet UILabel *lbl_DateTotalValue;
@property (weak, nonatomic) IBOutlet UILabel *lbl_DateTotal;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Help;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NotCheck;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Checked;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Reject;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Locked;
@property (weak, nonatomic) IBOutlet UILabel *lbl_LatedTimeKeeping;

@property (weak, nonatomic) IBOutlet SOCycleView *circleV1;
@property (weak, nonatomic) IBOutlet SOCycleView *circleV2;
@property (weak, nonatomic) IBOutlet SOCycleView *circleV3;

@property (weak, nonatomic) IBOutlet UIScrollView *sv_Container;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_numberOfTimeKeeping;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ManagerHelp;

@end

@implementation TimeKeepingCalendar

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(!self){
        return nil;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dateSelected = [NSDate date];
    _sv_Container.backgroundColor = AppColor_MainAppBackgroundColor;
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    _calendarManager.settings.pageViewHaveWeekDaysView = NO;
    _calendarManager.settings.pageViewNumberOfWeeks = 0; // Automatic
    
    _weekDayView.manager = _calendarManager;
    [_weekDayView reload];
    
    // Generate random events sort by date using a dateformatter for the demonstration
    //[self createRandomEvents];
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
    _calendarMenuView.scrollView.scrollEnabled = NO; // Scroll not supported with JTVerticalCalendarView
    self.lbl_DateTotalValue.text = [self.delegate getTotalTimeKeeping];
    self.lbl_ManagerHelp.hidden = true;
    
    if (self.isUserManager) {
        [self checkManage];
    }
    
}
- (void)checkManage
{
    self.cst_numberOfTimeKeeping.constant = 0;
    [self.lbl_Help setHidden:YES];
    [self.lbl_ManagerHelp setHidden:NO];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.delegate changeMonth:0];
}
- (void)reloadData
{
    self.lbl_DateTotalValue.text = [self.delegate getTotalTimeKeeping];
    [self.calendarManager reload];
}
- (void)setupTextForViews
{
    self.circleV1.backgroundColor = CommonColor_Orange;
    self.circleV2.backgroundColor = CommonColor_DarkBlue;
    self.circleV3.backgroundColor = [UIColor redColor];
    
    _lbl_DateTotal.textColor = AppColor_MainTextColor;
    _lbl_ManagerHelp.textColor = AppColor_MainTextColor;
    _lbl_Help.textColor = AppColor_MainTextColor;
    _lbl_NotCheck.textColor = AppColor_MainTextColor;
    _lbl_Checked.textColor = AppColor_MainTextColor;
    _lbl_Reject.textColor = AppColor_MainTextColor;
    _lbl_Locked.textColor = AppColor_MainTextColor;
    _lbl_LatedTimeKeeping.textColor = AppColor_MainTextColor;
    _lbl_DateTotal.text = [NSString stringWithFormat:@"%@:", LocalizedString(@"TTNS_TimeKeepingCalendar_Tổng_số_ngày_công_thực_tế")];
    _lbl_Help.text = LocalizedString(@"TTNS_TimeKeepingCalendar_Nhấn_chọn_ngày_để_cập_nhật_công");
    _lbl_NotCheck.text = LocalizedString(@"TTNS_TimeKeepingCalendar_Công_chưa_phê_duyệt");
    _lbl_Checked.text = LocalizedString(@"TTNS_TimeKeepingCalendar_Công_đã_phê_duyệt");
    _lbl_Reject.text = LocalizedString(@"TTNS_TimeKeepingCalendar_Công_bị_từ_chối");
    _lbl_Locked.text = LocalizedString(@"TTNS_TimeKeepingCalendar_Công_bị_khoá");
    _lbl_LatedTimeKeeping.text = LocalizedString(@"TTNS_TimeKeepingCalendar_Ngày_công_được_phê_duyệt_muộn");
}
- (void) action{
    
    [self.calendarContentView loadNextPage];
    
}
#pragma mark - CalendarManagerDelegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    dayView.rightLabel.hidden = YES;
    dayView.dotView.hidden = NO;
    dayView.dotView.backgroundColor = [UIColor blackColor];
    [[dayView.dotView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    dayView.circleView.backgroundColor = [UIColor clearColor];
    dayView.circleView.hidden = YES;
    dayView.textLabel.textColor = [UIColor blackColor];
    if(![self.delegate isLoaded])
    {
        return;
    }
    if (self.delegate) {
        TimeKeepingCalendarType status = [self.delegate getTypeOfTimeKeeping:dayView.date];
        NSString *title = [self.delegate getTitle];
        switch (status) {
            case Waiting:
            {
                dayView.dotView.backgroundColor = CommonColor_Orange;
                break;
            }
            case Approved:
            {
                dayView.dotView.backgroundColor = CommonColor_Blue;
                break;
            }
            case Approved2:
            {
                dayView.dotView.backgroundColor = CommonColor_Blue;
                break;
            }
            case Reject:
            {
                dayView.dotView.backgroundColor = [UIColor redColor];
                break;
            }
            case LatedDay:
            {
                dayView.dotView.backgroundColor = CommonColor_GreenTimeKeeping;
                break;
            }
            case Lock:
            {
                dayView.leftView.hidden = NO;
                dayView.dotView.hidden = YES;
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
                imageView.frame = CGRectMake(0, 0, 10, 10);
                [dayView.leftView addSubview:imageView];
                break;
            }
            default:
                dayView.dotView.hidden = YES;
                break;
        }
        
        //Day available
        //check user role
        if ([self.delegate checkAvailableToTimeKeeping:dayView.date] && status == UnKnown && !_isUserManager) {
            dayView.dotView.hidden = NO;
            dayView.dotView.backgroundColor = [UIColor clearColor];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pen"]];
            imageView.frame = CGRectMake(0, 0, 10, 10);
            [dayView.dotView addSubview:imageView];
        }
        
        if (![title isEqualToString:@""]) {
            dayView.rightLabel.hidden = NO;
            dayView.rightLabel.text = title;
            dayView.rightLabel.textColor = dayView.dotView.backgroundColor;
            [dayView.dotView setHidden:YES];
        }
    }
    //check the lastweek
    if([_calendarManager.dateHelper isAnotherMonth:dayView.date increaseMonth:[self.delegate getIncreaseMonth]]){
        dayView.dotView.hidden = YES;
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    else if ([_calendarManager.dateHelper isWeekend:dayView.date])
    {
        dayView.textLabel.textColor = [UIColor redColor];
    }
    if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.textLabel.textColor = [UIColor whiteColor];
        dayView.circleView.backgroundColor = [UIColor redColor];
    }
    
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    if(![self.delegate isLoaded])
    {
        return;
    }
    //    [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
    [self.delegate selectedDate:dayView.date];
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    //    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    //    [UIView transitionWithView:dayView
    //                      duration:.3
    //                       options:0
    //                    animations:^{
    //                        dayView.circleView.transform = CGAffineTransformIdentity;
    [_calendarManager reload];
    //                    } completion:nil];
    
    
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
- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    [self.delegate changeMonth:-1];
}
- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    [self.delegate changeMonth:1];
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

@end
