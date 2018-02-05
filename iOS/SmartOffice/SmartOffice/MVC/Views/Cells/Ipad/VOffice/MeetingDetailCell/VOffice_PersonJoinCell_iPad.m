//
//  Voffice_PersonJoinTableViewCell.m
//  VOFFICE_ListOfMeetingSchedules_iPad
//
//  Created by NguyenDucBien on 4/28/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import "VOffice_PersonJoinCell_iPad.h"
#import "EmployeeModel.h"
#import "Common.h"
@implementation VOffice_PersonJoinCell_iPad

- (void)awakeFromNib {
    [super awakeFromNib];
    _labelNamePerson.text = @"";
    _labelPosition.text = @"";
    _labelStatus.text = @"";
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - setup Data by Model
- (void)setupDataFromModel:(EmployeeModel *)model{
    _labelNamePerson.text = model.memberName;
    _labelPosition.text = model.vhrOrgName;
    _labelStatus.text = [Common getRoleFromMeetingModel:model.isPresident isParticipate:model.isParticipate isPrepare:model.isPrepare];
}

- (void)setupDataByName:(NSString *)employeeName position:(NSString *)position{
    _labelNamePerson.text = employeeName;
    _labelPosition.text = position;
}
@end
