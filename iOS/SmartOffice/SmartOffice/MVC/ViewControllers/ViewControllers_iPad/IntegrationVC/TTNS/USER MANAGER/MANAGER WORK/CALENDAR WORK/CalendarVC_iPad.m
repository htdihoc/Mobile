//
//  CalendarVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 5/9/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "CalendarVC_iPad.h"
#import "MonthVC_iPad.h"
#import "NSCalendar+MGCAdditions.h"
#import "UIButton+BorderDefault.h"
#import "UIView+BorderView.h"
#import "MZFormSheetController.h"
#import "ConfirmRefueAllVC_iPad.h"
#import "Common.h"
#import "WorkNoDataView.h"

typedef enum : NSUInteger
{
    CalendarViewWeekType  = 0,
    CalendarViewMonthType = 1,
    CalendarViewYearType = 2,
    CalendarViewDayType
} CalendarViewType;

@interface CalendarVC_iPad () <MZFormSheetBackgroundWindowDelegate, ConfirmRefueAllDelegate>

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic) EKCalendarChooser *calendarChooser;
@property (nonatomic) BOOL firstTimeAppears;

@property (nonatomic) MonthVC_iPad *monthViewController;

@end

@implementation CalendarVC_iPad

@synthesize calendar = _calendar;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _eventStore = [[EKEventStore alloc]init];
    }
    return self;
}

#pragma mark LifeCycler
- (void)viewDidLoad
{
    [super viewDidLoad];
    if([Common checkNetworkAvaiable]){
        NSString *calID = [[NSUserDefaults standardUserDefaults]stringForKey:@"calendarIdentifier"];
        self.calendar = [NSCalendar mgc_calendarFromPreferenceString:calID];
        [self.btnDeniedAll setBorderForButton:3 borderWidth:1 borderColor:[AppColor_BorderForCancelButton CGColor]];
        self.btnAllowAll.layer.cornerRadius = 3;
        
        //    NSUInteger firstWeekday = [[NSUserDefaults standardUserDefaults]integerForKey:@"firstDay"];
        //    if (firstWeekday != 0) {
        //        self.calendar.firstWeekday = firstWeekday;
        //    } else {
        //        [[NSUserDefaults standardUserDefaults]registerDefaults:@{ @"firstDay" : @(self.calendar.firstWeekday) }];
        //    }
        self.calendar.firstWeekday = 2;
        
        self.dateFormatter = [NSDateFormatter new];
        self.dateFormatter.calendar = self.calendar;
        
        
        CalendarViewController *controller = [self controllerForViewType];
        [self addChildViewController:controller];
        [self.containerView addSubview:controller.view];
        controller.view.frame = self.containerView.bounds;
        [controller didMoveToParentViewController:self];
        
        self.calendarViewController = controller;
        self.firstTimeAppears = YES;
    } else {
        [[Common shareInstance] showErrorHUDWithMessage:LocalizedString(@"Không có kết nối mạng") inView:self.view];
        [self.view setHidden:YES];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.firstTimeAppears) {
        NSDate *date = [self.calendar mgc_startOfWeekForDate:[NSDate date]];
        [self.calendarViewController moveToDate:date animated:NO];
        self.firstTimeAppears = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//    UINavigationController *nc = (UINavigationController*)self.presentedViewController;
//    if (nc) {
//        BOOL hide = (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular && self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular);
//        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissSettings:)];
//        nc.topViewController.navigationItem.rightBarButtonItem = hide ? nil : doneButton;
//    }
//}

#pragma mark UI

- (void)setTextForLB{
    self.descriptionLB.text = LocalizedString(@"TTNS_TimeKeepingCalendar_Nhấn_chọn_ngày_để_cập_nhật_công");
}

#pragma mark - Private

- (MonthVC_iPad*)monthViewController
{
    if (_monthViewController == nil) {
        _monthViewController = [[MonthVC_iPad alloc]initWithEventStore:self.eventStore];
        _monthViewController.calendar = self.calendar;
        _monthViewController.delegate = self;
        _monthViewController.monthPlannerView.rowHeight = (self.containerView.bounds.size.height - 50)/5;
    }
    return _monthViewController;
}

- (CalendarViewController*)controllerForViewType
{
    return self.monthViewController;
}

-(void)moveToNewController:(CalendarViewController*)newController atDate:(NSDate*)date
{
    [self.calendarViewController willMoveToParentViewController:nil];
    [self addChildViewController:newController];
    
    [self transitionFromViewController:self.calendarViewController toViewController:newController duration:.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^
     {
         newController.view.frame = self.containerView.bounds;
         newController.view.hidden = YES;
     } completion:^(BOOL finished)
     {
         [self.calendarViewController removeFromParentViewController];
         [newController didMoveToParentViewController:self];
         self.calendarViewController = newController;
         [newController moveToDate:date animated:NO];
         newController.view.hidden = NO;
     }];
}

#pragma mark - Actions


- (IBAction)showToday:(id)sender
{
    [self.calendarViewController moveToDate:[NSDate date] animated:YES];
}

- (IBAction)nextPage:(id)sender
{
    [self.calendarViewController moveToNextPageAnimated:YES];
}

- (IBAction)previousPage:(id)sender
{
    [self.calendarViewController moveToPreviousPageAnimated:YES];
}

- (IBAction)showCalendars:(id)sender
{
    if ([self.calendarViewController respondsToSelector:@selector(visibleCalendars)]) {
        self.calendarChooser = [[EKCalendarChooser alloc]initWithSelectionStyle:EKCalendarChooserSelectionStyleMultiple displayStyle:EKCalendarChooserDisplayAllCalendars eventStore:self.eventStore];
        self.calendarChooser.delegate = self;
        self.calendarChooser.showsDoneButton = YES;
        self.calendarChooser.selectedCalendars = self.calendarViewController.visibleCalendars;
    }
    
    if (self.calendarChooser) {
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:self.calendarChooser];
        self.calendarChooser.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(calendarChooserStartEdit)];
        nc.modalPresentationStyle = UIModalPresentationPopover;
        
        [self showDetailViewController:nc sender:self];
        
        UIPopoverPresentationController *popController = nc.popoverPresentationController;
        popController.barButtonItem = (UIBarButtonItem*)sender;
    }
}

