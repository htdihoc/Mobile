//
//  DetailWorkModel.h
//  SmartOffice
//
//  Created by Kaka on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOBaseModel.h"

typedef enum : NSUInteger {
	DetailTaskType_Unknow = 0,
	DetailTaskType_DuocGiao,
	DetailTaskType_ToiGiao,
	DetailTaskType_PhoiHop,
	DetailTaskType_CaNhanKhac,
	DetailTaskType_CaNhanRieng,
	DetailTaskType_DaChuyen,
	DetailTaskType_TongHop123
} DetailTaskType;

@interface DetailWorkModel : SOBaseModel{
	
}
@property (assign, nonatomic) NSUInteger taskId;
@property (strong, nonatomic) NSString *taskName;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;
@property (assign, nonatomic) DetailTaskType taskType;
@property (strong, nonatomic) NSString *taskTypeName;

//Commander
@property (assign, nonatomic) NSUInteger commanderId;
@property (strong, nonatomic) NSString *commanderName;
@property (assign, nonatomic) NSUInteger commandType;
@property (strong, nonatomic) NSString *commanderMobilePhone;
@property (strong, nonatomic) NSString *commanderEmail;

//Enforcement
@property (assign, nonatomic) NSUInteger enforcementId;
@property (strong, nonatomic) NSString *enforcementName;
@property (strong, nonatomic) NSString *enforcementEmail;
@property (strong, nonatomic) NSString *enforcementMobilePhone;

@property (strong, nonatomic) NSString *updateFrequency;
@property (strong, nonatomic) NSString *updateFrequencyName;

@property (assign, nonatomic) NSUInteger fieldId;

@property (assign, nonatomic) NSUInteger orgId;
@property (strong, nonatomic) NSString *orgName;

@property (strong, nonatomic) NSString *completedPercent;
@property (assign, nonatomic) BOOL isCompleted;
@property (assign, nonatomic) WorkStatus status;
@property (strong, nonatomic) NSString *statusName;

@property (strong, nonatomic) NSString *createdDate;
@property (strong, nonatomic) NSString *createdBy;
@property (strong, nonatomic) NSString *taskResult;
@property (strong, nonatomic) NSString *partitionBy;
@property (strong, nonatomic) NSString *taskPath;
@property (assign, nonatomic) NSInteger ratingPoint;

//???
@property (assign, nonatomic) NSInteger taskType2;
@property (strong, nonatomic) NSString *taskTypeName2;
@property (assign, nonatomic) BOOL isMajor;
@property (strong, nonatomic) NSDictionary *permissionsForTask;

@property (assign, nonatomic) NSInteger approvalState;
@property (assign, nonatomic) NSUInteger taskApprovalId;


@end
