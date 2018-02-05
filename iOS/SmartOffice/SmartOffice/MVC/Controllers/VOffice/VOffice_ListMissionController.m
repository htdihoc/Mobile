//
//  VOffice_ListController.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/15/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "VOffice_ListMissionController.h"
#import "NSException+Custom.h"
@interface VOffice_ListMissionController(){
    NSInteger _filterType;
}
@property (assign, nonatomic) MissionType missionType;
@property (assign, nonatomic) ListMissionType listType;
@property (strong, nonatomic) MissionGroupModel *groupModel;
@end
@implementation VOffice_ListMissionController
#pragma mark - LoadData
-(void)setMissionType:(MissionType)missionType missionGroupModel:(MissionGroupModel *) missionGroupModel listType:(ListMissionType)listType
{
    _missionType = missionType;
    _groupModel = missionGroupModel;
	_listType = listType;
}
- (void)setListMissionType:(ListMissionType)listType
{
    _listType = listType;
}
- (void)setMissionType:(MissionType)missionType
{
    _missionType = missionType;
}
- (void)setMissionGroupModel:(MissionGroupModel *)missionGroupModel
{
    _groupModel = missionGroupModel;
}

- (ListMissionType)getListMissionType
{
    return self.listType;
}
- (MissionType)getMissionType
{
    return self.missionType;
}
- (MissionGroupModel *)getMissionGroupModel
{
    return self.groupModel;
}
//Get type mission from popup Filter
+ (MissionType )typeMissionFromValue:(NSInteger)value{
    MissionType type = 0;
    switch (value) {
        case 0:{
            type = MissionType_All;
        }
            break;
        case 1:{
            type = MissionType_DirectorateAssigned;
        }
            break;
            
        case 2:{
            type = MissionType_Combined;
        }
            break;
            
        case 3:{
            type = MissionType_Registered;
        }
            break;
            
        default:
            break;
    }
    return type;
}
- (void)executeSearchForQuery:(NSString *)query delayedBatching:(BOOL)delayedBatching completion:(CallbackListMisstion)completion {
    if (delayedBatching) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, DELAY_SEARCH_UTIL_QUERY_UNCHANGED_FOR_TIME_OFFSE);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [self executeSearchForQuery:query completion:^(BOOL success, BOOL isLoadedAllMission, NSArray *resultArray, NSException *exception, NSDictionary *error) {
                completion(success, isLoadedAllMission, resultArray, exception, error);
            }];
        });
        
    }
    else {
        [self executeSearchForQuery:query completion:^(BOOL success, BOOL isLoadedAllMission, NSArray *resultArray, NSException *exception, NSDictionary *error) {
            completion(success, isLoadedAllMission, resultArray, exception, error);
        }];
    }
}
- (void)executeSearchForQuery:(NSString *)query completion:(CallbackListMisstion)completion{
    [self executeSearchForQuery:query orgID:self.groupModel.groupId typeMission:self.missionType listType:self.listType startRecord:0 completion:^(BOOL success, BOOL isLoadedAllMission, NSArray *resultArray, NSException *exception, NSDictionary *error) {
        completion(success, isLoadedAllMission, resultArray, exception, error);
    }];
}
- (void)loadData:(NSString *)name startRecord:(NSInteger)startRecord completion:(CallbackListMisstion)completion
{
    [self loadData:name orgID:self.groupModel.groupId typeMission:self.missionType listType:self.listType startRecord:startRecord completion:^(BOOL success, BOOL isLoadedAllMission, NSArray *resultArray, NSException *exception, NSDictionary *error) {
            completion(success, isLoadedAllMission, resultArray, exception, error);
        
    }];
}
- (void)loadData:(NSString *)name orgID:(NSString *)orgId typeMission:(NSInteger)type listType:(ListMissionType)listType startRecord:(NSInteger)startRecord completion:(CallbackListMisstion)completion{
    if ([Common checkNetworkAvaiable]) {
        [VOfficeProcessor searchMissionByName:name orgID:orgId typeMission:type listType:listType startRecord:startRecord callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (success) {
                BOOL _isLoadedAllMission = NO;
                NSArray *dictArr = resultDict[@"data"];
                NSMutableArray *arrData = [MissionModel arrayOfModelsFromDictionaries:dictArr error:nil];
                if (arrData.count < PAGE_SIZE_NUMBER){
                    _isLoadedAllMission = YES;
                }
                completion(success, _isLoadedAllMission, arrData, exception, nil);
            }
            else
            {
                completion(success, NO, Nil, exception, resultDict);
            }
        }];
    }
    else
    {
        completion(NO, NO, nil, [NSException initWithNoNetWork], nil);
    }
}
- (void)executeSearchForQuery:(NSString *)query orgID:(NSString *)orgId typeMission:(NSInteger)type listType:(ListMissionType)listType startRecord:(NSInteger)startRecord completion:(CallbackListMisstion)completion{
    if ([Common checkNetworkAvaiable]) {
        [VOfficeProcessor searchMissionByName:query orgID:orgId typeMission:type listType:listType startRecord:0 callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (success) {
                DLog(@"%@", query);
                BOOL _isLoadedAllMission = NO;
                NSArray *dictArr = resultDict[@"data"];
                NSMutableArray *arrData = [MissionModel arrayOfModelsFromDictionaries:dictArr error:nil];
                if (arrData.count < PAGE_SIZE_NUMBER){
                    _isLoadedAllMission = YES;
                }
                completion(success, _isLoadedAllMission, arrData, exception, nil);
            }
            else
            {
                completion(success, NO, Nil, exception, resultDict);
            }
            
        }];
    }
    else
    {
        completion(NO, NO, nil, [NSException initWithNoNetWork], nil);
    }
    
    
}
@end
