//
//  IncomeInfoVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 4/25/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "IncomeInfoVC_iPad.h"
#import "UIView+BorderView.h"
#import "ManagerInOutVC_iPad.h"
#import "CreateNewFormVC_iPad.h"
#import "TakeLeaveList_iPad.h"

#import "TTNS_InfoAndKiComtroller.h"

#import "InComeDetailInfoAndKi.h"
#import "TTNS_KiInfoModel.h"
#import "NSException+Custom.h"
#import "TTNS_PayInfoModel.h"
#import "NSDate+Utilities.h"
#import "NSString+StringToDate.h"
#import "InfoAndKiDateModel.h"
#import "KiDetailInfoAndKi.h"
#import "Common.h"


#import <Charts/Charts.h>
#import "ListRegisterFormVC.h"
#import "InfoHumanCell.h"
#import "ProcessTimeKeeping.h"
#import "InComeDetail.h"
#import "TimeKeepingCalendarDetail.h"
#import "InfoAndKIChart.h"
#import "NormalCheckOut.h"
#import "RegisterList.h"
#import "WorkNoDataView.h"
#import "TTNS_TimeKeepingCalendarDetailController.h"
#import "NSDictionary+RangeOfMonth.h"
#import "NSDate+Utilities.h"
#import "SOErrorView.h"
#import "NSException+Custom.h"
#import "GlobalObj.h"
#import "TTNS_PayInfoModel.h"






@interface IncomeInfoVC_iPad ()<ChartViewDelegate>{
@protected NSArray *parties;
    
    ChartXAxis *xAxisScore;
    TTNS_InfoAndKiComtroller *_ttns_InfoAndKiComtroller;
    
    
    NSDictionary *_distanceMonth;

    
    
    
}

@end

@implementation IncomeInfoVC_iPad

#pragma mark LifeCycler
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _distanceMonth = [NSDictionary getRangeOfMonthWith:0];

    
    
    
    [self setupArr];
    [self setupUI];
    
    [self.chartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];    
    [self setupForIncomeChart];
    [self animationCharts];
    [self initValues];
    
    
    //setupPieChartView
    //updateDataForTimeKeepingChart
    
    [self updateDataForInComeChart:nil];

    
    
    
    [self loadPayInfo];

    
}

#pragma mark UI
-(void)setupUI{
    [self setupTitleForLB];
    [self setupBorderForView];
    //    [self addLayoutForButton];
}

- (void)setupTitleForLB{
    self.inComeInfoLB.text          = LocalizedString(@"Thông tin thu nhập");
    self.luongKiLB.text             = LocalizedString(@"Lương kì 01");
    self.luongSXKDLB.text           = LocalizedString(@"Lương SXKD");
    self.luongkhacLB.text           = LocalizedString(@"Lương khác");
    self.donViTinhLB.text           = LocalizedString(@"Đơn vị tính");
}

- (void)setupBorderForView{
    [self.bottomView setBorderWithShadow:1 cornerRadius:0];
    [self.contentView setBorderWithShadow:1 cornerRadius:0];
}

-(void)hiddenViewWhenError {
    [self.chartView setHidden:YES];
    [self.centerChartView setHidden:YES];
    [self.countLuongLB setHidden:YES];
    [self.countLuongKhacLB setHidden:YES];
    [self.countLuongSXDKDLB setHidden:YES];
}

-(void)setChartColorIfNil {
    _chartView.backgroundColor = AppColor_MainAppTintColor;
}
#pragma mark : - UI FOR CHART