- (void)calendarChooserStartEdit
{
    self.calendarChooser.editing = YES;
    self.calendarChooser.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(calendarChooserEndEdit)];
}

- (void)calendarChooserEndEdit
{
    self.calendarChooser.editing = NO;
    self.calendarChooser.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(calendarChooserStartEdit)];
}

- (void)showConfirmRefueAllVC {
    ConfirmRefueAllVC_iPad *vc = NEW_VC_FROM_NIB(ConfirmRefueAllVC_iPad, @"ConfirmRefueAllVC_iPad");
    vc.delegate = self;
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    formSheet.presentedFormSheetSize = CGSizeMake(SCREEN_WIDTH_LANDSCAPE/3, SCREEN_HEIGHT_LANDSCAPE/3.3);
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.cornerRadius = 12;
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    }];
}



#pragma mark - CalendarViewControllerDelegate

- (void)calendarViewController:(CalendarViewController*)controller didShowDate:(NSDate*)date
{
    [self.dateFormatter setDateFormat:@"MMMM yyyy"];
    
    NSString *str = [self.dateFormatter stringFromDate:date];
    self.currentMonthLB.text = str;
    [self.currentMonthLB sizeToFit];
}

- (void)calendarViewController:(CalendarViewController*)controller didSelectEvent:(EKEvent*)event
{
    //NSLog(@"calendarViewController:didSelectEvent");
}


#pragma mark - EKCalendarChooserDelegate

- (void)calendarChooserSelectionDidChange:(EKCalendarChooser*)calendarChooser
{
    if ([self.calendarViewController respondsToSelector:@selector(setVisibleCalendars:)]) {
        self.calendarViewController.visibleCalendars = calendarChooser.selectedCalendars;
    }
}

- (void)calendarChooserDidFinish:(EKCalendarChooser*)calendarChooser
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (IBAction)arrowRightAction:(id)sender {
}

- (IBAction)arrowLeftAction:(id)sender {
}

- (IBAction)allowAllAction:(id)sender {
    self.lbMeritWaitComfirm.text = @"0";
    self.lbMeritConfirm.text = @"23";
}

- (IBAction)deniedAllAction:(id)sender {
    [self showConfirmRefueAllVC];
}
@end
