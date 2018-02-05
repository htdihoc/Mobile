//
//  VOffice_MainView_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_MainView_iPad.h"
#import "NSException+Custom.h"
#import "SOErrorView.h"
#import "VOffice_MissionPlan_iPad.h"
@interface VOffice_MainView_iPad()
{
    VOffice_MissionPlan_iPad *missionVC;
}
@end

@implementation VOffice_MainView_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)addContainerViews
{
    if (!self.isAddContainerViews) {
        missionVC = NEW_VC_FROM_NIB(VOffice_MissionPlan_iPad, @"VOffice_MissionPlan_iPad");
        [self displayVC:missionVC container:self.containerMissionPlan];
    }
    else
    {
        [missionVC loadData];
    }
    [super addContainerViews];
}
@end
