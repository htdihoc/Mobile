//
//  PositionCell.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PositionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *yearLB;

@property (weak, nonatomic) IBOutlet UILabel *dateLB;

@property (weak, nonatomic) IBOutlet UILabel *salaryLevelLB;

@property (weak, nonatomic) IBOutlet UILabel *positionLB;

@property (weak, nonatomic) IBOutlet UILabel *salaryLB;

@end
