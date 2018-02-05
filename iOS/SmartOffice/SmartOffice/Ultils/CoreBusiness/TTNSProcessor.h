//
//  TTNSProcessor.h
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 4/10/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTNSProcessor : NSObject

// AccessToken TTNS
+ (void)getAccessTokenTTNSWithComplete:(Callback)callBack;

//Get private Key
+ (void)getPrivateTTNSWithComplete:(NSNumber *)employeeID uuid:(NSString *)uuid callBack:(Callback)callBack;

// (GET) Lay so ngay phep con lai cua nhan vien

+ (void)getRemainingAnnual:(NSNumber*)employeeId callBack:(Callback)callBack;

// Post huy don nghi phep
+ (void)postTTNS_HUY_DON_NGHI_PHEP:(NSInteger)iD parameters:(NSDictionary *)parameters withProgress:(void (^)(float progress))progressBlock completion:(void (^)(NSDictionary *response))completionBlock onError:(void (^)(NSDictionary *error))errorBlock onException:(void (^)(NSException *exception))exceptionBlock;

// Get danh sách đơn nghỉ phép theo ID của nhân viên
+ (void)getTTNS_DANH_SACH_DON_NGHI_PHEP:(NSNumber*)iD type:(NSInteger)type callBack:(Callback)callBack;

// Get danh sách đơn nghỉ phép theo personalFormId ( chi tiết đơn)
+ (void)getTTNS_CHI_TIET_DON_NGHI_PHEP:(NSInteger)personalFormId callBack:(Callback)callBack;

// Get danh sách đơn nghỉ phep theo type
+ (void)getCompassionateLeaveWithType:(NSInteger)type callBack:(Callback)callBack;

// Trình ký đăng ký ngỉ (Post)
+ (void) postCompassionateLeaveSign:(NSInteger)personalFormId type:(NSInteger)type callBack:(Callback)callBack;

// Đăng ký/update nghỉ của nhân viên
+ (void)postRegisterOrUpdateLeave:(NSDictionary*)params personalFormId:(NSInteger)personalFormId callBack:(Callback)callBack;

#pragma mark TTNS_RegisterInOut
// approve register in out
+ (void)postApproveRegisterInOut:(NSDictionary*)params callBack:(Callback)callBack;

// delete reigster in out by id

+(void)postDeleteRegisterWithPersonalFormId:(NSInteger)personalFormId callBack:(Callback)callBack;

//get Register With ID
+ (void)getListRegisterWithId:(NSInteger)empOutRegId callBack:(Callback)callBack;

// get list register in out

+ (void)getListRegisterInOut:(NSDictionary*)parameters callBack:(Callback)callBack;

//+ (void)postListRegisterInOut:(NSString*)type sync_time:(NSInteger)sync_time callBack:(Callback)callBack;

// get list work place
+ (void)getListWorkPlaceWithType:(NSString*)type callBack:(Callback)callBack;

// get reason out by id

+ (void)getReasonWithId:(NSInteger)reasonId callBack:(Callback)callBack;

//get register in out by id

// get work place by id
+ (void)getWorkPlaceWithID:(NSInteger)ID callBack:(Callback)callBack;

// register in out

+ (void)postRegisterInOut:(NSDictionary*)params callBack:(Callback)callBack;

//approved

//get list in out reg of

// employee id effective

+ (void)getListInOutRegWithIdEffective:(NSNumber*)Id paramaters:(NSDictionary*)params callBack:(Callback)callBack;

//reason
+ (void)getListReason:(Callback)callBack;

// get attach file (danh sách hồ sơ đính kèm)
+ (void)getAttachFile:(NSNumber *)employeeId callBack:(Callback)callBack;

// get salary process (diễn biến lương, chức danh)
+ (void)getSalaryProcess:(NSNumber *)employeeId callBack:(Callback)callBack;

#pragma mark TTNS_TimeKeeping
// Get danh sach chấm công với IDEmployee và Người quản lý
+ (void)getTTNS_DANH_CHAM_CONG_THEO_IDEMPLOYEE:(NSDictionary *)params callBack:(Callback)callBack;

+ (void)getListEmployeeByManagerID:(NSString *)managerID params:(NSDictionary *)params callBack:(Callback)callBack;

+ (void)postTTNS_TimeKeeping_ForEmployee:(NSDictionary *)params callBack:(Callback)callBack;

+ (void)postTTNS_Delete_TimeKeeping:(NSDictionary *)params callBack:(Callback)callBack;

+ (void)postTTNS_Update_TimeKeeping:(NSDictionary *)params callBack:(Callback)callBack;

+ (void)postTTNS_Update_TimeKeepingRange:(NSDictionary *)params callBack:(Callback)callBack;


#pragma mark TTNS_Ki_Salary
+ (void)getTTNS_KI_THEO_IDEMPLOYEE:(NSDictionary *)params callBack:(Callback)callBack;
+ (void)getSSO_Token:(NSDictionary *)params callBack:(Callback)callBack;
+ (void)getPay:(NSDictionary *)params callBack:(Callback)callBack;
+ (void)getPayLatest:(Callback)callBack;
#pragma mark TTNS_EmloyeeInfo
+ (void)getTTNS_EmloyeeDetail:(NSString *)employeeID callBack:(Callback)callBack;

#pragma mark TTNS_CheckPoint
+ (void)getTTNS_CheckPoint:(NSDictionary *)params callBack:(Callback)callBack;

+ (void)getTTNS_PositionName:(NSString *)employeeID callBack:(Callback)callBack;

#pragma mark Manager
+ (void)getListManager:(Callback)callBack;
@end
