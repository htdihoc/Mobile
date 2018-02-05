//
//  VOffice_TaskController.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/15/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "VOffice_TaskController.h"
#import "Common.h"
#import "NSException+Custom.h"
@implementation VOffice_TaskController{
    NSMutableArray *_listGroupPerformedMission;
    NSMutableArray *_listGroupShippedMission;
}
- (void)loadData:(CallbackVOffice_Task)completion
{
    if ([Common checkNetworkAvaiable]) {
        NSMutableArray *exceptions = [[NSMutableArray alloc] init];
        NSMutableArray *exceptionCodes = [[NSMutableArray alloc] init];
        dispatch_group_t group = dispatch_group_create(); // 2
        dispatch_group_enter(group);
        [self loadSumPerformedMissionWithComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (exception) {
                [exceptions addObject:exception];
            }
            if (success) {
                NSArray *dictArr = resultDict[@"data"];
                NSError *error;
                NSMutableArray *listPerformedMission = [MissionModel arrayOfModelsFromDictionaries:dictArr error:&error];
                if (!error) {
                    //GroupBY
                    //_listGroupPerformedMission = [self groupObjectsFromMissionModelArray:listPerformedMission byType:MissionType_Perform];
                    [self groupDataFromMissionArray:listPerformedMission byType:ListMissionType_Perform completion:^(NSMutableArray *result) {
						_listGroupPerformedMission = result;
                        dispatch_group_leave(group);
                    }];
                }
                else
                {
                    [exceptionCodes addObject:resultDict];
                }
            }else{
                DLog(@"Error Load performed Mission");
                dispatch_group_leave(group);
            }
            //dispatch_group_leave(group);
        }];
        
        dispatch_group_enter(group);
        [self loadSumShippedMissionWithComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (exception) {
                [exceptions addObject:exception];
            }
            if (success) {
                NSArray *dictArr = resultDict[@"data"];
                NSError *error;
                NSMutableArray *listShippedMission = [MissionModel arrayOfModelsFromDictionaries:dictArr error:&error];
                if (!error) {
                    //GroupBY
                    //_listGroupShippedMission = [self groupObjectsFromMissionModelArray:listShippedMission byType:MissionType_Shipped];
                    [self groupDataFromMissionArray:listShippedMission byType:ListMissionType_Shipped completion:^(NSMutableArray *result) {
						_listGroupShippedMission = result;
						dispatch_group_leave(group);
                    }];
                }
                else
                {
                    [exceptionCodes addObject:resultDict];
                }
            }else{
                DLog(@"Error Load shipped Mission");
                dispatch_group_leave(group);
            }
            //dispatch_group_leave(group);
        }];
        
        
        //All tasks are completed
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{ // 4
			//return Sort data
			[_listGroupPerformedMission sortUsingComparator:^(MissionGroupModel *firstObject, MissionGroupModel *secondObject) {
				return [firstObject.msGroupName caseInsensitiveCompare:secondObject.msGroupName];
			}];
			
			[_listGroupShippedMission sortUsingComparator:^(MissionGroupModel *firstObject, MissionGroupModel *secondObject) {
				return [firstObject.msGroupName caseInsensitiveCompare:secondObject.msGroupName];
			}];

            if (exceptions.count > 0) {
				
                completion(NO, _listGroupPerformedMission,
                           _listGroupShippedMission, exceptions, exceptionCodes);
            }
            else
            {
                completion(YES, _listGroupPerformedMission,
                           _listGroupShippedMission, nil, nil);
            }
        });
    }
    else
    {
        completion(NO, nil, nil, @[[NSException initWithNoNetWork]], nil);
    }
    
}

#pragma mark - Group Util
- (NSMutableArray *)groupObjectsFromMissionModelArray:(NSArray *)missionArr byType:(MissionType)type{
	
    NSMutableArray *groupedArr = @[].mutableCopy;
    //GroupBY
    NSDictionary* groupedByOrgAssignId = [missionArr linq_groupBy:^id(id item) {
        if (type == ListMissionType_Shipped) {
            return [item orgPerformId];
        }
        return [item orgAssignId];
    }];
    
    //Parse dict group to new Array group model
    for (NSString *key in groupedByOrgAssignId.allKeys) {
        NSArray *missions = groupedByOrgAssignId[key];
        NSString *groupName = @"";
        NSString *groupId;
        if (missions.count > 0) {
            if (type == ListMissionType_Shipped) {
                groupName = [missions.firstObject ORG_PERFORM_NAME];
                groupId = [missions.firstObject orgPerformId];
            }else{
                groupName = [missions.firstObject ORG_ASSIGN_NAME];
                groupId = [missions.firstObject orgAssignId];
            }
            NSInteger countDelay = [missions linq_count:^BOOL(MissionModel *item) {
                return item.status == MissionStatus_DelayProgress;
            }];
            NSInteger countUnInProgress = [missions linq_count:^BOOL(MissionModel *item) {
                return item.status == MissionStatus_UnInprogress;
            }];
            MissionGroupModel *group = [[MissionGroupModel alloc] initWithName:groupName delayProgressNumber:countDelay unInprogress:countUnInProgress groupId:groupId];
            [groupedArr addObject:group];
        }
    }
    return groupedArr;
}

//Using this to group data : Separate perform - shipped mission
- (void)groupDataFromMissionArray:(NSArray *)missionArr byType:(ListMissionType)type completion:(void (^)(NSMutableArray *result))completeBlock{
	NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
	[myQueue addOperationWithBlock:^{
		// Background work
		NSMutableArray *groupedArr = @[].mutableCopy;
		//GroupBY
		NSDictionary* groupDict = [missionArr linq_groupBy:^id(id item) {
			if (type == ListMissionType_Shipped) {
				return [item orgPerformId];
			}
			return [item orgAssignId];
		}];
		
		//Parse dict group to new Array group model
		for (NSString *key in groupDict.allKeys) {
			NSArray *missions = groupDict[key];
			NSString *groupName = @"";
			NSString *groupId;
			//typeMission = 1
			if (missions.count > 0) {
				if (type == ListMissionType_Shipped) {
					groupName = [missions.firstObject ORG_PERFORM_NAME];
					groupId = [missions.firstObject orgPerformId];
				}else{
					groupName = [missions.firstObject ORG_ASSIGN_NAME];
					groupId = [missions.firstObject orgAssignId];
				}
				NSInteger countDelay = [missions linq_count:^BOOL(MissionModel *item) {
					//return item.status == MissionStatus_DelayProgress;
					return [Common isDelayMission:item] == YES;
				}];
				NSInteger countUnInProgress = [missions linq_count:^BOOL(MissionModel *item) {
					//return item.status == MissionStatus_UnInprogress;
					return [Common isDelayMission:item] == NO;
				}];
				
				if (!(countDelay == 0 && countUnInProgress == 0)) {
					MissionGroupModel *group = [[MissionGroupModel alloc] initWithName:groupName delayProgressNumber:countDelay unInprogress:countUnInProgress groupId:groupId];
					[groupedArr addObject:group];
				}
			}
		}
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			// Main thread work (UI usually)
			completeBlock(groupedArr);
		}];
	}];
}


#pragma mark - Load data From API
- (void)loadSumPerformedMissionWithComplete:(Callback)completeHandler{
    [VOfficeProcessor getAllListMissionByType:ListMissionType_Perform callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        completeHandler(success, resultDict, exception);
    }];
}


- (void)loadSumShippedMissionWithComplete:(Callback)completeHandler{
    [VOfficeProcessor getAllListMissionByType:ListMissionType_Shipped callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        completeHandler(success, resultDict, exception);
    }];
}
@end
