//
//  InfoAndKIChart.m
//  ChartsDemo
//
//  Created by NguyenVanTu on 4/12/17.
//  Copyright © 2017 dcg. All rights reserved.
//

#import "InfoAndKIChart.h"
#import "WYPopoverController.h"
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
#import "SOErrorView.h"

@interface InfoAndKIChart ()<ChartViewDelegate, IChartAxisValueFormatter, WYPopoverControllerDelegate, SOErrorViewDelegate>
{
    NSMutableArray *_kiInfo;
    NSMutableArray *_payInfoItems;
    WYPopoverController *settingsPopoverController;
    ChartXAxis *xAxisScore;
    SOErrorView *_errorView;

    TTNS_InfoAndKiComtroller *_ttns_InfoAndKiComtroller;
}
@property (weak, nonatomic) IBOutlet BarChartView *incomeChart;
@property (weak, nonatomic) IBOutlet BarChartView *scoreChart;
@property (weak, nonatomic) IBOutlet UIButton *btn_BackIncome;
@property (weak, nonatomic) IBOutlet UIButton *btn_NextIncome;
@property (weak, nonatomic) IBOutlet UIButton *btn_BackKI;
@property (weak, nonatomic) IBOutlet UIButton *btn_NextKI;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation InfoAndKIChart

