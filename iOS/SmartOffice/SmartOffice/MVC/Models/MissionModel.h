//
//  MissionModel.h
//  SmartOffice
//
//  Created by Kaka on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOBaseModel.h"

@interface MissionModel : SOBaseModel{
	
}

@property (strong, nonatomic) NSString *missionId;
@property (strong, nonatomic) NSString *missionName;
@property (strong, nonatomic) NSString *missionPath;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *target;
@property (strong, nonatomic) NSString *dateStart;
@property (strong, nonatomic) NSString *dateComplete;
@property (strong, nonatomic) NSString *weight;

@property (strong, nonatomic) NSString *orgAssignId;
@property (strong, nonatomic) NSString *assignId;
@property (strong, nonatomic) NSString *assignEmail;

@property (strong, nonatomic) NSString *orgPerformId;
@property (assign, nonatomic) NSInteger frequenceUpdate;
@property (assign, nonatomic) NSInteger status;

@property (assign, nonatomic) NSUInteger fieldId;
@property (strong, nonatomic) NSString *ORG_PERFORM_NAME;
@property (strong, nonatomic) NSString *ORG_ASSIGN_NAME;
@property (strong, nonatomic) NSString *USER_ASSIGN_NAME;
@property (strong, nonatomic) NSString *POSITION_NAME;
@property (assign, nonatomic) NSInteger missionGroup;
@property (assign, nonatomic) NSInteger commandType;
@property (assign, nonatomic) MissionType missionType;

@end
