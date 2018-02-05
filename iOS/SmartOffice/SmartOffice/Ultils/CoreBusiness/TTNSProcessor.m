//
//  TTNSProcessor.m
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 4/10/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNSProcessor.h"
#import "THService.h"
#import "SOSessionManager.h"

#define TTNS_GET_ACCESS_TOKEN_API               @"ttns/get-access-token"

#define TTNS_SO_NGAY_PHEP_CON_LAI               @"/remaining-annual"
#define TTNS_HUY_DON_NGHI_PHEP_URL              @"/compassionate-leave/"
#define TTNS_DANH_SACH_DON_NGHI_PHEP_URL        @"/compassionate-leave"
#define TTNS_CHI_TIET_DON_NGHI_PHEP_URL         @"ttns/compassionate-leave"
#define TTNS_TRINH_KY                           @"/compassionate-leave/sign"
#define TTNS_REGISTER_OR_UPDATE                 @"/compassionate-leave"

#define TTNS_APPROVE_REGISTER_IN_OUT            @"ttns-inout/register/inout/update"
#define TTNS_DELETE_REGISTER_IN_OUT_BY_ID       @"ttns-inout/register/inout/delete/"
#define TTNS_GET_LIST_REGISTER_IN_OUT           @"ttns-inout/register/inout"
#define TTNS_GET_LIST_WORK_PLACE                @"ttns-inout/register/inout/workplace"
#define TTNS_GET_REASON_OUT_BY_ID               @"ttns-inout/register/inout/reason/"
#define TTNS_GET_LIST_REGISTER_WITH_ID          @"/ttns-inout/register/inout/"
#define TTNS_GET_WORK_PLACE_BY_ID               @"ttns-inout/register/inout/workplace/"
#define TTNS_REGISTER_IN_OUT                    @"ttns-inout/register/inout"
#define TTNS_APPROVED                           @"ttns-inout/register/inout/approved/"
#define TTNS_GET_LIST_REGISTER_WITH_EFFECT      @"/ttns-inout/register/inout/employee/effective"
#define TTNS_REASON                             @"ttns-inout/register/inout/reason"

#define TTNS_GET_LIST_TIMEKEEPING_BY_IDEMPLOYEE @"ttns-timekeeping/timeKeeping/employee"
#define TTNS_TIMEKEEPING_PRIVATEKEY             @"ttns-timekeeping/timeKeeping/mobile-integrated"
#define TTNS_DELETE_TIMEKEEPING                 @"ttns-timekeeping/timeKeeping/employee/delete"
#define TTNS_UPDATE_TIMEKEEPING                 @"ttns-timekeeping/timeKeeping/employee/update"
#define TTNS_UPDATE_TIMEKEEPING_RANGE           @"ttns-timekeeping/timeKeeping/employee/approve/update"
#define TTNS_LIST_EMPLOYEE_BY_MANAGER_ID        @"ttns-timekeeping/timeKeeping/manager/employee/approve"
#define TTNS_EMPLOYEE_INFO                      @"ttns/employee/"


#define TTNS_ATTACH_FILE                        @"/attach-file"
#define TTNS_SALARY_PROCESS                     @"/salary-process"

#define TTNS_GET_KI_INFO                        @"/ttns/employee/ki"
#define TTNS_GET_SSO_TOKEN                      @"/ttns/get-sso-token"
#define TTNS_GET_PAY                            @"/ttns/my/salary/payslip"
#define TTNS_GET_PAY_LATEST                     @"/ttns/my/salary/latest"

#define TTNS_CHECK_POINT                        @"/ttns/employee-daily"

#define TTNS_GET_POSITION_NAME                  @"/work-process/latest"
#define TTNS_GET_LIST_MANAGER                   @"/ttns/organization/list-manager"
@implementation TTNSProcessor

