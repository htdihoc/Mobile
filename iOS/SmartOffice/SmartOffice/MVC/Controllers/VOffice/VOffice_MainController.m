//
//  VOffice_MainVC.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/15/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "VOffice_MainController.h"
#import "NSException+Custom.h"
@implementation VOffice_MainController
- (void)loadData:(CallbackVOffice_Main)completion{
    //Check Network here
    if ([Common checkNetworkAvaiable]) {
        [VOfficeProcessor getAcccessTokenVOfficeWithComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (success) {
                DLog(@"Get AccessToken Success")
                NSDictionary *dicSession = resultDict[@"data"];
				if (dicSession == nil) {
					//Show error: No data
					NSDictionary *errorDict = @{@"content":LocalizedString(@"Không có dữ liệu")};
					completion(YES, NO, exception, errorDict);
                    [self initWithDataNULL];
					return ;
				}
                VOfficeSessionModel *model = [[VOfficeSessionModel alloc] initWithDictionary:dicSession error:nil];
                [SOSessionManager sharedSession].vofficeSession = model;
                
                //Call API get UserRole
                [VOfficeProcessor getUserRole:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
                    if (success) {
                        DLog("UserRole: %@", resultDict);
                        NSArray *arrDictModel = resultDict[@"data"];
						if (arrDictModel == nil) {
							completion(YES, NO, exception, resultDict);
							return ;
						}
                        NSMutableArray *roles = [UserRoleModel arrayOfModelsFromDictionaries:arrDictModel error:nil];
                        if (roles.count > 0) {
                            NSMutableArray *listOrgIds = @[].mutableCopy;
                            [roles enumerateObjectsUsingBlock:^(UserRoleModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                [listOrgIds addObject:obj.orgId];
                            }];
                            UserRoleModel *firtOBJ = roles.firstObject;
                            [SOSessionManager sharedSession].vofficeSession.sysUserID = firtOBJ.sysUserId;
                            [SOSessionManager sharedSession].vofficeSession.userRolesArr = roles;
                            [SOSessionManager sharedSession].vofficeSession.listOrgIds = listOrgIds;
                            completion(YES, YES, exception, nil);
                            return ;
                        }
                    }
                    else
                    {
                        completion(YES, NO, exception, resultDict);
                    }
                    
                }];
                
            }else{
                completion(YES, NO, exception, resultDict);
            }
        }];
    }else{
        completion(NO, NO, [NSException initWithNoNetWork], nil);
    }
}

- (void) initWithDataNULL {
//    [self.delegate dataNULL];
}

@end
