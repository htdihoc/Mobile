//
//  ListMissionCell.h
//  SmartOffice
//
//  Created by Kaka on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MissionModel;

@interface ListMissionCell : UITableViewCell{
	
}

@property (weak, nonatomic) IBOutlet UILabel *lblTitleMission;
@property (weak, nonatomic) IBOutlet UILabel *lblDeadline;
@property (weak, nonatomic) IBOutlet UILabel *lblSubInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imgMissionType;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_SubInfoHeight;
//Setup data
//- (NSString *)getImageNameFromWorkType:(ListMissionType)type;
- (void)setupDataByModel:(MissionModel *)model byType:(ListMissionType)type misstionType:(MissionType)misstionType;


@end
