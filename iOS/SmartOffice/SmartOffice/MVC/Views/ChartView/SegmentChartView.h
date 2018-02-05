//
//  SegmentChartView.h
//  SmartOffice
//
//  Created by Kaka on 4/7/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentChartView : UIView{
    UIButton *_slowProgress;
    UIButton *_notProgress;
    NSLayoutConstraint *_widthSlowConstrain;
}

- (void)updateChartWithValue:(float)slowValue unInprogress:(float)unInprogressValue;

@end
