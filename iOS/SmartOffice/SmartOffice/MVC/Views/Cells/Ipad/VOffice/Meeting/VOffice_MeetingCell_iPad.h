//
//  VOffice_MeetingCell.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MeetingModel;

@interface VOffice_MeetingCell_iPad : UITableViewCell
//Update data
- (void)updateDataByModel:(MeetingModel *)model;
@end
