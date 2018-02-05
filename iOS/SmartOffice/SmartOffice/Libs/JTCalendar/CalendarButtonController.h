//
//  CalendarButtonControlelr.h
//  TestCalendar
//
//  Created by NguyenVanTu on 4/10/17.
//  Copyright © 2017 NguyenVanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum StateButtonCalender : NSUInteger {
    kNext,
    kBack,
} StateButtonCalender;
@interface CalendarButtonController : UIButton
@property (nonatomic, assign) StateButtonCalender stateCalenderButton;
@end
