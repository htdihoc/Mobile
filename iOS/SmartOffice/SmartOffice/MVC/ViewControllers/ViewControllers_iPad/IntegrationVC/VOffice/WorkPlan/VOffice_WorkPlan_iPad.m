//
//  VOffice_WorkPlan.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_WorkPlan_iPad.h"
#import "UIView+BorderView.h"
#import "VOffice_ListWorkMain_iPad.h"

#import "PieLayer.h"
#import "SOPieChartView.h"
#import "SOPieElement.h"
#import "Common.h"
#import "VOfficeProcessor.h"

#import "SumWorkModel.h"
#import "PersionaModel.h"
#import "MeetingModel.h"
#import "SumDocModel.h"
static NSString *NOT_PROGRESS   = @"VOffice_WorkPlan_iPad_Chưa_thực_hiện";
static NSString *SLOW_PROGRESS  = @"VOffice_WorkPlan_iPad_Chậm_tiến_độ";
@interface VOffice_WorkPlan_iPad () <ChartViewDelegate>
{
    PersionaModel *_perModel;
}
@property (weak, nonatomic) IBOutlet UIView *containerMainView;

@end

@implementation VOffice_WorkPlan_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackGroundForCharts];
    [self initValues];
    [self loadData];
}
- (void)initValues
{
    self.lblTitle.text = LocalizedString(@"VOffice_WorkPlan_iPad_Công_việc");
    _perModel = [[PersionaModel alloc] init];
}
#pragma mark - Load Data
- (void)loadData{
    [self excuteAPI];
}
//Get Sum Perform Work
- (void)sumNotProgressPerformWorkWithComplete:(Callback)callBack{
    [VOfficeProcessor searchSumTask:@[@(WorkStatus_UnInprogress)]  listTaskType:ListWorkType_Perform callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}


- (void)sumOverduePerformWorkWithComplete:(Callback)callBack{
    [VOfficeProcessor searchSumTask:@[@(WorkStatus_Delay)] listTaskType:ListWorkType_Perform callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}
//ShippedWork
- (void)sumNotProgressShippedWorkWithComplete:(Callback)callBack{
    [VOfficeProcessor searchSumTask:@[@(WorkStatus_UnInprogress)] listTaskType:ListWorkType_Shipped callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}

- (void)sumOverdueShippedWorkWithComplete:(Callback)callBack{
    [VOfficeProcessor searchSumTask:@[@(WorkStatus_Delay)] listTaskType:ListWorkType_Shipped callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}

#pragma mark - Loading Data
- (void)excuteAPI{
//    [[Common shareInstance] showHUDWithTitle:@"Loading..." inView:self.view];
    [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
    dispatch_group_t group = dispatch_group_create(); // 2
    
    //1: Sum NotProgress Perform Work
    dispatch_group_enter(group);
    [self sumNotProgressPerformWorkWithComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        if (success) {
            NSInteger sum = [resultDict[@"data"] integerValue];
            _perModel.performWorkModel.newTask = sum;
        }
        else
        {
            DLog(@"");
        }
        dispatch_group_leave(group);
    }];
    
    //2: Sum Overdue Perform work
    dispatch_group_enter(group);
    [self sumOverduePerformWorkWithComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        if (success) {
            NSInteger sum = [resultDict[@"data"] integerValue];
            _perModel.performWorkModel.overdue = sum;
        }
        else
        {
            DLog(@"");
        }
        dispatch_group_leave(group);
    }];
    
    //3: Sum NotProgress shippedWork
    dispatch_group_enter(group);
    [self sumNotProgressShippedWorkWithComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        if (success) {
            NSInteger sum = [resultDict[@"data"] integerValue];
            _perModel.shippedWorkModel.newTask = sum;
        }
        else
        {
            DLog(@"");
        }
        dispatch_group_leave(group);
    }];
    
    //4: Sum Overdue shippedWork
    dispatch_group_enter(group);
    [self sumOverdueShippedWorkWithComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        if (success) {
            NSInteger sum = [resultDict[@"data"] integerValue];
            _perModel.shippedWorkModel.overdue = sum;
        }
        else
        {
            DLog(@"");
        }
        dispatch_group_leave(group);
    }];
    
    //All task completed
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{ // 4
//        [[Common shareInstance] dismissHUD];
        [self dismissHub];
        [self setupViewFromModel:_perModel.performWorkModel shippedWork:_perModel.shippedWorkModel];
    });
}

