//
//  CalendarVC_iPad.h
//  SmartOffice
//
//  Created by Administrator on 5/9/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKitUI/EventKitUI.h>

@protocol CalendarViewControllerNavigation <NSObject>

@property (nonatomic, readonly) NSDate* centerDate;

- (void)moveToDate:(NSDate*)date animated:(BOOL)animated;
- (void)moveToNextPageAnimated:(BOOL)animated;
- (void)moveToPreviousPageAnimated:(BOOL)animated;

@optional

@property (nonatomic) NSSet* visibleCalendars;

@end


typedef  UIViewController<CalendarViewControllerNavigation> CalendarViewController;


@protocol CalendarViewControllerDelegate <NSObject>

@optional

- (void)calendarViewController:(CalendarViewController*)controller didShowDate:(NSDate*)date;
- (void)calendarViewController:(CalendarViewController*)controller didSelectEvent:(EKEvent*)event;

@end


@interface CalendarVC_iPad : UIViewController<CalendarViewControllerDelegate, EKCalendarChooserDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *currentMonthLB;

@property (weak, nonatomic) IBOutlet UIButton *arrowRightButotn;

@property (weak, nonatomic) IBOutlet UIButton *arrowLeftButton;

@property (weak, nonatomic) IBOutlet UILabel *sumOfWorkLB;

@property (weak, nonatomic) IBOutlet UILabel *numberSumOfWorkLB;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLB;

@property (weak, nonatomic) IBOutlet UIView *descriptionView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *btnAllowAll;
@property (weak, nonatomic) IBOutlet UIButton *btnDeniedAll;

@property (weak, nonatomic) IBOutlet UILabel *lbMeritWaitComfirm;

@property (weak, nonatomic) IBOutlet UILabel *lbMeritConfirm;

@property (nonatomic) CalendarViewController* calendarViewController;

@property (nonatomic) NSCalendar *calendar;

@property (nonatomic) EKEventStore *eventStore;

- (IBAction)arrowRightAction:(id)sender;

- (IBAction)arrowLeftAction:(id)sender;

- (IBAction)allowAllAction:(id)sender;

- (IBAction)deniedAllAction:(id)sender;



@end
