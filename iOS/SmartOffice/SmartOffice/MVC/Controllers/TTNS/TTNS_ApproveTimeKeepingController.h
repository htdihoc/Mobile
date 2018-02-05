//
//  TTNS_ApproveTimeKeepingController.h
//  SmartOffice
//
//  Created by Nguyen Van Tu on 9/22/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^CallbackLoadListEmployee)(BOOL success, NSArray *resultArray, NSException *exception, BOOL isConnectNetwork, NSDictionary *error);
typedef void (^CallbackLoadEmployeeDetail)(BOOL success, NSDictionary *emloyeeDetail, NSException *exception, BOOL isConnectNetwork, NSDictionary *error);
@interface TTNS_ApproveTimeKeepingController : NSObject
typedef void (^CallbackGetListEmployeeID)(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error);

+ (void)loadListEmployeeByManagerID:(NSNumber *)managerID fromTime:(NSNumber *)fromTime endTime:(NSNumber *)endTime status:(NSNumber *)status completion:(CallbackLoadListEmployee)completion;

+ (void)loadDetailEmployee:(NSString *)employeeID completion:(CallbackLoadEmployeeDetail)completion;


@end
