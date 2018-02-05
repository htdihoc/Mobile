//
//  VOfficeProcessor.h
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 4/11/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VOfficeProcessor : NSObject

//AccessToken _ VOffice
+ (void)getAcccessTokenVOfficeWithComplete:(Callback)callBack;
//Get UserRole
+ (void)getUserRole:(Callback)callBack;


#pragma mark - SUM
//Get Sum work
+ (void)getSumWorkVOByWorkType:(ListWorkType)type complete:(Callback)callBack;

//Get Sum Doc
//+ (void)sumTextWithComplete:(Callback)callBack;
//+ (void)sumDocWithComplete:(Callback)callBack;

//Get Sum Mission
+ (void)getSumMissionByType:(NSInteger)typeMission callBack:(Callback)callBack;

+ (void)getAllListMissionByType:(ListMissionType)listType callBack:(Callback)callBack;


#pragma mark - Lists
//Get list schedule
+ (void)getListScheduleVOFromWithComplete:(Callback)callBack;

//ListWork
+ (void)getListWorkByType:(ListWorkType)workType startRecord:(NSInteger)startRecord callBack:(Callback)callBack;

//List Doc
//Filter Docs - Use this to get
+ (void)filterDocsWithType:(NSInteger)type title:(NSString *)title startRecord:(NSInteger)startRecord callBack:(Callback)callBack;

//List Mission
+ (void)getListMissionsByType:(NSInteger)typeMission startRecord:(NSInteger)startRecord callBack:(Callback)callBack;
#pragma mark - Search
//1: Search Mission
//+ (void)searchMissionByName:(NSString *)name orgID:(NSString *)orgId typeMission:(NSInteger)type startRecord:(NSInteger)startRecord callBack:(Callback)callBack;
+ (void)searchMissionByName:(NSString *)name orgID:(NSString *)orgId typeMission:(NSInteger)missType listType:(ListMissionType)listType startRecord:(NSInteger)startRecord callBack:(Callback)callBack;

//2: Search Task
+ (void)searchTask:(NSString *)taskName listTaskType:(NSInteger)listTaskType taskType:(NSInteger)filterType startRecord:(NSInteger)startRecord isSum:(BOOL)isSum callBack:(Callback)callBack;
//3: Search SumTask
+ (void)searchSumTask:(NSArray *)listStatus listTaskType:(NSInteger)listTaskType callBack:(Callback)callBack;

//4: Search ExpressDoc
//+ (void)searchExpressDocByTitle:(NSString *)title startRecord:(NSInteger)startRecord callBack:(Callback)callBack;
+ (void)searchExpressDocByTitle:(NSString *)title startRecord:(NSInteger)startRecord isSum:(BOOL)isSum callBack:(Callback)callBack;


//5: Search Normal Doc
//+ (void)searchNormalDocByTitle:(NSString *)title docType:(DocType)type startRecord:(NSInteger)startRecord callBack:(Callback)callBack;
+ (void)searchNormalDocByTitle:(NSString *)title docType:(DocType)type startRecord:(NSInteger)startRecord isSum:(BOOL)isSum callBack:(Callback)callBack;


#pragma mark - Detail
//Detail Work
+ (void)getDetailWorkFromId:(NSInteger)workId callBack:(Callback)callBack;
+ (void)getDetailDoctByID:(NSString *)Id byDocType:(NSInteger)docType callBack:(Callback)callBack;
+ (void)getDetailMissionByID:(NSUInteger)missId callBack:(Callback)callBack;
+ (void)detailMeetingByID:(NSString *)meetingId callBack:(Callback)callBack;

@end
