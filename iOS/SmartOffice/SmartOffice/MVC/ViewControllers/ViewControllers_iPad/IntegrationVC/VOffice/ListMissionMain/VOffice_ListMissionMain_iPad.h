//
//  VOffice_ListMissionMain_iPad.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/27/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOffice_BaseBottomView_iPad.h"
#import "VOffice_ListMission_iPad.h"
#import "VOffice_ListMissionCell_iPad.h"
#import "WYPopoverController.h"
#import "ContentFilterAndSearchBarVC.h"
#import "VOffice_DetailMission_iPad.h"
#import "VOffice_ListMissionController.h"
@protocol VOffice_ListMissionMain_iPadDelegate
- (MissionGroupModel *)didSelectRow:(NSInteger)index;
- (NSArray *)getListmMsGroupName;
- (NSIndexPath *)getCurrentIndexPath;
- (NSInteger)getcurrentListType;
- (NSInteger)getcurrentMissionType;
- (void)setcurrentMissionType:(NSInteger)misstionType;
@end
@interface VOffice_ListMissionMain_iPad : VOffice_BaseBottomView_iPad
@property (weak, nonatomic) IBOutlet VOffice_ListMission_iPad *listMissionView;
@property (weak, nonatomic) IBOutlet VOffice_DetailMission_iPad *missionDetailView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) VOffice_ListMissionController *listMisstionController;
@property (weak, nonatomic) UISegmentedControl *segment;
@property (weak, nonatomic) id<VOffice_ListMissionMain_iPadDelegate> delegate;
-(void)setMissionType:(MissionType)missionType missionGroupModel:(MissionGroupModel *) missionGroupModel;
@end
