 //
//  TimePickerVCViewController.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SO_CustomDatePicker.h"
#import "TopPickerView.h"
#import "SO_CustomTimePicker.h"
@protocol TimePickerVCDelegate
- (void)didDismissView:(NSString *)startDate startDateDetail:(NSString *)startDateDetail endDate:(NSString *)endDate endDateDetail:(NSString *)endDateDetail;
- (NSString *)getStartDate;
- (NSString *)getStartDateDetail;
- (NSString *)getEndDate;
- (NSString *)getEndDateDetail;
- (BOOL)isAMMode;
@end
@interface TimePickerVC : BaseVC    
@property (weak, nonatomic) IBOutlet SO_CustomDatePicker *datePickerView;
@property (weak, nonatomic) IBOutlet TopPickerView *topView;
@property (nonatomic,strong) SO_CustomTimePicker *clockView;
@property (weak, nonatomic) IBOutlet UIView *nav_TimePickerVC;
@property (weak, nonatomic) id<TimePickerVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (assign, nonatomic) BOOL isLockMinuteView;
@end
