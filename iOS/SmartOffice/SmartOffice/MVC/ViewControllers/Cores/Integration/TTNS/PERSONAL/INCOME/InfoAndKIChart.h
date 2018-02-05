//
//  InfoAndKIChart.h
//  ChartsDemo
//
//  Created by NguyenVanTu on 4/12/17.
//  Copyright © 2017 dcg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>
#import "BaseChartViewController.h"

@interface InfoAndKIChart : BaseChartViewController
@property (weak, nonatomic) IBOutlet UIView *incomeView;
@property (weak, nonatomic) IBOutlet UIView *kiView;
@property (assign) double latestPayDate;
- (void)initValues;
@end
