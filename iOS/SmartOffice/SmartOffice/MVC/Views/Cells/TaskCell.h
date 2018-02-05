//
//  TaskCell.h
//  SmartOffice
//
//  Created by Kaka on 4/11/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SOBadgeLabel;
@class SegmentChartView;
@class MissionGroupModel;
@interface TaskCell : UITableViewCell{
    
}
@property (weak, nonatomic) IBOutlet UILabel *titleChart;
@property (weak, nonatomic) IBOutlet SOBadgeLabel *lblSumValue;

@property (weak, nonatomic) IBOutlet SegmentChartView *chartView;

//Passing Data
- (void)setupDataByModel:(MissionGroupModel *)model;


@end
