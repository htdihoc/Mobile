//
//  AbsentInfo.m
//  ChartsDemo
//
//  Created by NguyenVanTu on 4/13/17.
//  Copyright © 2017 dcg. All rights reserved.
//

#import "AbsentInfo.h"
#import "WYPopoverController.h"
@interface AbsentInfo () <ChartViewDelegate>
{
    NSArray<NSString *> *months;
    NSArray *parties;
}
@property (nonatomic, strong) IBOutlet PieChartView *absentInfoChart;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_absentLongTime;
@property (weak, nonatomic) IBOutlet UILabel *lbl_absentComfirm;
@property (weak, nonatomic) IBOutlet UILabel *lbl_absentOther;
@property (weak, nonatomic) IBOutlet UILabel *lbl_absentWithOutSalary;
@property (weak, nonatomic) IBOutlet UILabel *lbl_absentPersonalFact;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel_iPad;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceToBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_ButtonHeight;


@end

@implementation AbsentInfo

// MARK : LifeCycler

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupArr];
    // entry label styling
    _absentInfoChart.entryLabelColor = UIColor.whiteColor;
    _absentInfoChart.entryLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    [_absentInfoChart animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    [self setupPieChartView:_absentInfoChart];
    [self updateChartData:_absentInfoChart];
    
}
- (void)setupTextForViews
{
    _lbl_Title.textColor = App_Color_MainTextBoldColor;
    _lbl_absentLongTime.textColor = App_Color_MainTextBoldColor;
    _lbl_absentComfirm.textColor = App_Color_MainTextBoldColor;
    _lbl_absentOther.textColor = App_Color_MainTextBoldColor;
    _lbl_absentWithOutSalary.textColor = App_Color_MainTextBoldColor;
    _lbl_absentPersonalFact.textColor = App_Color_MainTextBoldColor;
    [_btn_cancel setTitleColor:App_Color_MainTextBoldColor forState:UIControlStateNormal];
    
    _lbl_Title.text = AppendString(@"0", LocalizedString(@"TTNS_AbsentInfo_Thông_tin_nghỉ") );
    _lbl_absentLongTime.text = AppendString(@"0", LocalizedString(@"TTNS_AbsentInfo_nghỉ_dài_ngày"));
    _lbl_absentComfirm.text = AppendString(@"0", LocalizedString(@"TTNS_AbsentInfo_nghỉ_phép"));
    _lbl_absentOther.text = AppendString(@"0", LocalizedString(@"TTNS_AbsentInfo_nghỉ_khác"));
    _lbl_absentWithOutSalary.text = AppendString(@"0", LocalizedString(@"TTNS_AbsentInfo_nghỉ_không_lương"));
    _lbl_absentPersonalFact.text = LocalizedString(@"TTNS_AbsentInfo_nghỉ_việc_riêng");
    [_btn_cancel setTitle:LocalizedString(@"TTNS_AbsentInfo_Cancel") forState:UIControlStateNormal];
}
-(void)setupArr{
    parties     = @[
                    @"", @"", @"", @"", @""
                    ];

    if (IS_PAD) {
        [_btn_cancel setHidden:YES];
        [self.btn_cancel_iPad setTitle:@"Đóng" forState:UIControlStateNormal];
    } else {
        [_btn_cancel_iPad setHidden:YES];
        [_lbl_line setHidden:YES];
        _distanceToBottom = 0;

    }
}


- (void)setupButtonCenterChart:(UIButton *)button with:(NSString *)title{
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.backgroundColor = [UIColor lightGrayColor];
    button.tintColor = [UIColor whiteColor];
    button.layer.cornerRadius = button.bounds.size.width/2;
    button.layer.masksToBounds = YES;
    [button setTitle:title forState:normal];
}

- (void)setupPieChartView:(PieChartView *)chartView{
    chartView.drawEntryLabelsEnabled = NO;
    chartView.usePercentValuesEnabled = YES;
    chartView.drawSlicesUnderHoleEnabled = NO;
    chartView.holeRadiusPercent = 0.58;
    chartView.transparentCircleRadiusPercent = 0;
    chartView.chartDescription.enabled = NO; // Show Description Label
    [chartView setExtraOffsetsWithLeft:0 top:0 right:0 bottom:0];
    chartView.delegate = self;
    chartView.drawCenterTextEnabled = YES;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle]mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    chartView.drawHoleEnabled = YES;
    chartView.rotationAngle = 0.0;
    chartView.highlightPerTapEnabled = YES;
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