- (void)addLayoutForButton{
    if(self.view.bounds.size.height <= SCREEN_HEIGHT_LANDSCAPE*0.6){
        NSLayoutConstraint *height = [NSLayoutConstraint
                                      constraintWithItem:self.centerChartView
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.chartView
                                      attribute:NSLayoutAttributeHeight
                                      multiplier:0.5
                                      constant:0];
        
        NSLayoutConstraint *width  = [NSLayoutConstraint
                                      constraintWithItem:self.centerChartView
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.centerChartView attribute:
                                      NSLayoutAttributeHeight multiplier:1
                                      constant:0];
        
        [self.view addConstraints:@[width, height]];
    } else {
        NSLayoutConstraint *width   = [NSLayoutConstraint
                                       constraintWithItem:self.centerChartView
                                       attribute:NSLayoutAttributeWidth
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:self.chartView
                                       attribute:NSLayoutAttributeWidth
                                       multiplier:0.6
                                       constant:-25];
        
        
        
        NSLayoutConstraint *height  = [NSLayoutConstraint
                                       constraintWithItem:self.centerChartView
                                       attribute:NSLayoutAttributeHeight
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:self.centerChartView attribute:
                                       NSLayoutAttributeWidth multiplier:1
                                       constant:0];
        [self.view addConstraints:@[width, height]];
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    // Button in center
//    [self setupButtonCenterChart:self.centerChartView with:@"Tháng\n12"];
    [self addLayoutForButton];
}

- (void)setupArr{
    parties     = @[
                    @"Sun", @"", @"Mon", @"Tue", @"Web", @"Thu", @"Fri", @"Sat"
                    ];
}

// Setup Pie Chart ( 5 Element )
- (void)setupPieChartView:(PieChartView *)chartView{
    //
    chartView.drawEntryLabelsEnabled                = NO;
    chartView.usePercentValuesEnabled               = NO;
    chartView.drawSlicesUnderHoleEnabled            = NO;
    chartView.holeRadiusPercent = 0.6;
    chartView.transparentCircleRadiusPercent        = 0;
    chartView.chartDescription.enabled              = NO; // Show Description Label
    [chartView setExtraOffsetsWithLeft:0 top:0 right:0 bottom:0];
    chartView.delegate                              = self;
    NSMutableParagraphStyle *paragraphStyle         = [[NSParagraphStyle defaultParagraphStyle]mutableCopy];
    paragraphStyle.lineBreakMode                    = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment                        = NSTextAlignmentCenter;
    chartView.drawHoleEnabled                       = YES;
    chartView.rotationAngle                         = 0.0;
    chartView.rotationEnabled                       = YES;
    chartView.highlightPerTapEnabled                = YES;
    chartView.rotationEnabled                       = NO;
    ChartLegend *l                                  = chartView.legend;
    l.horizontalAlignment                           = ChartLegendHorizontalAlignmentRight;
    l.verticalAlignment                             = ChartLegendVerticalAlignmentTop;
    l.orientation                                   = ChartLegendOrientationVertical;
    l.drawInside                                    = NO;
    l.xEntrySpace                                   = 7.0;
    l.yEntrySpace                                   = 0.0;
    l.yOffset                                       = 0.0;
    
    chartView.legend.enabled                        = NO; // Hide comment chart
    
    
}

//- (void)updateChartData:(PieChartView *)chartView{
//    [self.chartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
//    [self setDataCount:3 range:100 charView:self.chartView]; // 3 children in Chart
//}

- (void)setDataCount:   (NSInteger)count
               range:(double)range
            chartView:(PieChartView*)chartView{
    
    double mult                     = range;
    NSMutableArray *values          = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++){
        [values addObject:[[PieChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 4) label:parties[i % parties.count] icon: [UIImage imageNamed:@"icon"]]];
    }
    
    PieChartDataSet *dataSet        = [[PieChartDataSet alloc] initWithValues:values label:@"Election Results"];
    dataSet.drawIconsEnabled        = NO;
    dataSet.selectionShift          = 0;
    dataSet.sliceSpace              = 3.0;
    dataSet.iconsOffset             = CGPointMake(0, 40);
    dataSet.drawValuesEnabled       = NO;
    // add a lot of colors
    
    NSMutableArray *colors = [self getColor];
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    chartView.data = data;
    [chartView highlightValues:nil];
}

- (NSMutableArray *)getColor{
    NSMutableArray *colors = [[NSMutableArray alloc]init];
    [colors addObject:CommonColor_Blue];
    [colors addObject:CommonColor_Orange];
    [colors addObject:CommonColor_Purple];
    //    [colors addObject:CommonColor_Gray];
    //    [colors addObject:CommonColor_LightGray];
    
    return colors;
}

// VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

- (void)setupForIncomeChart
{
    [self setupPieChartView:_chartView];
}

