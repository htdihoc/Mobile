//
//  ListDocCell.m
//  SmartOffice
//
//  Created by Kaka on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ListDocCell.h"
#import "DocModel.h"
#import "Common.h"
#import "TextModel.h"
#import "SORoundLabel.h"



@implementation ListDocCell


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
	_lblDocTitle.textColor = App_Color_MainTextBoldColor;
	_lblSignedDate.textColor = AppColor_MainTextColor;
	_lblRaiseMember.textColor = AppColor_MainTextColor;
}

#pragma mark - SetupData by Model
- (void)setupDataByModel:(id)model{
	if (model) {
		if ([model isKindOfClass:[DocModel class]]) {
			DocModel *docModel = (DocModel *)model;
			_lblDocTitle.text = docModel.title;
			NSString *senderName = docModel.signer;
			_lblRaiseMember.text = [NSString stringWithFormat:@"%@: %@",@"Người ký", senderName];
            NSString *timeReceive = [[Common shareInstance] fullNormalStringDateFromServerDate:docModel.receiveDate serverFormatDate:kFormatDateClientDetail];
            _lblSignedDate.text = [NSString stringWithFormat:@"%@: %@", @"Thời gian nhận", timeReceive];
            
			_lblPriority.text = docModel.priority;

			if (docModel.priorityId == UrgentDocStatus_Normal) { //Check priority of text
				_lblUrgentStatus.backgroundColor = AppColor_Normal_Doc_Status_Color;
			}else{
				_lblUrgentStatus.backgroundColor = AppColor_Urgency_Doc_Status_Color;
			}
		}else{
			TextModel *textModel = (TextModel *)model;
			_lblDocTitle.text = textModel.title;
			_lblRaiseMember.text = [NSString stringWithFormat:@"%@: %@", @"Người ký", textModel.chiefName];
            
            NSString *timeSigned = [[Common shareInstance] fullNormalStringDateFromServerDate:textModel.receiveDate serverFormatDate:kFormatDateClientDetail];
            _lblSignedDate.text = [NSString stringWithFormat:@"%@: %@", @"Thời gian trình ký", timeSigned];
            
			_lblPriority.text = textModel.priorityName;

			

			if (textModel.priorityId == UrgentTextStatus_Normal || [textModel.priorityName isEqualToString:PRIORITY_NORMAL_TEXT]) { //Check priority of text
				//_imgPriority.hidden = YES;
				//_lblPriority.hidden = YES;
				_lblUrgentStatus.backgroundColor = AppColor_Normal_Doc_Status_Color;
			}else{
				//_imgPriority.hidden = NO;
				//_lblPriority.hidden = NO;
				_lblUrgentStatus.backgroundColor = AppColor_Urgency_Doc_Status_Color;
			}
		}
	}
}
@end
