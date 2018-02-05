//
//  TimePickerVCViewController.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TimePickerVC.h"
#import "NSString+SizeOfString.h"
#import "NSException+Custom.h"
#import "MZFormSheetController.h"
#import "NSDate+Utilities.h"
#import "Common.h"
#import "NSDate+Utilities.h"
#import "NSString+StringToDate.h"
@interface TimePickerVC () <SO_CustomDatePickerDelegate, SO_CustomTimePickerDelegate>
{
    BOOL _isSelectedEndDate;
    BOOL _isSelectedStartDate;
    BOOL _isValideDateToGoOut;
    BOOL _isShowClockView;
    BOOL _isLoadView;
    NSDate *_selectedDate;
    NSString *_stringStartDate;
    NSString *_stringEndDate;
    NSString *_stringStartTimeDetail;
    NSString *_stringEndTimeDetail;
    
    NSDate *_startDate;
    NSDate *_endDate;
    
    NSDateFormatter *_clockFormatterDetail;
}
@property(nonatomic,strong) UIView *halfTransparentBackgroundView;
@end

@implementation TimePickerVC
@synthesize clockView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.nav_TimePickerVC.backgroundColor = AppColor_MainAppTintColor;
    [self.leftButton setTitle:LocalizedString(@"TimePickerVC_Thời_gian_nghỉ") forState:UIControlStateNormal];
    self.datePickerView.delegate = self;
    [self initValues];
    // Do any additional setup after loading the view from its nib.
}
- (void)initValues
{
    _selectedDate = [NSDate date];
    _clockFormatterDetail = [[NSDateFormatter alloc] init];
    [_clockFormatterDetail setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.delegate || ([self.delegate getStartDate] == nil || [self.delegate getStartDateDetail])) {
        [self setDefault];
    }
    else
    {
        [self.topView setStringToStartDate:[self.delegate getStartDate]];
        [self.topView setStringToStartDateDetail:[self.delegate getStartDateDetail]];
        [self.topView setStringToEndDate:[self.delegate getEndDate]];
        [self.topView setStringToEndDateDetail:[self.delegate getEndDateDetail]];
    }
    
}
- (void)setDefault
{
    [self setTitleForTopView:[NSString stringWithFormat:@"%02ld", (long)[NSDate currentHour]] minutes:[NSString stringWithFormat:@"%02ld", [NSDate currentMinute]] timeMode:[NSDate dateMode] selectedEndDate:NO];
    [self setTitleForTopView:[NSString stringWithFormat:@"%02ld", (long)[NSDate currentHour]] minutes:[NSString stringWithFormat:@"%02ld", [NSDate currentMinute]] timeMode:[NSDate dateMode] selectedEndDate:YES];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.view.frame.size.width != 350 && !_isLoadView) {
        _isLoadView = YES;
        CGFloat imageWidth = 38;
        self.leftButton.translatesAutoresizingMaskIntoConstraints = NO;
        CGFloat layoutToCheck = [self.leftButton.titleLabel.text widthOfString:self.leftButton.titleLabel.font] + imageWidth;
        if (layoutToCheck > self.view.frame.size.width/2) {
            layoutToCheck = self.view.frame.size.width/2;
        }
        NSLayoutConstraint *width = [NSLayoutConstraint
                                     constraintWithItem:self.leftButton
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1.0
                                     constant:layoutToCheck];
        [self.view addConstraint:width];
    }
}
- (BOOL)checkValidateDate
{
//    NSString *startDate = [NSString stringWithFormat:@"%@ %@", _stringStartDate, _stringStartTimeDetail];
//    NSString *endDate = [NSString stringWithFormat:@"%@ %@", _stringEndDate, _stringEndTimeDetail];
//    NSString *format = @"dd/MM/yyyy HH:mm a";
//    NSDate *startDate
    if (([_startDate compare:_endDate] == NSOrderedDescending) || [_startDate compare:_endDate] == NSOrderedSame) {
        return YES;
    }
    return NO;
}
- (void)showClockView
{
    _isShowClockView = YES;
    self.clockView = [[SO_CustomTimePicker alloc] initWithFrame:self.view.bounds];
    self.clockView.delegate = self;
    [self.clockView.clockView iniValuesForMode];
    self.halfTransparentBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.halfTransparentBackgroundView.backgroundColor = [UIColor blackColor]; //or whatever...
    self.halfTransparentBackgroundView.alpha = 0.5;
    [self.view addSubview: self.halfTransparentBackgroundView];
    [self.view addSubview:clockView];
    
    
    if ([self isSameDate] && ![self isLockMinuteView]) {
        [self.clockView.clockView selectCurrentDate];
        return;
    }
    if ([self isLockMinuteView]) {
        if (_isSelectedEndDate) {
            [self.clockView.clockView checkValidAbsentEndDate:12];
        }
        else
        {
            [self.clockView.clockView checkValidAbsentStartDate:12];
        }
    }
}
- (NSString *)getSelectedStringDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kAppNormalFormatDate];
    return [formatter stringFromDate:_selectedDate];
}

