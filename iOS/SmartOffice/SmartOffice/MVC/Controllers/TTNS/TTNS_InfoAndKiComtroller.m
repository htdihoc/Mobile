//
//  TTNS_InfoAndKiComtroller.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/30/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_InfoAndKiComtroller.h"
#import "TTNSProcessor.h"
#import "TTNS_KiInfoModel.h"
#import "SOSessionManager.h"
#import "Common.h"
#import "NSException+Custom.h"
#import "TTNS_PayInfoModel.h"
#import "NSDate+Utilities.h"
#import "NSDate+Utilities.h"
#import "NSString+StringToDate.h"

#define kMinYear 2015
@interface TTNS_InfoAndKiComtroller()
{
    NSMutableArray *_dateStampIncome;
    NSMutableArray *_dateStampScore;
    
    NSInteger _barTotalInChart;
    NSString *_dateFormat;
    NSMutableArray *_kiColors;
    NSMutableArray *_payColors;
    InfoAndKiDateModel *_kiDate;
    InfoAndKiDateModel *_payDate;
}
@end
@implementation TTNS_InfoAndKiComtroller
- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}
- (NSArray *)getDateScore
{
    return _dateStampScore;
}
- (NSArray *)getDateIncome
{
    return _dateStampIncome;
}
- (InfoAndKiDateModel *)getKiDate
{
    return _kiDate;
}
- (InfoAndKiDateModel *)getIncomeDate
{
    return _payDate;
}
- (NSInteger)getTotalBarInChart
{
    return _barTotalInChart;
}
- (NSArray *)getScoreColors
{
    return _kiColors;
}
- (NSArray *)getIncomeColors
{
    return _payColors;
}
- (void)updateKiDate:(ActionType)actionType chartType:(ChartType)chartType
{
    if (actionType == ActionType_Next) {
        _kiDate = [self checkNext:chartType currentMonth:_kiDate.currentMonth monthTotal:_kiDate.monthTotal currentYear:_kiDate.currentYear];
        [self addTimeslamp:_kiDate.currentMonth year:_kiDate.currentYear type:chartType actionType:actionType];
    }
    else
    {
        _kiDate = [self checkBack:chartType currentMonth:_kiDate.currentMonth monthTotal:_kiDate.monthTotal currentYear:_kiDate.currentYear];
        [self addTimeslamp:_kiDate.currentMonth year:_kiDate.currentYear type:chartType actionType:actionType];
    }
    
    
}
- (void)updateIncomeDate:(ActionType)actionType chartType:(ChartType)chartType
{
    if (actionType == ActionType_Next) {
        _payDate = [self checkNext:chartType currentMonth:_payDate.currentMonth monthTotal:_payDate.monthTotal currentYear:_payDate.currentYear];
        [self addTimeslamp:_payDate.currentMonth year:_payDate.currentYear type:chartType actionType:ActionType_Next];
    }
    else
    {
        _payDate = [self checkBack:chartType currentMonth:_payDate.currentMonth monthTotal:_payDate.monthTotal currentYear:_payDate.currentYear];
        [self addTimeslamp:_payDate.currentMonth year:_payDate.currentYear type:chartType actionType:ActionType_Back];
    }
}
- (BOOL)checkAvailableYear:(ActionType)type chartType:(ChartType)chartType
{
    NSInteger currentYear;
    NSInteger currentMonth;
    NSInteger monthTotal;
    if (chartType == ChartType_Ki) {
        currentYear = _kiDate.currentYear;
        currentMonth = _kiDate.currentMonth;
        monthTotal = _kiDate.monthTotal;
    }
    else
    {
        currentYear = _payDate.currentYear;
        currentMonth = _payDate.currentMonth;
        monthTotal = _payDate.monthTotal;
    }
    switch (type) {
        case ActionType_Next:
            if (currentYear > [self getCurrentYear]) {
                return NO;
            }
            else
            {
                if (currentYear == [self getCurrentYear] && currentMonth == monthTotal) {
                    return NO;
                }
                return YES;
            }
            break;
        default:
            if (currentYear < kMinYear) {
                return NO;
            }
            else
            {
                if (currentYear == kMinYear && currentMonth <= _barTotalInChart) {
                    return NO;
                }
                return YES;
            }
            break;
    }
    
}

