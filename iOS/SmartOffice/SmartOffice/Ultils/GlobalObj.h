//
//  GlobalObj.h
//  SpeedTest
//
//  Created by Nguyen Thanh Huy on 7/3/16.
//  Copyright © 2016 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTNS_EmployeeTimeKeeping.h"
@interface GlobalObj : NSObject

+ (GlobalObj *)getInstance;

@property (strong, nonatomic) NSString *urlRootApi;

@property (strong, nonatomic) NSString *userSession;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSNumber *ttns_employID;
@property (strong, nonatomic) NSNumber *ttns_managerID;
@property (strong, nonatomic) NSNumber *ttns_organizationId;
@property (strong, nonatomic) NSString *ttns_uid;
@property (strong, nonatomic) NSString *ttns_userName;
@property (strong, nonatomic) NSString *ttns_password;
@property (strong, nonatomic) NSNumber *qltt_employID;
@property (strong, nonatomic) NSString *qltt_commentEmployID;
@property (strong, nonatomic) NSNumber *qltt_employeeCode;
@property (strong, nonatomic) NSString *ttns_timeKeepingSourceData;

@property (strong, nonatomic) TTNS_EmployeeTimeKeeping* employee;
//api
- (NSString *)getApiFullUrl:(NSString *)iApiName;
- (void)updateEmployeeDetail;
@end
