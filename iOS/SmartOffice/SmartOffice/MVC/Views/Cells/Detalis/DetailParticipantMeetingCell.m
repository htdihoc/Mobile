//
//  DetailParticipantMeetingCell.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/20/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "DetailParticipantMeetingCell.h"
#import "EmployeeModel.h"
#import "Common.h"

@implementation DetailParticipantMeetingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _lblStatusPersonJoin.text = @"";
    _lblStatusPersonJoin.textColor = AppColor_MainTextColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (BOOL)checkValid:(NSInteger)value
//{
//    if (value == 1) {
//        return YES;
//    }
//    return NO;
//}
//- (NSString *)checkType:(NSInteger)isPresident isParticipate:(NSInteger)isParticipate isPrepare:(NSInteger)isPrepare
//{
//    if ([self checkValid:isPresident]) {
//        return LocalizedString(@"VOffice_PersonJoinCell_iPad_Chủ_trì");
//    }
//    if ([self checkValid:isPrepare]) {
//        return LocalizedString(@"VOffice_PersonJoinCell_iPad_Chuẩn_bị");
//    }
//    return LocalizedString(@"VOffice_PersonJoinCell_iPad_Tham_gia");
//}

#pragma mark - setup Data by Model
- (void)setupDataFromModel:(EmployeeModel *)model{
	_lblParticipantName.text = model.memberName;
	_lblPosition.text = model.vhrOrgName;
//    _lblStatusPersonJoin.text = [self checkType:model.isPresident isParticipate:model.isParticipate isPrepare:model.isPrepare];
//    if (model.isPresident) {
//        _lblStatusPersonJoin.text = [Common getRoleFromMeetingModel:model];
//    }
    _lblStatusPersonJoin.text = [Common getRoleFromMeetingModel:model.isPresident isParticipate:model.isParticipate isPrepare:model.isPrepare];
}

//None use now
- (void)setupDataByName:(NSString *)employeeName position:(NSString *)position{
	_lblParticipantName.text = employeeName;
	_lblPosition.text = position;
}
@end
