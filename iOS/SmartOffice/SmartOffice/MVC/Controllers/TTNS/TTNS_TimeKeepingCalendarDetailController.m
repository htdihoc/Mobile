//
//  TTNS_TimeKeepingCalendarDetailController.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/16/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_TimeKeepingCalendarDetailController.h"
#import "TTNSProcessor.h"
#import "TTNS_TimeKeepingDayModel.h"
#import "Common.h"
#import "NSDate+Utilities.h"
#import "NSException+Custom.h"
@interface TTNS_TimeKeepingCalendarDetailController()
{
    NSInteger _waitingDayTotal;
    NSInteger _approveDayTotal;
    NSInteger _rejectDayTotal;
    NSInteger _latedDayTotal;
    NSInteger _lockDayTotal;
    BOOL _isLoaded;
    NSString *_title;
}
@property (strong, nonatomic) NSMutableArray *timeKeepingModels;
@property (strong, nonatomic) NSNumber *totalTimeKeeping;
@property (strong, nonatomic) NSNumber *currentTotalTimeKeeping;
@end
@implementation TTNS_TimeKeepingCalendarDetailController


+ (void)updateTimeKeeping:(NSNumber *)managerID timeKeeping:(NSString *)timeKeeping updateType:(TimeKeepingUpdateType)updateType reason:(NSString *)reason completion:(CallbackUpdateTimeKeeping)completion
{
    if (managerID == nil || timeKeeping == nil) {
        return;
    }
    reason = reason == nil ? @"" : reason;
    NSDictionary *params = @{@"approve_emp_id": managerID, @"id" : timeKeeping, @"status" : [NSNumber numberWithInt:updateType], @"reason" : reason};
    if([Common checkNetworkAvaiable]){
        if (managerID == nil) {
            return;
        }
        [TTNSProcessor postTTNS_Update_TimeKeeping:params callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            completion(success, exception, resultDict);
        }];
    }
    else
    {
        completion(NO, [NSException initWithNoNetWork], nil);
    }
}

+ (void)updateTimeKeeping:(NSNumber *)employeeID managerID:(NSNumber *)managerID updateType:(TimeKeepingUpdateType)updateType fromTime:(NSNumber *)fromTime toTime:(NSNumber *)toTime comment:(NSString *)comment completion:(CallbackUpdateTimeKeeping)completion
{
    if (managerID == nil || employeeID == nil || fromTime == nil || toTime == nil) {
        return;
    }
    comment = comment == nil ? @"" : comment;

    NSDictionary *params = @{@"employee_id":employeeID,@"approve_emp_id": managerID, @"from_time" : fromTime, @"end_time" : toTime, @"comment": comment, @"type" : [NSNumber numberWithInteger:updateType]};
    if([Common checkNetworkAvaiable]){
        if (managerID == nil) {
            return;
        }
        [TTNSProcessor postTTNS_Update_TimeKeepingRange:params callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            completion(success, exception, resultDict);
        }];
    }
    else
    {
        completion(NO, [NSException initWithNoNetWork], nil);
    }
}
- (void)loadData:(NSNumber *)employeeID managerID:(NSNumber *)managerID fromTime:(NSNumber *)fromTime toTime:(NSNumber *)toTime completion:(CallbackLoadListTimeKeeping)completion
{
    
    if([Common checkNetworkAvaiable]){
        //employee_id=41652&manager_id=40833&from_time=631152000000&to_time=1494892800000
        if (!employeeID || !managerID || !fromTime || !toTime) {
            return;
        }
        NSDictionary *params = @{@"employee_id" : employeeID,
                                 @"manager_id" : employeeID,
                                 @"from_time":fromTime,
                                 @"to_time":toTime};
        [TTNSProcessor getTTNS_DANH_CHAM_CONG_THEO_IDEMPLOYEE:params callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (success) {
                [self resetData];
                NSDictionary *entity = [[resultDict valueForKey:@"data"] valueForKey:@"entity"];
                if ([entity isKindOfClass:[NSDictionary class]]) {
                    NSArray *timeKeepings = [entity valueForKey:@"timeKeepings"];
                    self.totalTimeKeeping = [entity valueForKey:@"totalTimeKeeping"];
                    NSArray *modelResult = [TTNS_TimeKeepingDayModel arrayOfModelsFromDictionaries:timeKeepings error:nil];
                    self.timeKeepingModels = [[NSMutableArray alloc] initWithArray:modelResult];
                    if (!_isLoaded) {
                        _isLoaded = YES;
                    }
                    completion(success, modelResult, exception, YES, resultDict);
                }
                else
                {
                    completion(success, nil, exception, YES, resultDict);
                    
                }
                
            }
            else
            {
                completion(success, nil, exception, YES, resultDict);
            }
        }];
    }
    else
    {
        completion(NO, nil, [NSException initWithNoNetWork], NO, nil);
    }
}
- (TimeKeepingCalendarType)getState:(NSDate *)dateToCompare
{
    _title = @"";
    for (TTNS_TimeKeepingDayModel *model in self.timeKeepingModels) {
        NSDate *modelDate = [NSDate dateWithTimeIntervalSince1970:model.startDate/1000.0];
        if ([modelDate compareSameMonthAndYearWithOtherDay:dateToCompare] == NSOrderedSame) {
            _title = model.title;
            if (model.isLock) {
                return Lock;
            }
            return model.status;
        }
    }
    return UnKnown;
}
- (NSString *)getTitle
{
    return _title;
}
- (NSString *)getTimeKeepingID:(NSDate *)dateToCompare