-(void)animationCharts {
    [self.chartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    [self setDataCount:3 range:100 chartView:self.chartView]; // 3 children in Chart}
}

- (void)initValues
{
    _ttns_InfoAndKiComtroller = [[TTNS_InfoAndKiComtroller alloc] init];
    [_btn_NextIncome setEnabled:NO];
}

- (void)loadPayInfo
{
    __block NSArray *_payInfoItems;

    [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
    [TTNS_InfoAndKiComtroller getPay:[_ttns_InfoAndKiComtroller getDateIncome].firstObject toDate:[_ttns_InfoAndKiComtroller getDateIncome].lastObject completion:^(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error) {
        [self dismissHub];
        if (success) {
            if ([resultArray isKindOfClass:[NSArray class]]) {
                _payInfoItems = [TTNS_PayInfoModel arrayOfModelsFromDictionaries:resultArray error:nil];
            }
            [self setDataCount:[_ttns_InfoAndKiComtroller getIncomeDate].currentMonth > [_ttns_InfoAndKiComtroller getTotalBarInChart] ? [_ttns_InfoAndKiComtroller getTotalBarInChart] : [_ttns_InfoAndKiComtroller getIncomeDate].currentMonth range:1000 chartView:_chartView];
            
            [self updateDataForInComeChart:_payInfoItems];
            
            if (_payInfoItems.count == 0) {
                [self handleErrorFromResult:nil withException:[NSException initWithString:LocalizedString(@"Không tìm thấy kết quả")] inView:_contentView];
            }
        }
        else
        {
            if (exception) {
                [self handleErrorFromResult:nil withException:exception inView:_contentView];
                return ;
            }
            [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:_contentView];
          //  [self hiddenViewWhenError];
          //  [self setChartColorIfNil];
        }
    }];
}

//- (NSMutableArray*)generateIncomeValues:(NSInteger)count
//{
//    NSMutableArray *yVals = [[NSMutableArray alloc] init];
//    for (NSInteger i = 0; i < count; i++)
//    {
//        double totalPeriod = [TTNS_InfoAndKiComtroller getTotalWithItems:_payInfoItems type:IncomeType_Period date:[_ttns_InfoAndKiComtroller getDateIncome][i]];
//        double totalSXKD = [TTNS_InfoAndKiComtroller getTotalWithItems:_payInfoItems type:IncomeType_SXKD date:[_ttns_InfoAndKiComtroller getDateIncome][i]];
//        double totalOther = [TTNS_InfoAndKiComtroller getTotalWithItems:_payInfoItems type:IncomeType_Other date:[_ttns_InfoAndKiComtroller getDateIncome][i]];
//        [yVals addObject:[[BarChartDataEntry alloc] initWithX:i yValues:@[@(totalOther), @(totalSXKD), @(totalPeriod)] icon: nil]];
//    }
//    return yVals;
//    
//}

- (void)updateDataForInComeChart:(NSArray *)payInCome
{
    [_chartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    [self setDataForInComeChart:payInCome];
    [self setDetailIncome:payInCome];
}

- (void)setDataForInComeChart:(NSArray *)payInfoItems
{
    NSMutableArray *values = [[NSMutableArray alloc] init];
    double totalPeriod = [TTNS_InfoAndKiComtroller getTotalWithItems:payInfoItems type:IncomeType_Period date:[_distanceMonth valueForKey:@"firstDay"]];
    double totalSXKD = [TTNS_InfoAndKiComtroller getTotalWithItems:payInfoItems type:IncomeType_SXKD date:[_distanceMonth valueForKey:@"firstDay"]];
    double totalOther = [TTNS_InfoAndKiComtroller getTotalWithItems:payInfoItems type:IncomeType_Other date:[_distanceMonth valueForKey:@"firstDay"]];
    double payTotal = totalOther + totalSXKD + totalPeriod;
    
    [values addObject:[[PieChartDataEntry alloc] initWithValue:totalPeriod == 0 ? 0 : (totalPeriod/payTotal) label:nil icon: nil]];
    [values addObject:[[PieChartDataEntry alloc] initWithValue:totalOther == 0 ? 0 : (totalOther/payTotal) label:nil icon: nil]];
    [values addObject:[[PieChartDataEntry alloc] initWithValue:totalSXKD == 0 ? 0 : (totalSXKD/payTotal) label:nil icon: nil]];
    if (payTotal != 0) {
        [values addObject:[[PieChartDataEntry alloc] initWithValue:0 label:nil icon: nil]];
    }
    else
    {
        [values addObject:[[PieChartDataEntry alloc] initWithValue:1 label:nil icon: nil]];
    }
    [self setDataForChart:values chartView:_chartView];
}

- (void)setDataForChart:(NSMutableArray *)values chartView:(PieChartView*)chartView
{
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"Election Results"];
    dataSet.drawIconsEnabled = NO;
    dataSet.drawValuesEnabled = NO;
    dataSet.selectionShift = 5;
    dataSet.sliceSpace = 2.0;
    dataSet.iconsOffset = CGPointMake(0, 40);
    // add a lot of colors
    
    NSMutableArray *colors = [self getColorWith];
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    chartView.data = data;
    [chartView highlightValues:nil];
}

-(void)setDetailIncome:(NSArray *)value {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    numberFormatter.locale = [NSLocale currentLocale];// this ensures the right separator behavior
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.usesGroupingSeparator = YES;
    [numberFormatter setGroupingSeparator:@"."];
    
    double totalOtherIncome = [value.firstObject doubleValue]*1000000;
    double totalSXKD = [value[(int)value.count/2] doubleValue]*1000000;
    double totalPeriod = [value.lastObject doubleValue]*1000000;
    
    _countLuongKhacLB.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithDouble:totalOtherIncome]]];
    _countLuongSXDKDLB.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithDouble:totalSXKD]]];
    _countLuongLB.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithDouble:totalPeriod]]];
}