- (void)setupBackGroundForCharts
{
    _personalChartView.backgroundColor = [UIColor clearColor];
    _shipperChartView.backgroundColor = [UIColor clearColor];
    
//    [_shipperChartView setUserInteractionEnabled:NO];
//    [_personalChartView setUserInteractionEnabled:NO];
}
- (void)setupViewFromModel:(SumWorkModel *)_performWork shippedWork:(SumWorkModel *)_shippedWork{
    NSInteger sumPerformWork = _performWork.newTask + _performWork.overdue;
    NSInteger sumShippedWork = _shippedWork.newTask + _shippedWork.overdue;
    //Defaul personal work has allway values.
    if (sumShippedWork <= 0) {
        //Hidden note ShipperView
        _noteShipperView.hidden = YES;
        _shipperChartView.hidden = YES;
    }else{
        _noteShipperView.hidden = NO;
        _shipperChartView.hidden = NO;
        
        //Set data and draw shipper chart
        _lblSumShipperWork.text = [NSString stringWithFormat:@"%@ (%ld)", LocalizedString(@"VOffice_WorkPlan_iPad_Giao_đi"), (long)sumShippedWork ];
        _lblShipperWork_Low.text = [NSString stringWithFormat:@"%@ (%ld)", LocalizedString(SLOW_PROGRESS), (long)_shippedWork.overdue];
        _lblShipperWork_NotProgress.text = [NSString stringWithFormat:@"%@ (%ld)",   LocalizedString(NOT_PROGRESS), (long)_shippedWork.newTask];
        //+++ Draw chart
        
        //[self drawChart:_shipperChartView withSlowProgressValue:model.sumShipperSlowProgress andNotProgressValue:model.sumShipperNotProgress withMaxRadius:_shipperChartView.frame.size.width/2 - 30];
        [self drawHalfPieChart:_shipperChartView withSlowProgressValue:_shippedWork.overdue  andNotProgressValue:_shippedWork.newTask  withMaxRadius:0.5];
    }
    
    
    //Set data and draw personal chart
    _lblSumPersonalWork.text = [NSString stringWithFormat:@"%@ (%ld)", LocalizedString(@"VOffice_WorkPlan_iPad_Thực_thiện"), (long)sumPerformWork];
    _lblPersonalWork_Low.text = [NSString stringWithFormat:@"%@ (%ld)", LocalizedString(SLOW_PROGRESS) , (long)_performWork.overdue];
    _lblPersonalWork_NotProgress.text = [NSString stringWithFormat:@"%@ (%ld)", LocalizedString(NOT_PROGRESS), (long)_performWork.newTask];
    //+++Draw Chart
    [self drawHalfPieChart:_personalChartView withSlowProgressValue:_performWork.overdue  andNotProgressValue:_performWork.newTask withMaxRadius:0.65];
}
- (NSInteger)getIndexItemWhenSelectNothing:(ChartViewBase *)chartView
{
    NSInteger index = 0;
    for(UIGestureRecognizer *gesture in chartView.gestureRecognizers){
        if([gesture isKindOfClass:[UITapGestureRecognizer class]] && gesture.state == UIGestureRecognizerStateEnded){
            index = (self.view.frame.size.width/[gesture locationInView:self.view].x)-1;
        }
    }
    return index;
}
- (void)chartHighLight:(ChartViewBase *)chartView withIndex:(NSInteger)index
{
    [chartView highlightValue:[[ChartHighlight alloc] initWithX:index dataSetIndex:0 stackIndex:0]];
}
- (void)resetHightLightShipperChartView
{
    [self resetHighLightForChart:self.shipperChartView];
}
- (void)resetHightLightPersonalChartView
{
    [self resetHighLightForChart:self.personalChartView];
}
- (void)resetHighLightForChart:(PieChartView *)chartView
{
    [chartView highlightValues:NULL];
}
- (void)pushToListWorkVCWith:(ListWorkType)type
{
    VOffice_ListWorkMain_iPad *listWork = NEW_VC_FROM_NIB(VOffice_ListWorkMain_iPad, @"VOffice_ListWorkMain_iPad");
    listWork.listWorkType = type;
    [self pushIntegrationVC:listWork];
}
#pragma mark - Prepare Chart using Chart Framework
- (void)setupChartView:(PieChartView *)_chartView{
    [_chartView setNoDataText:@""];
    [_chartView clearValues];
    _chartView.holeColor = UIColor.whiteColor;
    _chartView.transparentCircleColor = [UIColor.whiteColor colorWithAlphaComponent:0.43];
    _chartView.holeRadiusPercent = 0.65;
    _chartView.rotationEnabled = NO;
    _chartView.highlightPerTapEnabled = YES;
    _chartView.delegate = self;
    
    _chartView.maxAngle = 180.0; // Half chart
    _chartView.rotationAngle = 180.0; // Rotate to make the half on the upper side
    _chartView.centerTextOffset = CGPointMake(0.0, 0.0);
    
    _chartView.legend.enabled = NO;
    /*
     ChartLegend *l = _chartView.legend;
     l.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
     l.verticalAlignment = ChartLegendVerticalAlignmentTop;
     l.orientation = ChartLegendOrientationHorizontal;
     l.drawInside = NO;
     l.xEntrySpace = 7.0;
     l.yEntrySpace = 0.0;
     l.yOffset = 0.0;
     */
    // entry label styling
    _chartView.entryLabelColor = UIColor.redColor;
    _chartView.entryLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
}
- (void)drawHalfPieChart:(PieChartView *)_chartView  withSlowProgressValue:(NSInteger)
slowValue andNotProgressValue:(NSInteger)notValue withMaxRadius:(CGFloat)maxRadius{
    [_chartView setNoDataText:@""];
    if (notValue == 0 && slowValue == 0) {
        return;
    }
    NSInteger sumValue = slowValue + notValue;
    CGFloat percentSlow = ((CGFloat)slowValue * 100 / (CGFloat)sumValue);
    CGFloat percentNot = 100 - percentSlow;
    if (percentSlow > 99 || (percentSlow < 1 && percentSlow > 0)) {
        if (percentSlow > 99) {
            if (percentNot > 0) {
                percentSlow = 99;
                percentNot = 1;
            }
        }
        else
        {
            if (percentNot) {
                percentSlow = 1;
                percentNot = 99;
            }
        }
        
    }
    percentSlow = round(percentSlow);
    percentNot = 100 - percentSlow;
    NSInteger percentToDrawCenterText = 96;
    if (ABS(percentSlow - percentNot) < percentToDrawCenterText) {
        _chartView.drawCenterTextEnabled = YES;
        _chartView.drawSliceTextEnabled = NO;
    }
    
    [self setupChartView:_chartView];
    _chartView.holeRadiusPercent = maxRadius;
    
    _chartView.chartDescription.enabled = NO;
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    PieChartDataEntry *slowDataEntry = [[PieChartDataEntry alloc] initWithValue:percentSlow];
    
    PieChartDataEntry *notDataEntry = [[PieChartDataEntry alloc] initWithValue:percentNot];

	if (percentSlow != 0) {
		[values addObject:slowDataEntry];
	}
	if (percentNot != 0) {
		[values addObject:notDataEntry];
	}

    //Detech Color for chart
	/* No need reverse color on chart now
    if (_chartView == _personalChartView) {
        //Add Value data
        [values addObject:slowDataEntry];
        if (percentNot > 0) {
            [values addObject:notDataEntry];
        }
        
    }else{
        //Add Value data
        if (percentNot > 0) {
            [values addObject:notDataEntry];
        }
        [values addObject:slowDataEntry];
    }
    */
    //Set Color chart
    UIColor *slowPrColor = AppColor_SlowProgressPersonalChartColor;
    UIColor *notPrColor = AppColor_NotProgressPersonalChartColor;
    if (_chartView != _personalChartView) {
        slowPrColor = AppColor_SlowProgressShipperChartColor;
        notPrColor = AppColor_NotProgressShipperChartColor;
    }
	/* No need to reverse color now
    NSMutableArray *colors;
    if (_chartView == _personalChartView) {
        colors = @[slowPrColor, notPrColor].mutableCopy;
    }else{
        colors = @[notPrColor, slowPrColor].mutableCopy;
    }
	 */
	NSMutableArray *colors = @[slowPrColor, notPrColor].mutableCopy;
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"Election Results"];
    dataSet.sliceSpace = 1.0;
    dataSet.selectionShift = 0.0;
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @"%";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    
    [data setValueFont:AppFont_MainFontWithSize(11)];
    [data setValueTextColor:UIColor.whiteColor];
    
    _chartView.data = data;
    
    [_chartView setNeedsDisplay];
}

#pragma mark ChartViewDelegate
- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight
{
    ListWorkType type = ListWorkType_Perform;
    if(chartView == _shipperChartView)
    {
        DLog(@"shipperChartView is selected");
        type = ListWorkType_Shipped;
        [self resetHightLightPersonalChartView];
    }else
    {
        DLog(@"personalChartView is selected");
        [self resetHightLightShipperChartView];
    }
    [self pushToListWorkVCWith:type];
}
- (void)chartValueNothingSelected:(ChartViewBase *)chartView
{
    ListWorkType type = ListWorkType_Perform;
    if(chartView != _shipperChartView)
    {
        DLog(@"shipperChartView is selected");
        type = ListWorkType_Shipped;
        [self resetHightLightPersonalChartView];
        [self chartHighLight:self.shipperChartView withIndex:[self getIndexItemWhenSelectNothing:chartView]];
    }else
    {
        DLog(@"personalChartView is selected");
        [self resetHightLightShipperChartView];
        [self chartHighLight:self.personalChartView withIndex:[self getIndexItemWhenSelectNothing:chartView]];
    }
    [self pushToListWorkVCWith:type];
}
@end
