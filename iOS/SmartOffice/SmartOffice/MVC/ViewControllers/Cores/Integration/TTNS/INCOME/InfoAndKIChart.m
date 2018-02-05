//
//  InfoAndKIChart.m
//  ChartsDemo
//
//  Created by NguyenVanTu on 4/12/17.
//  Copyright © 2017 dcg. All rights reserved.
//

#import "InfoAndKIChart.h"
#import "WYPopoverController.h"
#import "InComeDetail.h"

typedef enum {
    Income = 0,
    Score
} ChartType;

@interface InfoAndKIChart ()<ChartViewDelegate, IChartAxisValueFormatter, WYPopoverControllerDelegate>
{
    NSArray<NSString *> *months;
    WYPopoverController *settingsPopoverController;
}
@property (weak, nonatomic) IBOutlet BarChartView *incomeChart;
@property (weak, nonatomic) IBOutlet BarChartView *scoreChart;

@end

@implementation InfoAndKIChart

- (IBAction)back:(id)sender {
    [self popToRoot];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    months = @[
               @"1/2016", @"2/2016", @"3/2016",
               @"4/2016", @"5/2016", @"6/2016",
               @"7/2016", @"8/2016", @"9/2016",
               @"10/2016", @"11/2016", @"12/2016"
               ];
    [self setupForIncomeChart];
    [self setupForScoreChart];
    [self animationCharts];
}
- (void)showInComeDetailAt:(CGPoint)position
{
    InComeDetail *incomeDetail = [[InComeDetail alloc] initWithNibName:@"InComeDetail" bundle:nil];
    incomeDetail.preferredContentSize = CGSizeMake(240, 200);
    
    incomeDetail.title = @"Thông tin lương";
    //
    //        [settingsViewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"change" style:UIBarButtonItemStylePlain target:self action:@selector(change:)]];
    
    //        [settingsViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)]];
    
    incomeDetail.modalInPopover = NO;
    
    UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:incomeDetail];
    
    settingsPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
    settingsPopoverController.delegate = self;
    settingsPopoverController.passthroughViews = @[self];
    settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    settingsPopoverController.wantsDefaultContentAppearance = NO;
    
    //        if (sender == dialogButton)
    //        {
    //                    [settingsPopoverController presentPopoverAsDialogAnimated:YES
    //                                                                      options:WYPopoverAnimationOptionFadeWithScale];
    //        }
    //        else
    //        {
    [settingsPopoverController presentPopoverFromRect:CGRectMake(position.x, position.y, 20, 20)
                                               inView:self.view
                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                             animated:YES
                                              options:WYPopoverAnimationOptionFadeWithScale];
    //        }
}
- (void)resetHighLightValuesForAllCharts
{
    [_incomeChart highlightValues:NULL];
    [_scoreChart highlightValue:NULL];
}
- (void)animationCharts
{
    [_incomeChart animateWithXAxisDuration:1.4 yAxisDuration:1.4];
    [_scoreChart animateWithXAxisDuration:1.4 yAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
}
- (void)setupForIncomeChart
{
    [self setupDefaultForChart:_incomeChart chartType: Income];
    [self setDataForChartCount:4 range:24 chartType:Income];
    
}

- (void)setupForScoreChart
{
    [self setupDefaultForChart:_scoreChart chartType: Score];
    [self setDataForChartCount:4 range:150 chartType:Score];
    
}
- (void)setupDefaultForChart:(BarChartView*)chartView
                   chartType:(ChartType)chartType
{
    chartView.delegate = self;
    chartView.rightAxis.enabled = NO;
    chartView.chartDescription.enabled = NO;
    chartView.dragEnabled = NO;
    chartView.pinchZoomEnabled = NO;
    chartView.drawGridBackgroundEnabled = NO;
    chartView.drawBarShadowEnabled = NO;
    chartView.drawValueAboveBarEnabled = NO;
    chartView.highlightFullBarEnabled = NO;
    
    if(chartType == Score)
    {
        chartView.drawCustomText = YES;
    }
    NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
    leftAxisFormatter.maximumFractionDigits = 1;
    
    ChartYAxis *leftAxis = chartView.leftAxis;
    leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
    leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    
    ChartXAxis *xAxis = chartView.xAxis;
    
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.axisMinimum = -0.8;
    xAxis.granularity = 1.0;
    xAxis.labelCount = 7;
    xAxis.valueFormatter = self;
    xAxis.drawGridLinesEnabled = NO; //remove vertical line
    
    
    
    chartView.legend.enabled = false;
}

- (NSMutableArray*)generateScoreSampleValue:(int)count range:(double)range
{
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double mult = (range + 1);
        double val = (double) (arc4random_uniform(mult)) + mult / 3.0;
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:val]];
    }
    
    return yVals;
    
}
- (NSMutableArray*)generateIncomeSampleValue:(int)count range:(double)range
{
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double mult = range ;
        double val1 = (double) (arc4random_uniform(mult) + mult / 3);
        double val2 = (double) (arc4random_uniform(mult) + mult / 3);
        double val3 = (double) (arc4random_uniform(mult) + mult / 3);
        
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:i yValues:@[@(val1), @(val2), @(val3)] icon: [UIImage imageNamed:@"icon"]]];
    }
    
    return yVals;
    
}
- (BarChartDataSet *)setDefaultDataCount:(NSMutableArray *)yVals andChartView:(BarChartView *)chartView
{
    BarChartDataSet *set = (BarChartDataSet *)_scoreChart.data.dataSets[0];
    set.values = yVals;
    [chartView.data notifyDataChanged];
    [chartView notifyDataSetChanged];
    return set;
}
- (void)setDataForChartCount:(int)count
                            range:(double)range
                        chartType:(ChartType)chartType{
    NSMutableArray *yVals = chartType == Income ? [self generateIncomeSampleValue:count range:range] : [self generateScoreSampleValue:count range:range];
    BarChartDataSet *set1 = nil;
    BarChartView *currentChart = (chartType == Income ? _incomeChart:_scoreChart);
    if (_scoreChart.data.dataSetCount > 0)
    {
        set1 = [self setDefaultDataCount:yVals andChartView:currentChart];
    }
    else
    {
        switch (chartType) {
            case Income:
                [self setValueForIncomeChart:currentChart andyValues:yVals];
                break;
                
            default:
                [self setValueForScoreChart:currentChart andyValues:yVals];
                break;
        }
    }
}
- (void)setValueForScoreChart:(BarChartView*)chartView andyValues:(NSMutableArray*)yVals
{
    BarChartDataSet *set = [[BarChartDataSet alloc] initWithValues:yVals label:@""];
    set.colors = @[UIColorFromRGB(0x00b253),
                   UIColorFromRGB(0xf05253),
                   UIColorFromRGB(0x109bdc),
                   UIColorFromRGB(0xff9000)];
    set.drawValuesEnabled = YES;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set];
    
    BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
    data.barWidth = 0.25;
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.f]];
    [data setValueTextColor:UIColor.whiteColor];
    chartView.data = data;
    chartView.fitBars = YES;
    [chartView layoutIfNeeded];
}
- (void)setValueForIncomeChart:(BarChartView*)chartView andyValues:(NSMutableArray*)yVals
{
    BarChartDataSet *set = [[BarChartDataSet alloc] initWithValues:yVals label:@""];
    set.drawIconsEnabled = NO;
    set.drawValuesEnabled = NO;
    set.colors = @[UIColorFromRGB(0xff9000), UIColorFromRGB(0x6fddd2), UIColorFromRGB(0x109bdc)];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.maximumFractionDigits = 1;
    //    formatter.negativeSuffix = @" $";
    //    formatter.positiveSuffix = @" $";
    
    BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:7.f]];
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:formatter]];
    [data setValueTextColor:UIColor.whiteColor];
    data.barWidth = 0.25;
    chartView.fitBars = YES;
    chartView.data = data;
    [chartView layoutIfNeeded];
}
#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
    [self addPopoverAt:[chartView convertPoint:CGPointMake(highlight.xPx, highlight.yPx) toView:self.view]];
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    [self close:nil];
    NSLog(@"chartValueNothingSelected");
}
#pragma mark - IAxisValueFormatter

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    return months[(int)value % months.count];
}

