//
//  KIInfoVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 4/25/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "KIInfoVC_iPad.h"
#import "UIView+BorderView.h"
#import "ManagerInOutVC_iPad.h"

#import "InComeDetailInfoAndKi.h"
#import "TTNS_InfoAndKiComtroller.h"
#import "TTNS_KiInfoModel.h"
#import "NSException+Custom.h"
#import "TTNS_PayInfoModel.h"
#import "NSDate+Utilities.h"
#import "NSString+StringToDate.h"
#import "InfoAndKiDateModel.h"
#import "KiDetailInfoAndKi.h"
#import "Common.h"

@interface KIInfoVC_iPad ()<ChartViewDelegate, IChartAxisValueFormatter>{
//@protected NSArray *months;
//@protected int currentIndex;
    
    NSMutableArray *_kiInfo;
    ChartXAxis *xAxisScore;
    
    //   NSMutableArray *_dateStampScore;
    //    NSInteger _barTotalInChart;
    
//    InfoAndKiDateModel *_kiDate;
//    NSString *_dateFormat;
//    
//    NSMutableArray *_payColors;
//    NSMutableArray *_kiColors;
    
    //    NSMutableArray *_kiInfo;
    //    NSMutableArray *_payInfoItems;
    //    ChartXAxis *xAxisScore;
    
    TTNS_InfoAndKiComtroller *_ttns_InfoAndKiComtroller;
    
    
}

@end

@implementation KIInfoVC_iPad

#pragma mark Lifecycler

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupForScoreChart];
    [self setupUI];
    [self animationCharts];
    [self addSwipeGesture];
    [self initValues];
    [self loadKiInfo];
    
    
}

#pragma mark UI
- (void)setupUI{
    [self setupTitleForLB];
    [self setupBorderForView];
}

- (void)setupTitleForLB{
    self.kIInfoLB.text          = LocalizedString(@"Thông tin KI");
    self.pointLB.text           = LocalizedString(@"Điểm");
    self.monthLB.text           = LocalizedString(@"Tháng");
    self.managerInOutLB.text    = LocalizedString(@"K_INFO_HUMAN_VC_MANAGER_IN_OUT");
}

- (void)setupBorderForView{
    [self.bottomView setBorderWithShadow:1 cornerRadius:0];
    [self.contentView setBorderWithShadow:1 cornerRadius:0];
}

- (void)initValues {
    
    _ttns_InfoAndKiComtroller = [[TTNS_InfoAndKiComtroller alloc] init];
    [_rightButton setEnabled:NO];
}

- (void)animationCharts
{
    [_kIChartView animateWithXAxisDuration:1.4 yAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
}

- (NSInteger)getCurrentMonth
{
    return [NSDate getCurrentMonth];
}
- (NSInteger)getCurrentYear
{
    return [NSDate getCurrentYear];
}

- (NSInteger)getTotalDayOfMonth:(NSInteger)month year:(NSInteger)year
{
    return [NSDate getTotalDayOfMonth:month year:year];
}

- (void)loadKiInfo
{
    [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
    [TTNS_InfoAndKiComtroller getKiInfo:[GlobalObj getInstance].ttns_employID fromDate:[_ttns_InfoAndKiComtroller getDateScore].firstObject toDate:[_ttns_InfoAndKiComtroller getDateScore].lastObject completion:^(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error) {
        [self dismissHub];
        [_kiInfo removeAllObjects];
        if (success) {
            if ([resultArray isKindOfClass:[NSArray class]]) {
                _kiInfo = [TTNS_KiInfoModel arrayOfModelsFromDictionaries:resultArray error:nil];
            }
            [self setDataForChartCount:[_ttns_InfoAndKiComtroller getKiDate].currentMonth > [_ttns_InfoAndKiComtroller getTotalBarInChart] ? [_ttns_InfoAndKiComtroller getTotalBarInChart] : [_ttns_InfoAndKiComtroller getKiDate].currentMonth range:24 chartType:ChartType_Ki];
            if (_kiInfo.count == 0) {
                [self handleErrorFromResult:nil withException:[NSException initWithString:LocalizedString(@"Không tìm thấy kết quả")] inView:self.view];
            }
        }
        else
        {
            if (exception) {
                [self handleErrorFromResult:nil withException:exception inView:self.view];
                return ;
            }
            [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
        }
        
    }];
}

- (void)setDataForChartCount:(NSInteger)count
                       range:(double)range
                   chartType:(ChartType)chartType{
    
    NSMutableArray *yVals = chartType == ChartType_Ki ? [self generateScoreValues:count] : [self generateScoreValues:count]; //[self generateIncomeValues:count]
    BarChartView *currentChart = (chartType == ChartType_Ki ? _kIChartView:_kIChartView);
    switch (chartType) {
        case ChartType_Income:
         //   [self setValueForIncomeChart:currentChart andyValues:yVals];
            break;
            
        default:
            [self setValueForScoreChart:currentChart andyValues:yVals];
            break;
    }
}


- (NSMutableArray*)generateScoreValues:(NSInteger)count
{
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++)
    {
        NSString *month = [_ttns_InfoAndKiComtroller convertTimeStampToDateStr:[[_ttns_InfoAndKiComtroller getDateScore][i] doubleValue]];
        TTNS_KiInfoModel *validedModel = [self checkValidKiInfoMonth:month data:_kiInfo];
        if (validedModel) {
            [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:[validedModel.empKiPoint doubleValue] text: validedModel.emp_ki]];
            [_ttns_InfoAndKiComtroller addColorWithGrade:validedModel.emp_ki at:i];
        }
        else
        {
            [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:0 text:@""]];
        }
        
    }
    
    return yVals;
    
}