- (IBAction)back:(id)sender {
    [self popToIntegrationRoot];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backTitle = LocalizedString(@"Thông tin lương và KI");
    [self setupForIncomeChart];
    [self setupForScoreChart];
    [self animationCharts];
    [self addSwipeGesture];

    [self setStateForButtons:[_ttns_InfoAndKiComtroller getIncomeDate]];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([Common checkNetworkAvaiable]) {
        [self loadData];
    }else
    {
        [self addErrorView:LocalizedString(@"Mất kết nối mạng")];
    }
}
#pragma mark SOErrorViewDelegate
- (void)didRefreshOnErrorView:(SOErrorView *)errorView
{
    if ([Common checkNetworkAvaiable]) {
        [self loadData];
    }
    
}
- (void)loadData
{
    self.containerView.hidden = NO;
    _errorView.hidden = YES;
    [self loadKiInfo];
    [self loadPayInfo];
}
- (void)addErrorView:(NSString *)content
{
    self.containerView.hidden = YES;
    if (!_errorView) {
        [self addNoNetworkView];
    }
    else
    {
        [_errorView setHidden:NO];
    }
    [_errorView setErrorInfo:content];
}
- (void)addNoNetworkView
{
    [self.view addSubview:[self getErrorView]];
}
- (SOErrorView *)getErrorView
{
    
    _errorView = [[SOErrorView alloc] initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height - 70) inforError:nil];
    [_errorView setBackgroundColor:[UIColor clearColor]];
    _errorView.delegate = self;
    return _errorView;
}
- (void)setStateForButtons:(InfoAndKiDateModel *)payDate
{
    if (payDate.currentYear < [NSDate getCurrentYear]) {
        [_btn_NextIncome setEnabled:YES];
    }
    else if (payDate.currentMonth < [NSDate getCurrentMonth]) {
        [_btn_NextIncome setEnabled:YES];
    }
    else
    {
        [_btn_NextIncome setEnabled:NO];
    }
}
- (void)initValues
{
    _ttns_InfoAndKiComtroller = [[TTNS_InfoAndKiComtroller alloc] init];
    InfoAndKiDateModel *payDate = [[InfoAndKiDateModel alloc] initWith:[NSDate getMonth:[NSDate dateWithTimeIntervalSince1970:self.latestPayDate/1000]] monthTotal:[NSDate getMonth:[NSDate dateWithTimeIntervalSince1970:self.latestPayDate/1000]] currentYear:[NSDate getYear:[NSDate dateWithTimeIntervalSince1970:self.latestPayDate/1000]]];
    [_ttns_InfoAndKiComtroller setPayDate:payDate];
    [_ttns_InfoAndKiComtroller initValues];
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
                [self handleErrorFromResult:nil withException:[NSException initWithString:LocalizedString(@"Không tìm thấy kết quả")] inView:self.kiView];
            }
        }
        else
        {
            if (exception) {
                [self handleErrorFromResult:nil withException:exception inView:self.kiView];
                return ;
            }
            [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.kiView];
        }
        
    }];
}
- (void)loadPayInfo
{
    [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
    [TTNS_InfoAndKiComtroller getPay:[_ttns_InfoAndKiComtroller getDateIncome].firstObject toDate:[_ttns_InfoAndKiComtroller getDateIncome].lastObject completion:^(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error) {
        [self dismissHub];
        [_payInfoItems removeAllObjects];
        if (success) {
            if ([resultArray isKindOfClass:[NSArray class]]) {
                _payInfoItems = [TTNS_PayInfoModel arrayOfModelsFromDictionaries:resultArray error:nil];
            }
            [self setDataForChartCount:[_ttns_InfoAndKiComtroller getIncomeDate].currentMonth > [_ttns_InfoAndKiComtroller getTotalBarInChart] ? [_ttns_InfoAndKiComtroller getTotalBarInChart] : [_ttns_InfoAndKiComtroller getIncomeDate].currentMonth range:24 chartType:ChartType_Income];
            if (_payInfoItems.count == 0) {
                [self handleErrorFromResult:nil withException:[NSException initWithString:LocalizedString(@"Không tìm thấy kết quả")] inView:self.incomeView];
            }
        }
        else
        {
            if (exception) {
                [self handleErrorFromResult:nil withException:exception inView:self.incomeView];
                return ;
            }
            [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.incomeView];
        }
    }];
}
- (void)addSwipeGesture
{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeIncomeView:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeIncomeView:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [self.incomeView addGestureRecognizer:swipeLeft];
    [self.incomeView addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeLeftKIView = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeKIView:)];
    UISwipeGestureRecognizer *swipeRightKIView = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeKIView:)];
    
    // Setting the swipe direction.
    [swipeLeftKIView setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRightKIView setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [self.kiView addGestureRecognizer:swipeLeftKIView];
    [self.kiView addGestureRecognizer:swipeRightKIView];
}
- (void)handleSwipeKIView:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self nextScoreChart];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self backScoreChart];
    }
    
}
- (void)handleSwipeIncomeView:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self nextInComeChart];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self backInComeChart];
    }
    
}
- (void)backInComeChart {
    if(![self checkBack:ChartType_Income])
    {
        [self disableButton:self.btn_BackIncome];
        return;
    }
    if(self.btn_NextIncome.enabled == NO)
    {
        [self enableButton:self.btn_NextIncome];
    }
    [_btn_BackIncome setEnabled:[_ttns_InfoAndKiComtroller checkAvailableYear:ActionType_Back chartType:ChartType_Income]];
}
- (void)nextInComeChart {
    
    if(![self checkNext:ChartType_Income]) //we will change stament when we get real data
    {
        [self disableButton:self.btn_NextIncome];
        return;
    }
    if(self.btn_BackIncome.enabled == NO)
    {
        [self enableButton:self.btn_BackIncome];
    }
    [_btn_NextIncome setEnabled:[_ttns_InfoAndKiComtroller checkAvailableYear:ActionType_Next chartType:ChartType_Income]];
}

