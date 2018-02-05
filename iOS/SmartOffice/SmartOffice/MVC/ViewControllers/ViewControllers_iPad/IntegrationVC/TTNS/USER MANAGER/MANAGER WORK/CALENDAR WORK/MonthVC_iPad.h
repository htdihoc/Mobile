//
//  MonthVC_iPad.h
//  SmartOffice
//
//  Created by Administrator on 5/9/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "MGCMonthPlannerEKViewController.h"
#import "CalendarVC_iPad.h"

@interface MonthVC_iPad : MGCMonthPlannerEKViewController <CalendarViewControllerNavigation>

@property (nonatomic, weak) id<CalendarViewControllerDelegate> delegate;

@end
