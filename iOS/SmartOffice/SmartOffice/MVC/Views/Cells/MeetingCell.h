//
//  MeetingCell.h
//  SmartOffice
//
//  Created by Kaka on 4/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeetingModel;
@interface MeetingCell : UITableViewCell{
	
}

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

//Update data
- (void)updateDataByModel:(MeetingModel *)model;

@end
