//
//  SO_CustomDatePicker.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNCalendarView.h"

@protocol SO_CustomDatePickerDelegate
@optional
- (BOOL)calendarViewShouldSelectEndDate;
- (void)calendarSelectedDate:(NSDate* )date;
@end
@interface SO_CustomDatePicker : UIView
@property (nonatomic, weak) id<SO_CustomDatePickerDelegate> delegate;
@property(nonatomic,strong) MNCalendarView *calendarView;
@end
