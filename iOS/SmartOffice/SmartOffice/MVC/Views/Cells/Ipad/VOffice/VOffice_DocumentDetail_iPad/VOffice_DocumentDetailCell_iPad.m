//
//  VOffice_DocumentDetailCell_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_DocumentDetailCell_iPad.h"
#import "TextModel.h"
#import "DocModel.h"
#import "Common.h"
@implementation VOffice_DocumentDetailCell_iPad
{
    UIColor *_currentColor;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _iconPerson.hidden = YES;
    _iconTime.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _imgPriority.backgroundColor = _currentColor;
    }
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
            NSString *senderName = docModel.signer? [NSString stringWithFormat:@"%@", docModel.signer] : @"";
            _lblRaiseMember.text = [NSString stringWithFormat:@"%@: %@", @"Người ký",senderName];
             NSString *timeReceive = [[Common shareInstance] fullNormalStringDateFromServerDate:docModel.receiveDate serverFormatDate:kFormatDateClientDetail];
            _lblSignedDate.text = [NSString stringWithFormat:@"%@: %@", @"Thời gian nhận", timeReceive];
            
            _lblPriority.text = docModel.priority;
            //Hidden status of Doc
            if (docModel.priorityId == UrgentDocStatus_Normal) { //Check priority of text
                _currentColor = AppColor_Normal_Doc_Status_Color;
                
            }else{
                _currentColor = AppColor_Urgency_Doc_Status_Color;
            }
        }else{
            TextModel *textModel = (TextModel *)model;
            _lblDocTitle.text = textModel.title;
            _lblRaiseMember.text = [NSString stringWithFormat:@"%@: %@", @"Người ký",textModel.chiefName];
            NSString *timeSigned = [[Common shareInstance] fullNormalStringDateFromServerDate:textModel.receiveDate serverFormatDate:kFormatDateClientDetail];
            _lblSignedDate.text = [NSString stringWithFormat:@"%@: %@", @"Thời gian trình ký", timeSigned];
            _lblPriority.text = textModel.priorityName;
            
            if (textModel.priorityId == UrgentTextStatus_Normal || [textModel.priorityName isEqualToString:PRIORITY_NORMAL_TEXT]) { //Check priority of text
                _currentColor = AppColor_Normal_Doc_Status_Color;
                
            }else{
                _currentColor = AppColor_Urgency_Doc_Status_Color;
            }
        }
        _lblPriority.layer.cornerRadius = _imgPriority.frame.size.width/2;
        _imgPriority.backgroundColor = _currentColor;
    }
}
@end