- (void)setTitleForTopView:(NSString *)hours minutes:(NSString *)minutes timeMode:(NSString *)timeMode selectedEndDate:(BOOL)isSelectedEndDate
{
    if (![hours isEqualToString:@""]) {
        NSString *stringFromDate = [self getSelectedStringDate];
        NSString *stringTimeDetail = [NSString stringWithFormat:@"%@:%@ %@", hours, minutes, timeMode];
        NSDate *date = [[NSString stringWithFormat:@"%@ %@", stringFromDate, stringTimeDetail] convertStringToDateWith:kFormat12H];
        if (!isSelectedEndDate) {
            _stringStartDate = stringFromDate;
            _stringStartTimeDetail = stringTimeDetail;
            _startDate = date;
        }
        else
        {
            _stringEndDate = stringFromDate;
            _stringEndTimeDetail = stringTimeDetail;
            _endDate = date;
        }
        [self setTitleForTopView:stringFromDate stringTimeDetail:stringTimeDetail selectedEndDate:isSelectedEndDate];
    }
}

- (void)setTitleForTopView:(NSString *)stringDate stringTimeDetail:(NSString *)stringTimeDetail selectedEndDate:(BOOL)isSelectedEndDate
{
    isSelectedEndDate == NO ?  [self.topView setStringToStartDate:stringDate] : [self.topView setStringToEndDate:stringDate];
    isSelectedEndDate == NO ?  [self.topView setStringToStartDateDetail:stringTimeDetail] : [self.topView setStringToEndDateDetail:stringTimeDetail];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInView:_topView];
        for (id sublayer in _topView.layer.sublayers) {
            if ([sublayer isKindOfClass:[CustomShapeLayer class]]) {
                CustomShapeLayer *shapeLayer = sublayer;
                if (CGPathContainsPoint(shapeLayer.path, 0, touchLocation, YES)) {
                    if ([shapeLayer.identifer isEqualToString:@"Left"]) {
                        [_topView.leftBottomIcon setHidden:NO];
                        [_topView.rightBottomIcon setHidden:YES];
                        _isSelectedEndDate = NO;
                        _topView.startTimeLayer.fillColor = [CommonColor_Blue CGColor];
                        _topView.endTimeLayer.fillColor = [AppColor_MainAppTintColor CGColor];
                    }
                    else
                    {
                        if (_stringStartDate == nil) {
                            return;
                        }
                        [_topView.leftBottomIcon setHidden:YES];
                        [_topView.rightBottomIcon setHidden:NO];
                        _isSelectedEndDate = YES;
                        _topView.endTimeLayer.fillColor = [CommonColor_Blue CGColor];
                        _topView.startTimeLayer.fillColor = [AppColor_MainAppTintColor CGColor];
                    }
                }
            }
        }
    }
}
#pragma mark Action
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController * _Nonnull formSheetController){
    }];
}
- (IBAction)check:(id)sender {
    
    if (_isLockMinuteView && (!_isValideDateToGoOut || !_isSelectedStartDate)) {
        [self showAbsentDateError];
        return;
    }
    if (![self checkValidateDate]) {
        [self showEndSelectedDateError];
    }
    else
    {
        if (IS_IPAD) {
            [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController * _Nonnull formSheetController) {
            }];
            if (self.delegate) {
                [self.delegate didDismissView:_stringStartDate startDateDetail:_stringStartTimeDetail endDate:_stringEndDate endDateDetail:_stringEndTimeDetail];
            }
            
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.delegate) {
                    [self.delegate didDismissView:_stringStartDate startDateDetail:_stringStartTimeDetail endDate:_stringEndDate endDateDetail:_stringEndTimeDetail];
                }
            }];
        }
        
    }
    
}

