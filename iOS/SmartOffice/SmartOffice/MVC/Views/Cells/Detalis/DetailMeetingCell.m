//
//  DetailMeetingCell.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/20/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "DetailMeetingCell.h"
#import "MeetingModel.h"
#import "Common.h"


@implementation DetailMeetingCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


#pragma mark - Setup Data
- (void)setupData:(MeetingModel *)model atIndex:(NSInteger)index{
    switch (index) {
        case DetailMeetingCellType_TOPIC:{
            _lblTitleCell.text = LocalizedString(@"VOffice_MeetingDetail_iPad_Chủ_đề_cuộc_họp");
			_lblContentCell.text = model.subject;
        }
            break;
        case DetailMeetingCellType_CONTENT:{
            _lblTitleCell.text = LocalizedString(@"VOffice_MeetingDetail_iPad_Nội_dung");
			_lblContentCell.text = model.summary? model.summary : LocalizedString(@"N/A");
        }
            break;
        case DetailMeetingCellType_PLACE:{
            _lblTitleCell.text = LocalizedString(@"VOffice_MeetingDetail_iPad_Phòng_họp");
			_lblContentCell.text = model.roomName;
        }
            break;
        case DetailMeetingCellType_START_AT:{
            _lblTitleCell.text = LocalizedString(@"Thời gian");
			NSString *startTime = [[Common shareInstance] fullNormalStringDateFromServerDate:model.startTime serverFormatDate:kFormatDateClientDetail];
			NSString *endTime = [[Common shareInstance] fullNormalStringDateFromServerDate:model.endTime serverFormatDate:kFormatDateClientDetail];
			_lblContentCell.text = [NSString stringWithFormat:@"%@    %@", startTime, endTime];
        }
            break;
        case DetailMeetingCellType_CALLER:{
            _lblTitleCell.text = LocalizedString(@"VOffice_MeetingDetail_iPad_Người_liên_hệ");
			_lblContentCell.text = model.contactPerson;
        }
            break;
        default:
            break;
    }
}
@end
