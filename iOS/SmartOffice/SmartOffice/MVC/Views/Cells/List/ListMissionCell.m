//
//  ListMissionCell.m
//  SmartOffice
//
//  Created by Kaka on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ListMissionCell.h"
#import "MissionModel.h"
#import "Common.h"
#import "NSDate+Utilities.h"

static CGFloat HEIGHT_DEFAULT_INFO = 16.0f;

@implementation ListMissionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setup Data from Model
- (void)setupDataByModel:(MissionModel *)model byType:(ListMissionType)type misstionType:(MissionType)misstionType{
	if (model) {
		//icon
        _imgMissionType.image = [UIImage imageNamed:[Common missionNameiConFromCommandType:model.commandType]];
		//Hidden icon
		if (type == ListMissionType_Shipped) {
			_imgMissionType.hidden = YES;

		}else{
			_imgMissionType.hidden = NO;
		}
		//fix allway hidden iCon - remove later when has right data
		//_imgMissionType.hidden = NO;
		
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
            //_lblSubInfo.text = [NSString stringWithFormat:@"%@: %@",LocalizedString(@"ĐV thực hiện"), model.ORG_PERFORM_NAME];
			_lblSubInfo.text = @"";
			_cst_SubInfoHeight.constant = 0;
        }
        else
        {
			_cst_SubInfoHeight.constant = HEIGHT_DEFAULT_INFO;
			_lblSubInfo.text = [NSString stringWithFormat:@"%@: %@",LocalizedString(@"LI_ASSIGNER_LABEL"), model.USER_ASSIGN_NAME];
        }
		[self setNeedsDisplay];
		
		_lblStatus.text = [NSString stringWithFormat:@"%@: %@", LocalizedString(@"LI_STATE_LABEL"), [Common statusStringFromType:model.status]];
	}
}

//[Answer] see commandType : loại việc (1 - việc có đánh giá; 2 - việc riêng (cá nhân); 3 - việc bàn giao (đă chuyển); 4 - việc phối hợp)
#pragma mark - use CommandType for filter
- (NSString *)iconTypeMissionByCommandType:(NSInteger)commandType{
	NSString *iconName = @"";
	if (commandType == 2) {
		//Personal
		iconName = @"work_perform_icon";
	}else if (commandType == 4){
		//Combined
		iconName = @"work_combinated_icon";
	}else{
		//Other
		iconName = @"work_other_icon";
	}
	return iconName;
}

@end
