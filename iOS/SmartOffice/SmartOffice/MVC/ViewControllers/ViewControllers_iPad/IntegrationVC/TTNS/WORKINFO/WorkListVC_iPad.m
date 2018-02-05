//
//  WorkListVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 4/25/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "WorkListVC_iPad.h"

#import "ProcessTimeKeeping.h"
#import "TimeKeepingCalendarDetail.h"
#import "InComeDetail.h"
#import "ManagerCeremony.h"
#import "DetailWorkInfoVC_iPad.h"
#import "NSDictionary+RangeOfMonth.h"
#import "UIView+BorderView.h"
#import "TTNSProcessor.h"

@interface WorkListVC_iPad ()<ChartViewDelegate>{
@protected NSArray *parties;
@protected BOOL _isLoaded;
@protected BOOL _isCheck;
@protected TimeKeepingCalendarDetail *_timekeepingCalendar;
}

@property (nonatomic, assign) TimeKeepingType timeKeepingType;
@property (nonatomic, strong) ChartHighlight *lastHightLight;
@property (weak, nonatomic) TTNS_TimeKeepingCalendarDetailController *timekeepingController;
@end

@implementation WorkListVC_iPad

#pragma mark LifeCycler

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.heightOfNotesConstraint.constant = 110;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupArr];
    [self setupUI];
    _isShowCalendar = YES;
    self.timeKeepingType = TimeKeepingType_Base;
    
    // entry label styling
    [_workInfoChartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    [self setupPieChartView:self.workInfoChartView];
//    [self updateChartData:self.workInfoChartView];
    [self updateDataForTimeKeepingChart];
}

#pragma mark - UI

-(void)setupUI{
    [self setupTitleForLB];
    [self setupBorderForView];
//    [self addLayoutForButton];
}

-(void)setupTitleForLB{
    self.workInfoLB.text            = LocalizedString(@"Thông tin công");
    self.congPheDuyetLB.text        = LocalizedString(@"Công phê duyệt");
    self.congChuaPheDuyetLB.text    = LocalizedString(@"Công chưa phê duyệt");
    self.nghiKhongLuongLB.text      = LocalizedString(@"Nghỉ không lương");
    self.chuaChamCongLB.text        = LocalizedString(@"Công chưa chấm");
    self.quanLyTrucLeLB.text        = LocalizedString(@"K_INFO_HUMAN_VC_MANAGER_HOLYDAY");
}

- (void)setupBorderForView{
    [self.bottomView setBorderWithShadow:1 cornerRadius:0];
    [self.ContentView setBorderWithShadow:1 cornerRadius:0];
}


#pragma mark networking 