- (NSString *)convertTimeStampToDateStr:(double)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    return [date stringWithFormat:@"MM/yyyy"];
}

- (TTNS_KiInfoModel *)checkValidKiInfoMonth:(NSString *)month data:(NSArray *)data
{
    NSString *format = @"MM/yyyy";
    NSDate *date = [month convertStringToDateWith:format];
    for (int i = 0; i < data.count; i++) {
        NSDate *modelDate = [((TTNS_KiInfoModel *)data[i]).month_ki convertStringToDateWith:format];
        if (modelDate == date) {
            return (TTNS_KiInfoModel *)data[i];
        }
    }
    return nil;
}


#pragma mark UI FOR CHARTVIEW

- (void)setupForScoreChart
{
    [self setupDefaultForChart:_kIChartView chartType: ChartType_Ki];
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
    chartView.legend.enabled = false;
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
    
    
    if(chartType == ChartType_Ki)
    {
        chartView.drawCustomText = YES;
        xAxisScore = xAxis;
    }
}


- (void)setValueForScoreChart:(BarChartView*)chartView andyValues:(NSMutableArray*)yVals
{
    BarChartDataSet *set = [[BarChartDataSet alloc] initWithValues:yVals label:@""];
    set.colors = [_ttns_InfoAndKiComtroller getScoreColors];
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
#pragma mark IAxisValueFormatter


- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    NSNumber *timestamp = (axis == xAxisScore ? [_ttns_InfoAndKiComtroller getDateScore][(NSInteger)value] : [_ttns_InfoAndKiComtroller getDateIncome][(NSInteger)value]);
    NSString *stringToShow = [_ttns_InfoAndKiComtroller convertTimeStampToDateStr:[timestamp doubleValue]];
    return stringToShow;
}

// NEXT ();

- (void)addSwipeGesture
{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeKIView:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeKIView:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [self.contentView addGestureRecognizer:swipeLeft];
    [self.contentView addGestureRecognizer:swipeRight];
}

- (void)handleSwipeKIView:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self backScoreChart];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self backScoreChart];
    }
    
}
#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
    //    [self addPopoverAt:[chartView convertPoint:CGPointMake(highlight.xPx, highlight.yPx) toView:self.view]];
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    //    [self close:nil];
    NSLog(@"chartValueNothingSelected");
}


- (void)backScoreChart {
    if(![self checkBack:ChartType_Ki])
    {
        [self disableButton:self.leftButton];
        return;
    }
    if(self.rightButton.enabled == NO)
    {
        [self enableButton:self.rightButton];
    }
    [_leftButton setEnabled:[_ttns_InfoAndKiComtroller checkAvailableYear:ActionType_Back chartType:ChartType_Ki]];
}
- (void)nextScoreChart {
    if(![self checkNext:ChartType_Ki])
    {
        [self disableButton:self.rightButton];
        return;
    }
    if(self.leftButton.enabled == NO)
    {
        [self enableButton:self.leftButton];
    }
    [_rightButton setEnabled:[_ttns_InfoAndKiComtroller checkAvailableYear:ActionType_Next chartType:ChartType_Ki]];
}
- (void)updateChart:(ChartType)type
{
    switch (type) {
        case ChartType_Income:
            //  [self loadPayInfo];
            break;
        default:
            [self loadKiInfo];
            break;
    }
}

- (BOOL)checkBack:(ChartType)chartType
{
    if (chartType == ChartType_Ki) {
        if ([_ttns_InfoAndKiComtroller getKiDate].currentMonth == 0 && [_ttns_InfoAndKiComtroller getKiDate].monthTotal && [_ttns_InfoAndKiComtroller getKiDate].currentYear) {
            return NO;
        }
        [_ttns_InfoAndKiComtroller updateKiDate:ActionType_Back chartType:chartType];
    }
    else
    {
        [_ttns_InfoAndKiComtroller updateIncomeDate:ActionType_Back chartType:chartType];
    }
    [self updateChart:chartType];
    return YES;
}


- (BOOL)checkNext:(ChartType)chartType
{
    if (chartType == ChartType_Ki) {
        if (![_ttns_InfoAndKiComtroller checkAvailableYear:ActionType_Next chartType:chartType]) {
            return NO;
        }
        [_ttns_InfoAndKiComtroller updateKiDate:ActionType_Next chartType:chartType];
    }
    else
    {
        if (![_ttns_InfoAndKiComtroller checkAvailableYear:ActionType_Next chartType:chartType]) {
            return NO;
        }
        [_ttns_InfoAndKiComtroller updateIncomeDate:ActionType_Next chartType:chartType];
    }
    [self updateChart:chartType];
    return YES;
}

- (void)disableButton:(UIButton *)button
{
    button.enabled = NO;
    button.alpha = 0.3;
}
- (void)enableButton:(UIButton *)button
{
    button.enabled = YES;
    button.alpha = 1.0;
}


#pragma mark IBAction
- (IBAction)arrowRightAction:(id)sender {
    [self nextScoreChart];
}

- (IBAction)arrowLeftAction:(id)sender {
    [self backScoreChart];
}

- (IBAction)managerInOutAction:(id)sender {
    ManagerInOutVC_iPad *vc      = [[ManagerInOutVC_iPad alloc]initWithNibName:@"ManagerInOutVC_iPad" bundle:nil];
    [self pushIntegrationVC:vc];
}
@end
