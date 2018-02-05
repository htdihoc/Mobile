//
//  VOffice_MissionDetailController.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/15/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VOfficeProcessor.h"
#import "MissionModel.h"
#import "DetailMissionModel.h"
typedef void (^CallbackMissionDetail)(BOOL success, DetailMissionModel *missionDetail, NSException *exception, NSDictionary *error);
@interface VOffice_MissionDetailController : NSObject
- (void)loadData:(MissionModel *)missionModel completion:(CallbackMissionDetail)completion;
@end
