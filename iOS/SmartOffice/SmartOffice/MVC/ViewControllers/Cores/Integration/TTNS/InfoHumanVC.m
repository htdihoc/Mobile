//
//  InfoHumanVC.m
//  SmartOffice
//
//  Created by Kaka on 4/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "InfoHumanVC.h"
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
#import "TTNS_InfoAndKiComtroller.h"
#import "TTNS_PayInfoModel.h"
#import "DismissTimeKeeping.h"
#import "NSString+Util.h"
#import "NSDate+Utilities.h"
typedef enum {
    InfoHuman_ChartType_Income = 0,
    InfoHuman_ChartType_TimeKeeping
} InfoHuman_ChartType;

@interface InfoHumanVC ()<ChartViewDelegate, UITableViewDataSource, UITableViewDelegate, SOErrorViewDelegate,TimeKeepingCalendarDetailDelegate>{
@protected NSArray *parties;
@protected NSArray *imgArr;
@protected NSArray *titleArr;
@protected NSString *dateCurrent;
@protected NSString *monthCurrent;
    TimeKeepingCalendarDetail *_timekeepingCalendar;
    NSDictionary *_distanceMonth;
    NSArray *_payInfoItems;
    BOOL _isLoaded;
    BOOL _check;
}

@property (weak, nonatomic) IBOutlet PieChartView *timeKeepingChart;

@property (weak, nonatomic) IBOutlet PieChartView *inComeChart;

@property (weak, nonatomic) IBOutlet UILabel *timeKeepingCount;

@property (weak, nonatomic) IBOutlet UILabel *inComeInMonth;

@property (weak, nonatomic) IBOutlet UIButton *btn_TimeKeepingType;

@property (nonatomic, assign) TimeKeepingType timeKeepingType;

@property (nonatomic, strong) ChartHighlight *lastHightLight;

@property (strong, nonatomic) TTNS_TimeKeepingCalendarDetailController *timekeepingController;
@end

@implementation InfoHumanVC

#pragma mark LifeCycler

