//
//  Voffice_MeetingDetail_TableViewCell.h
//  VOFFICE_ListOfMeetingSchedules
//
//  Created by NguyenDucBien on 4/28/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOfice_DetailBaseCell.h"
@class MeetingModel;

@interface VOffice_MeetingDetailCell_iPad : VOfice_DetailBaseCell
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *lbTittleMeettingDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbContentMeeting;
- (void)setupData:(MeetingModel *)model atIndex:(NSInteger)index;
@end
