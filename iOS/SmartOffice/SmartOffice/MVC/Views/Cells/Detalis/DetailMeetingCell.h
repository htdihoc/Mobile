//
//  DetailMeetingCell.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/20/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    DetailMeetingCellType_TOPIC = 0,	//Chủ đề cuộc họp
    DetailMeetingCellType_CONTENT,		//Nội dung
    DetailMeetingCellType_PLACE,		//Địa điểm
    DetailMeetingCellType_START_AT,		//Thời gian bắt đầu
    DetailMeetingCellType_CALLER		//Người liên lạc
} DetailMeetingCellType;
@class MeetingModel;
@interface DetailMeetingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitleCell;
@property (weak, nonatomic) IBOutlet UILabel *lblContentCell;
- (void)setupData:(MeetingModel *)model atIndex:(NSInteger)index;
@end
