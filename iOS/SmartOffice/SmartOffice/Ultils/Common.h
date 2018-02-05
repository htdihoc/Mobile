//
//  Common.h
//  SpeedTest
//
//  Created by Nguyen Thanh Huy on 7/10/16.
//  Copyright © 2016 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kAppNormalFormatDate	@"dd/MM/yyyy"
#define kAppFullFormatDate		@"EEEE (dd/MM/yyyy)"
#define kServerFormatDate       @"dd/MM/yyyy HH:mm:ss"

#define kFullFormatClientDate	@"HH:mm - dd/MM/yyyy"
#define kFormatDateClientDetail @"dd/MM/yyyy HH:mm:ss"
#define kFormat12H              @"MM/dd/yyyy hh:mm a"
#define kQLTTFormatClientDate   @"HH:mm - dd/MMMM/yyyy"



@class WorkModel;
@class MissionModel;
@class MeetingModel;
@class MBProgressHUD;
@interface Common : NSObject

+ (Common *)shareInstance;

//date

+ (BOOL)validateDateString:(NSString *)iStr;

//Detect Network
+ (BOOL)checkNetworkAvaiable;

#pragma mark - HUD
//HUD
+ (MBProgressHUD *)instanceCustomHUDInView:(UIView *)view;
- (void)showCustomHudInView:(UIView *)view;
- (void)showHUDWithTitle:(NSString *)title inView:(UIView *)view;
- (void)showSuccessHUDWithTitle:(NSString *)title inView:(UIView *)view;
- (void)showErrorHUDWithMessage:(NSString *)message inView:(UIView *)view;
- (void)dismissHUD;
- (void)dismissCustomHUD;
- (void)showCustomTTNSHudInView:(UIView *)view;
- (void)dismissTTNSCustomHUD;
- (void)dismissAllTTNSCustomHUB;
@property (assign) BOOL canShowHub;
//Parse jSon String to dict
+ (id)dictFromJSONString:(NSString *)jSon;
+ (NSString *)readDataFromPlistSampleFileWithKey:(NSString *)key;


//Utils Date
- (NSDate *)dateFromString:(NSString *)strDate withFormat:(NSString *)format;
- (NSString *)stringWithCheckCompareFromDateString:(NSString *)strDate;
- (NSString *)fullNormalStringDateFromServerDate:(NSString *)serverDate serverFormatDate:(NSString *)format;
- (NSString *)normalDateFromServerDate:(NSString *)serverDate serverFormatDate:(NSString *)serFormat toClientFormat:(NSString *)clientFormat;

- (NSString *)convertToServerDateFromClientDate:(NSDate *)clientDate;

- (NSString*)getCurrentTime;


#pragma mark - UTILS VOFFICE
+ (NSString *)missionNameiConFromCommandType:(NSInteger)type;

//Check Role User
+ (BOOL)isManagerUserById:(NSString *)userID;
//Check role user from all group
+ (BOOL)isHasManagedRoleFromRoles:(NSArray *)roles;

//For list meeting paricipate
+ (BOOL)checkValid:(NSInteger)value;
+ (NSString *)getRoleFromMeetingModel:(NSInteger)isPresident isParticipate:(NSInteger)isParticipate isPrepare:(NSInteger)isPrepare;
+ (NSString *)base64EncodeImage:(UIImage *)originalImage;

#pragma mark - Util string
+ (NSArray *)separateStringBySpaceCharacter:(NSString *)curStr;

#pragma mark - Detech Delay work
+ (BOOL)isDelayWork:(WorkModel *)model;
+ (BOOL)isDelayMission:(MissionModel *)model;


+ (NSString *)iconTypeWorkFromCommandType:(NSInteger)commandType;
+ (NSInteger)numberRowsOfCommandTypeWork:(NSInteger)commandType;

#pragma mark - Util Status For List signer by status
+ (UIColor *)colorForStatusSign:(SignStatus)status;
+ (NSString *)getStatusSignFrom:(SignStatus)status;

#pragma mark - Util Mission
+ (NSString *)statusStringFromType:(MissionStatus)status;
#pragma mark - Util DOC
+ (NSString *)getPriorityDoc:(NSInteger)priorityId;

#pragma mark - Detect iS TextEdit Control
+ (BOOL)isTextEditControll:(UIView *)view;
@end