{
    for (TTNS_TimeKeepingDayModel *model in self.timeKeepingModels) {
        NSDate *modelDate = [NSDate dateWithTimeIntervalSince1970:model.startDate/1000.0];
        if ([modelDate compareSameMonthAndYearWithOtherDay:dateToCompare] == NSOrderedSame) {
            return model.id;
        }
    }
    return @"";
}
- (BOOL)checkAvailableToTimeKeeping:(NSDate *)dateToCompare increaseMonth:(NSInteger)increaseMonth
{
    if ([[NSDate date] compareSameMonthAndYearWithOtherDay:dateToCompare] == NSOrderedDescending || [[NSDate date] compareSameMonthAndYearWithOtherDay:dateToCompare] == NSOrderedSame || [[NSDate date] compareMonth:dateToCompare] == NSOrderedAscending)
    {
        return YES;
    }
    return NO;
}
- (NSString *)getTotalTimeKeeping
{
    if ([self.totalTimeKeeping stringValue] == nil || [[self.totalTimeKeeping stringValue] isEqualToString:@""]) {
        return @"0";
    }
    return [self.totalTimeKeeping stringValue];
}

- (void)timeKeepingWithID:(NSNumber *)employee_id timeKeeping:(NSNumber *)timeKeeping workPlaceType:(NSString *)workPlaceType workType:(NSString *)workType sourceData:(NSString *)sourceData privateKey:(NSString *)privateKey completion:(CallbackTimeKeeping)completion
{
    
    if([Common checkNetworkAvaiable]){
        if (!employee_id ||
            !timeKeeping ||
            !workPlaceType ||
            !workType ||
            !sourceData ||
            !privateKey) {
            return;
        }
        NSDictionary *params = @{@"employee_id" : employee_id,
                                 @"time_keeping" : timeKeeping,
                                 @"work_place_type":workPlaceType,
                                 @"type":workType,
                                 @"source_data":sourceData,
                                 @"private_key":privateKey};
        [TTNSProcessor postTTNS_TimeKeeping_ForEmployee:params callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (success) {
                //done
                if ([[[resultDict valueForKey:@"data"] valueForKey:@"entity"] isKindOfClass:[NSString class]]) {
                    //error
                    completion(success, [[resultDict valueForKey:@"data"] valueForKey:@"entity"], exception, YES, resultDict);
                }
                else
                {
                    completion(success, nil, exception, YES, resultDict);
                }
                
            }
            else
            {
                completion(success, nil, exception, YES, resultDict);
            }
        }];
    }
    else
    {
        completion(NO, nil, [NSException initWithNoNetWork], NO, nil);
    }
}