- (NSMutableArray *)getColorWith
{
    NSMutableArray *colors = [[NSMutableArray alloc] init];

            [colors addObject:CommonColor_Blue];
            [colors addObject:CommonColor_Orange];
            [colors addObject:CommonColor_LightGreen];
            [colors addObject:CommonColor_LightGray];
  
    return colors;
}
// next - previous

- (BOOL)checkBack:(ChartType)chartType
{
    if (chartType == ChartType_Ki) {
        if ([_ttns_InfoAndKiComtroller getKiDate].currentMonth == 0 && [_ttns_InfoAndKiComtroller getKiDate].monthTotal && [_ttns_InfoAndKiComtroller getKiDate].currentYear) {
            return NO;
        }
        [_ttns_InfoAndKiComtroller updateKiDate:ActionType_Back chartType:chartType];
        //        _kiDate = [_ttns_InfoAndKiComtroller checkBack:chartType currentMonth:_kiDate.currentMonth monthTotal:_kiDate.monthTotal currentYear:_kiDate.currentYear];
        //        [_ttns_InfoAndKiComtroller addTimeslamp:_kiDate.currentMonth year:_kiDate.currentYear type:type actionType:ActionType_Back];
    }
    else
    {
        [_ttns_InfoAndKiComtroller updateIncomeDate:ActionType_Back chartType:chartType];
        //        _payDate = [_ttns_InfoAndKiComtroller checkBack:chartType currentMonth:_payDate.currentMonth monthTotal:_payDate.monthTotal currentYear:_payDate.currentYear];
        //        [_ttns_InfoAndKiComtroller addTimeslamp:_payDate.currentMonth year:_payDate.currentYear type:type actionType:ActionType_Back];
    }
    [self loadPayInfo];
    return YES;
}


- (BOOL)checkNext:(ChartType)chartType
{
    if (chartType == ChartType_Ki) {
        if (![_ttns_InfoAndKiComtroller checkAvailableYear:ActionType_Next chartType:chartType]) {
            return NO;
        }
        [_ttns_InfoAndKiComtroller updateKiDate:ActionType_Next chartType:chartType];
        //        _kiDate = [self checkNext:chartType currentMonth:_kiDate.currentMonth monthTotal:_kiDate.monthTotal currentYear:_kiDate.currentYear];
        //        [_ttns_InfoAndKiComtroller addTimeslamp:_kiDate.currentMonth year:_kiDate.currentYear type:type actionType:ActionType_Next];
    }
    else
    {
        if (![_ttns_InfoAndKiComtroller checkAvailableYear:ActionType_Next chartType:chartType]) {
            return NO;
        }
        [_ttns_InfoAndKiComtroller updateIncomeDate:ActionType_Next chartType:chartType];
        //        _payDate = [self checkNext:chartType currentMonth:_payDate.currentMonth monthTotal:_payDate.monthTotal currentYear:_payDate.currentYear];
        //        [_ttns_InfoAndKiComtroller addTimeslamp:_payDate.currentMonth year:_payDate.currentYear type:type actionType:ActionType_Next];
    }
    [self loadPayInfo];
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

- (void)backInComeChart {
    if(![self checkBack:ChartType_Income])
    {
        [self disableButton:self.btn_PreviousIncome];
        return;
    }
    if(self.btn_NextIncome.enabled == NO)
    {
        [self enableButton:self.btn_NextIncome];
    }
    [_btn_PreviousIncome setEnabled:[_ttns_InfoAndKiComtroller checkAvailableYear:ActionType_Back chartType:ChartType_Income]];
}
- (void)nextInComeChart {
    
    if(![self checkNext:ChartType_Income]) //we will change stament when we get real data
    {
        [self disableButton:self.btn_NextIncome];
        return;
    }
    if(self.btn_PreviousIncome.enabled == NO)
    {
        [self enableButton:self.btn_PreviousIncome];
    }
    [_btn_NextIncome setEnabled:[_ttns_InfoAndKiComtroller checkAvailableYear:ActionType_Next chartType:ChartType_Income]];
}


#pragma mark CHART DELEGATE
- (void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight{
    DLog(@"Chart Value Selected");
    
}

- (void)chartValueNothingSelected:(ChartViewBase *)chartView{
    DLog(@"Chart Value Nothing Selected");
}


#pragma mark IBAction
- (IBAction)quanLyNgiPhepAction:(id)sender {
    TakeLeaveList_iPad *vc = [[TakeLeaveList_iPad alloc] initWithNibName:@"TakeLeaveList_iPad" bundle:nil];
    [self pushIntegrationVC:vc];
}

- (IBAction)centerChartviewAction:(id)sender {
    DLog(@"center chart selected");
}

- (IBAction)arrowRightAction:(id)sender {
    [self nextInComeChart];
}

- (IBAction)arrowLeftAction:(id)sender {
    [self backInComeChart];
}
@end
