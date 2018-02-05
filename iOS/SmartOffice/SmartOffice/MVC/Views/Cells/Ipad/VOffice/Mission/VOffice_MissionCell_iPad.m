//
//  VOffice_MissionCell_iPad.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_MissionCell_iPad.h"

@implementation VOffice_MissionCell_iPad

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	self.backgroundColor = [UIColor clearColor];
}
- (void)layoutSubviews{
	[super layoutSubviews];
	//[self setupDataByModel:_groupModel];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - Update Data
- (void)setupDataByModel:(MissionGroupModel *)model{
    if (model) {
        NSInteger sumValue = model.msDelayProgressNumber + model.msUnProgressNumber;
        _titleChart.text = model.msGroupName;
        _lblSumValue.text = [NSString stringWithFormat:@"%ld", (long)sumValue];
        [self updateDataWithSlowValue:model.msDelayProgressNumber unInprogressValue:model.msUnProgressNumber];
    }
}
- (void)updateDataWithSlowValue:(float)slowValue unInprogressValue:(float)unInprogressValue{
    //Update title chart value here
    [_chartView updateChartWithValue:slowValue unInprogress:unInprogressValue];
}
@end
