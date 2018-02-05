//
//  VOffice_MissionCell_iPad.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MissionGroupModel.h"
#import "SOBadgeLabel.h"
#import "SegmentChartView.h"

@interface VOffice_MissionCell_iPad : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleChart;
@property (weak, nonatomic) IBOutlet SOBadgeLabel *lblSumValue;

@property (weak, nonatomic) IBOutlet SegmentChartView *chartView;
//Passing Data
- (void)setupDataByModel:(MissionGroupModel *)model;
@end