+ (void)getAccessTokenTTNSWithComplete:(Callback)callBack{
    
    //    NSDictionary *params = @{@"username" : [GlobalObj getInstance].username, @"passwork": [GlobalObj getInstance].password};
    //
    [THService requestGETFromUrl:[[GlobalObj getInstance] getApiFullUrl:TTNS_GET_ACCESS_TOKEN_API] parameter:nil withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}

+ (void)getPrivateTTNSWithComplete:(NSNumber *)employeeID uuid:(NSString *)uuid callBack:(Callback)callBack{
    
    if ([SOSessionManager sharedSession].ttnsSession.accessToken) {
        if (![SOSessionManager sharedSession].ttnsSession.accessToken || !employeeID || !uuid) {
            return;
        }
        NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
        NSDictionary *params = @{@"employee_id": employeeID, @"uuid" : uuid};
        [THService requestGETFromUrl:[[GlobalObj getInstance] getApiFullUrl:TTNS_TIMEKEEPING_PRIVATEKEY] withToken:token parameter:params withProgress:nil completion:^(NSDictionary *response) {
            callBack(YES, response, nil);
        } onError:^(NSDictionary *error) {
            callBack(NO, error, nil);
        } onException:^(NSException *exception) {
            callBack(NO, nil, exception);
        }];
    }
    else
    {
        [self getAccessTokenTTNSWithComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if(success){
                DLog(@"Get access token success");
                NSString *accessToken = resultDict[@"data"][@"data"][@"access_token"];
                [SOSessionManager sharedSession].ttnsSession.accessToken = accessToken;
                [[SOSessionManager sharedSession]saveData];
            }
        }];
    }
}
+ (void)getRemainingAnnual:(NSNumber*)employeeId callBack:(Callback)callBack{
    
    NSString *url = [NSString stringWithFormat:@"ttns/%@%@", employeeId, TTNS_SO_NGAY_PHEP_CON_LAI];
    NSString *urlRequest = [[GlobalObj getInstance]getApiFullUrl:url];
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    
    [THService requestGETFromUrl:urlRequest withToken:token parameter:nil withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}


+ (void)postTTNS_HUY_DON_NGHI_PHEP:(NSInteger)iD parameters:(NSDictionary *)parameters withProgress:(void (^)(float))progressBlock completion:(void (^)(NSDictionary *))completionBlock onError:(void (^)(NSDictionary *))errorBlock onException:(void (^)(NSException *))exceptionBlock{
    
    NSString *_url = [NSString stringWithFormat:@"ttns/%ld%@", (long)iD, TTNS_HUY_DON_NGHI_PHEP_URL];
    NSString *urlRequest = [[GlobalObj getInstance]getApiFullUrl:_url];
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    
    [THService requestPOSTFromUrl:urlRequest withToken:token parameter:parameters withProgress:nil completion:^(NSDictionary *response) {
        DLog(@"completion");
        
        if(completionBlock){
            completionBlock(response);
        }
    } onError:^(NSDictionary *error) {
        DLog(@"onError: %@", error);
        if (errorBlock) {
            errorBlock(error);
        }
    } onException:^(NSException *exception) {
        DLog(@"onException: %@", exception.description);
        if (exceptionBlock) {
            exceptionBlock(exception);
        }
    }];
}

+ (void)getTTNS_DANH_SACH_DON_NGHI_PHEP:(NSNumber*)iD type:(NSInteger)type callBack:(Callback)callBack{
    
    /*
     *  iD      : id of employee
     *  type    : 0 = ALL, 1 = xin nghi phep ...
     */
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    NSString *url = [NSString stringWithFormat:@"ttns/%@%@?type=%ld", iD, TTNS_DANH_SACH_DON_NGHI_PHEP_URL, (long)type];
    NSString *urlRequest = [[GlobalObj getInstance]getApiFullUrl:url];
    
    [THService requestGETFromUrl:urlRequest withToken:token parameter:nil withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}

+ (void)getTTNS_CHI_TIET_DON_NGHI_PHEP:(NSInteger)personalFormId callBack:(Callback)callBack{
    
    NSString *urlString = [[GlobalObj getInstance] getApiFullUrl:TTNS_CHI_TIET_DON_NGHI_PHEP_URL];
    NSString *fullURL = [NSString stringWithFormat:@"%@?personalFormId=%ld", urlString, (long)personalFormId];
    
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    
    [THService requestGETFromUrl:fullURL withToken:token parameter:nil withProgress:nil completion:^(NSDictionary *response) {
        DLog(@"completion");
        callBack(YES, response, nil);
        
    } onError:^(NSDictionary *error) {
        DLog(@"onError: %@", error);
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        DLog(@"onException: %@", exception.description);
        callBack(NO, nil, exception);
    }];
}

+ (void)getCompassionateLeaveWithType:(NSInteger)type callBack:(Callback)callBack{
    
    NSString *urlString = [[GlobalObj getInstance] getApiFullUrl:TTNS_CHI_TIET_DON_NGHI_PHEP_URL];
    NSString *fullURL = [NSString stringWithFormat:@"%@?type=%ld", urlString, (long)type];
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    
    [THService requestGETFromUrl:fullURL withToken:token parameter:nil withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
        
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}

+ (void)postCompassionateLeaveSign:(NSInteger)personalFormId type:(NSInteger)type callBack:(Callback)callBack{
    // trinh ky dang ky nghi cua nhan vien
    NSString *url = [NSString stringWithFormat:@"ttns/%ld%@", (long)personalFormId, TTNS_DANH_SACH_DON_NGHI_PHEP_URL];
    NSString *urlRequest = [[GlobalObj getInstance]getApiFullUrl:url];
    if (!type || ![SOSessionManager sharedSession].ttnsSession.accessToken) {
        return;
    }
    NSDictionary *params = @{@"type":@(type)};
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    
    [THService requestPOSTFromUrl:urlRequest withToken:token parameter:params withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
    
}

//+ (void)postRegisterOrUpdateLeave:(NSInteger)type iD:(NSInteger)iD from_date:(NSInteger)from_date to_date:(NSInteger)to_date reason:(NSString *)reason type_resign:(NSString *)type_resign callBack:(Callback)callBack{
//    // dang ky/update cua nhan vien
//    NSString *url = [NSString stringWithFormat:@"ttns/%ld%@", (long)iD, TTNS_REGISTER_OR_UPDATE];
//    NSString *urlRequest = [[GlobalObj getInstance]getApiFullUrl:url];
//    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
//    NSDictionary *params = @{@"type" : @(type),
//                             @"id":@(iD),
//                             @"from_date":@(from_date),
//                             @"to_date":@(to_date),
//                             @"reason":reason,
//                             @"type_resign":type_resign};
//    
//    [THService requestPOSTFromUrl:urlRequest withToken:token parameter:params withProgress:nil completion:^(NSDictionary *response) {
//        callBack(YES, response, nil);
//    } onError:^(NSDictionary *error) {
//        callBack(NO, error, nil);
//    } onException:^(NSException *exception) {
//        callBack(NO, nil, exception);
//    }];
//}

+ (void)postRegisterOrUpdateLeave:(NSDictionary*)params personalFormId:(NSInteger)personalFormId callBack:(Callback)callBack{
    NSString *url = [NSString stringWithFormat:@"ttns/%ld%@", (long)personalFormId, TTNS_REGISTER_OR_UPDATE];
    NSString *urlRequest = [[GlobalObj getInstance]getApiFullUrl:url];
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    
    [THService requestPOSTFromUrl:urlRequest withToken:token parameter:params withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}

#pragma mark ttns register in out

// approve register in out

+ (void)postApproveRegisterInOut:(NSDictionary *)params callBack:(Callback)callBack{
    NSString *urlRequest = [[GlobalObj getInstance]getApiFullUrl:TTNS_APPROVE_REGISTER_IN_OUT];
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    
    [THService requestPOSTFromUrl:urlRequest withToken:token parameter:params withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}

//delete register in out by id

+(void)postDeleteRegisterWithPersonalFormId:(NSInteger)personalFormId callBack:(Callback)callBack{
    NSString *urlString = [NSString stringWithFormat:@"%@%ld", TTNS_DELETE_REGISTER_IN_OUT_BY_ID, (long)personalFormId];
    NSString *urlRequest = [[GlobalObj getInstance]getApiFullUrl:urlString];
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    
    [THService requestPOSTFromUrl:urlRequest withToken:token parameter:nil withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}

// getlist register in out

+ (void)getListRegisterInOut:(NSDictionary*)parameters callBack:(Callback)callBack{
    NSString *urlRequest = [[GlobalObj getInstance]getApiFullUrl:TTNS_GET_LIST_REGISTER_IN_OUT];
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    
    [THService requestGETFromUrl:urlRequest withToken:token parameter:nil withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
    
}

// Get list work place
+ (void)getListWorkPlaceWithType:(NSString*)type callBack:(Callback)callBack{
    if (!type || ![SOSessionManager sharedSession].ttnsSession.accessToken) {
        return;
    }
    NSDictionary *params = @{
                             @"type" : type
                             };
    NSString *urlRequest = [[GlobalObj getInstance] getApiFullUrl:TTNS_GET_LIST_WORK_PLACE];
    NSDictionary *token = @{@"TTNS-TOKEN" : [SOSessionManager sharedSession].ttnsSession.accessToken};
    
    [THService requestGETFromUrl:urlRequest withToken:token parameter:params withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}



// Get list reason

+ (void)getListReason:(Callback)callBack{
    NSDictionary *token = @{@"TTNS-TOKEN" : [SOSessionManager sharedSession].ttnsSession.accessToken};
    NSString *urlRequest = [[GlobalObj getInstance] getApiFullUrl:TTNS_REASON];
    [THService requestGETFromUrl:urlRequest withToken:token parameter:nil withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}

// get reason out by id

+ (void)getReasonWithId:(NSInteger)reasonId callBack:(Callback)callBack{
    NSString *urlString = [NSString stringWithFormat:@"%@%ld", TTNS_GET_REASON_OUT_BY_ID, (long)reasonId];
    NSString *urlRequest = [[GlobalObj getInstance]getApiFullUrl:urlString];
    NSDictionary *token = @{@"TTNS-TOKEN" : [SOSessionManager sharedSession].ttnsSession.accessToken};
    
    [THService requestGETFromUrl:urlRequest withToken:token parameter:nil withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}


// get register in out by id
// Lay danh sach dang ky ra ngoai theo ID
+ (void)getListRegisterWithId:(NSInteger)empOutRegId callBack:(Callback)callBack{
    NSString *url = [NSString stringWithFormat:@"%@%ld", TTNS_GET_LIST_REGISTER_WITH_ID, (long)empOutRegId];
    NSString *urlRequest = [[GlobalObj getInstance]getApiFullUrl:url];
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    
    [THService requestGETFromUrl:urlRequest withToken:token parameter:nil withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}

// get workplace with id

+ (void)getWorkPlaceWithID:(NSInteger)ID callBack:(Callback)callBack{
    NSString *url = [NSString stringWithFormat:@"%@%ld", TTNS_GET_WORK_PLACE_BY_ID, (long)ID];
    NSString *urlRequest = [[GlobalObj getInstance]getApiFullUrl:url];
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    
    [THService requestGETFromUrl:urlRequest withToken:token parameter:nil withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}


// approved




// attach-file
+ (void)getAttachFile:(NSNumber *)employeeId callBack:(Callback)callBack {
    NSString *url = [NSString stringWithFormat:@"ttns/%@%@", employeeId, TTNS_ATTACH_FILE];
    NSString *urlRequest = [[GlobalObj getInstance] getApiFullUrl:url];
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    
    [THService requestGETFromUrl:urlRequest withToken:token parameter:nil withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exeption) {
        callBack(NO, nil, exeption);
    }];
}

// salary-process
+ (void)getSalaryProcess:(NSNumber *)employeeId callBack:(Callback)callBack {
    NSString *url = [NSString stringWithFormat:@"ttns/%@%@", employeeId, TTNS_SALARY_PROCESS];
    NSString *urlRequest = [[GlobalObj getInstance] getApiFullUrl:url];
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    
    [THService requestGETFromUrl:urlRequest withToken:token parameter:nil withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exeption) {
        callBack(NO, nil, exeption);
    }];
    
}

// register in out

+ (void)postRegisterInOut:(NSDictionary*)params callBack:(Callback)callBack{
    NSString *urlRequest = [[GlobalObj getInstance]getApiFullUrl:TTNS_REGISTER_IN_OUT];
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    
    [THService requestPOSTFromUrl:urlRequest withToken:token parameter:params withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}

//approved



//get list in out reg of

// employee id effective

+ (void)getListInOutRegWithIdEffective:(NSNumber*)Id paramaters:(NSDictionary *)params callBack:(Callback)callBack{
    NSString *url = [NSString stringWithFormat:@"%@/%@", TTNS_GET_LIST_REGISTER_WITH_EFFECT, Id];
    NSString *urlRequest = [[GlobalObj getInstance]getApiFullUrl:url];
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    
    [THService requestGETFromUrl:urlRequest withToken:token parameter:params withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}

// reason


#pragma TTNS_TimeKeeping
+ (void)getTTNS_DANH_CHAM_CONG_THEO_IDEMPLOYEE:(NSDictionary *)params callBack:(Callback)callBack
{
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    [THService requestGETFromUrl:[[GlobalObj getInstance] getApiFullUrl:TTNS_GET_LIST_TIMEKEEPING_BY_IDEMPLOYEE] withToken:token parameter:params withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}

+ (void)getListEmployeeByManagerID:(NSString *)managerID params:(NSDictionary *)params callBack:(Callback)callBack
{
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    [THService requestGETFromUrl:[NSString stringWithFormat:@"%@/%@", [[GlobalObj getInstance] getApiFullUrl:TTNS_LIST_EMPLOYEE_BY_MANAGER_ID], managerID] withToken:token parameter:params withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}

+ (void)postTTNS_TimeKeeping_ForEmployee:(NSDictionary *)params callBack:(Callback)callBack
{
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    [THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:TTNS_GET_LIST_TIMEKEEPING_BY_IDEMPLOYEE] withToken:token parameter:params withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}

+ (void)postTTNS_Delete_TimeKeeping:(NSDictionary *)params callBack:(Callback)callBack
{
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    [THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:TTNS_DELETE_TIMEKEEPING] withToken:token parameter:params withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}

+ (void)postTTNS_Update_TimeKeeping:(NSDictionary *)params callBack:(Callback)callBack
{
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    [THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:TTNS_UPDATE_TIMEKEEPING] withToken:token parameter:params withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}
+ (void)postTTNS_Update_TimeKeepingRange:(NSDictionary *)params callBack:(Callback)callBack
{
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    [THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:TTNS_UPDATE_TIMEKEEPING_RANGE] withToken:token parameter:params withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}
#pragma mark TTNS_Ki_Salary
+ (void)getTTNS_KI_THEO_IDEMPLOYEE:(NSDictionary *)params callBack:(Callback)callBack
{
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    [THService requestGETFromUrl:[[GlobalObj getInstance] getApiFullUrl:TTNS_GET_KI_INFO] withToken:token parameter:params withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}
+ (void)getSSO_Token:(NSDictionary *)params callBack:(Callback)callBack
{
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    
    
    [THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:TTNS_GET_SSO_TOKEN] withToken:token parameter:params withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}
+ (void)getPay:(NSDictionary *)params callBack:(Callback)callBack
{
    NSDictionary *ssoToken = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.ssoToken};
    [THService requestGETFromUrl:[[GlobalObj getInstance] getApiFullUrl:TTNS_GET_PAY] withToken:ssoToken parameter:params withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}

+ (void)getPayLatest:(Callback)callBack
{
    NSDictionary *ssoToken = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.ssoToken};
    [THService requestGETFromUrl:[[GlobalObj getInstance] getApiFullUrl:TTNS_GET_PAY_LATEST] withToken:ssoToken parameter:nil withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}

+ (void)getTTNS_EmloyeeDetail:(NSString *)employeeID callBack:(Callback)callBack
{
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    [THService requestGETFromUrl:[NSString stringWithFormat:@"%@/%@", [[GlobalObj getInstance] getApiFullUrl:TTNS_EMPLOYEE_INFO], employeeID] withToken:token parameter:nil withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}

+ (void)getTTNS_CheckPoint:(NSDictionary *)params callBack:(Callback)callBack
{
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    [THService requestGETFromUrl:[[GlobalObj getInstance] getApiFullUrl:TTNS_CHECK_POINT] withToken:token parameter:params withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}
+ (void)getTTNS_PositionName:(NSString *)employeeID callBack:(Callback)callBack
{
    NSString *url = [NSString stringWithFormat:@"/ttns/%@%@", employeeID, TTNS_GET_POSITION_NAME];
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.accessToken};
    [THService requestGETFromUrl:[[GlobalObj getInstance] getApiFullUrl:url] withToken:token parameter:nil withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}

#pragma mark Manager
+ (void)getListManager:(Callback)callBack;
{
    NSDictionary *token = @{@"TTNS-TOKEN":[SOSessionManager sharedSession].ttnsSession.ssoToken};
    [THService requestGETFromUrl:[[GlobalObj getInstance] getApiFullUrl:TTNS_GET_LIST_MANAGER] withToken:token parameter:nil withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}
@end
