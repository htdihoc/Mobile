//
//  VOfficeProcessor.m
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 4/11/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOfficeProcessor.h"
#import "THService.h"
#import "SOSessionManager.h"
#import "VOfficeSessionModel.h"
#import "NSDate+Utilities.h"

//AccessToken
#define VOFFICE_ACCESS_TOKEN_API		@"voffice/get_access_token"
#define VOFFICE_Get_USER_ROLE_API		@"voffice/get_list_user_sign_with_role"


#define SUM_WORK_FROM_VO_API        @"voffice/sum_task"
#define LIST_MEETING_API			@"voffice/list_meeting"
#define SUM_DOC_API				@"voffice/sum_doc"
#define SUM_TEXT_API			@"voffice/sum_text"
#define SUM_MISSION_FROM_VO_API		@"voffice/sum_mission"

//List Work
#define LIST_WORK_FROM_VO_API		@"voffice/get_list_task"

//List Mission
#define LIST_MISSION_FROM_VO_API	@"voffice/get_list_mission"

//List Doc
#define LIST_DOC_BY_DOCTYPE_API			@"voffice/search_doc"
#define LIST_DOC_BY_TEXTTYPE_API		@"voffice/search_text"
#define FILTER_DOCS_COMMON_API			@"voffice/search_doc" //Like search Doc API
//Detail
#define DETAIL_WORK_API				@"voffice/task_detail"
#define DETAIL_EXPRESS_DOC_API		@"voffice/doc_detail"
#define DETAIL_NORMAL_DOC_API		@"voffice/text_detail"
#define DETAIL_MISSION_API			@"voffice/mission_detail"
#define DETAIL_MEETING_API			@"voffice/meeting_detail"

//Search
#define SEARCH_MISSION_API		@"voffice/search_mission"
#define SEARCH_TASK_API			@"voffice/search_task"
#define SEARCH_EXPRESS_DOC_API		@"voffice/search_doc"
#define SEARCH_NORMAL_DOC_API		@"voffice/search_text"


@implementation VOfficeProcessor

//Get AccessToken
+ (void)getAcccessTokenVOfficeWithComplete:(Callback)callBack{
	 NSDictionary *params = @{@"username" : [GlobalObj getInstance].username, @"password" : [GlobalObj getInstance].password};
	[THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:VOFFICE_ACCESS_TOKEN_API] parameter:params withProgress:nil completion:^(NSDictionary *response) {
		callBack(YES, response, nil);
	} onError:^(NSDictionary *error) {
		callBack(NO, error, nil);
	} onException:^(NSException *exception) {
		callBack(NO, nil, exception);
	}];
}

+ (void)getUserRole:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;
	NSDictionary *params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key};
	
	[THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:VOFFICE_Get_USER_ROLE_API] parameter:params withProgress:nil completion:^(NSDictionary *response) {
		callBack(YES, response, nil);
	} onError:^(NSDictionary *error) {
		callBack(NO, error, nil);
	} onException:^(NSException *exception) {
		callBack(NO, nil, exception);
	}];

}
#pragma mark - Get Sum
//Get Sum Work
+ (void)getSumWorkVOByWorkType:(ListWorkType)type complete:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;
	NSDictionary *params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"type":@(type) };
	
    [THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:SUM_WORK_FROM_VO_API] parameter:params withProgress:nil completion:^(NSDictionary *response) {
        callBack(YES, response, nil);
    } onError:^(NSDictionary *error) {
        callBack(NO, error, nil);
    } onException:^(NSException *exception) {
        callBack(NO, nil, exception);
    }];
}

//Get iLst Schedule
+ (void)getListScheduleVOFromWithComplete:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;
	NSDictionary *params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"pageSize":@(3), @"type":@(1)};
	
	//Fixed Date: , @"fromDate":@"16/01/2016 14:09:00"
	NSString *mainURL = [[GlobalObj getInstance] getApiFullUrl:LIST_MEETING_API];
	[THService requestPOSTFromUrl:mainURL parameter:params withProgress:nil
					   completion:^(NSDictionary *response) {
						   callBack(YES, response, nil);
					   } onError:^(NSDictionary *error) {
						   callBack(NO, error, nil);
					   } onException:^(NSException *exception) {
						   callBack(NO, nil, exception);
					   }];
}

