//
//  UserManagement.m
//  ChartsDemo
//
//  Created by NguyenVanTu on 4/14/17.
//  Copyright © 2017 dcg. All rights reserved.
//

#import "UserManagement.h"
#import <Charts/Charts.h>
#import "ListRegisterFormVC.h"
#import "UserManagementCell.h"
#import "AbsentInfo.h"
#import "CheckOut.h"
#import "TimeKeepingCalendarDetail.h"
#import "TimeKeepings.h"
#import "NSException+Custom.h"
#import "TTNSProcessor.h"
#import "TTNS_CheckPointModel.h"
#import "MZFormSheetController.h"
#import "FullWidthSeperatorTableView.h"
#import "SOErrorView.h"
@interface UserManagement() <ChartViewDelegate, UITableViewDataSource, UITableViewDelegate, AbsentInfoDelegate, SOErrorViewDelegate>{
@protected NSArray *parties;
@protected NSArray *imgArr;
@protected NSArray *titleArr;
    
@protected NSDate *_currentDate;
    TTNS_CheckPointModel *_checkPoint;
    SOErrorView *_errorView;
}
@property (weak, nonatomic) IBOutlet FullWidthSeperatorTableView *table_Options;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet PieChartView *absentInfoChart;
@property (nonatomic, assign) BOOL shouldHideData;
@property (nonatomic, strong) ChartHighlight *lastHightLight;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Date;
@end

@implementation UserManagement

// MARK : LifeCycler

#pragma mark LifeCycler
- (void)viewWillAppear {
    [super viewWillAppear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _currentDate = [NSDate date];
    [self.table_Options registerNib:[UINib nibWithNibName:@"UserManagementCell"
                                                   bundle:[NSBundle mainBundle]]
             forCellReuseIdentifier:@"UserManagementCell"];
    self.table_Options.delegate = self;
    self.table_Options.dataSource = self;
    [self setupArr];
    [self setupUI];
    // entry label styling
    _absentInfoChart.entryLabelColor = UIColor.whiteColor;
    _absentInfoChart.entryLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    [_absentInfoChart animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    
    [self reloadData];
}
- (void)reloadData
{
    [self loadData: _currentDate];
}
- (void)loadData:(NSDate *)date
{
    [self hiddenErrorView];
    //    organization_id=148871&sys_date=1505806951000
    if ([Common checkNetworkAvaiable]) {
        [[Common shareInstance] showCustomTTNSHudInView:self.view];
        NSDictionary *params = @{@"organization_id":[GlobalObj getInstance].ttns_organizationId, @"sys_date":[NSNumber numberWithLongLong:[date timeIntervalSince1970]*1000]};
        [TTNSProcessor getTTNS_CheckPoint:params callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            [[Common shareInstance] dismissTTNSCustomHUD];
            if (success) {
                _checkPoint = [[TTNS_CheckPointModel alloc] initWithDictionary:[[resultDict valueForKey:@"data"] valueForKey:@"entity"] error:nil];
            }
            else
            {
                [self handleErrorFromResult:nil withException:exception inView:self.view];
            }
            [self updateChartData:_absentInfoChart numberOfElements:2 range:100];
        }];
    }else {
        [self addErrorView:LocalizedString(@"Mất kết nối mạng")];
    }
    
}
#pragma mark UI

- (void)setupUI{
    _currentDate = [NSDate date];
    self.nextDateButton.enabled = NO;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(self.view.frame.size.width != 300)
    {
        [self setupPieChartView:_absentInfoChart];
        [self updateChartData:_absentInfoChart numberOfElements:2 range:100];
        [self setupButtonCenterChart:self.centerAbsentInfo with:nil];
    }
}

-(void)setupTextForViews
{
    self.lbl_Date.textColor = AppColor_MainTextColor;
    self.lbl_Absence.textColor = AppColor_MainTextColor;
    self.lbl_Presence.textColor = AppColor_MainTextColor;
    
    self.lbl_Date.text = [self getCurrentDate];
    self.lbl_Date.numberOfLines = 1;
    self.lbl_Date.adjustsFontSizeToFitWidth = YES;
    [self.lbl_Date setMinimumScaleFactor:8.0/16];
}

-(void)setupArr{
    parties     = @[
                    @"", @""
                    ];
    imgArr      = @[
                    @"icon_vao_ra", @"icon_nghi_phep", @"icon_in_out_manager"
                    ];
    titleArr    = @[
                    LocalizedString(@"Phê duyệt ra vào"), LocalizedString(@"TTNS_UserManagement_Phê_duyệt_công"), LocalizedString(@"Tra cứu thông tin nhân viên")
                    ];
    
}
- (void)addPopoverAt:(CGPoint)position {
//    if ([_checkPoint getLeaveTotal] != 0) {
        AbsentInfo *absentViewController = NEW_VC_FROM_NIB(AbsentInfo, @"AbsentInfo");
        absentViewController.absentViewDelegate = self;
        
        MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:absentViewController];
        CGSize size;
        
        if (IS_IPHONE) {
            size = CGSizeMake(0.9*SCREEN_WIDTH_PORTRAIT, 195);
        }
        else
        {
            size = CGSizeMake(300, 195);
        }
        formSheet.presentedFormSheetSize = size;
        formSheet.shadowRadius = 2.0;
        formSheet.shadowOpacity = 0.3;
        formSheet.cornerRadius = 12;
        formSheet.shouldCenterVertically = YES;
        formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
        formSheet.shouldDismissOnBackgroundViewTap = YES;
        [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        }];
