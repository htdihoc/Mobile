//
//  TaskCell.m
//  SmartOffice
//
//  Created by Kaka on 4/11/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TaskCell.h"
#import "SegmentChartView.h"
#import "MissionGroupModel.h"
#import "SOBadgeLabel.h"

@implementation TaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)layoutSubviews{
	[super layoutSubviews];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - updateValue
- (void)setupDataByModel:(MissionGroupModel *)model{
	if (model) {
		NSInteger sumValue = model.msDelayProgressNumber + model.msUnProgressNumber;
		_titleChart.text = model.msGroupName;
		_lblSumValue.text = [NSString stringWithFormat:@"%ld", (long)sumValue];
		[self updateDataWithSlowValue:model.msDelayProgressNumber unInprogressValue:model.msUnProgressNumber];
	}
}

- (void)updateDataWithSlowValue:(NSInteger)slowValue unInprogressValue:(NSInteger)unInprogressValue{
    //Update title chart value here
    [_chartView updateChartWithValue:slowValue unInprogress:unInprogressValue];
}
@end
