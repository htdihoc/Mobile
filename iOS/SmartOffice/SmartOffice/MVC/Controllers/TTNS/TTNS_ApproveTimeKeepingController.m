//
//  TTNS_ApproveTimeKeepingController.m
//  SmartOffice
//
//  Created by Nguyen Van Tu on 9/22/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_ApproveTimeKeepingController.h"
#import "Common.h"
#import "TTNSProcessor.h"
#import "NSException+Custom.h"
#import "TTNS_EmployeeTimeKeeping.h"
@implementation TTNS_ApproveTimeKeepingController


+ (void)loadListEmployeeByManagerID:(NSNumber *)managerID fromTime:(NSNumber *)fromTime endTime:(NSNumber *)endTime status:(NSNumber *)status completion:(CallbackLoadListEmployee)completion
{
    if([Common checkNetworkAvaiable]){
        if (managerID == nil) {
            return;
        }
        NSDictionary *params = @{@"from_time": fromTime, @"end_time" : endTime, @"status": status};
        [TTNSProcessor getListEmployeeByManagerID:[managerID stringValue] params:params callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (success) {
                NSArray *modelResult = [[resultDict valueForKey:@"data"] valueForKey:@"entity"];
                completion(success, modelResult, exception, YES, resultDict);
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
+ (void)loadDetailEmployee:(NSString *)employeeID completion:(CallbackLoadEmployeeDetail)completion
{
    if([Common checkNetworkAvaiable]){
        if (employeeID == nil) {
            return;
        }
        [TTNSProcessor getTTNS_EmloyeeDetail:employeeID callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (success) {
                completion(success, [resultDict valueForKey:@"data"], exception, YES, resultDict);
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
@end