//    }
    
    
    
}

- (void)showListTimeKeeping
{
    if ([Common checkNetworkAvaiable]) {
        TimeKeepings *timeKeepings = NEW_VC_FROM_NIB(TimeKeepings, @"TimeKeepings");
        [self pushIntegrationVC:timeKeepings];
    }
    else
    {
        [self addErrorView:LocalizedString(@"Mất kết nối mạng")];
    }
    
}

- (void)resetHighLightValuesForAllCharts
{
    [_absentInfoChart highlightValues:NULL];
}
- (void)setupButtonCenterChart:(UIButton *)button with:(NSString *)title{
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = button.bounds.size.width/2;
    button.tintColor = [UIColor lightGrayColor];
    button.layer.masksToBounds = YES;
    [button setTitle:title forState:normal];
}

- (void)setupPieChartView:(PieChartView *)chartView{
    chartView.drawEntryLabelsEnabled = NO;
    chartView.usePercentValuesEnabled = YES;
    chartView.drawSlicesUnderHoleEnabled = NO;
    chartView.holeRadiusPercent = 0.6;
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
    chartView.rotationEnabled = YES;
    chartView.highlightPerTapEnabled = YES;
    chartView.rotationEnabled = NO;
    ChartLegend *l = chartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
    l.verticalAlignment  = ChartLegendVerticalAlignmentTop;
    l.orientation = ChartLegendOrientationVertical;
    l.drawInside = NO;
    l.xEntrySpace = 0.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
    
    chartView.legend.enabled = NO; // Hide comment chart
    
}

#pragma mark set data for Chart

- (void)updateChartData:(PieChartView *)chartView
       numberOfElements:(int)count
                  range:(CGFloat)range
{
    NSLog(@"%f", chartView.frame.size.width);
    [chartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    if (self.shouldHideData)
    {
        chartView.data = nil;
        
        return;
    }
    
    [self setDataCount:count range:range charView:chartView];
}

- (void)setDataCount:(int)count range:(double)range charView:(PieChartView*)chartView{
    //    double mult = range;
    //
    NSMutableArray *values = [[NSMutableArray alloc] init];
    NSMutableArray *colors;
    // add a lot of colors
    if (_checkPoint) {
        colors = [[NSMutableArray alloc] init];
        self.lbl_Presence.text = [NSString stringWithFormat:@"%@(%.0f)", LocalizedString(@"TTNS_UserManagement_Đi_làm"), (long)_checkPoint.totalEmp - _checkPoint.getLeaveTotal];
        self.lbl_Absence.text = [NSString stringWithFormat:@"%@(%ld)", LocalizedString(@"TTNS_UserManagement_Nghỉ"), (long)[_checkPoint getLeaveTotal]];
        
        
        
        if (_checkPoint.getLeaveTotal > 0) {
            [colors addObject:CommonColor_Red];
            [values addObject:[[PieChartDataEntry alloc] initWithValue:[_checkPoint getLeaveTotal]]];
        }
        if (_checkPoint.totalEmp - _checkPoint.getLeaveTotal > 0) {
            [values addObject:[[PieChartDataEntry alloc] initWithValue:_checkPoint.totalEmp - _checkPoint.getLeaveTotal]];//Go
            [colors addObject:CommonColor_Blue];
        }
        
        
    }
    else
    {
        [values addObject:[[PieChartDataEntry alloc] initWithValue:1]];
        colors = [[NSMutableArray alloc] init];
        [colors addObject:CommonColor_Gray];
        
    }
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"Election Results"];
    dataSet.selectionShift = 0;
    dataSet.drawIconsEnabled = NO;
    dataSet.colors = colors;
    if (colors.count == 1) {
        dataSet.drawValuesEnabled = NO;
    }
    dataSet.sliceSpace = 2.0;
    [dataSet setValueTextColor:[UIColor whiteColor]];
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @"%";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue" size:(chartView.frame.size.width/20)]];
    
    
    chartView.data = data;
    [chartView highlightValues:nil];
}