- (void)backScoreChart {
    if(![self checkBack:ChartType_Ki])
    {
        [self disableButton:self.btn_BackKI];
        return;
    }
    if(self.btn_NextKI.enabled == NO)
    {
        [self enableButton:self.btn_NextKI];
    }
    [_btn_BackKI setEnabled:[_ttns_InfoAndKiComtroller checkAvailableYear:ActionType_Back chartType:ChartType_Ki]];
}
- (void)nextScoreChart {
    if(![self checkNext:ChartType_Ki])
    {
        [self disableButton:self.btn_NextKI];
        return;
    }
    if(self.btn_BackKI.enabled == NO)
    {
        [self enableButton:self.btn_BackKI];
    }
    [_btn_NextKI setEnabled:[_ttns_InfoAndKiComtroller checkAvailableYear:ActionType_Next chartType:ChartType_Ki]];
}
- (void)updateChart:(ChartType)type
{
    switch (type) {
        case ChartType_Income:
            [self loadPayInfo];
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
- (void)showInComeDetailAt:(CGPoint)position
                     yVals:(id)yVals
                     index:(NSInteger)index
             isInComeChart:(BOOL)isInComeChart
{
    if (isInComeChart) {
        InComeDetailInfoAndKi *incomeDetail = NEW_VC_FROM_NIB(InComeDetailInfoAndKi, @"InComeDetailInfoAndKi");
        [incomeDetail setDataForView:yVals];
        incomeDetail.preferredContentSize = CGSizeMake(240, 155);
        NSNumber *timestamp = [_ttns_InfoAndKiComtroller getDateIncome][index];
        NSString *stringToShow = [_ttns_InfoAndKiComtroller convertTimeStampToDateStr:[timestamp doubleValue]];
        [incomeDetail setTitleForView:stringToShow];
        incomeDetail.modalInPopover = NO;
        settingsPopoverController = [[WYPopoverController alloc] initWithContentViewController:incomeDetail];
    }
    else
    {
        KiDetailInfoAndKi *kiDetail = NEW_VC_FROM_NIB(KiDetailInfoAndKi, @"KiDetailInfoAndKi");
        kiDetail.preferredContentSize = CGSizeMake(150, 80);
        NSNumber *timestamp = [_ttns_InfoAndKiComtroller getDateScore][index];
        NSString *stringToShow = [_ttns_InfoAndKiComtroller convertTimeStampToDateStr:[timestamp doubleValue]];
        [kiDetail setTitle:stringToShow ki:[NSString stringWithFormat:@"%ld", [yVals longValue]]];
        kiDetail.modalInPopover = NO;
        settingsPopoverController = [[WYPopoverController alloc] initWithContentViewController:kiDetail];
    }
    
    
    settingsPopoverController.delegate = self;
    settingsPopoverController.passthroughViews = @[self];
    settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    settingsPopoverController.wantsDefaultContentAppearance = NO;
    [settingsPopoverController presentPopoverFromRect:CGRectMake(position.x, position.y, 20, 20)
                                               inView:self.view
                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                             animated:YES
                                              options:WYPopoverAnimationOptionFadeWithScale];
    
}
- (void)resetHighLightValuesForAllCharts
{
    [_incomeChart highlightValues:NULL];
    [_scoreChart highlightValues:NULL];
}
- (void)animationCharts
{
    [_incomeChart animateWithXAxisDuration:1.4 yAxisDuration:1.4];
    [_scoreChart animateWithXAxisDuration:1.4 yAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
}
- (void)setupForIncomeChart
{
    [self setupDefaultForChart:_incomeChart chartType: ChartType_Income];
    
}

- (void)setupForScoreChart
{
    [self setupDefaultForChart:_scoreChart chartType: ChartType_Ki];
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
- (NSMutableArray*)generateScoreValues:(NSInteger)count
{
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (NSInteger i = count - 1; i >= 0; i--)
    {
        NSString *month = [_ttns_InfoAndKiComtroller convertTimeStampToDateStr:[[_ttns_InfoAndKiComtroller getDateScore][i] doubleValue]];
        TTNS_KiInfoModel *validedModel = [self checkValidKiInfoMonth:month data:_kiInfo];
        if (validedModel) {
            [yVals addObject:[[BarChartDataEntry alloc] initWithX:count-1-i y:[validedModel.empKiPoint doubleValue] text: validedModel.emp_ki]];
            [_ttns_InfoAndKiComtroller addColorWithGrade:validedModel.emp_ki at:i];
        }
        else
        {
            [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:0 text:@""]];
        }
        
    }
    
    return yVals;
    
}
- (NSMutableArray*)generateIncomeValues:(NSInteger)count
{
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < count; i++)
    {
        double totalPeriod = [TTNS_InfoAndKiComtroller getTotalWithItems:_payInfoItems type:IncomeType_Period date:[_ttns_InfoAndKiComtroller getDateIncome][i]];
        double totalSXKD = [TTNS_InfoAndKiComtroller getTotalWithItems:_payInfoItems type:IncomeType_SXKD date:[_ttns_InfoAndKiComtroller getDateIncome][i]];
        double totalOther = [TTNS_InfoAndKiComtroller getTotalWithItems:_payInfoItems type:IncomeType_Other date:[_ttns_InfoAndKiComtroller getDateIncome][i]];
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:i yValues:@[@(totalPeriod), @(totalOther), @(totalSXKD)] icon: nil]];
    }
    return yVals;
    
}