#pragma mark SO_CustomDatePickerDelegate
- (BOOL)calendarViewShouldSelectEndDate
{
    return _isSelectedEndDate;
}
- (void)calendarSelectedDate:(NSDate *)date
{
    _selectedDate = date;
    [self showClockView];
}
- (BOOL)isSameDate
{
    return [_stringStartDate isEqualToString:[self getSelectedStringDate]];
}

#pragma mark CustomTimePickerDelegate
- (void)SO_dismissClockViewWithHours:(NSString *)hours andMinutes:(NSString *)minutes andTimeMode:(NSString *)timeMode{
    _isShowClockView = NO;
    self.clockView.delegate = nil;
    [self.clockView removeFromSuperview];
    [self.halfTransparentBackgroundView removeFromSuperview];
    [self setTitleForTopView:hours minutes:minutes timeMode:timeMode selectedEndDate:_isSelectedEndDate];
    if (![hours isEqualToString:@""]) {
        if (!_isSelectedEndDate) {
            _isSelectedStartDate = YES;
        }
        else
        {
            _isValideDateToGoOut = YES;
        }
        
    }
    
}

- (void)showAbsentDateError
{
    [self showError:LocalizedString(@"Hãy chọn giờ bắt đầu và giờ kết thúc theo đúng khung giờ") inView:_isShowClockView == YES ? self.clockView.clockView : self.view];
}

- (void)showEndSelectedDateError
{
    [self showError:LocalizedString(@"Hãy chọn giờ kết thúc lớn hơn giờ bắt đầu") inView:_isShowClockView == YES ? self.clockView.clockView : self.view];
}
- (void)showStartSelectedDateError
{
    [self showError:LocalizedString(@"Hãy chọn giờ bắt đầu lớn hơn giờ hiện tại") inView:_isShowClockView == YES ? self.clockView.clockView : self.view] ;
}
- (void)showStartOutOfAbsentDate
{
    [self showError:LocalizedString(@"Đã hết khung giờ ra ngoài, vui lòng chọn ngày khác") inView:self.view];
}
- (void)showError:(NSString *)content inView:(UIView *)view
{
    [self handleErrorFromResult:nil withException:[NSException initWithString:content] inView:view];
}

- (BOOL)isLockMinuteView
{
    return _isLockMinuteView;
}
- (NSDate *)getSelectedDate
{
    return _selectedDate;
}

- (NSString *)getCheckingHours
{
    [_clockFormatterDetail setDateFormat:@"hh"];
    NSString *hours = @"";
    hours = [_clockFormatterDetail stringFromDate:[self getCheckingDate]];
    return hours;
}

- (NSString *)getCheckingMinutes
{
    [_clockFormatterDetail setDateFormat:@"mm"];
    NSString *minutes = @"";
    minutes = [_clockFormatterDetail stringFromDate:[self getCheckingDate]];
    return minutes;
}
- (BOOL)isAMMode
{
    [_clockFormatterDetail setDateFormat:@"a"];
    NSString *amMode = @"";
    amMode = [_clockFormatterDetail stringFromDate:[self getCheckingDate]];
    return [amMode isEqualToString:@"AM"];
}
- (NSDate *)getCheckingDate
{
    if (_isSelectedEndDate) {
        return _startDate;
    }
    else
    {
        return _endDate != nil ? _endDate : _startDate;
    }
}
@end
