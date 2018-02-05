//
//  ListMissionCell.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/27/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_ListMissionCell_iPad.h"
#import "NSDate+Utilities.h"

@implementation VOffice_ListMissionCell_iPad

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - Setup Data from Model
- (void)setupDataByModel:(MissionModel *)model byType:(ListMissionType)type misstionType:(MissionType)misstionType{
    if (model) {
        _lblTitleMission.text = model.missionName;
        NSString *deadline = [[Common shareInstance] fullNormalStringDateFromServerDate:model.dateComplete serverFormatDate:kFormatDateClientDetail];
        _lblDeadline.text = [NSString stringWithFormat:@"%@: %@", LocalizedString(@"LI_DEADLINE_LABEL"), deadline];
		
		//Check delay time or not
		if ([Common isDelayMission:model]) {
			_lblDeadline.textColor = [UIColor redColor];
		}else{
			_lblDeadline.textColor = AppColor_MainTextColor;
		}
        
        if (type == ListMissionType_Shipped) {
            _lblSubInfo.text = [NSString stringWithFormat:@"%@: %@",LocalizedString(@"ĐV thực hiện"), model.ORG_PERFORM_NAME];
        }
        else
        {
                _lblSubInfo.text = [NSString stringWithFormat:@"%@: %@",LocalizedString(@"LI_ASSIGNER_LABEL"), model.USER_ASSIGN_NAME];
        }
        _lblStatus.text = [NSString stringWithFormat:@"%@: %@", LocalizedString(@"LI_STATE_LABEL"), [Common statusStringFromType:model.status]];
    }
}

@end
