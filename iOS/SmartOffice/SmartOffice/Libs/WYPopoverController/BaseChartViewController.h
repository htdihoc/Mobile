//
//  BaseChartViewController.h
//  ChartsDemo
//
//  Created by NguyenVanTu on 4/12/17.
//  Copyright © 2017 dcg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>
#import "TTNS_BaseVC.h"
@interface BaseChartViewController : TTNS_BaseVC
{
    @protected
    NSArray *parties;
}

@property (nonatomic, strong) IBOutlet UIButton *optionsButton;
@property (nonatomic, strong) IBOutlet NSArray *options;

@property (nonatomic, assign) BOOL shouldHideData;

- (void)handleOption:(NSString *)key forChartView:(ChartViewBase *)chartView;

- (void)updateChartData;

- (void)setupPieChartView:(PieChartView *)chartView;
- (void)setupRadarChartView:(RadarChartView *)chartView;
- (void)setupBarLineChartView:(BarLineChartViewBase *)chartView;
- (void)addCustomValue:(ChartViewBase *)chartView;
- (void)toggleHighlight:(ChartViewBase *)chartView;
@end
