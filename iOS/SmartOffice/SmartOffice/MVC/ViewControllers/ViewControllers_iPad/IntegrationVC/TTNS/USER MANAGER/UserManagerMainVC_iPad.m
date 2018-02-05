//
//  UserManagerMainVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 5/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "UserManagerMainVC_iPad.h"
#import "WorkListVC_iPad.h"
#import "IncomeInfoVC_iPad.h"
#import "KIInfoVC_iPad.h"
#import "WYPopoverController.h"
#import "AbsentInfo.h"
#import "ManagerWorkVC_iPad.h"
#import "ConfirmInOutVC_iPad.h"
#import "Common.h"
#import "TTNSProcessor.h"
#import "SOSessionManager.h"
#import "NSException+Custom.h"
#import "SOErrorView.h"

@interface UserManagerMainVC_iPad ()<ChartViewDelegate, WYPopoverControllerDelegate, AbsentInfoDelegate, SOErrorViewDelegate>{
@protected NSArray *parties;
@protected WYPopoverController *settingsPopoverController;
@protected NSDate *_currentDate;
@protected UISwipeGestureRecognizer *swipeRight;
@protected UISwipeGestureRecognizer *swipeLeft;
@protected SOErrorView *errorView;
}

@property (nonatomic, assign) BOOL shouldHideData;

@end

@implementation UserManagerMainVC_iPad

#pragma mark lifecycler

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![Common checkNetworkAvaiable]) {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    //    [self.countChartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupArr];
    [self setupUI];
    [self getAccessToken];
    [self addViews];
}

- (void)addViews
{
    if([Common checkNetworkAvaiable]){
        WorkListVC_iPad *workListVC = NEW_VC_FROM_NIB(WorkListVC_iPad, @"WorkListVC_iPad");
        [self displayVC:workListVC container:self.thongTinCongView];
        
        IncomeInfoVC_iPad *inComeVC = NEW_VC_FROM_NIB(IncomeInfoVC_iPad, @"IncomeInfoVC_iPad");
        [self displayVC:inComeVC container:self.incomeView];
        
        KIInfoVC_iPad *kiInfoVC     = NEW_VC_FROM_NIB(KIInfoVC_iPad, @"KIInfoVC_iPad");
        [self displayVC:kiInfoVC container:self.kIInfoView];
        
        if(errorView != nil){
            [errorView removeFromSuperview];
        }
    } else {
        [self showNotConnectedView];
    }
    
}
-(void)getAccessToken{
    if([Common checkNetworkAvaiable]){
        [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
        [TTNSProcessor getAccessTokenTTNSWithComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            [self dismissHub];
            if(success){
                NSString *accessToken = resultDict[@"data"][@"data"][@"access_token"];
                [SOSessionManager sharedSession].ttnsSession.accessToken = accessToken;
                [[SOSessionManager sharedSession] saveData];
                [TTNSProcessor getPrivateTTNSWithComplete:[GlobalObj getInstance].ttns_employID uuid:[GlobalObj getInstance].ttns_uid callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
                    NSString *privateKey = resultDict[@"data"][@"entity"];
                    [SOSessionManager sharedSession].ttnsSession.privateKey = privateKey;
                    [[SOSessionManager sharedSession] saveData];
                    
                }];
            } else {
                //                [self showViewNoData];
                [self handleErrorFromResult:resultDict withException:exception inView:self.view];
                
            }
        }];
    }
    else
    {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}

#pragma mark UI


- (void)setupUI{
    self.arrowRightButton.enabled           = NO;
    swipeLeft.enabled                       = NO;
    _currentDate                            = [NSDate date];
    
    [self addSwipeGesture];
    
    self.countChartView.entryLabelColor     = UIColor.whiteColor;
    self.countChartView.entryLabelFont      = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    self.timeLB.text                        =  [self getCurrentDate];
    [self setupPieChartView:self.countChartView];
    [self updateChartData:self.countChartView numberOfElements:2 range:100];
}

