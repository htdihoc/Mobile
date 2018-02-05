//
//  DetailMissionCell.m
//  SmartOffice
//
//  Created by Kaka on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "DetailMissionCell.h"
#import "DetailMissionModel.h"

@implementation DetailMissionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	_lblTitleCell.textColor = RGB(102, 102, 102);
	_lblContentCell.textColor = RGB(51, 51, 51);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setup Data from Model
////Detai Mission (DM)
//"DM_NAME_MISSION_LABEL" = "Tên nhiệm vụ";
//"DM_RELEASE_DATE_LABEL"	= "Ngày giao";
//"DM_DEADLINE_DATE"		= "Thời hạn";
//"DM_STATE_LABEL"		= "Trạng thái";
//"DM_FREQUENCY_UPDATE_LABEL"	= "Tần suất báo cáo";
//"DM_IMPORTANT_LEVEL_LABEL"	= "Mức độ";
//"DM_OBJECTIVE_LABEL"		= "Mục tiêu";
//"DM_ASSIGNER_LABEL"			= "Người giao việc";

//"DM_LEVEL_IMPORTANT_LABEL"	= "Quan trọng";
//"DM_LEVEL_NORMAL_LABEL"		= "Bình thường";
- (void)setupDataByModel:(DetailMissionModel *)model atIndex:(NSInteger)index{
	if (model) {
		switch (index) {
			case 0:{
				_lblTitleCell.text = LocalizedString(@"DM_NAME_MISSION_LABEL");
				_lblContentCell.text = model.missionName;
			}
				break;
			case 1:{
				_lblTitleCell.text = LocalizedString(@"DM_RELEASE_DATE_LABEL");
				_lblContentCell.text = model.dateStart;
			}
				break;
			case 2:{
				_lblTitleCell.text = LocalizedString(@"DM_DEADLINE_DATE");
				_lblContentCell.text = model.dateComplete;
			}
				break;
			case 3:{
				_lblTitleCell.text = LocalizedString(@"DM_STATE_LABEL");
				_lblContentCell.text = model.statusName;
			}
				break;
			case 4:{
				_lblTitleCell.text = LocalizedString(@"DM_FREQUENCY_UPDATE_LABEL");
				_lblContentCell.text = model.frequenceUpdateName;
			}
				break;
			case 5:{
				_lblTitleCell.text = LocalizedString(@"DM_IMPORTANT_LEVEL_LABEL");
				if (model.levelImportance == MissionLevelType_Normal) {
					_lblContentCell.text = LocalizedString(@"DM_LEVEL_NORMAL_LABEL");
				}else{
					_lblContentCell.text = LocalizedString(@"DM_LEVEL_IMPORTANT_LABEL");
				}
			}
				break;
			case 6:{
				_lblTitleCell.text = LocalizedString(@"DM_OBJECTIVE_LABEL");
				_lblContentCell.text = model.target;
			}
				break;
			case 7:{
                    _lblTitleCell.text = LocalizedString(@"DM_ASSIGNER_LABEL");
                    _lblContentCell.text = model.assignName;
			}
				break;
				
			default:
				break;
		}
	}
}

@end
