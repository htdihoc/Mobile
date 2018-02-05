//
//  VOffice_MeetingCell.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_MeetingCell_iPad.h"
#import "MeetingModel.h"
#import "Common.h"

@interface VOffice_MeetingCell_iPad()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@end
@implementation VOffice_MeetingCell_iPad

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - update data from Model
- (void)updateDataByModel:(MeetingModel *)model{
    if (model) {
        _lblTitle.text = model.subject;
        _lblLocation.text = model.roomName;
        
        //Time
        /*
         NSString *startTime = [NSString stringWithFormat:@"%@h%@", model.startHour, model.startMinute];
         NSString *endTime = [NSString stringWithFormat:@"%@h%@", model.endHour, model.endMinute];
         _lblTime.text = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
         */
        _lblTime.text =  model.duration;
        //Date
        _lblDate.text = [[Common shareInstance] stringWithCheckCompareFromDateString:model.startTime];
    }
}
@end
