//
//  TTNS_InfoAndKiComtroller.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/30/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InfoAndKiDateModel.h"
typedef enum : NSUInteger {
    IncomeType_Period = 1, //Lương theo giai đoạn
    IncomeType_SXKD,	//Lương SXKD
    IncomeType_Other,// Thu nhập khác
} IncomeType;
typedef enum {
    ChartType_Income = 0,
    ChartType_Ki
} ChartType;
typedef enum {
    ActionType_Next = 0,
    ActionType_Back
} ActionType;
@interface TTNS_InfoAndKiComtroller : NSObject
typedef void (^CallbackInfoAndKi)(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error);
- (void)initValues;
+ (void)getKiInfo:(NSNumber *)employee_id fromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate completion:(CallbackInfoAndKi)completion;

+ (void)getSSO_Token:(NSString *)userName password:(NSString *)password completion:(CallbackInfoAndKi)completion;

+ (void)getPay:(NSNumber *)fromDate toDate:(NSNumber *)toDate completion:(CallbackInfoAndKi)completion;
+ (void)getPayLatest:(CallbackInfoAndKi)completion;
+ (double)getTotalWithItems:(NSArray *)items type:(IncomeType)type date:(NSNumber *)date;
+ (double)getTotalWithItems:(NSArray *)items type:(IncomeType)type;
- (void)addTimeslamp:(NSInteger)month year:(NSInteger)year type:(ChartType)type actionType:(ActionType)actionType;
- (NSInteger)getCurrentYear;
- (NSInteger)getCurrentMonth;
- (NSString *)convertTimeStampToDateStr:(double)timestamp;
- (void)addColorWithGrade:(NSString *)grade at:(NSInteger)index;

- (NSArray *)getDateScore;
- (NSArray *)getDateIncome;

- (NSArray *)getScoreColors;
- (NSArray *)getIncomeColors;

- (InfoAndKiDateModel *)getKiDate;
- (InfoAndKiDateModel *)getIncomeDate;
- (NSInteger)getTotalBarInChart;

- (void)setPayDate:(InfoAndKiDateModel *)payDate;
//- (InfoAndKiDateModel *)checkBack:(ChartType)chartType currentMonth:(NSInteger)currentMonth monthTotal:(NSInteger)monthTotal currentYear:(NSInteger)currentYear;
//- (InfoAndKiDateModel *)checkNext:(ChartType)chartType currentMonth:(NSInteger)currentMonth monthTotal:(NSInteger)monthTotal currentYear:(NSInteger)currentYear;
- (void)updateKiDate:(ActionType)actionType chartType:(ChartType)chartType;
- (void)updateIncomeDate:(ActionType)actionType chartType:(ChartType)chartType;
- (BOOL)checkAvailableYear:(ActionType)type chartType:(ChartType)chartType;
@end