#pragma mark -addPopOver
- (void)addPopoverAt:(CGPoint)position {
    [self close:^{
        [self showInComeDetailAt:position];
    }];
}
- (void)close:(void (^)(void))completion
{
    if(settingsPopoverController != nil)
    {
        [settingsPopoverController dismissPopoverAnimated:YES completion:^{
            [self popoverControllerDidDismissPopover:settingsPopoverController];
            if(completion)
            {
                completion();
            }
        }];
    }
    else
    {
        if(completion)
        {
            completion();
        }
    }
}



#pragma mark - WYPopoverControllerDelegate

- (void)popoverControllerDidPresentPopover:(WYPopoverController *)controller
{
    NSLog(@"popoverControllerDidPresentPopover");
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    if (controller == settingsPopoverController)
    {
        settingsPopoverController.delegate = nil;
        settingsPopoverController = nil;
        [self resetHighLightValuesForAllCharts];
    }
}

- (BOOL)popoverControllerShouldIgnoreKeyboardBounds:(WYPopoverController *)popoverController
{
    return YES;
}

- (void)popoverController:(WYPopoverController *)popoverController willTranslatePopoverWithYOffset:(float *)value
{
    // keyboard is shown and the popover will be moved up by 163 pixels for example ( *value = 163 )
    *value = 0; // set value to 0 if you want to avoid the popover to be moved
}
@end