- (InfoAndKiDateModel *)checkBack:(ChartType)chartType currentMonth:(NSInteger)currentMonth monthTotal:(NSInteger)monthTotal currentYear:(NSInteger)currentYear
{
    InfoAndKiDateModel *currentDate = [[InfoAndKiDateModel alloc] initWith:currentMonth monthTotal:monthTotal currentYear:currentYear];
    if (![self checkAvailableYear:ActionType_Back chartType:chartType]) {
        currentDate.currentMonth = 0;
        currentDate.monthTotal = 0;
        currentDate.currentYear = 0;
        return currentDate;
    }
    if (currentDate.currentMonth <= _barTotalInChart) {
        
        currentDate.currentMonth = 12;
        currentDate.monthTotal = 12;
        currentDate.currentYear = currentDate.currentYear - 1;
        
    }
    else
    {
        currentDate.currentMonth = currentDate.currentMonth - _barTotalInChart;
    }
    return currentDate;
}
- (InfoAndKiDateModel *)checkNext:(ChartType)chartType currentMonth:(NSInteger)currentMonth monthTotal:(NSInteger)monthTotal currentYear:(NSInteger)currentYear
{
    InfoAndKiDateModel *currentDate = [[InfoAndKiDateModel alloc] initWith:currentMonth monthTotal:monthTotal currentYear:currentYear];
    if (![self checkAvailableYear:ActionType_Next chartType:chartType]) {
        currentDate.currentYear = [self getCurrentYear];
        return currentDate;
    }
    
    if (currentDate.currentMonth <= currentDate.monthTotal - _barTotalInChart) {
        currentDate.currentMonth = currentDate.currentMonth + _barTotalInChart;
    }
    else
    {
        currentDate.monthTotal = 12;
        currentDate.currentMonth = _barTotalInChart;
        currentDate.currentYear = currentDate.currentYear + 1;
        if (currentDate.currentYear == [self getCurrentYear]) {
            currentDate.monthTotal = [self getCurrentMonth];
            currentDate.currentMonth = [self getCurrentMonth] > _barTotalInChart ? ([self getCurrentMonth] - _barTotalInChart):[self getCurrentMonth];
        }
        
    }
    return currentDate;
}
- (void)addColorWithGrade:(NSString *)grade at:(NSInteger)index
{
    UIColor *color;
    if ([grade isEqualToString:@"A"]) {
        color = UIColorFromRGB(0x00b253);
    }
    else if([grade isEqualToString:@"B"]) {
        color = UIColorFromRGB(0x109bdc);
    }
    else if([grade isEqualToString:@"C"]) {
        color = UIColorFromRGB(0xff9000);
    }
    else
    {
        color = UIColorFromRGB(0xf05253);
    }
    _kiColors[index] = color;
}
- (void)addTimeslamp:(NSInteger)month year:(NSInteger)year type:(ChartType)type actionType:(ActionType)actionType
{
    NSInteger startAt;
    if(type == ChartType_Ki) {
        startAt = _kiDate.currentMonth > _barTotalInChart ? (_kiDate.currentMonth-_barTotalInChart+1) : 1;
    }
    else
    {
        startAt = _payDate.currentMonth > _barTotalInChart ? (_payDate.currentMonth-_barTotalInChart+1) : 1;
    }
    
    [self addTimeslamp:month startAt:startAt year:year type:type];
}
- (void)setPayDate:(InfoAndKiDateModel *)payDate
{
    _payDate = payDate;
}
- (void)initValues
{
    _kiDate = [[InfoAndKiDateModel alloc] initWith:[self getCurrentMonth] monthTotal:[self getCurrentMonth] currentYear:[self getCurrentYear]];
//    _payDate = [[InfoAndKiDateModel alloc] initWith:[self getCurrentMonth] monthTotal:[self getCurrentMonth] currentYear:[self getCurrentYear]];
    
    _barTotalInChart = 4;
    _dateStampIncome = [[NSMutableArray alloc] init];
    _dateStampScore = [[NSMutableArray alloc] init];
    _dateFormat = kAppNormalFormatDate;
    _kiColors = [NSMutableArray arrayWithArray:@[UIColorFromRGB(0xf05253), UIColorFromRGB(0xf05253), UIColorFromRGB(0xf05253), UIColorFromRGB(0xf05253)]];
    _payColors = [NSMutableArray arrayWithArray:@[UIColorFromRGB(0xff9000), UIColorFromRGB(0x6fddd2), UIColorFromRGB(0x109bdc)]];
    [self addTimeslamp:_payDate.currentMonth year:_payDate.currentYear type:ChartType_Income actionType:ActionType_Back];
    [self addTimeslamp:_kiDate.currentMonth year:_kiDate.currentYear type:ChartType_Ki actionType:ActionType_Back];
}
- (void)addTimeslamp:(NSInteger)month startAt:(NSInteger)startAt year:(NSInteger)year type:(ChartType)type
{
    if (type == ChartType_Income) {
        [_dateStampIncome removeAllObjects];
    }
    else
    {
        [_dateStampScore removeAllObjects];
    }
    
    NSString *firstDay = @"1";
    NSMutableArray *dateArray = [NSMutableArray new];
    for (NSInteger i = startAt; i <= month; i++) {
        NSString *dateString;
        if (i == month) {
            if (dateArray.count == 0) {
                dateString = [NSString stringWithFormat:@"%@/%ld/%ld", firstDay, (long)i, (long)year];
            }
            dateString = [NSString stringWithFormat:@"%ld/%ld/%ld", (long)[self getTotalDayOfMonth:i year:year], (long)i, (long)year];
        }
        else
        {
            dateString = [NSString stringWithFormat:@"%@/%ld/%ld", firstDay, (long)i, (long)year];
        }
        [dateArray addObject:[NSNumber numberWithDouble:[[dateString convertStringToDateWith:_dateFormat] timeIntervalSince1970]*1000]];
    }
    if (type == ChartType_Income) {
        _dateStampIncome = dateArray;
    }
    else
    {
        _dateStampScore = dateArray;
    }
}