#pragma mark - SUM
//Get Sum Text
+ (void)sumTextWithComplete:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;
	NSString *today = [[Common shareInstance] convertToServerDateFromClientDate:[NSDate date]];
	NSDictionary *params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"toDate":today};

	[THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:SUM_TEXT_API] parameter:params withProgress:nil
					   completion:^(NSDictionary *response) {
						   callBack(YES, response, nil);
					   } onError:^(NSDictionary *error) {
						   callBack(NO, error, nil);
					   } onException:^(NSException *exception) {
						   callBack(NO, nil, exception);
					   }];
	
	
}
//Get Sum DOC
+ (void)sumDocWithComplete:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;
	
	NSString *today = [[Common shareInstance] convertToServerDateFromClientDate:[NSDate date]];
	NSDictionary *params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"type":@(3), @"status":@(0), @"toDate":today};
	
	[THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:SUM_DOC_API] parameter:params withProgress:nil
					   completion:^(NSDictionary *response) {
						   callBack(YES, response, nil);
					   } onError:^(NSDictionary *error) {
						   callBack(NO, error, nil);
					   } onException:^(NSException *exception) {
						   callBack(NO, nil, exception);
					   }];

}


+ (void)getSumMissionByType:(NSInteger)typeMission callBack:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;
	
	//Default status mission to get sum
	NSArray *listStatus = @[@(MissionStatus_UnInprogress), @(MissionStatus_DelayProgress)];
	NSDictionary *params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"typeMission":@(typeMission), @"listStatus":listStatus};
	
	[THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:SUM_MISSION_FROM_VO_API] parameter:params withProgress:nil
					   completion:^(NSDictionary *response) {
						   callBack(YES, response, nil);
					   } onError:^(NSDictionary *error) {
						   callBack(NO, error, nil);
					   } onException:^(NSException *exception) {
						   callBack(NO, nil, exception);
					   }];

}

//Function to calculate sum mission
+ (void)getAllListMissionByType:(ListMissionType)listType callBack:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;
	
	//Default status mission to get sum
	NSArray *listStatus = @[@(MissionStatus_UnInprogress), @(MissionStatus_DelayProgress)];
	
	
	//+++:Old logic: Use listOrgIds to pass params
	//NSString *userId = [SOSessionManager sharedSession].vofficeSession.sysUserID;
	NSArray *listOrgId = [SOSessionManager sharedSession].vofficeSession.listOrgIds;
	
	NSDictionary *params;
	//New change: Using typeMission for params
	NSString *typeMission = listType == ListMissionType_Perform? @"1":@"2";
	/*
	if (listType == ListMissionType_Perform) {
		//Unuse this param nơ: @"listOrgPerformId":listOrgId
		//params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"listStatus":listStatus, @"typeMission":typeMission};
		
		//+++ New Params
		params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"isSearchAdvanced":@1, @"displayOrg":@1, @"sortBy":@1, @"viewType":@1, @"searchOrgIds":listOrgId, @"listStatus": listStatus, @"typeMission":typeMission};
	}else{
		//Unuse this param now: @"listOrgAssignId":listOrgId
		//params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"listStatus":listStatus, @"typeMission":typeMission};
		//params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"listStatus":listStatus, @"typeMission":typeMission};
		
		params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"isSearchAdvanced":@1, @"displayOrg":@1, @"sortBy":@1, @"viewType":@1, @"searchOrgIds":listOrgId, @"listStatus": listStatus, @"typeMission":typeMission};
	}
	*/
	params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"isSearchAdvanced":@1, @"displayOrg":@1, @"sortBy":@1, @"viewType":@1, @"searchOrgIds":listOrgId, @"listStatus": listStatus, @"typeMission":typeMission};
	
	[THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:SEARCH_MISSION_API] parameter:params withProgress:nil
					   completion:^(NSDictionary *response) {
						   callBack(YES, response, nil);
					   } onError:^(NSDictionary *error) {
						   callBack(NO, error, nil);
					   } onException:^(NSException *exception) {
						   callBack(NO, nil, exception);
					   }];
}
#pragma mark - List Data
// Get List Mission
+ (void)getListMissionsByType:(NSInteger)typeMission startRecord:(NSInteger)startRecord callBack:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;

	//Default status mission to get sum
	NSArray *listStatus = @[@(MissionStatus_UnInprogress), @(MissionStatus_DelayProgress)];
	NSDictionary *params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"typeMission":@(typeMission), @"startRecord":@(startRecord), @"pageSize":@(PAGE_SIZE_NUMBER), @"listStatus":listStatus};
	
	[THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:LIST_MISSION_FROM_VO_API] parameter:params withProgress:nil
					   completion:^(NSDictionary *response) {
						   callBack(YES, response, nil);
					   } onError:^(NSDictionary *error) {
						   callBack(NO, error, nil);
					   } onException:^(NSException *exception) {
						   callBack(NO, nil, exception);
					   }];
}


