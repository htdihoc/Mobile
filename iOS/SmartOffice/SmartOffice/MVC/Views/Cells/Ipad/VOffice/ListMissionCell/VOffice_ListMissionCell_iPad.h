//
//  ListMissionCell.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/27/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MissionModel.h"
#import "Common.h"
@interface VOffice_ListMissionCell_iPad : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitleMission;
@property (weak, nonatomic) IBOutlet UILabel *lblDeadline;
@property (weak, nonatomic) IBOutlet UILabel *lblSubInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

- (void)setupDataByModel:(MissionModel *)model byType:(ListMissionType)type misstionType:(MissionType)misstionType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_SubInfoHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height_sub_info;


@end
