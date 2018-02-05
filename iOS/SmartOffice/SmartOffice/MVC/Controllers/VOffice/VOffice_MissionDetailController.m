//
//  VOffice_MissionDetailController.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/15/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "VOffice_MissionDetailController.h"
#import "Common.h"
#import "NSException+Custom.h"
@interface VOffice_MissionDetailController()

@end

@implementation VOffice_MissionDetailController

#pragma mark - Load Data
- (void)loadData:(MissionModel *)missionModel completion:(CallbackMissionDetail)completion{
    if ([Common checkNetworkAvaiable]) {
        [VOfficeProcessor getDetailMissionByID:missionModel.missionId.integerValue callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (success) {
                NSDictionary *dictModel = resultDict[@"data"];
                DetailMissionModel *model = [[DetailMissionModel alloc] initWithDictionary:dictModel error:nil];
                completion(success, model, exception, nil);
                
            }else{
                DLog(@"Error load detail mission");
                completion(success, nil, exception, resultDict);
            }
        }];
    }
    else
    {
        completion(NO, nil, [NSException initWithNoNetWork], nil);
    }
}
@end