- (void)setupTextForViews{
    self.timeLB.textColor                   = AppColor_MainTextColor;
    self.workLB.textColor                   = AppColor_MainTextColor;
    self.notWorkLB.textColor                = AppColor_MainTextColor;
    
    self.timeLB.text                        = @"Thứ 3, 13/04/2017";
    self.timeLB.numberOfLines               = 1;
    self.timeLB.adjustsFontSizeToFitWidth   = YES;
    [self.timeLB setMinimumScaleFactor:8.0/16];
    self.workLB.text = AppendString(LocalizedString(@"TTNS_UserManagement_Đi_làm"), @"(155)");
    self.notWorkLB.text = AppendString(LocalizedString(@"TTNS_UserManagement_Nghỉ"), @"(55)");
}

- (void)setupPieChartView:(PieChartView*)chartView{
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

// MARK : SetData For Chart78

- (void)updateChartData:(PieChartView *)chartView
       numberOfElements:(int)count
                  range:(CGFloat)range
{
    NSLog(@"%f", chartView.frame.size.width);
    if (self.shouldHideData)
    {
        chartView.data = nil;
        return;
    }
    
    [self setDataCount:count range:range charView:chartView];
}


- (void)setDataCount:(int)count range:(double)range charView:(PieChartView*)chartView{
    double mult = range;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [values addObject:[[PieChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 5) label:parties[i % parties.count] icon: [UIImage imageNamed:@"icon"]]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"Election Results"];
    dataSet.selectionShift = 3;
    dataSet.drawIconsEnabled = NO;
    
    dataSet.sliceSpace = 2.0;
    [dataSet setValueTextColor:[UIColor whiteColor]];
    // add a lot of colors
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObject:CommonColor_Gray];
    [colors addObject:CommonColor_Blue];
    dataSet.colors = colors;
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

- (void)addSwipeGesture
{
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeView:)];
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeView:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [self.quansoView addGestureRecognizer:swipeLeft];
    [self.quansoView addGestureRecognizer:swipeRight];
}

- (void)handleSwipeView:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        DLog(@"Left Swipe");
        if([Common checkNetworkAvaiable]){
            self.timeLB.text    = [self forwardDate];
            if([self isCurrentDate]){
                self.arrowRightButton.enabled = NO;
                swipeLeft.enabled = NO;
            }
        } else{
            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
        }
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        DLog(@"Right Swipe");
        if([Common checkNetworkAvaiable]){
            self.timeLB.text    = [self preDate];
            _arrowRightButton.enabled = YES;
            swipeLeft.enabled = YES;
        } else {
            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
        }
    }
    
}


#pragma mark ChartDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    [self addPopoverAt:[chartView convertPoint:CGPointMake(highlight.xPx, highlight.yPx) toView:self.view]];
    NSLog(@"chartValueSelected");
    
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    [self closePop:nil];
    NSLog(@"chartValueNothingSelected");
}

- (void)resetHighLightValuesForAllCharts
{
    [self.countChartView highlightValues:NULL];
}

- (void)addPopoverAt:(CGPoint)position {
    [self closePop:^{
        AbsentInfo *absentVC = NEW_VC_FROM_NIB(AbsentInfo, @"AbsentInfo");
        absentVC.absentViewDelegate = self;
        [self showAlert:absentVC title:nil leftButtonTitle:nil rightButtonTitle:nil leftHander:nil rightHander:nil];
        [settingsPopoverController presentPopoverAsDialogAnimated:YES
                                                          options:WYPopoverAnimationOptionFadeWithScale];
    }];
}

- (void)closePop:(void  (^ _Nullable )(void))completion
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

#pragma mark data

- (void)setupArr{
    parties         = @[
                        @"", @""
                        ];
}

#pragma mark - AlertDelegate