- (void)viewDidLoad {
    [super viewDidLoad];
    _distanceMonth = [NSDictionary getRangeOfMonthWith:0];
    self.timekeepingController = [[TTNS_TimeKeepingCalendarDetailController alloc] init];
    self.timeKeepingType = TimeKeepingType_Base;
    [self setupArr];
    self.incomeLB.text = LocalizedString(@"KINFO_HUMAN_VC_INCOME_INFO");
    dateCurrent = [self getCurrentDate];
    monthCurrent = [self getCurrentMonth];
    
    // entry label styling
    [_timeKeepingChart animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    [self setupPieChartView:_timeKeepingChart type:InfoHuman_ChartType_TimeKeeping];
    [self updateDataForTimeKeepingChart];
    
    // Setup UI for InComeChart
    _inComeChart.entryLabelColor = UIColor.whiteColor;
    _inComeChart.entryLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    _inComeChart.chartDescription.enabled = YES;
    [_inComeChart animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    [self setupPieChartView:_inComeChart type:InfoHuman_ChartType_Income];
    [self updateDataForInComeChart:nil];
    [self addLayoutForButtons];
    
    [self reloadData];
    _timekeepingCalendar = NEW_VC_FROM_NIB(TimeKeepingCalendarDetail, @"TimeKeepingCalendarDetail");
    _timekeepingCalendar.delegate = self;
//    [_timekeepingCalendar setTimekeepingController:_timekeepingController];
}
- (void)reloadData
{
    [self getListTimeKeeping:0];
    [self loadPayInfo];
}
#pragma API process
- (void)loadPayInfo
{
    [[Common shareInstance] showCustomTTNSHudInView:self.view];
//    [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
    [TTNS_InfoAndKiComtroller getPayLatest:^(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error) {
//        [self dismissHub];
        [[Common shareInstance] dismissTTNSCustomHUD];
        if (success) {
            if ([resultArray isKindOfClass:[NSArray class]]) {
                _payInfoItems = [TTNS_PayInfoModel arrayOfModelsFromDictionaries:resultArray error:nil];
                [self setupIncomtMonthLabel];
            }
            [self updateDataForInComeChart:_payInfoItems];
            [self.delegate setDataForView:_payInfoItems];
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

- (void)getListTimeKeeping:(NSInteger)increseMonth
{
    //call API
    //    NSDictionary *params = @{@"employee_id":@41652, @"manager_id":@41652, @"from_time":@1493596800000, @"to_time":@1496188800000};
    //params here
    [[Common shareInstance] showCustomTTNSHudInView:self.view];
    NSDictionary *rangeOfMonth = [NSDictionary getRangeOfMonthWith:increseMonth];
    [self.timekeepingController loadData:[GlobalObj getInstance].ttns_employID managerID:[GlobalObj getInstance].ttns_managerID fromTime:[rangeOfMonth valueForKey:@"firstDay"] toTime:[rangeOfMonth valueForKey:@"lastDay"] completion:^(BOOL success, NSArray *resultArray, NSException *exception, BOOL isConnectNetwork, NSDictionary *error) {
        [[Common shareInstance] dismissAllTTNSCustomHUB];
        _isLoaded = YES;
        [_timekeepingCalendar reloadData];
//        if (exception) {
//            [self handleErrorFromResult:nil withException:exception inView:self.view];
//            return ;
//        }
        if (success) {
            if (_timekeepingCalendar.increseMonth == 0) {
                [self.timekeepingController setCurrentTotalTimeKeeping];
                self.countLB.text = [self.timekeepingController currentMonthTotalTimeKeeping];
                if (self.timeKeepingType == TimeKeepingType_Base) {
                    [self updateDataForTimeKeepingChart];
                }
                else
                {
                    [self setupTimeKeepingChartForWeekChart];
                }
                [self setColorForCenterTimekeepingButt:[_timekeepingController getState:[NSDate date]]];
            }
            
        }
        else
        {
            [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
            
            [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:_timekeepingCalendar.view];
        }
        
    }];
}
#pragma mark UI

- (void)setupIncomtMonthLabel
{
    _inComeInMonth.text = [self getMonth:[NSDate dateWithTimeIntervalSince1970:[[_payInfoItems.lastObject valueForKey:@"salaryDate"] doubleValue]/1000]];
}
- (NSString *)getMonth:(NSDate *)date
{
    return [date stringWithFormat:@"MM/yyyy"];
}
- (NSString *)getCurrentMonth
{
    return [self getMonth:[NSDate date]];
    
}

- (NSString *)getCurrentDate
{
    return [[NSDate date] stringWithFormat:@"dd/MM/yyyy"];
    
}

- (void)checkIncome {
//    if () {
//        self.dateLB.text = [self getCurrentMonth];
//    } else {
//        self.dateLB.text = @"Chưa có thu nhập"
//    }
}

- (void)addLayoutForButtons
{
    NSLayoutConstraint *incomeButtonWidth = [NSLayoutConstraint
                                             constraintWithItem:self.centerInComeButton
                                             attribute:NSLayoutAttributeWidth
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:self.inComeChart attribute:
                                             NSLayoutAttributeWidth multiplier:0.6
                                             constant:-20];
    NSLayoutConstraint *incomeButtonHeight = [NSLayoutConstraint
                                              constraintWithItem:self.centerInComeButton
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:self.inComeChart attribute:
                                              NSLayoutAttributeWidth multiplier:0.6
                                              constant:-20];
    [self.view addConstraints:@[incomeButtonWidth, incomeButtonHeight]];
    
    NSLayoutConstraint *leftTimeKeepingButtonWidth = [NSLayoutConstraint
                                                      constraintWithItem:self.centerTimeKeepingButton
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                      toItem:self.timeKeepingChart attribute:
                                                      NSLayoutAttributeWidth multiplier:0.6
                                                      constant:-20];
    NSLayoutConstraint *rightKeepingButtonHeight = [NSLayoutConstraint
                                                    constraintWithItem:self.centerTimeKeepingButton
                                                    attribute:NSLayoutAttributeHeight
                                                    relatedBy:NSLayoutRelationEqual
                                                    toItem:self.timeKeepingChart attribute:
                                                    NSLayoutAttributeWidth multiplier:0.6
                                                    constant:-20];
    [self.view addConstraints:@[leftTimeKeepingButtonWidth, rightKeepingButtonHeight]];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(self.view.frame.size.width != 300)
    {
        //Mo\n18\n12-2016
        //Button in center PieChart
        [self.centerInComeButton setImage:[UIImage imageNamed:@"icon_center_income"] forState:UIControlStateNormal];
        NSDate *date= [NSDate date];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
        
        int year = [components year];
        int month = [components month];
        int day = [components day];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE"];
        NSString *dayName = [dateFormatter stringFromDate:date];
        
        UIFont *font = [UIFont systemFontOfSize:12];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                    forKey:NSFontAttributeName];
        
        
        UIFont *font2 = [UIFont systemFontOfSize:25];
        NSDictionary *attrsDictionary2 = [NSDictionary dictionaryWithObject:font2
                                                                    forKey:NSFontAttributeName];
        
        UIFont *font3 = [UIFont systemFontOfSize:10];
        NSDictionary *attrsDictionary3 = [NSDictionary dictionaryWithObject:font3
                                                                    forKey:NSFontAttributeName];
        
        NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", dayName] attributes:attrsDictionary];
        
        NSAttributedString *dayString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%02d\n", day] attributes:attrsDictionary2];
        
        NSAttributedString *monthYear = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%02d-%02d", month, year] attributes:attrsDictionary3];
        
        [dateString appendAttributedString:dayString];
        [dateString appendAttributedString:monthYear];
        
        [self setupButtonCenterChart:_centerTimeKeepingButton with:dateString];
    }
}
- (void)setupButtonCenterChart:(UIButton *)button with:(NSAttributedString *)title{
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
//    button.backgroundColor = COLOR_FROM_HEX(0xcdd1da);
    //    button.tintColor = [UIColor whiteColor];
    button.layer.cornerRadius = button.bounds.size.width/2;
    button.layer.masksToBounds = YES;
    [button setAttributedTitle:title forState:normal];
}
-(void)setupArr{
    parties     = @[
                    LocalizedString(@"Mon"), LocalizedString(@"Tue"), LocalizedString(@"Web"), LocalizedString(@"Thu"), LocalizedString(@"Fri"), LocalizedString(@"Sat"), LocalizedString(@"Sun"), @""
                    ];
    imgArr      = @[
                    @"icon_vao_ra", @"icon_nghi_phep", @"icon_in_out_manager"
                    ];
    titleArr    = @[
                    LocalizedString(@"K_INFO_HUMAN_VC_MANAGER_IN_OUT"), LocalizedString(@"K_INFO_HUMAN_VC_MANAGER_ABSENT"), LocalizedString(@"K_INFO_HUMAN_VC_MANAGER_HOLYDAY")
                    ];
    
}




#pragma mark showOtherView
- (void)showViewNoData{
    
    self.tableView.hidden = YES;
    WorkNoDataView *workNoDataView = (WorkNoDataView *)([[UINib nibWithNibName:@"WorkNoDataView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    workNoDataView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    workNoDataView.contenLB.text = LocalizedString(@"TTNS_NO_DATA");
    [self.view addSubview:workNoDataView];
}


- (void)resetHighLightValuesForAllCharts
{
    [_inComeChart highlightValues:NULL];
    [_timeKeepingChart highlightValue:NULL];
}

- (void)didDismissAlert
{
    [self resetHighLightValuesForAllCharts];
}
- (void)changeImageForTimeKeepingType
{
    switch (self.timeKeepingType) {
        case TimeKeepingType_Base:
            [self.btn_TimeKeepingType setImage:[UIImage imageNamed:@"icon_calendar"] forState:UIControlStateNormal];
            break;
        case TimeKeepingType_Week:
            [self.btn_TimeKeepingType setImage:[UIImage imageNamed:@"icon_in_out_manager"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)showCarlendar
{
    [self pushIntegrationVC:_timekeepingCalendar];
}

- (void)showInComeDetail
{
    InComeDetail *content = NEW_VC_FROM_NIB(InComeDetail, @"InComeDetail");
    double totalPeriod = [TTNS_InfoAndKiComtroller getTotalWithItems:_payInfoItems type:IncomeType_Period];
    double totalSXKD = [TTNS_InfoAndKiComtroller getTotalWithItems:_payInfoItems type:IncomeType_SXKD];
    double totalOther = [TTNS_InfoAndKiComtroller getTotalWithItems:_payInfoItems type:IncomeType_Other];
    [content setDataForView:totalOther totalSXKD:totalSXKD totalPeriod:totalPeriod];

    [self showAlert:content title:[NSString stringWithFormat:@" %@ %@", LocalizedString(@"TTNS_InfoHumanVC_Thông_tin_lương_tháng"), [self getMonth:[NSDate dateWithTimeIntervalSince1970:[[_payInfoItems.lastObject valueForKey:@"salaryDate"] doubleValue]/1000]]] leftButtonTitle:nil rightButtonTitle:nil leftHander:nil rightHander:nil];
}
- (void)setupTimeKeepingChartForWeekChart
{
    self.lastHightLight = [[ChartHighlight alloc] initWithX:2 y:0 dataSetIndex:0];
    self.timeKeepingChart.highlightPerTapEnabled = YES;
    float numberOfElements = 8;
    float persentTotal = 100;
    [self setDataForSameRateChart:numberOfElements
                percentForElement:numberOfElements/persentTotal
                           colors:[self.timekeepingController getColorsInThisMonth]
                        chartView:_timeKeepingChart];
    _timeKeepingChart.drawEntryLabelsEnabled = YES;
    _timeKeepingChart.rotationAngle = 115;
    [_timeKeepingChart animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
}

- (void)setDataForSameRateChart:(int)count
              percentForElement:(double)percentForElement
                         colors:(NSArray*)colors
                      chartView:(PieChartView *)charView
{
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++)
    {
        [values addObject:[[PieChartDataEntry alloc] initWithValue:percentForElement label:parties[i % parties.count] icon: [UIImage imageNamed:@"icon"]]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"Election Results"];
    dataSet.drawIconsEnabled = NO;
    dataSet.drawValuesEnabled = NO;
    dataSet.sliceSpace = 5;
    dataSet.iconsOffset = CGPointMake(0, 40);
    dataSet.selectionShift = 5;
    // add a lot of colors
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.whiteColor];
    
    charView.data = data;
    [charView highlightValues:nil];
}

- (void)setupPieChartView:(PieChartView *)chartView type:(InfoHuman_ChartType)type{
    //
    chartView.drawEntryLabelsEnabled = NO;
    chartView.usePercentValuesEnabled = NO;
    chartView.drawSlicesUnderHoleEnabled = NO;
    chartView.holeRadiusPercent = 0.6;
    chartView.transparentCircleRadiusPercent = 0;
    chartView.chartDescription.enabled = NO; // Show Description Label
    [chartView setExtraOffsetsWithLeft:0 top:0 right:0 bottom:0];
    chartView.delegate = self;
//    if(type == TimeKeeping)
//    {
//        chartView.highlightPerTapEnabled = NO;
//    }
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle]mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    
    
    chartView.drawHoleEnabled = YES;
    chartView.rotationEnabled = YES;
    chartView.rotationEnabled = NO;
    ChartLegend *l = chartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
    l.verticalAlignment  = ChartLegendVerticalAlignmentTop;
    l.orientation = ChartLegendOrientationVertical;
    l.drawInside = NO;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
    
    chartView.legend.enabled = NO; // Hide comment chart
    
}

#pragma mark set data for Chart
- (NSMutableArray *)getColorWith:(InfoHuman_ChartType )type
{
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    switch (type) {
        case InfoHuman_ChartType_TimeKeeping:
            [colors addObject:CommonColor_Red];
            [colors addObject:CommonColor_Blue];
            [colors addObject:CommonColor_Orange];
            [colors addObject:CommonColor_GreenTimeKeeping];
            [colors addObject:CommonColor_LightGray];
            break;
        case InfoHuman_ChartType_Income:
            [colors addObject:CommonColor_Blue];
            [colors addObject:CommonColor_Orange];
            [colors addObject:CommonColor_LightGreen];
            [colors addObject:CommonColor_LightGray];
            break;
        default:
            break;
    }
    return colors;
}
- (void)setColorForCenterTimekeepingButt:(TimeKeepingCalendarType)state
{
    UIColor *color;
    switch (state) {
        case Waiting:
            color = CommonColor_Orange;
            break;
        case Approved:
            color = CommonColor_Blue;
            break;
        case Approved2:
            color = CommonColor_Blue;
            break;
        case Reject:
            color = CommonColor_Red;
            break;
        case LatedDay:
            color = CommonColor_GreenTimeKeeping;
            break;
//        case Lock:
//
//            break;
        default:
            color = CommonColor_LightGray;
            break;
    }
    [self.centerTimeKeepingButton setBackgroundColor:color];
}
- (void)updateDataForTimeKeepingChart
{
    [_timeKeepingChart animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    _timeKeepingChart.rotationAngle = 0;
    self.timeKeepingChart.drawEntryLabelsEnabled = NO;
//    self.timeKeepingChart.highlightPerTapEnabled = NO;
    [self setDataForTimeKeepingChart];
}
- (void)updateDataForInComeChart:(NSArray *)payInCome
{
    [_inComeChart animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    [self setDataForInComeChart:payInCome];
    
}
- (void)setDataForInComeChart:(NSArray *)payInfoItems
{
    NSMutableArray *values = [[NSMutableArray alloc] init];
    double totalPeriod = [TTNS_InfoAndKiComtroller getTotalWithItems:payInfoItems type:IncomeType_Period];
    double totalSXKD = [TTNS_InfoAndKiComtroller getTotalWithItems:payInfoItems type:IncomeType_SXKD];
    double totalOther = [TTNS_InfoAndKiComtroller getTotalWithItems:payInfoItems type:IncomeType_Other];
    double payTotal = totalOther + totalSXKD + totalPeriod;

    
    [values addObject:[[PieChartDataEntry alloc] initWithValue:totalOther == 0 ? 0 : (totalOther/payTotal) label:nil icon: nil]];
    [values addObject:[[PieChartDataEntry alloc] initWithValue:totalPeriod == 0 ? 0 : (totalPeriod/payTotal) label:nil icon: nil]];
    [values addObject:[[PieChartDataEntry alloc] initWithValue:totalSXKD == 0 ? 0 : (totalSXKD/payTotal) label:nil icon: nil]];
    if (payTotal != 0) {
        [values addObject:[[PieChartDataEntry alloc] initWithValue:0 label:nil icon: nil]];
    }
    else
    {
        [values addObject:[[PieChartDataEntry alloc] initWithValue:1 label:nil icon: nil]];
    }
    [self setDataForChart:values chartView:_inComeChart type:InfoHuman_ChartType_Income];
}
- (void)setDataForTimeKeepingChart{
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    CGFloat waitingPersent = [self.timekeepingController getWaitingDayPercent];
    CGFloat approvedPersent = [self.timekeepingController getApproveDayPercent];
    CGFloat rejectPersent = [self.timekeepingController getRejctDayPercent];
    CGFloat latedPersent = [self.timekeepingController getLatedDayPercent];
    CGFloat unCheckPersent = [self.timekeepingController getUnCheckTimeKeeping];
    if (waitingPersent + approvedPersent + rejectPersent + unCheckPersent == 0) {
        unCheckPersent = 1;
    }
    [values addObject:[[PieChartDataEntry alloc] initWithValue:(rejectPersent) label:nil icon: nil]];
    [values addObject:[[PieChartDataEntry alloc] initWithValue:(approvedPersent) label:nil icon: nil]];
    [values addObject:[[PieChartDataEntry alloc] initWithValue:(waitingPersent) label:nil icon: nil]];
    [values addObject:[[PieChartDataEntry alloc] initWithValue:(latedPersent) label:nil icon: nil]];
    [values addObject:[[PieChartDataEntry alloc] initWithValue:(unCheckPersent) label:nil icon: nil]];
    [self setDataForChart:values chartView:_timeKeepingChart type:InfoHuman_ChartType_TimeKeeping];
}

- (void)setDataForChart:(NSMutableArray *)values chartView:(PieChartView*)chartView type:(InfoHuman_ChartType)type
{
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"Election Results"];
    dataSet.drawIconsEnabled = NO;
    dataSet.drawValuesEnabled = NO;
    dataSet.selectionShift = 0;
    dataSet.sliceSpace = 2.0;
    dataSet.iconsOffset = CGPointMake(0, 40);
    // add a lot of colors
    
    NSMutableArray *colors = [self getColorWith:type];
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
#pragma mark CHART DELEGATE
- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    if (chartView == self.timeKeepingChart) {
        [self showCarlendar];
        [self resetHighLightValuesForAllCharts];
    }
    else
    {
        [self showInComeDetail];
    }
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}


#pragma mark  IBAction

- (IBAction)changeTimeKeepingType:(id)sender {
    switch (self.timeKeepingType) {
        case TimeKeepingType_Base:
            self.timeKeepingType = TimeKeepingType_Week;
            [self setupTimeKeepingChartForWeekChart];
            break;
        case TimeKeepingType_Week:
            self.timeKeepingType = TimeKeepingType_Base;
            [self updateDataForTimeKeepingChart];
            break;
        default:
            break;
    }
    [self changeImageForTimeKeepingType];
}

- (IBAction)centerTimeKeepingAction:(id)sender {
    [self selectedDate:[NSDate date]];
}

- (void)showMessageWhenSelectUnCheckDate:(NSDate *)date increseMonth:(NSInteger)increseMonth
{
    DismissTimeKeeping *content = [[DismissTimeKeeping alloc] initWithNibName:@"DismissTimeKeeping" bundle:nil];
    [self keepAlertWhenTouch:YES];
    [self showAlert:content title:[NSString stringWithFormat:@"%@ %@", LocalizedString(@"TTNS_TimeKeepingCalendar_Huỷ_chấm_công"), [date stringWithFormat:@"dd/MM/yyyy"]] leftButtonTitle: LocalizedString(@"TTNS_TimeKeepingCalendar_Đóng") rightButtonTitle:LocalizedString(@"TTNS_TimeKeepingCalendar_Huỷ_chấm_công") leftHander:^{
        [self keepAlertWhenTouch:NO];
        
        
    } rightHander:^{
        DLog(@"%@", content.tv_Content.text);
        if ([content.tv_Content.text checkSpace]) {
            [self showToastWithMessage:LocalizedString(@"Bạn phải nhập lí do hủy chấm công")];
            return;
        }
        else
        {
            [self keepAlertWhenTouch:NO];
        }
        if ([Common checkNetworkAvaiable]) {
            [self.timekeepingController deleteTimeKeeping:[GlobalObj getInstance].ttns_employID content:content.tv_Content.text date:date increaseMonth:increseMonth completion:^(BOOL success, NSString *message, NSException *exception, BOOL isConnectNetwork, NSDictionary *error) {
                if (exception) {
                    [self handleErrorFromResult:nil withException:exception inView:self.view];
                    return ;
                }
                if (message) {
                    if ([message isEqualToString:@"Comment not found"]) {
                        [self showToastWithMessage:LocalizedString(@"Bạn phải nhập lí do hủy chấm công")];
                    }
                    else
                    {
                        [self showToastWithMessage:message];
                    }
                    
                }
                else
                {
                    [self showToastWithMessage:LocalizedString(@"Huỷ chấm công thành công")];
                    [self getListTimeKeeping:increseMonth];
                }
                if (!success) {
                    [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
                }
            }];
        }
        else
        {
            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
        }
        
    }];
}
- (void)selectedDate:(NSDate *)date
{
    TimeKeepingCalendarType status = [self.timekeepingController getState:date];
    if(status == Lock)
    {
        [self showToastWithMessage:LocalizedString(@"Ngày công đã bị khoá")];
    }
    else if(status == Waiting || status == Reject)
    {
        [self showMessageWhenSelectUnCheckDate:date increseMonth:0];
    }
    else if(status == Approved ||
            status == LatedDay ||
            status == Approved2)
    {

        [self showToastWithMessage:LocalizedString(@"Ngày công đã được duyệt")];
    }
    else
    {
        [self showProcessTimeKeeping];
    }
//    switch (status) {
//        case Lock:
//            [self showToastWithMessage:LocalizedString(@"Ngày công đã bị khoá")];
////            [_timekeepingCalendar requestTimeKeeping:nil timeKeeping:[NSNumber numberWithDouble:[date timeIntervalSince1970]*1000] workPlaceType:nil workType:nil sourceData:nil privateKey:nil];
//            break;
//        case Waiting | Approved | LatedDay | Reject:
//            [self showMessageWhenSelectUnCheckDate:date increseMonth:0];
//            break;
////        case Approved | LatedDay:
////            [self showToastWithMessage:LocalizedString(@"Ngày công đã được phê duyệt")];
////            break;
////        case Reject:
////            [self showToastWithMessage:LocalizedString(@"Ngày công đã bị từ chối")];
////            break;
//        default:
//        {
//            [self showProcessTimeKeeping];
//            break;
//        }
//            
//    }
}
- (void)showProcessTimeKeeping
{
    ProcessTimeKeeping *content = NEW_VC_FROM_NIB(ProcessTimeKeeping, @"ProcessTimeKeeping");
    [self showAlert:content title:[NSString stringWithFormat:@"%@ \n (%@)", LocalizedString(@"TTNS_InfoHumanVC_Thực_hiện_chấm_công"), dateCurrent] leftButtonTitle: LocalizedString(@"TTNS_InfoHumanVC_Đóng") rightButtonTitle:LocalizedString(@"TTNS_InfoHumanVC_Chấm_công") leftButtonColor:UIColorFromHex(0x303030) rightButtonColor:UIColorFromHex(0x027eba) leftHander:nil rightHander:^{
        //call API
        NSDictionary *contentValue = [content getValue];
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        date = [calendar startOfDayForDate:date];
        [_timekeepingCalendar requestTimeKeeping:nil timeKeeping:[NSNumber numberWithDouble:[date timeIntervalSince1970]*1000] workPlaceType:[contentValue valueForKey:@"valueAddress"] workType:[contentValue valueForKey:@"valueTypeWork"] sourceData:nil privateKey:[SOSessionManager sharedSession].ttnsSession.privateKey];
        
    }];
}
- (IBAction)centerInComeAction:(id)sender {
    InfoAndKIChart *infoChart = NEW_VC_FROM_NIB(InfoAndKIChart, @"InfoAndKIChart");
    infoChart.latestPayDate = [[_payInfoItems.lastObject valueForKey:@"salaryDate"] doubleValue];
    [infoChart initValues];
    [self pushIntegrationVC:infoChart];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"InfoHumanCell";
    
    InfoHumanCell *cell             = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell                        = [[InfoHumanCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle         = UITableViewCellSelectionStyleNone;
    }
    cell.iconImg.image              = [UIImage imageNamed:imgArr[indexPath.row]];
    cell.titleLB.text               = titleArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        NormalCheckOut *normalCheckOut = NEW_VC_FROM_NIB(NormalCheckOut, @"NormalCheckOut");
        [self pushIntegrationVC:normalCheckOut];
        DLog(@"Quản lý vào ra");
    } else if (indexPath.row  == 1) {
        DLog(@"Quản lý nghỉ phép");
        ListRegisterFormVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ListRegisterFormVC"];
        [AppDelegateAccessor.navIntegrationVC pushViewController:vc animated:YES];
    } else {
        DLog(@"Quản lý trực lễ");
        RegisterList *registerList = NEW_VC_FROM_NIB(RegisterList, @"RegisterList");
        [self pushIntegrationVC:registerList];
    }
}

#pragma mark TimeKeepingCalendarDetailDelegate
- (TTNS_TimeKeepingCalendarDetailController *)getTimekeepingController
{
    return self.timekeepingController;
}
- (BOOL)isLoaded
{
    return _isLoaded;
}
- (void)showError:(NSString *)message
{
    [self showToastWithMessage:message];
}

#pragma mark SOErrorView Delegate

- (void)didRefreshOnErrorView:(SOErrorView *)errorView{
        [self reloadData];
}

@end
