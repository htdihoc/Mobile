//
//  GlobalObj.m
//  SpeedTest
//
//  Created by Nguyen Thanh Huy on 7/3/16.
//  Copyright © 2016 Nguyen Thanh Huy. All rights reserved.
//

#import "GlobalObj.h"

@implementation GlobalObj

@synthesize userSession;

static GlobalObj *sharedInstance = nil;

+ (GlobalObj *)getInstance
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[GlobalObj alloc] init];
        }
    }
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self globalObjInit];
    }
    return self;
}

- (void)globalObjInit {
    self.urlRootApi = URL_SERVICE_ROOT;
    userSession = [[NSString alloc] init];
	_username = @"010993"; // - 196232 - 204965
	_password = @"222222a@"; //196232/222222a@ - 010993
	//NV:         102856/123456a@  41652
	//Quản lý: 099813/123456a@					40833
    
    
    _ttns_employID = @51655;
    _ttns_managerID = @41387;
    _ttns_organizationId = @148871;
    _ttns_uid = @"112";
    
    _ttns_userName = @"123008";
    _ttns_password = @"1qazXSW@1";
    
    _qltt_employID = @199917;
    _qltt_commentEmployID =  @"204965";
    _qltt_employeeCode = @199917;
    _ttns_timeKeepingSourceData = @"API_TIMEKEEPING";
}
- (void)updateEmployeeDetail
{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *employeeID = [f numberFromString:_employee.employeeId];
    _ttns_employID = employeeID;
    _ttns_managerID = employeeID;
    _ttns_organizationId = _employee.organizationId;
}
- (void)setUserSession:(NSString *)valueUserSession
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setObject:valueUserSession forKey:@"userSession"];
        [standardUserDefaults synchronize];
    }
}

- (NSString *)userSession
{
    NSString *valueUserSession = [[NSUserDefaults standardUserDefaults] stringForKey:@"userSession"];
    return valueUserSession == NULL ? @"" : valueUserSession;
}

#pragma makr - Get full url

- (NSString *)getApiFullUrl:(NSString *)iApiName {
    return [NSString stringWithFormat:@"%@%@", self.urlRootApi, iApiName];
}

@end