- (void)setDataForChartCount:(NSInteger)count
                       range:(double)range
                   chartType:(ChartType)chartType{
    
    NSMutableArray *yVals = chartType == ChartType_Income ? [self generateIncomeValues:count] : [self generateScoreValues:count];
    BarChartView *currentChart = (chartType == ChartType_Income ? _incomeChart:_scoreChart);
    switch (chartType) {
        case ChartType_Income:
            [self setValueForIncomeChart:currentChart andyValues:yVals];
            break;
            
        default:
            [self setValueForScoreChart:currentChart andyValues:yVals];
            break;
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
- (void)setValueForIncomeChart:(BarChartView*)chartView andyValues:(NSMutableArray*)yVals
{
    BarChartDataSet *set = [[BarChartDataSet alloc] initWithValues:yVals label:@""];
    set.drawIconsEnabled = NO;
    set.drawValuesEnabled = NO;
    set.colors = [_ttns_InfoAndKiComtroller getIncomeColors];
    
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

#pragma mark - IBAction
- (IBAction)actionBackInComeChart:(UIButton *)sender {
    [self backInComeChart];
}
- (IBAction)actionNextInComeChart:(UIButton *)sender {
    [self nextInComeChart];
}

- (IBAction)actionBackScoreChart:(UIButton *)sender {
    [self backScoreChart];
}
- (IBAction)actionNextScoreChart:(UIButton *)sender {
    [self nextScoreChart];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    BarChartDataEntry *currentEntry = (BarChartDataEntry *)entry;
    DLog(@"chartValueSelected");
    [self addPopoverAt:[chartView convertPoint:CGPointMake(highlight.xPx, highlight.yPx) toView:self.view] yVals:(currentEntry.yValues == nil ? [NSNumber numberWithDouble:currentEntry.y] : currentEntry.yValues) index:currentEntry.x isInComeChart:chartView == _incomeChart];
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    [self close:nil];
    DLog(@"chartValueNothingSelected");
}
#pragma mark - IAxisValueFormatter

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    NSNumber *timestamp = (axis == xAxisScore ? [_ttns_InfoAndKiComtroller getDateScore][(NSInteger)value] : [_ttns_InfoAndKiComtroller getDateIncome][(NSInteger)value]);
    NSString *stringToShow = [_ttns_InfoAndKiComtroller convertTimeStampToDateStr:[timestamp doubleValue]];
    return stringToShow;
}



#pragma mark -addPopOver
- (void)addPopoverAt:(CGPoint)position yVals:(id)yVals index:(NSInteger)index isInComeChart:(BOOL)isInComeChart{
    [self close:^{
        [self showInComeDetailAt:position yVals:yVals index:index isInComeChart:isInComeChart];
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
    DLog(@"popoverControllerDidPresentPopover");
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
