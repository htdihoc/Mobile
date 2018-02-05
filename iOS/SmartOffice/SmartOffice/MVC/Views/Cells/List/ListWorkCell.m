//
//  ListWorkCell.m
//  SmartOffice
//
//  Created by Kaka on 4/13/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ListWorkCell.h"
#import "WorkModel.h"
#import "UILabel+FormattedText.h"
#import "Common.h"
#import "NSDate+Utilities.h"

@implementation ListWorkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setupColor{
    _lblTitleWork.textColor = App_Color_MainTextBoldColor;
    _lblAssigner.textColor = AppColor_MainTextColor;
    _lblDeadline.textColor = AppColor_MainTextColor;
}

#pragma mark - SetupData by Model
- (void)setupDataByModel:(WorkModel *)model withListWorkType:(ListWorkType)type{
    if (model) {
        _lblTitleWork.text = model.taskName;
        
        NSString *time = [[Common shareInstance] fullNormalStringDateFromServerDate:model.endTime serverFormatDate:@"dd/MM/yyyy HH:mm"];
        _lblDeadline.text = [NSString stringWithFormat:@"%@: %@", LocalizedString(@"VOffice_ListWorkCell_iPad_Thời_hạn"),time];
		
		//Check delay time or not
		if ([Common isDelayWork:model]) {
			_lblDeadline.textColor = [UIColor redColor];
		}else{
			_lblDeadline.textColor = AppColor_MainTextColor;
		}
		
        [self setTextForAssignerLabel:type content:model type:model.commandType];
        if (type != ListWorkType_Shipped) {
            [self checkPersonalType:model.commandType];
        }
        else
        {
            _cst_Assigner.constant = 21;
        }
        [self setTextForStatusLabel:model.status];
        [self setImageForWorkType:type commandType:model.commandType]; //taskType2 can not use now
    }
}

- (void)checkPersonalType:(StatusWorkType)type
{
    if (type == StatusWorkType_ToiGiao) {
        //check model is personal then the field assigner will be set to nill.
        _lblAssigner.text = @"";
        _cst_Assigner.constant = 0;
    }
    else
    {
        _cst_Assigner.constant = 21;
    }
}
- (void)setImageForWorkType:(ListWorkType)type commandType:(StatusWorkType)commandType
{
    NSString *iConName = [self iconTypeWorkFromCommandType:commandType];
    _imgWorkType.image = [UIImage imageNamed:iConName];
    if (type == ListWorkType_Shipped) {
        //Nothings to do here
    }else{
        _imgWorkType.hidden = NO;
    }
}
- (void)setTextForStatusLabel:(WorkStatus)status
{
    NSString *statusWork = [self statusWorkFrom:status];
    _lblStatus.text = [NSString stringWithFormat:@"%@: %@", LocalizedString(@"VOffice_ListWorkCell_iPad_Trạng_thái"),statusWork];
    if (status == WorkStatus_Delay) {
        _lblDeadline.textColor = CommonColor_Red;
    }
    else if (status == WorkStatus_InProgress) {
        [_lblStatus colorSubString:statusWork withColor:AppColor_HightLightTextColor];
    }else{
        _lblStatus.textColor = AppColor_MainTextColor;
    }
}
- (void)setTextForAssignerLabel:(ListWorkType)type content:(WorkModel *)model type:(StatusWorkType)typeWork
{
    if (type == ListWorkType_Perform) {
        if (typeWork == StatusWorkType_DuocGiao) {
            _lblAssigner.text = [NSString stringWithFormat:@"%@: %@", LocalizedString(@"VOffice_ListWorkCell_iPad_Người_giao"), model.commanderName];
        }
        else
        {
            _lblAssigner.text = [NSString stringWithFormat:@"%@: %@", LocalizedString(@"VOffice_ListWorkCell_iPad_Phối_hợp"),model.enforcementName];
        }
    }
    else
    {
        _lblAssigner.text = [NSString stringWithFormat:@"%@: %@", LocalizedString(@"VOffice_ListWorkCell_iPad_Giao_tới"), model.enforcementName];
    }
	
}

//Util
- (NSString *)statusWorkFrom:(WorkStatus)status{
    NSString *textStatus = @"";
    switch (status) {
        case WorkStatus_UnInprogress:
            textStatus = LocalizedString(@"Status_Work_UnInprogress");
            break;
            
        case WorkStatus_InProgress:
            textStatus = LocalizedString(@"Status_Work_Inprogress");
            break;
        case WorkStatus_Completed:
            textStatus = LocalizedString(@"Status_Work_Completed");
            break;
        default:
            textStatus = [NSString stringWithFormat:@"Unknown: %lu", (unsigned long)status];
            break;
    }
    return textStatus;
}

- (NSString *)iconTypeWorkFromCommandType:(NSInteger)commandType{
    NSString *iconName = @"";
    if (commandType == 2) {
        //Personal
        iconName = @"work_perform_icon";
    }else if (commandType == 4){
        //Combined
        iconName = @"work_combinated_icon";
    }else{
        //Other - Được giao
        iconName = @"work_other_icon";
    }
    return iconName;
}

@end
