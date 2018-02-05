//
//  VOffice_ListController.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/15/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "VOfficeProcessor.h"
#import "MissionModel.h"
#import "MissionGroupModel.h"
typedef void (^CallbackListMisstion)(BOOL success, BOOL isLoadedAllMission, NSArray *resultArray, NSException *exception, NSDictionary *error);
@interface VOffice_ListMissionController : NSObject
- (void)loadData:(NSString *)name orgID:(NSString *)orgId typeMission:(NSInteger)type listType:(ListMissionType)listType startRecord:(NSInteger)startRecord completion:(CallbackListMisstion)completion;
- (void)loadData:(NSString *)name startRecord:(NSInteger)startRecord completion:(CallbackListMisstion)completion;
- (void)executeSearchForQuery:(NSString *)query orgID:(NSString *)orgId typeMission:(NSInteger)type listType:(ListMissionType)listType startRecord:(NSInteger)startRecord completion:(CallbackListMisstion)completion;
- (void)executeSearchForQuery:(NSString *)query delayedBatching:(BOOL)delayedBatching completion:(CallbackListMisstion)completion;
-(void)setMissionType:(MissionType)missionType missionGroupModel:(MissionGroupModel *) missionGroupModel listType:(ListMissionType)listType;
-(void)setMissionType:(MissionType)missionType;
-(void)setMissionGroupModel:(MissionGroupModel *)missionGroupModel;
- (void)setListMissionType:(ListMissionType)listType;

- (ListMissionType)getListMissionType;
- (MissionType)getMissionType;
- (MissionGroupModel *)getMissionGroupModel;

+ (MissionType )typeMissionFromValue:(NSInteger)value;
@end
