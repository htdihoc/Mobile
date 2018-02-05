//
//  WorkPersonalCell.m
//  SmartOffice
//
//  Created by Kaka on 4/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "WorkPersonalCell.h"
#import "SumWorkModel.h"

#import "PieLayer.h"
#import "SOPieChartView.h"
#import "SOPieElement.h"


static NSString *NOT_PROGRESS   = @"Chưa thực hiện";
static NSString *SLOW_PROGRESS  = @"Chậm tiến độ";
@interface WorkPersonalCell()<ChartViewDelegate>{
	
}

@end
@implementation WorkPersonalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _personalChartView.backgroundColor = [UIColor clearColor];
    _shipperChartView.backgroundColor = [UIColor clearColor];
	
	[_shipperChartView setUserInteractionEnabled:YES];
	[_personalChartView setUserInteractionEnabled:YES];
	_personalChartView.delegate = self;
	_shipperChartView.delegate = self;
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupLanguage{
	
}
#pragma mark - Load Data
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
        _lblSumShipperWork.text = [NSString stringWithFormat:@"%@ (%ld)", LocalizedString(@"KVOFF_SHIPPED_TITLE"), (long)sumShippedWork ];
        _lblShipperWork_Low.text = [NSString stringWithFormat:@"%@ (%ld)", SLOW_PROGRESS, (long)_shippedWork.overdue];
        _lblShipperWork_NotProgress.text = [NSString stringWithFormat:@"%@ (%ld)", NOT_PROGRESS, (long)_shippedWork.newTask];
        //+++ Draw chart
        
        //[self drawChart:_shipperChartView withSlowProgressValue:model.sumShipperSlowProgress andNotProgressValue:model.sumShipperNotProgress withMaxRadius:_shipperChartView.frame.size.width/2 - 30];
        [self drawHalfPieChart:_shipperChartView withSlowProgressValue:_shippedWork.overdue  andNotProgressValue:_shippedWork.newTask  withMaxRadius:0.5];
    }
	
    
    //Set data and draw personal chart
    _lblSumPersonalWork.text = [NSString stringWithFormat:@"%@ (%ld)", LocalizedString(@"KVOFF_PERFORM_TITLE"), (long)sumPerformWork];
    _lblPersonalWork_Low.text = [NSString stringWithFormat:@"%@ (%ld)", SLOW_PROGRESS, (long)_performWork.overdue];
     _lblPersonalWork_NotProgress.text = [NSString stringWithFormat:@"%@ (%ld)", NOT_PROGRESS, (long)_performWork.newTask];
    //+++Draw Chart
     [self drawHalfPieChart:_personalChartView withSlowProgressValue:_performWork.overdue  andNotProgressValue:_performWork.newTask withMaxRadius:0.65];
}

#pragma mark - Using SSOPieChartView
/*
- (void)drawChart:(SOPieChartView *)pieChart withSlowProgressValue:(NSInteger)slowValue andNotProgressValue:(NSInteger)notValue withMaxRadius:(CGFloat)maxRadius{
    if (pieChart.layer.values > 0) {
        //Use this to keep redraw again
        return;
    }
    //Default personal color
    UIColor *slowPrColor = AppColor_SlowProgressPersonalChartColor;
    UIColor *notPrColor = AppColor_NotProgressPersonalChartColor;
    if (pieChart != _personalChartView) {
        slowPrColor = AppColor_SlowProgressShipperChartColor;
        notPrColor = AppColor_NotProgressShipperChartColor;
    }
    
    
    SOPieElement *slowElement = [SOPieElement pieElementWithValue:slowValue color:slowPrColor];
    slowElement.title = [NSString stringWithFormat:@"%ld", (long)slowValue];
    //slowElement.showTitle = YES;
    SOPieElement *notElement = [SOPieElement pieElementWithValue:notValue color:notPrColor];
     notElement.title = [NSString stringWithFormat:@"%ld", (long)notValue];
    //notElement.showTitle = YES;
    pieChart.layer.showTitles = ShowTitlesNever;
    [pieChart.layer addValues:@[notElement, slowElement] animated:YES];
    [pieChart setClearsContextBeforeDrawing:YES];
    [pieChart setupWithHalfPie:YES maxRadius:maxRadius minRadius:maxRadius - 30];
}



- (void)setupPieChartView:(PieChartView *)chartView{
    chartView.usePercentValuesEnabled = YES;
    chartView.drawSlicesUnderHoleEnabled = NO;
    chartView.holeRadiusPercent = 0.58;
    chartView.transparentCircleRadiusPercent = 0.61;
    chartView.chartDescription.enabled = NO; // Show Description Label
    [chartView setExtraOffsetsWithLeft:0 top:0 right:0 bottom:0];
    
    chartView.drawCenterTextEnabled = YES;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle]mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
}
*/
#pragma mark - handle logic Sum data
- (void)handleUILogicBySumPerformWork:(NSInteger)sumPerformWork sumShippedWork:(NSInteger)sumShippedWork{
	
}
#pragma mark - Prepare Chart using Chart Framework
- (void)setupChartView:(PieChartView *)_chartView{
    //_chartView.delegate = self;
	[_chartView clearValues];
    _chartView.holeColor = UIColor.whiteColor;
    _chartView.transparentCircleColor = [UIColor.whiteColor colorWithAlphaComponent:0.43];
    _chartView.holeRadiusPercent = 0.65;
    _chartView.rotationEnabled = NO;
    _chartView.highlightPerTapEnabled = YES;
    
    _chartView.maxAngle = 180.0; // Half chart
    _chartView.rotationAngle = 180.0; // Rotate to make the half on the upper side
    _chartView.centerTextOffset = CGPointMake(0.0, 0.0);

	
	[_chartView setNoDataText:@""];
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
	
	/* No use reverse color on chart now
	//Detech Color for chart
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
	NSMutableArray *colors;
	/* no need reverse color
	if (_chartView == _personalChartView) {
		colors = @[slowPrColor, notPrColor].mutableCopy;
	}else{
		colors = @[notPrColor, slowPrColor].mutableCopy;
	}
	 */
	colors = @[slowPrColor, notPrColor].mutableCopy;
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

#pragma mark - ChartView Delegate
- (void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight{
	//[chartView setHighlighter:nil];
	ListWorkType type;
	if(chartView == _shipperChartView)
	{
		DLog(@"shipperChartView is selected");
		type = ListWorkType_Shipped;
	}else
	{
		DLog(@"personalChartView is selected");
		type = ListWorkType_Perform;
	}
	if (_delegate) {
		[_delegate didTapOnChartView:chartView withType:type];
	}

}
- (void)chartValueNothingSelected:(ChartViewBase *)chartView{
	//[chartView setHighlighter:nil];
	/*
	ListWorkType type;
	if(chartView == _shipperChartView)
	{
		DLog(@"shipperChartView is selected");
		type = ListWorkType_Shipped;
	}else
	{
		DLog(@"personalChartView is selected");
		type = ListWorkType_Perform;
	}
	if (_delegate) {
		[_delegate didTapOnChartView:chartView withType:type];
	}
	*/
}


@end
