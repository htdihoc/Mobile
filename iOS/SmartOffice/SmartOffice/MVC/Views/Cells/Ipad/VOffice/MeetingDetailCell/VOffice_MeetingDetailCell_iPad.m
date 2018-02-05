//
//  Voffice_MeetingDetail_TableViewCell.m
//  VOFFICE_ListOfMeetingSchedules
//
//  Created by NguyenDucBien on 4/28/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import "VOffice_MeetingDetailCell_iPad.h"
#import "MeetingModel.h"
#import "Common.h"
#import "DetailMeetingCell.h"

@implementation VOffice_MeetingDetailCell_iPad

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
    _bottomView.hidden = YES;
    switch (index) {
        case DetailMeetingCellType_TOPIC:{
            _lbTittleMeettingDetail.text = LocalizedString(@"VOffice_MeetingDetail_iPad_Chủ_đề_cuộc_họp");
            _lbContentMeeting.text = model.subject;
        }
            break;
        case DetailMeetingCellType_CONTENT:{
            _lbTittleMeettingDetail.text = LocalizedString(@"VOffice_MeetingDetail_iPad_Nội_dung");
            _lbContentMeeting.text = model.summary;
        }
            break;
        case DetailMeetingCellType_PLACE:{
            _lbTittleMeettingDetail.text = LocalizedString(@"VOffice_MeetingDetail_iPad_Phòng_họp");
            _lbContentMeeting.text = model.roomName;
        }
            break;
        case DetailMeetingCellType_START_AT:{
            _lbTittleMeettingDetail.text = LocalizedString(@"VOffice_MeetingDetail_iPad_Thời_gian");
            NSString *startTime = [[Common shareInstance] fullNormalStringDateFromServerDate:model.startTime serverFormatDate:
                                   kFormatDateClientDetail];
            NSString *endTime = [[Common shareInstance] fullNormalStringDateFromServerDate:model.endTime serverFormatDate:kFormatDateClientDetail];
            startTime = startTime == nil ? LocalizedString(@"N/A") : startTime;
            endTime = endTime == nil ? LocalizedString(@"N/A") : endTime;
            _lbContentMeeting.text = [NSString stringWithFormat:@"%@    %@", startTime, endTime];
        }
            break;
        case DetailMeetingCellType_CALLER:{
            _lbTittleMeettingDetail.text = LocalizedString(@"VOffice_MeetingDetail_iPad_Người_liên_hệ");
            _lbContentMeeting.text = model.contactPerson;
            _bottomView.hidden = NO;
        }
            break;
        default:
            break;
    }
    [self layoutIfNeeded];
}
@end