// MARK : set data for Chart

- (void)updateChartData:(PieChartView *)chartView
{
    
    [self setDataCount:5 range:100 charView:chartView];
}

- (void)setDataCount:(int)count range:(double)range charView:(PieChartView*)chartView{
    double mult = range;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
     NSMutableArray *colors = [[NSMutableArray alloc] init];
//    for (int i = 0; i < count; i++)
//    {
//        [values addObject:[[PieChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 5) label:parties[i % parties.count] icon: [UIImage imageNamed:@"icon"]]];
//    }
    if ([[self.absentViewDelegate getCheckPoint] getLeaveTotal] == 0) {
        [values addObject:[[PieChartDataEntry alloc] initWithValue:1]];
        [colors addObject:CommonColor_Gray];
    }
    else
    {
        CGFloat totalLeaveLong = [self.absentViewDelegate getCheckPoint].totalLeaveLong;
        CGFloat totalLeaveP = [self.absentViewDelegate getCheckPoint].totalLeaveP;
        CGFloat totalLeaveOther = [self.absentViewDelegate getCheckPoint].totalLeaveOther;
        CGFloat totalLeaveRo = [self.absentViewDelegate getCheckPoint].totalLeaveRo;
        CGFloat totalLeaveRv = [self.absentViewDelegate getCheckPoint].totalLeaveRv;
        
        _lbl_absentLongTime.text = [NSString stringWithFormat:@"%02ld %@", (long)totalLeaveLong, LocalizedString(@"nghỉ dài ngày")];
        _lbl_absentComfirm.text = [NSString stringWithFormat:@"%02ld %@", (long)totalLeaveP, LocalizedString(@"nghỉ phép")];
        _lbl_absentOther.text = [NSString stringWithFormat:@"%02ld %@", (long)totalLeaveOther, LocalizedString(@"nghỉ khác")];
        _lbl_absentWithOutSalary.text = [NSString stringWithFormat:@"%02ld %@", (long)totalLeaveRo, LocalizedString(@"nghỉ không lương")];
        _lbl_absentPersonalFact.text = [NSString stringWithFormat:@"%02ld %@", (long)totalLeaveRv, LocalizedString(@"nghỉ việc riêng")];
        
        
        if (totalLeaveP > 0) {
            [values addObject:[[PieChartDataEntry alloc] initWithValue:totalLeaveP]];
            [colors addObject:CommonColor_Red];
        }
        
        if (totalLeaveP > 0) {
            [values addObject:[[PieChartDataEntry alloc] initWithValue:totalLeaveP]];
            [colors addObject:CommonColor_Orange];
        }
        
        if (totalLeaveOther > 0) {
            [values addObject:[[PieChartDataEntry alloc] initWithValue:totalLeaveOther]];
            [colors addObject:CommonColor_Blue];
        }
        
        if (totalLeaveRo > 0) {
            [values addObject:[[PieChartDataEntry alloc] initWithValue:totalLeaveRo]];
            [colors addObject:CommonColor_Purple];
        }
        
        if (totalLeaveRv) {
            [values addObject:[[PieChartDataEntry alloc] initWithValue:totalLeaveRv]];
            [colors addObject:CommonColor_Green];
        }
        
        
        
        
        
        
    }

    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"Election Results"];
    
    dataSet.drawIconsEnabled = NO;
    dataSet.selectionShift = 2;
    dataSet.sliceSpace = 0;
    dataSet.iconsOffset = CGPointMake(0, 40);
    
    // add a lot of colors
    
   
    
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @"%";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue" size:(chartView.frame.size.width/28)+1]];
    [data setValueTextColor:UIColor.whiteColor];
    
    chartView.data = data;
    [chartView highlightValues:nil];
}

// MARK : CHART DELEGATE

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    
    DLog(@"chartValueSelected");
    
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    DLog(@"chartValueNothingSelected");
}

// MARK : IBAction
- (IBAction)cancelView:(id)sender {
    [self.absentViewDelegate didDissmissView];
}
- (IBAction)cancelView_iPad:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.absentViewDelegate didDissmissView];
}

@end