- (void)didDismissAlert{
    [self resetHighLightValuesForAllCharts];
}

#pragma mark - WYPopoverControllerDelegate

- (void)popoverControllerDidPresentPopover:(WYPopoverController *)controller
{
    DLog(@"popoverControllerDidPresentPopover");
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

#pragma mark - AbsentDelegate

- (void)didDissmissView{
    [self resetHighLightValuesForAllCharts];
}

#pragma mark SOErrorViewDelegate

- (void)didRefreshOnErrorView:(SOErrorView *)errorView{
    [self addViews];
}

#pragma mark action

- (void)showNotConnectedView{
    errorView = (SOErrorView*)([[UINib nibWithNibName:@"SOErrorView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    
    errorView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    errorView.backgroundColor = AppColor_MainAppBackgroundColor;
    errorView.delegate  = self;
    [self.view addSubview:errorView];
}


- (NSString*)getCurrentDate{
    NSDateFormatter *dateFM = [[NSDateFormatter alloc]init];
    [dateFM setDateFormat:@"EEEE, dd/MM/yyyy"];
    return [dateFM stringFromDate:[NSDate date]];
}

- (NSString*)forwardDate{
    NSInteger _dayNumberNext        = 1;
    NSDateComponents *dayComponent  = [[NSDateComponents alloc] init];
    dayComponent.day                = _dayNumberNext;
    NSCalendar *theCalendar         = [NSCalendar currentCalendar];
    NSDate *nextDate                = [theCalendar dateByAddingComponents:dayComponent toDate:_currentDate options:0];
    _currentDate                    = nextDate;
    NSDateFormatter *dateFM         = [[NSDateFormatter alloc]init];
    [dateFM setDateFormat:@"EEEE, dd/MM/yyyy"];
    DLog(@"%@", [dateFM stringFromDate:[NSDate date]]);
    return [dateFM stringFromDate:nextDate];
}

- (NSString*)preDate{
    NSInteger _dayNumberBack        = -1;
    NSDateComponents *dayComponent  = [[NSDateComponents alloc] init];
    dayComponent.day                = _dayNumberBack;
    NSCalendar *theCalendar         = [NSCalendar currentCalendar];
    NSDate *preDate                 = [theCalendar dateByAddingComponents:dayComponent toDate:_currentDate options:0];
    _currentDate                    = preDate;
    NSDateFormatter *dateFM         = [[NSDateFormatter alloc]init];
    [dateFM setDateFormat:@"EEEE, dd/MM/yyyy"];
    DLog(@"%@", [dateFM stringFromDate:[NSDate date]]);
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

#pragma mark button action

- (IBAction)arrowRightAction:(id)sender {
    DLog(@"Button Next Quan so");
    if([Common checkNetworkAvaiable]){
        self.timeLB.text    = [self forwardDate];
        if([self isCurrentDate]){
            self.arrowRightButton.enabled = NO;
        }
    } else{
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}


- (IBAction)arrowLeftAction:(id)sender {
    DLog(@"Button Back Quan so");
    if([Common checkNetworkAvaiable]){
        self.timeLB.text    = [self preDate];
        self.arrowRightButton.enabled = YES;
    } else {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    
}

- (IBAction)pheDuyetRaNgoaiAction:(id)sender {
    ConfirmInOutVC_iPad *confirmInOutVC = NEW_VC_FROM_NIB(ConfirmInOutVC_iPad, @"ConfirmInOutVC_iPad");
    [self pushIntegrationVC:confirmInOutVC];
}

- (IBAction)pheDuyetCongAction:(id)sender {
    ManagerWorkVC_iPad *managerWorkVC = NEW_VC_FROM_NIB(ManagerWorkVC_iPad, @"ManagerWorkVC_iPad");
    [self pushIntegrationVC:managerWorkVC];
}

- (IBAction)traCuuNVAction:(id)sender {
}

- (IBAction)centerChartAction:(id)sender {
}
@end
