//
//  TTNS_TimeKeepingCalendarDetailController.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/16/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeKeepingCalendar.h"
typedef enum : NSUInteger{
    TimeKeepingUpdateType_Approve = 1,
    TimeKeepingUpdateType_Reject = 2
}TimeKeepingUpdateType;
typedef void (^CallbackLoadListTimeKeeping)(BOOL success, NSArray *resultArray, NSException *exception, BOOL isConnectNetwork, NSDictionary *error);
typedef void (^CallbackTimeKeeping)(BOOL success, NSString *message, NSException *exception, BOOL isConnectNetwork, NSDictionary *error);
typedef void (^CallbackUpdateTimeKeeping)(BOOL success, NSException *exception, NSDictionary *error);
@interface TTNS_TimeKeepingCalendarDetailController : NSObject

+ (void)updateTimeKeeping:(NSNumber *)managerID timeKeeping:(NSString *)timeKeeping updateType:(TimeKeepingUpdateType)updateType reason:(NSString *)reason completion:(CallbackUpdateTimeKeeping)completion;
+ (void)updateTimeKeeping:(NSNumber *)employeeID managerID:(NSNumber *)managerID updateType:(TimeKeepingUpdateType)updateType fromTime:(NSNumber *)fromTime toTime:(NSNumber *)toTime comment:(NSString *)comment completion:(CallbackUpdateTimeKeeping)completion;
- (void)loadData:(NSNumber *)employeeID managerID:(NSNumber *)managerID fromTime:(NSNumber *)fromTime toTime:(NSNumber *)toTime completion:(CallbackLoadListTimeKeeping)completion;
- (void)timeKeepingWithID:(NSNumber *)employee_id timeKeeping:(NSNumber *)timeKeeping workPlaceType:(NSString *)workPlaceType workType:(NSString *)workType sourceData:(NSString *)sourceData privateKey:(NSString *)privateKey completion:(CallbackTimeKeeping)completion;
- (void)deleteTimeKeeping:(NSNumber *)employee_id content:(NSString *)content date:(NSDate *)date increaseMonth:(NSInteger)increaseMonth completion:(CallbackTimeKeeping)completion;
- (TimeKeepingCalendarType)getState:(NSDate *)dateToCompare;
- (BOOL)checkAvailableToTimeKeeping:(NSDate *)dateToCompare increaseMonth:(NSInteger)increaseMonth;
- (void)setCurrentTotalTimeKeeping;
- (NSString *)currentMonthTotalTimeKeeping;
- (NSString *)getTotalTimeKeeping;
- (CGFloat)getWaitingDayPercent;
- (CGFloat)getApproveDayPercent;
- (CGFloat)getRejctDayPercent;
- (CGFloat)getUnCheckTimeKeeping;
- (CGFloat)getLatedDayPercent;
- (NSArray *)getColorsInThisMonth;
- (NSString *)getTimeKeepingID:(NSDate *)dateToCompare;
- (NSString *)getTitle;
- (void)resetData;
@end