- (NSInteger)getCurrentYear
{
    return [NSDate getCurrentYear];
}
- (NSInteger)getCurrentMonth
{
    return [NSDate getCurrentMonth];
}
- (NSInteger)getTotalDayOfMonth:(NSInteger)month year:(NSInteger)year
{
    return [NSDate getTotalDayOfMonth:month year:year];
}

- (NSString *)convertTimeStampToDateStr:(double)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    return [date stringWithFormat:@"MM/yyyy"];
}

+ (void)getKiInfo:(NSNumber *)employee_id fromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate completion:(CallbackInfoAndKi)completion
{
    
    if([Common checkNetworkAvaiable]){
        if (!employee_id || !fromDate || !toDate) {
            return;
        }
        NSDictionary *params = @{@"employee_id" : employee_id, @"from_date": [fromDate stringValue], @"to_date": [toDate stringValue]};
        [TTNSProcessor getTTNS_KI_THEO_IDEMPLOYEE:params callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (success) {
                NSArray *result = [[resultDict valueForKey:@"data"] valueForKey:@"entity"];
                completion(YES, result, exception, resultDict);
            }
            else
            {
                completion(NO, nil, exception, resultDict);
            }
        }];
    }
    else
    {
        completion(NO, nil, [NSException initWithNoNetWork], nil);
    }
    
}

+ (void)getSSO_Token:(NSString *)userName password:(NSString *)password completion:(CallbackInfoAndKi)completion
{
    if([Common checkNetworkAvaiable]){
        if (!userName || !password) {
            return;
        }
        NSDictionary *params = @{@"username" : userName, @"password" : password};
        [TTNSProcessor getSSO_Token:params callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (success) {
                NSString *access_token = [[[resultDict valueForKey:@"data"] valueForKey:@"data"] valueForKey:@"access_token"];
                [SOSessionManager sharedSession].ttnsSession.ssoToken = access_token;
                completion(YES, @[access_token], exception, resultDict);
            }
            else
            {
                completion(NO, nil, exception, resultDict);
            }
        }];
    }
    else
    {
        completion(NO, nil, [NSException initWithNoNetWork], nil);
    }
    
}