//ListWork
+ (void)getListWorkByType:(ListWorkType)workType startRecord:(NSInteger)startRecord callBack:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;
	NSDictionary *params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"type":@(workType), @"startRecord":@(startRecord), @"pageSize":@(PAGE_SIZE_NUMBER)};
	
	[THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:LIST_WORK_FROM_VO_API] parameter:params withProgress:nil completion:^(NSDictionary *response) {
		callBack(YES, response, nil);
	} onError:^(NSDictionary *error) {
		callBack(NO, error, nil);
	} onException:^(NSException *exception) {
		callBack(NO, nil, exception);
	}];
}

//ListDoc: 2 API
+ (void)getListDocs_DocAPIByType:(NSInteger)type state:(NSInteger)state startRecord:(NSInteger)startRecord callBack:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;
	NSDictionary *params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"type":@(type), @"startRecord":@(startRecord), @"pageSize":@(PAGE_SIZE_NUMBER), @"isCount":@(0), @"state":@(state), @"status":@(0)};
	
	[THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:LIST_DOC_BY_DOCTYPE_API] parameter:params withProgress:nil completion:^(NSDictionary *response) {
		callBack(YES, response, nil);
	} onError:^(NSDictionary *error) {
		callBack(NO, error, nil);
	} onException:^(NSException *exception) {
		callBack(NO, nil, exception);
	}];

}

+ (void)getListDocs_TextAPIByType:(NSInteger)type state:(NSInteger)state startRecord:(NSInteger)startRecord callBack:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;
	NSDictionary *params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"type":@(type), @"startRecord":@(startRecord), @"pageSize":@(PAGE_SIZE_NUMBER), @"isCount":@(0), @"state":@(state), @"status":@(0)};
	
	[THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:LIST_DOC_BY_TEXTTYPE_API] parameter:params withProgress:nil completion:^(NSDictionary *response) {
		callBack(YES, response, nil);
	} onError:^(NSDictionary *error) {
		callBack(NO, error, nil);
	} onException:^(NSException *exception) {
		callBack(NO, nil, exception);
	}];
}

//Filter Docs using Common API to get list Docs
+ (void)filterDocsWithType:(NSInteger)type title:(NSString *)title startRecord:(NSInteger)startRecord callBack:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;
	NSString *_title = title? title:@"";
	NSDictionary *params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"type":@(type), @"startRecord":@(startRecord), @"pageSize":@(PAGE_SIZE_NUMBER), @"isCount":@(0), @"title":_title, @"status":@(0)};
	
	[THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:FILTER_DOCS_COMMON_API] parameter:params withProgress:nil completion:^(NSDictionary *response) {
		callBack(YES, response, nil);
	} onError:^(NSDictionary *error) {
		callBack(NO, error, nil);
	} onException:^(NSException *exception) {
		callBack(NO, nil, exception);
	}];
}

#pragma mark - Detail
+ (void)getDetailWorkFromId:(NSInteger)workId callBack:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;
	NSDictionary *params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"taskId":@(workId)};
	
	[THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:DETAIL_WORK_API] parameter:params withProgress:nil completion:^(NSDictionary *response) {
		callBack(YES, response, nil);
	} onError:^(NSDictionary *error) {
		callBack(NO, error, nil);
	} onException:^(NSException *exception) {
		callBack(NO, nil, exception);
	}];
}

//Detail Doc
+ (void)getDetailDoctByID:(NSString *)Id byDocType:(NSInteger)docType callBack:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;
	NSDictionary *params;
	NSString *url;
	if (docType == DocType_Express) {
		url = DETAIL_EXPRESS_DOC_API;
		params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"documentId":Id};
	}else{
		url = DETAIL_NORMAL_DOC_API;
		params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"textId":Id};
	}
	[THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:url] parameter:params withProgress:nil completion:^(NSDictionary *response) {
		callBack(YES, response, nil);
	} onError:^(NSDictionary *error) {
		callBack(NO, error, nil);
	} onException:^(NSException *exception) {
		callBack(NO, nil, exception);
	}];
}

//Detail Mission
+ (void)getDetailMissionByID:(NSUInteger)missId callBack:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;
	NSDictionary *params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"missionId":@(missId)};
	
	[THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:DETAIL_MISSION_API] parameter:params withProgress:nil completion:^(NSDictionary *response) {
		callBack(YES, response, nil);
	} onError:^(NSDictionary *error) {
		callBack(NO, error, nil);
	} onException:^(NSException *exception) {
		callBack(NO, nil, exception);
	}];
}

