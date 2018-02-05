//
//  VOffice_DocumentTypicalProfileDetail_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_DocumentTypicalProfileDetailCell_iPad.h"
#import "MemberModel.h"
#import "Common.h"
@implementation VOffice_DocumentTypicalProfileDetailCell_iPad

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lblStatus.textColor = AppColor_MainAppTintColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setup Data by Model
- (void)setupDataFromModel:(id)model type:(DocType)type{
    if (model) {
        if ([model isKindOfClass:[MemberModel class]]) {
            MemberModel *_member = (MemberModel *)model;
            if (type == DocType_Express) {
                _lblAcceptedSigner.text = _member.signer;
                _lblInfoSigner.text = _member.departmentName;
                _lblStatus.text = [Common getStatusSignFrom:_member.status];
                _lblStatus.textColor = [Common colorForStatusSign:_member.status];
            }
            else
            {
                _lblAcceptedSigner.text = _member.empVhrName;
                _lblInfoSigner.text = _member.departmentName;
                _lblStatus.text = [Common getStatusSignFrom:_member.status];
                _lblStatus.textColor = [Common colorForStatusSign:_member.status];
            }
            
        }
    }
}

@end
