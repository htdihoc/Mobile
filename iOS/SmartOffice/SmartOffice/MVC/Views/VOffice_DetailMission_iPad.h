//
//  VOffice_DetailMission_iPad.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VOffice_DetailView_iPad.h"
#import "DetailMissionModel.h"
#import "VOffice_MissionDetailController.h"
#import "Common.h"
@protocol VOffice_DetailMission_iPadDelegate
- (MissionModel *)getModelToShow;
- (DetailMissionModel *)getMissionDetailModel;
- (void)didSelectVOffice;
- (void)endEditView;
@end
@interface VOffice_DetailMission_iPad : VOffice_DetailView_iPad
@property (weak, nonatomic) id<VOffice_DetailMission_iPadDelegate> delegate;
@property (nonatomic) NSInteger checkReturn;
- (void)reloadData;
@end