//Detail Meeting
+ (void)detailMeetingByID:(NSString *)meetingId callBack:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;
	NSDictionary *params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"meetingId":meetingId};
	
	[THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:DETAIL_MEETING_API] parameter:params withProgress:nil completion:^(NSDictionary *response) {
		callBack(YES, response, nil);
	} onError:^(NSDictionary *error) {
		callBack(NO, error, nil);
	} onException:^(NSException *exception) {
		callBack(NO, nil, exception);
	}];

}

#pragma mark ck- Search
+ (void)searchMissionByName:(NSString *)name orgID:(NSString *)orgId typeMission:(NSInteger)missType listType:(ListMissionType)listType startRecord:(NSInteger)startRecord callBack:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;
	
	//Default status mission to get sum
	NSArray *listStatus = @[@(MissionStatus_UnInprogress), @(MissionStatus_DelayProgress)];
	//NSArray *listOrgId = [SOSessionManager sharedSession].vofficeSession.listOrgIds;
	
	NSDictionary *params;
	id _type;
	if ( missType == MissionType_All) {
		if (listType == ListMissionType_Perform) {
			_type = @"1";
		}else{
			_type = @"2";
		}
	}else{
		_type = @(missType);
	}
	
	//Unuse this param nơ: @"listOrgPerformId":listOrgId
	//@"listOrgPerformId":listOrgId
	//@"listOrgAssignId":listOrgId
	if (listType == ListMissionType_Perform) {
		params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"missionName":name, @"typeMission":_type, @"startRecord":@(startRecord), @"pageSize":@(PAGE_SIZE_NUMBER), @"listStatus":listStatus, @"isCount":@(0), @"orgAssignId":orgId};
	}else{
		//Shipped
		params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"missionName":name, @"typeMission":_type, @"startRecord":@(startRecord), @"pageSize":@(PAGE_SIZE_NUMBER), @"listStatus":listStatus, @"isCount":@(0), @"orgPerformId":orgId};
	}
	
	
	[THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:SEARCH_MISSION_API] parameter:params withProgress:nil
					   completion:^(NSDictionary *response) {
						   callBack(YES, response, nil);
					   } onError:^(NSDictionary *error) {
						   callBack(NO, error, nil);
					   } onException:^(NSException *exception) {
						   callBack(NO, nil, exception);
					   }];

}

//Search Works
+ (void)searchTask:(NSString *)taskName listTaskType:(NSInteger)listTaskType taskType:(NSInteger)filterType startRecord:(NSInteger)startRecord isSum:(BOOL)isSum callBack:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;
	//Default status mission to get sum
	NSArray *listStatus = @[ @(WorkStatus_UnInprogress), @(WorkStatus_Delay)];
	NSString *userId = [SOSessionManager sharedSession].vofficeSession.sysUserID;
	NSDictionary *params;
	
	id _filterType;
	if (filterType == WorkType_All) {
		_filterType = @"";
	}else{
		_filterType = @(filterType);
	}
	
	id _startRecord;
	id _pageSize;
	
	NSString *isCount = @"";
	if (isSum) {
		isCount = @"1";
		_startRecord = @"";
		_pageSize = @"";
	}else{
		isCount = @"0";
		_startRecord = @(startRecord);
		_pageSize = @(PAGE_SIZE_NUMBER);
	}
	if (listTaskType == ListWorkType_Perform) {
		params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"taskName":taskName, @"type":_filterType, @"startRecord":_startRecord, @"pageSize":_pageSize, @"isCount":isCount, @"enforcementId":userId, @"listStatus":listStatus};
		//*****Fake Remove listStatus Params
		//params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"taskName":taskName, @"type":_filterType, @"startRecord":_startRecord, @"pageSize":_pageSize, @"isCount":isCount, @"enforcementId":userId};
	}
	if (listTaskType == ListWorkType_Shipped) {
		params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"taskName":taskName, @"type":_filterType, @"startRecord":_startRecord, @"pageSize":_pageSize, @"isCount":isCount, @"commanderId":userId, @"listStatus":listStatus};
		
		//****Fake Remove List Status Params
		//params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"taskName":taskName, @"type":_filterType, @"startRecord":_startRecord, @"pageSize":_pageSize, @"isCount":isCount, @"commanderId":userId};
	}
	
	[THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:SEARCH_TASK_API] parameter:params withProgress:nil
					   completion:^(NSDictionary *response) {
						   callBack(YES, response, nil);
					   } onError:^(NSDictionary *error) {
						   callBack(NO, error, nil);
					   } onException:^(NSException *exception) {
						   callBack(NO, nil, exception);
					   }];


}