#pragma mark CHART DELEGATE

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    if (_checkPoint.totalEmp == _checkPoint.getLeaveTotal || _checkPoint.getLeaveTotal == 0) {
        return;
    }
    [self addPopoverAt:[chartView convertPoint:CGPointMake(highlight.xPx, highlight.yPx) toView:self.view]];
    NSLog(@"chartValueSelected");
    
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

#pragma mark action

- (NSString*)getCurrentDate{
    NSDateFormatter *dateFM = [[NSDateFormatter alloc]init];
    [dateFM setDateFormat:@"dd/MM/yyyy"];
    return [dateFM stringFromDate:[NSDate date]];
}

- (NSString*)forwardDate{
    NSInteger _dayNumberNext        = 1;
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = _dayNumberNext;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:_currentDate options:0];
    _currentDate = nextDate;
    NSDateFormatter *dateFM = [[NSDateFormatter alloc]init];
    [dateFM setDateFormat:@"dd/MM/yyyy"];
    DLog(@"%@", [dateFM stringFromDate:[NSDate date]]);
    _dayNumberNext++;
    return [dateFM stringFromDate:nextDate];
}

- (NSString*)preDate{
    NSInteger _dayNumberBack    = -1;
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = _dayNumberBack;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *preDate = [theCalendar dateByAddingComponents:dayComponent toDate:_currentDate options:0];
    _currentDate = preDate;
    NSDateFormatter *dateFM = [[NSDateFormatter alloc]init];
    [dateFM setDateFormat:@"dd/MM/yyyy"];
    _dayNumberBack--;
    return [dateFM stringFromDate:preDate];
}

- (BOOL)isCurrentDate{
    NSDateFormatter *dateFM         = [[NSDateFormatter alloc]init];
    [dateFM setDateFormat:@"EEEE, dd/MM/yyyy"];
    
    NSString *_currentDateStr   = [dateFM stringFromDate:_currentDate];
    NSString *_dateStr           = [dateFM stringFromDate:[NSDate date]];
    
    if([_currentDateStr isEqualToString:_dateStr]){
        return YES;
    }
    return NO;
}

#pragma mark IBAction
- (IBAction)centerabsentInfoAction:(id)sender {
    
}


#pragma mark UITableViewDatasouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"UserManagementCell";
    
    UserManagementCell *cell             = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell                        = [[UserManagementCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle         = UITableViewCellSelectionStyleNone;
    }
    cell.iconImg.image              = [UIImage imageNamed:imgArr[indexPath.row]];
    cell.titleLB.text               = titleArr[indexPath.row];
    
    
    if(indexPath.row == TTNS_Manage_CheckOut){
        [cell.badgeButton setHidden:NO];
        [cell.badgeButton setTitle:@"99" forState:UIControlStateNormal];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == TTNS_Manage_CheckOut) {
        CheckOut *checkOutVC = NEW_VC_FROM_NIB(CheckOut, @"CheckOut");
        [self pushIntegrationVC:checkOutVC];
        DLog(@"Quản lý vào ra");
    } else if (indexPath.row  == TTNS_Manage_TimeKeeping) {
        DLog(@"Phê duyệt công");
        [self showListTimeKeeping];
    } else {
        DLog(@"Tra cứu thông tin nhân viên");
    }
}

#pragma mark - AlertDelegate
- (void)didDismissAlert
{
    [self resetHighLightValuesForAllCharts];
}

#pragma mark - AbsentDelegate
- (void)didDissmissView
{
    [self mz_dismissFormSheetControllerAnimated:true completionHandler:nil];
    [self resetHighLightValuesForAllCharts];
}
- (TTNS_CheckPointModel *)getCheckPoint
{
    return _checkPoint;
}
- (IBAction)backDateAction:(id)sender {
    if([Common checkNetworkAvaiable]){
        self.lbl_Date.text = [self preDate];
        [self loadData:_currentDate];
        self.nextDateButton.enabled = YES;
    } else {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    
}

- (IBAction)nextDateAction:(id)sender {
    if([Common checkNetworkAvaiable]){
        self.lbl_Date.text = [self forwardDate];
        [self loadData:_currentDate];
        if([self isCurrentDate]){
            self.nextDateButton.enabled = NO;
        }
    } else {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}

- (void)addErrorView:(NSString *)content
{
    [self.contentView setHidden:YES];
    [self.table_Options setHidden:YES];
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
- (void)hiddenErrorView
{
    [self.contentView setHidden:NO];
    [self.table_Options setHidden:NO];
    [_errorView setHidden:YES];
}
- (void)didRefreshOnErrorView:(SOErrorView *)errorView
{
    [self loadData:_currentDate];
}
@end