- (void)deleteTimeKeeping:(NSNumber *)employee_id content:(NSString *)content date:(NSDate *)date increaseMonth:(NSInteger)increaseMonth completion:(CallbackTimeKeeping)completion
{
    if([Common checkNetworkAvaiable]){
        if (!employee_id || ![self getTimeKeepingIDFrom:date increaseMonth:increaseMonth]) {
            return;
        }
        NSDictionary *params = @{@"employee_id" : employee_id,
                                 @"id" : [self getTimeKeepingIDFrom:date increaseMonth:increaseMonth],
                                 @"comment":content == nil ? [NSNull null] : content};
        [TTNSProcessor postTTNS_Delete_TimeKeeping:params callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            id entity = [[resultDict valueForKey:@"data"] valueForKey:@"entity"];
            if (success) {
                if ([entity isKindOfClass:[NSString class]]) {
                    completion(success, entity, exception, YES, resultDict);
                }
                else
                {
                    completion(success, nil, exception, YES, resultDict);
                }
            }
            else
            {
                completion(success, nil, exception, YES, resultDict);
            }
            DLog(@"Called Delete API");
        }];
    }
    else
    {
        completion(NO, nil, [NSException initWithNoNetWork], NO, nil);
    }
}
- (NSString *)getTimeKeepingIDFrom:(NSDate *)date increaseMonth:(NSInteger)increaseMonth
{
    for (TTNS_TimeKeepingDayModel *model in self.timeKeepingModels) {
        NSDate *modelDate = [NSDate dateWithTimeIntervalSince1970:model.startDate/1000.0];
        if ([modelDate compareSameMonthAndYearWithOtherDay:date] == NSOrderedSame) {
            return model.id;
        }
    }
    return nil;
}
- (UIColor *)getColorWithType:(TimeKeepingCalendarType)type
{
    switch (type) {
        case Waiting:
            return CommonColor_Orange;
        case Approved:
            return CommonColor_Blue;
        case Approved2:
        {
            return CommonColor_Blue;
        }
        case Reject:
            return CommonColor_Red;
        case LatedDay:
            return CommonColor_GreenTimeKeeping;
        default:
            return CommonColor_LightGray;
    }
}
- (NSArray *)getColorsInThisMonth
{
    NSMutableArray *values = [[NSMutableArray alloc] init];
    NSArray *daysInThisWeekTotal = [NSDate getDaysInThisWeekTotal];
    for (NSDate *dateToCompare in daysInThisWeekTotal) {
        [values addObject:[self getColorWithType:[self getState:dateToCompare]]];
    }
    //add gray color for 8th piece
    [values addObject:CommonColor_LightGray];
    return values;
}

- (void)calculateDateType
{
    _waitingDayTotal = 0;
    _approveDayTotal = 0;
    _rejectDayTotal = 0;
    _latedDayTotal = 0;
    _lockDayTotal = 0;
    for (TTNS_TimeKeepingDayModel *model in self.timeKeepingModels) {
        switch (model.status) {
            case Waiting:
                _waitingDayTotal = _waitingDayTotal + 1;
                break;
            case Approved:
                _approveDayTotal = _approveDayTotal + 1;
                break;
            case Approved2:
                _approveDayTotal = _approveDayTotal + 1;
                break;
            case Reject:
                _rejectDayTotal = _rejectDayTotal + 1;
                break;
            case LatedDay:
                _latedDayTotal = _latedDayTotal + 1;
                break;
            case Lock:
                _lockDayTotal = _lockDayTotal + 1;
                break;
            default:
                break;
        }
    }
}
- (CGFloat)getWaitingDayPercent
{
    return (CGFloat)_waitingDayTotal/[[NSDate date] totalDayInThisMonth];
}
- (CGFloat)getApproveDayPercent
{
    return (CGFloat)_approveDayTotal/[[NSDate date] totalDayInThisMonth];
}
- (CGFloat)getRejctDayPercent
{
    return (CGFloat)_rejectDayTotal/[[NSDate date] totalDayInThisMonth];
}
- (CGFloat)getUnCheckTimeKeeping
{
    return 1 - ([self getWaitingDayPercent] + [self getApproveDayPercent] + [self getRejctDayPercent] + [self getLatedDayPercent]);
}
- (CGFloat)getLatedDayPercent
{
    return (CGFloat)_latedDayTotal/[[NSDate date] totalDayInThisMonth];
}
- (NSString *)currentMonthTotalTimeKeeping
{
    if (!self.currentTotalTimeKeeping) {
        self.currentTotalTimeKeeping = self.totalTimeKeeping;
    }
    if ([self.currentTotalTimeKeeping stringValue] == nil || [[self.currentTotalTimeKeeping stringValue] isEqualToString:@""]) {
        return @"0";
    }
    return [self.currentTotalTimeKeeping stringValue];
}
- (void)setCurrentTotalTimeKeeping
{
    [self calculateDateType];
    _currentTotalTimeKeeping = _totalTimeKeeping;
}
- (void)resetData
{
    _timeKeepingModels = [[NSMutableArray alloc] init];
    _totalTimeKeeping = [NSNumber numberWithInt:0];
}
@end