//Use this for getting Sum Work
+ (void)searchSumTask:(NSArray *)listStatus listTaskType:(NSInteger)listTaskType callBack:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;
	//Default status mission to get sum
	NSString *userId = [SOSessionManager sharedSession].vofficeSession.sysUserID;
	NSDictionary *params;
		
	if (listTaskType == ListWorkType_Perform) {
		params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"isCount":@(1), @"enforcementId":userId, @"listStatus":listStatus};
		
		//Fake Params without listStatus Key
		//params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"isCount":@(1), @"enforcementId":userId};
	}
	if (listTaskType == ListWorkType_Shipped) {
		params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"isCount":@(1), @"commanderId":userId, @"listStatus":listStatus};
		
		//Fake Params without listStatus Key
		//params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"isCount":@(1), @"commanderId":userId};
	}
	[THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:SEARCH_TASK_API] parameter:params withProgress:nil
					   completion:^(NSDictionary *response) {
						   callBack(YES, response, nil);
					   } onError:^(NSDictionary *error) {
						   callBack(NO, error, nil);
					   } onException:^(NSException *exception) {
						   callBack(NO, nil, exception);
					   }];
}


#pragma mark - Search Doc
+ (void)searchExpressDocByTitle:(NSString *)title startRecord:(NSInteger)startRecord isSum:(BOOL)isSum callBack:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;
	
	//Param Date
	NSString *today = [[Common shareInstance] convertToServerDateFromClientDate:[NSDate date]];
	NSString *twoWeekAgo = [[Common shareInstance] convertToServerDateFromClientDate:[[NSDate date] dateBySubtractingDays:14]];

	NSDictionary *params;
	if (isSum) {
		params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"isCount":@(1), @"startRecord":@(startRecord), @"status":@(0), @"type":@"1", @"priorityId":@3,  @"receiveDateFrom":twoWeekAgo, @"receiveDateTo":today};
	}else{
		params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"isCount":@(0), @"startRecord":@(startRecord), @"title":title, @"content": title, @"pageSize":@(PAGE_SIZE_NUMBER), @"status":@(0), @"type":@"1", @"priorityId":@3, @"receiveDateFrom":twoWeekAgo, @"receiveDateTo":today};
	}
	
	[THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:SEARCH_EXPRESS_DOC_API] parameter:params withProgress:nil
					   completion:^(NSDictionary *response) {
						   callBack(YES, response, nil);
					   } onError:^(NSDictionary *error) {
						   callBack(NO, error, nil);
					   } onException:^(NSException *exception) {
						   callBack(NO, nil, exception);
					   }];

}

+ (void)searchNormalDocByTitle:(NSString *)title docType:(DocType)type startRecord:(NSInteger)startRecord isSum:(BOOL)isSum callBack:(Callback)callBack{
	//Prepare Params
	NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
	NSString *aes_key = [SOSessionManager sharedSession].vofficeSession.aes_key;
	NSString *rsa_public_key = [SOSessionManager sharedSession].vofficeSession.rsa_public_key;
	NSDictionary *params;
	NSInteger _type = 0;
	NSInteger _state = 0;
	if (type == DocType_Waiting) {
		//Ký Duyệt
		_type = 3; _state = 0;
	}
	if (type == DocType_Flash) {
		//Ký nháy
		_type = 3; _state = 5;
	}
	
	//Date Params
	NSString *today = [[Common shareInstance] convertToServerDateFromClientDate:[NSDate date]];
	NSString *twoWeekAgo = [[Common shareInstance] convertToServerDateFromClientDate:[[NSDate date] dateBySubtractingDays:14]];
	
	if (isSum) {
		params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"isCount":@(1), @"type":@(_type), @"state":@(_state), @"fromDate":twoWeekAgo, @"toDate":today, @"keyword" : @"A", @"isFinancial" : @0};
	}else{
			params = @{@"access_token" : access_token, @"aes_key" : aes_key, @"rsa_public_key" : rsa_public_key, @"isCount":@(0), @"startRecord":@(startRecord), @"title":title, @"description": title, @"type":@(_type), @"state":@(_state), @"pageSize":@(PAGE_SIZE_NUMBER), @"fromDate":twoWeekAgo, @"toDate":today, @"keyword" : @"A", @"isFinancial" : @0};
	}
	
	[THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:SEARCH_NORMAL_DOC_API] parameter:params withProgress:nil
					   completion:^(NSDictionary *response) {
						   callBack(YES, response, nil);
					   } onError:^(NSDictionary *error) {
						   callBack(NO, error, nil);
					   } onException:^(NSException *exception) {
						   callBack(NO, nil, exception);
					   }];
}

@end