- (void)getListTimeKeeping:(NSInteger)increseMonth
{
    //call API
    //    NSDictionary *params = @{@"employee_id":@41652, @"manager_id":@41652, @"from_time":@1493596800000, @"to_time":@1496188800000};
    //params here
    NSDictionary *rangeOfMonth = [NSDictionary getRangeOfMonthWith:increseMonth];
    [self.timekeepingController loadData:[GlobalObj getInstance].ttns_employID managerID:[GlobalObj getInstance].ttns_managerID fromTime:[rangeOfMonth valueForKey:@"firstDay"] toTime:[rangeOfMonth valueForKey:@"lastDay"] completion:^(BOOL success, NSArray *resultArray, NSException *exception, BOOL isConnectNetwork, NSDictionary *error) {
        [self dismissHub];
        _isLoaded = YES;
        [_timekeepingCalendar reloadData];
        if (exception) {
            [self handleErrorFromResult:nil withException:exception inView:self.view];
            return ;
        }
        if (success) {
            if (_timekeepingCalendar.increseMonth == 0) {
                [self.timekeepingController setCurrentTotalTimeKeeping];
//                self.countLB.text = [self.timekeepingController currentMonthTotalTimeKeeping];
                if (self.timeKeepingType == TimeKeepingType_Base) {
                    [self updateDataForTimeKeepingChart];
                }
                else
                {
                    [self setupTimeKeepingChartForWeekChart];
                }
            }
            
        }
        else
        {
            [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
        }
        
    }];
}

#pragma mark - UI FOR CHARTS

- (void)addLayoutForButton{
    if(self.view.bounds.size.height <= SCREEN_HEIGHT_LANDSCAPE*0.6){
        NSLayoutConstraint *height = [NSLayoutConstraint
                                      constraintWithItem:self.workInfoCenterButton
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.workInfoChartView
                                      attribute:NSLayoutAttributeHeight
                                      multiplier:0.5
                                      constant:0];
        
        NSLayoutConstraint *width  = [NSLayoutConstraint
                                      constraintWithItem:self.workInfoCenterButton
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.workInfoCenterButton attribute:
                                      NSLayoutAttributeHeight multiplier:1
                                      constant:0];
        
        [self.view addConstraints:@[width, height]];
    } else {
        NSLayoutConstraint *width   = [NSLayoutConstraint
                                       constraintWithItem:self.workInfoCenterButton
                                       attribute:NSLayoutAttributeWidth
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:self.workInfoChartView
                                       attribute:NSLayoutAttributeWidth
                                       multiplier:0.6
                                       constant:-25];
        
        
        
        NSLayoutConstraint *height  = [NSLayoutConstraint
                                       constraintWithItem:self.workInfoCenterButton
                                       attribute:NSLayoutAttributeHeight
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:self.workInfoCenterButton attribute:
                                       NSLayoutAttributeWidth multiplier:1
                                       constant:0];
        [self.view addConstraints:@[width, height]];
    }
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    // Button in center
//    [self setupButtonCenterChart:self.workInfoCenterButton with:@"Mon\n18\n12-2016"];
    [self addLayoutForButton];
}

- (void)setupArr{
    parties     = @[
                    LocalizedString(@"Sun"), @"", LocalizedString(@"Mon"), LocalizedString(@"Tue"), LocalizedString(@"Web"), LocalizedString(@"Thu"), LocalizedString(@"Fri"), LocalizedString(@"Sat")
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
    chartView.drawCenterTextEnabled = YES;
}

- (void)setupTimeKeepingChartToWeekChart
{
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObject:UIColorFromRGB(0xced0dc)];
    [colors addObject:UIColorFromRGB(0xebebeb)];
    [colors addObject:UIColorFromRGB(0x2a9bd5)];
    [colors addObject:UIColorFromRGB(0x2a9bd5)];
    [colors addObject:UIColorFromRGB(0xf05253)];
    [colors addObject:UIColorFromRGB(0xff9000)];
    [colors addObject:UIColorFromRGB(0xced0dc)];
    float numberOfElements = 8;
    float persentTotal = 100;
    [self setDataForSameRateChart:numberOfElements
                percentForElement:numberOfElements/persentTotal
                           colors:colors
                        chartView:_workInfoChartView];
    _workInfoChartView.drawEntryLabelsEnabled = YES;
    _workInfoChartView.rotationAngle = 25;
    [_workInfoChartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
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
    dataSet.selectionShift = 3;
    // add a lot of colors
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.whiteColor];
    
    charView.data = data;
    [charView highlightValues:nil];
}


- (NSMutableArray *)getColor{
    NSMutableArray *colors = [[NSMutableArray alloc]init];
    [colors addObject:CommonColor_Blue];
    [colors addObject:CommonColor_Orange];
    [colors addObject:CommonColor_Purple];
    [colors addObject:CommonColor_Gray];
    [colors addObject:CommonColor_LightGray];
    
    return colors;
}

- (void)setupTimeKeepingChartForWeekChart
{
    self.lastHightLight = [[ChartHighlight alloc] initWithX:2 y:0 dataSetIndex:0];
    self.workInfoChartView.highlightPerTapEnabled = YES;
    float numberOfElements = 8;
    float persentTotal = 100;
    [self setDataForSameRateChart:numberOfElements
                percentForElement:numberOfElements/persentTotal
                           colors:[self.timekeepingController getColorsInThisMonth]
                        chartView:_workInfoChartView];
    _workInfoChartView.drawEntryLabelsEnabled = YES;
    _workInfoChartView.rotationAngle = 115;
    [_workInfoChartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
}

#pragma mark updateChart

- (void)updateDataForTimeKeepingChart
{
    [_workInfoChartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    _workInfoChartView.rotationAngle = 0;
    self.workInfoChartView.drawEntryLabelsEnabled = NO;
    //    self.timeKeepingChart.highlightPerTapEnabled = NO;
    [self setDataForTimeKeepingChart];
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
    [self setDataForChart:values chartView:_workInfoChartView];
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

//- (void)updateChartData:(PieChartView *)chartView{
//    [_workInfoChartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
//    [self setDataCount:5 range:100 charView:self.workInfoChartView];
//}

//- (void)setDataCount:   (int)count
//               range:(double)range
//            charView:(PieChartView*)chartView{
//    
//    double mult                     = range;
//    NSMutableArray *values          = [[NSMutableArray alloc] init];
//    
//    for (int i = 0; i < count; i++){
//        [values addObject:[[PieChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 5) label:parties[i % parties.count] icon: [UIImage imageNamed:@"icon"]]];
//    }
//    
//    PieChartDataSet *dataSet        = [[PieChartDataSet alloc] initWithValues:values label:@"Election Results"];
//    dataSet.drawIconsEnabled        = NO;
//    dataSet.selectionShift          = 5;
//    dataSet.sliceSpace              = 3.0;
//    dataSet.iconsOffset             = CGPointMake(0, 40);
//    dataSet.drawValuesEnabled       = NO;
//    // add a lot of colors
//    
//    NSMutableArray *colors = [self getColor];
//    
//    dataSet.colors = colors;
//    
//    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
//    
//    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
//    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
//    pFormatter.maximumFractionDigits = 1;
//    pFormatter.multiplier = @1.f;
//    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
//    chartView.data = data;
//    [chartView highlightValues:nil];
//}

#pragma mark - CHART DELEGATE

- (void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight{
    switch (_timeKeepingType) {
        case TimeKeepingType_Base:
            DLog(@"Handle click chart but don't somethings")
            break;
        case TimeKeepingType_Week:
            if(self.isShowCalendar){
                DLog(@"Show Detail WorkList with Calendar");
                DetailWorkInfoVC_iPad *detailWorkInfoVC = NEW_VC_FROM_NIB(DetailWorkInfoVC_iPad, @"DetailWorkInfoVC_iPad");
                [self pushIntegrationVC:detailWorkInfoVC];
            } else {
                DLog(@"Don't show Calendar detail work");
            }
            break;
    }
}

- (void)chartValueNothingSelected:(ChartViewBase *)chartView{
    DLog(@"ChartValueNothingSelected");
}

#pragma mark : IBAction

- (IBAction)workInfoCenterAction:(id)sender {
    ProcessTimeKeeping *content = NEW_VC_FROM_NIB(ProcessTimeKeeping, @"ProcessTimeKeeping");
    [self showAlert:content title:LocalizedString(@"TTNS_InfoHumanVC_Thực_hiện_chấm_công") leftButtonTitle: LocalizedString(@"TTNS_InfoHumanVC_Đóng") rightButtonTitle:LocalizedString(@"TTNS_InfoHumanVC_Chấm_công") leftButtonColor:[UIColor blackColor] rightButtonColor:UIColorFromHex(0x027eba) leftHander:nil rightHander:nil];
}

- (IBAction)calendarAction:(id)sender {
    
    switch (self.timeKeepingType) {
            
        case TimeKeepingType_Base:
            self.timeKeepingType = TimeKeepingType_Week;
            [self setupTimeKeepingChartToWeekChart];
            break;
        case TimeKeepingType_Week:
            self.timeKeepingType = TimeKeepingType_Base;
            [self updateDataForTimeKeepingChart];
            self.workInfoChartView.drawEntryLabelsEnabled = NO;
            break;
            
        default:
            break;
    }
}

- (IBAction)quanLyTrucLeAction:(id)sender {
    ManagerCeremony *vc = [[ManagerCeremony alloc]initWithNibName:@"ManagerCeremony" bundle:nil];
    [self pushIntegrationVC:vc];
}

- (void)showInComeDetail
{
    InComeDetail *content = NEW_VC_FROM_NIB(InComeDetail, @"InComeDetail");
    [self showAlert:content title:LocalizedString(@"TTNS_InfoHumanVC_Thông_tin_lương_tháng") leftButtonTitle:nil rightButtonTitle:nil leftHander:nil rightHander:nil];
}

- (IBAction)arrowRightAction:(id)sender {
}

- (IBAction)arrowLeftAction:(id)sender {
}
@end
