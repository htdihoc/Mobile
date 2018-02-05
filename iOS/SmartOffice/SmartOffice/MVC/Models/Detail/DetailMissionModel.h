//
//  DetailMissionModel.h
//  SmartOffice
//
//  Created by Kaka on 5/9/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOBaseModel.h"

@interface DetailMissionModel : SOBaseModel{
	
}
@property (assign, nonatomic) NSUInteger missionId;
@property (strong, nonatomic) NSString *missionName;
@property (strong, nonatomic) NSString *missionPath;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *target;
@property (strong, nonatomic) NSString *dateStart;
@property (strong, nonatomic) NSString *dateComplete;
@property (assign, nonatomic) NSInteger orgType;
@property (assign, nonatomic) NSUInteger orgAssignId;
@property (strong, nonatomic) NSString *orgAssignName;

@property (assign, nonatomic) NSUInteger assignId;
@property (strong, nonatomic) NSString *assignName;
@property (strong, nonatomic) NSString *assignEmail;
@property (strong, nonatomic) NSString *assignMobilePhone;

@property (assign, nonatomic) NSUInteger orgPerformId;
@property (strong, nonatomic) NSString *orgPerformName;

@property (assign, nonatomic) NSInteger frequenceUpdate;
@property (strong, nonatomic) NSString *frequenceUpdateName;

@property (assign, nonatomic) NSUInteger fieldId;
@property (assign, nonatomic) NSInteger status;
@property (strong, nonatomic) NSString *statusName;

@property (strong, nonatomic) NSString *createdDate;
@property (assign, nonatomic) NSUInteger createdBy;
@property (strong, nonatomic) NSString *createdByName;
@property (strong, nonatomic) NSString *createdByEmail;
@property (strong, nonatomic) NSString *createdByMobilePhone;

@property (assign, nonatomic) NSInteger delFlag;
@property (assign, nonatomic) BOOL isTransferOrgPerform;

@property (assign, nonatomic) NSInteger levelImportance;
@property (assign, nonatomic) BOOL isDocReport;
@property (strong, nonatomic) NSArray *listDocumentRef;
@property (assign, nonatomic) NSInteger missionGroup;


//"listSource": [
//			   {
//				   "sourceMapId": 26765,
//				   "sourceName": "ề",
//				   "sourceType": 1,
//				   "sourceTypeName": "Theo nguồn gốc khác",
//				   "objectType": 2
//			   }
//			   ],
//"permissionOfAssignOrg": {
//	"created": true,
//	"deliver": true,
//	"guide": false,
//	"edit": true,
//	"delete": true,
//	"transfer": true,
//	"checked": false
//},
//"permissionOfPerformOrg": {
//	"create": true,
//	"reject": false,
//	"approve": false,
//	"update": false
//},
//"permissionOfCombinationOrg": {
//	"update": false
//},


@end
