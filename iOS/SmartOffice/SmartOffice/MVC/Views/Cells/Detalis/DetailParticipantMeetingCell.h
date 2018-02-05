//
//  DetailParticipantMeetingCell.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/20/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmployeeModel;
@interface DetailParticipantMeetingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblStatusPersonJoin;

@property (weak, nonatomic) IBOutlet UILabel *lblParticipantName;
@property (weak, nonatomic) IBOutlet UILabel *lblPosition;

- (void)setupDataFromModel:(EmployeeModel *)model;
- (void)setupDataByName:(NSString *)employeeName position:(NSString *)position;

@end
