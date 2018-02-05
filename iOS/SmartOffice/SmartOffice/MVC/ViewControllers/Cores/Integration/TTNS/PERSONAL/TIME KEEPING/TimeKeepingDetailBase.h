//
//  TimeKeepingDetailBase.h
//  SmartOffice
//
//  Created by NguyenVanTu on 6/23/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNS_BaseVC.h"
#import "TTNS_TimeKeepingCalendarDetailController.h"
#import "EmployeeModel.h"
@protocol TimeKeepingCalendarDetailDelegate <NSObject>
@optional
- (TTNS_TimeKeepingCalendarDetailController *)getTimekeepingController;
- (void)getListTimeKeeping:(NSInteger)increseMonth;
- (BOOL)isLoaded;
- (NSNumber *)getEmployeeID;
- (void)updateAllTimeKeeping:(TimeKeepingUpdateType)type employeeID:(NSNumber *)employeeID managerID:(NSNumber *)managerID
                     comment:(NSString *)comment increseMonth:(NSInteger)increseMonth;
- (void)updateATimeKeeping:(TimeKeepingUpdateType)type managerID:(NSNumber *)managerID timeKeepingID:(NSString *)timeKeepingID reason:(NSString *)reason increseMonth:(NSInteger)increseMonth;
- (void)showError:(NSString *)message;
@end
@interface TimeKeepingDetailBase : TTNS_BaseVC
@property (strong, nonatomic) TTNS_TimeKeepingCalendarDetailController *timekeepingController;
@property (assign) NSUInteger increseMonth;
- (void)selectedDate:(NSDate *)date;
- (void)requestTimeKeeping:(NSNumber *)employee_id timeKeeping:(NSNumber *)timeKeeping workPlaceType:(NSString *)workPlaceType workType:(NSString *)workType sourceData:(NSString *)sourceData privateKey:(NSString *)privateKey;
- (void)setTimekeepingController:(TTNS_TimeKeepingCalendarDetailController *)timekeepingController;
- (void)reloadData;
@property (weak, nonatomic) id <TimeKeepingCalendarDetailDelegate> delegate;
@end