+ (void)getPayLatest:(CallbackInfoAndKi)completion
{
    if (![SOSessionManager sharedSession].ttnsSession.ssoToken || [[SOSessionManager sharedSession].ttnsSession.ssoToken isEqualToString:@""]) {
        //Tặm xử lý mỗi lần request sẽ get SSO token trước, sau sẽ bàn lại cách tối ưu.
        [self getSSO_Token:[GlobalObj getInstance].ttns_userName password:[GlobalObj getInstance].ttns_password completion:^(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error) {
            if (success) {
                [TTNS_InfoAndKiComtroller getPayLatest:completion];
            }
            else
            {
                completion(NO, nil, exception, error);
            }
            
        }];
    }
    else
    {
        if([Common checkNetworkAvaiable]){
            [TTNSProcessor getPayLatest:^(BOOL success, id resultDict, NSException *exception) {
                if (success) {
                    NSArray *result = [[resultDict valueForKey:@"data"] valueForKey:@"entity"];
                    completion(YES, result, exception, resultDict);
                }
                else
                {
                    if ([[resultDict valueForKey:@"resultCode"] integerValue] == 2001) {
                        [self getSSO_Token:[GlobalObj getInstance].ttns_userName password:[GlobalObj getInstance].ttns_password completion:^(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error) {
                            if (success) {
                                [TTNS_InfoAndKiComtroller getPayLatest:completion];
                            }
                            else
                            {
                                completion(NO, nil, exception, error);
                            }
                            
                        }];
                    }
                    else
                    {
                        completion(NO, nil, exception, resultDict);
                    }
                    
                }
            }];
        }
        else
        {
            completion(NO, nil, [NSException initWithNoNetWork], nil);
        }
    }
    
}

+ (void)getPay:(NSNumber *)fromDate toDate:(NSNumber *)toDate completion:(CallbackInfoAndKi)completion
{
    if (![SOSessionManager sharedSession].ttnsSession.ssoToken) {
        //Tặm xử lý mỗi lần request sẽ get SSO token trước, sau sẽ bàn lại cách tối ưu.
        [self getSSO_Token:[GlobalObj getInstance].ttns_userName password:[GlobalObj getInstance].ttns_password completion:^(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error) {
            if (success) {
                [TTNS_InfoAndKiComtroller getPay:fromDate toDate:toDate completion:completion];
            }
            else
            {
                completion(NO, nil, exception, error);
            }
            
        }];
    }
    else
    {
        if([Common checkNetworkAvaiable]){
            if (fromDate == nil || toDate == nil) {
                return;
            }
            NSDictionary *params = @{@"from_date" : fromDate, @"to_date" : toDate};
            [TTNSProcessor getPay:params callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
                if (success) {
                    NSArray *result = [[resultDict valueForKey:@"data"] valueForKey:@"entity"];
                    completion(YES, result, exception, resultDict);
                }
                else
                {
                    if ([[resultDict valueForKey:@"resultCode"] integerValue] == 2001) {
                        [self getSSO_Token:[GlobalObj getInstance].ttns_userName password:[GlobalObj getInstance].ttns_password completion:^(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error) {
                            if (success) {
                                [TTNS_InfoAndKiComtroller getPay:fromDate toDate:toDate completion:completion];
                            }
                            else
                            {
                                completion(NO, nil, exception, error);
                            }
                            
                        }];
                    }
                    else
                    {
                        completion(NO, nil, exception, resultDict);
                    }
                    
                }
            }];
        }
        else
        {
            completion(NO, nil, [NSException initWithNoNetWork], nil);
        }
    }
    
}

+ (double)getTotalWithItems:(NSArray *)items type:(IncomeType)type date:(NSNumber *)date
{
    
    double total = 0;
    NSDate *dateToCheck = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]/1000];
    if (items == nil || items.count == 0) {
        return total;
    }
    for(TTNS_PayInfoModel* payModel in items)
    {
        NSDate *modelDate = [NSDate dateWithTimeIntervalSince1970:[payModel.salaryDate doubleValue]/1000];
        if ([dateToCheck compareSameMonthAndYearWithOtherDay:modelDate] != 2 && payModel.incomeType == type) {
            total = [payModel.realIncome doubleValue]/1000000 + total;
        }
        
    }
    return total;
}

+ (double)getTotalWithItems:(NSArray *)items type:(IncomeType)type
{
    
    double total = 0;
    if (items == nil || items.count == 0) {
        return total;
    }
    for(TTNS_PayInfoModel* payModel in items)
    {
        if (payModel.incomeType == type) {
            total = [payModel.realIncome doubleValue]/1000000 + total;
        }
        
    }
    return total;
}
@end
