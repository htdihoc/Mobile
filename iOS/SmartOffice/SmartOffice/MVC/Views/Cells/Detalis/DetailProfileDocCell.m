//
//  DetailProfileDocCell.m
//  SmartOffice
//
//  Created by Kaka on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "DetailProfileDocCell.h"
#import "MemberModel.h"
#import "Common.h"

@implementation DetailProfileDocCell

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
- (void)setupDataFromModel:(id)model forDoc:(BOOL)isDoc{
	if (model) {
		if ([model isKindOfClass:[MemberModel class]]) {
			if (isDoc) {
				MemberModel *_member = (MemberModel *)model;
				_lblAcceptedSigner.text = _member.signer;
				_lblInfoSigner.text = _member.departmentName;
				_lblStatus.text = [Common getStatusSignFrom:_member.status];
				_lblStatus.textColor = [Common colorForStatusSign:_member.status];
			}else{
				MemberModel *_member = (MemberModel *)model;
				_lblAcceptedSigner.text = _member.empVhrName;
				_lblInfoSigner.text = _member.departmentName;
				_lblStatus.text = [Common getStatusSignFrom:_member.status];
				_lblStatus.textColor = [Common colorForStatusSign:_member.status];
			}
		}
	}
}
@end
