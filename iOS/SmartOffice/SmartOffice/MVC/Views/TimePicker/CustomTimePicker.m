//
//  CustomTimePicker.m
//  CustomTimePicker
//
//  Created by Amboj Goyal on 21/05/14.
//  Copyright (c) 2014 Amboj Goyal. All rights reserved.
//

#import "CustomTimePicker.h"
#import "NSDate+Utilities.h"
#define MAINCIRCLE_LINE_WIDTH 1.0f
#define kMainCircleRadius  15.0
#define kSmallCircleRadius  3.0
#define kConnectingLineLength  60.0
#define kColonWidth 3.0f
#define kColonHeight 4.0f
#define kColonOrigin 4.0f
#define tagPoint 110
@interface CustomTimePicker()

-(void)rotateHand:(UIView *)view rotationDegree:(float)degree;

@end


@implementation CustomTimePicker
@synthesize delegate;


UIColor * clockBackgroundColor;
UIColor * viewBackgroundColor;
UIColor * clockPointerColor;
UIColor * textColor;
UIColor * selectedTimeColor;

UIView *hoursCircle ;
UIView *minutesCircle ;
UIView *clockHandView;
UIView *lineView = nil;
UIView *selectedTimeView = nil;

CAShapeLayer *mask;

BOOL isTimevalueClicked;
BOOL isDarkThemeSelected;
BOOL isMinuteClockDisplayed;
BOOL isAMMode;
BOOL isCheckValidAbsentDate;
UIButton *doneButton = nil;
UIButton *cancelButton = nil;
UIButton * hoursButton = nil;
UIButton * minuteButton = nil;

UIView * seperatorLineView = nil;

UIButton * timeModeLabelAM = nil;
UIButton * timeModeLabelPM = nil;

int previousIndex = tagPoint;
int currentIndex = 0;
int clockHandIndex = tagPoint;

NSString *seperatorImageName = nil;

BOOL isFirstHour;
BOOL isFirstMinute;

NSString  *startDay;
NSString  *startMonth;
NSString  *startYear;

NSString  *checkingHours;
NSString  *checkingMinutes;
NSString  *startHourType;
//- (id)initWithFrame:(CGRect)frame withThemeDarkTheme:(BOOL)isDarkTheme {
- (id)initWithView:(CGRect)parentFrame withDarkTheme:(BOOL)isDarkTheme{
    self = [super initWithFrame:CGRectMake(0, 0, parentFrame.size.width *0.7, parentFrame.size.width)];
    if (self) {
        self.opaque = NO;
        
        isTimevalueClicked = FALSE;
        isMinuteClockDisplayed = FALSE;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateHand:)];
        panGesture.delegate = self;
        [panGesture setMaximumNumberOfTouches:1];
        [self addGestureRecognizer:panGesture];
        
        isDarkThemeSelected = isDarkTheme;
        if (isDarkTheme) {
            clockBackgroundColor = UIColorFromRGB(0x363636);
            viewBackgroundColor = UIColorFromRGB(0x404040);
            clockPointerColor = UIColorFromRGB(0x8C3A3A);
            textColor = [UIColor whiteColor];
            selectedTimeColor =UIColorFromRGB(0x8C3A3A);
            seperatorImageName = @"seperatorImage_Dark";
        }else{
            clockBackgroundColor = [UIColor purpleColor];
            viewBackgroundColor = [UIColor whiteColor];
            clockPointerColor = AppColor_MainAppTintColor;  //0xD4F0FB  // 0xCAE6E6
            selectedTimeColor = [UIColor whiteColor];
            textColor = [UIColor blackColor];
            seperatorImageName = @"seperator_LightTheme";
        }
        [self setBackgroundColor:viewBackgroundColor];
        [self createClockView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
        [clockHandView addGestureRecognizer:tapGesture];
    }
    return self;
}
- (void)iniValuesForMode
{
    if (([[self.delegate getSelectedDate] compareSameMonthAndYearWithOtherDay:[NSDate date]] == NSOrderedSame)) {
        isAMMode = [[NSDate dateMode] isEqualToString:LocalizedString(@"AM")];
    }
    else
    {
        isAMMode = YES;
    }
}
- (BOOL)isAM
{
    return [self isAM:[self currentHour]];
}

- (BOOL)isAM:(NSInteger)hours
{
    return hours - 12 < 0 ? YES:NO;
}
- (NSInteger)currentHour
{
    // In practice, these calls can be combined
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:now];
    
    return [components hour];
}
- (NSInteger)currentMinute
{
    // In practice, these calls can be combined
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMinute fromDate:now];
    
    return  [components minute];
}
#pragma mark - Private Methods Implementation.
- (void)rotateHand:(UIView *)view rotationDegree:(float)degree{
    [UIView animateWithDuration:1.0
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.transform = CGAffineTransformMakeRotation((degree)*(M_PI/180));
                         int finalValue =0;
                         if (isTimevalueClicked) {
                             finalValue =(int)(clockHandIndex - previousIndex);
                         }else{
                             finalValue = (int)(currentIndex - previousIndex);
                         }
                         
                         if (isMinuteClockDisplayed) {
                             finalValue = finalValue*5;
                             if (finalValue == 60)
                                 [minuteButton setTitle:@"00" forState:UIControlStateNormal];
                             else
                                 [minuteButton setTitle:[NSString stringWithFormat:@"%02d", finalValue] forState:UIControlStateNormal];
                         }else{
                             if (finalValue == 0) {
                                 [hoursButton setTitle:@"12" forState:UIControlStateNormal];
                             }
                             [hoursButton setTitle:[NSString stringWithFormat:@"%02d", finalValue] forState:UIControlStateNormal];
                         }
                         
                     } completion:^(BOOL finished) {
                         if (isCheckValidAbsentDate) {
                             [self checkAbsentDate];
                             isCheckValidAbsentDate = NO;
                         }
                         if (!isFirstHour) {
                             isFirstHour = YES;
                         }
                         else
                         {
                             if (!isMinuteClockDisplayed && ![self.delegate isLockMinuteView]) {
                                 [self showMinutesClock];
                             }
                             isTimevalueClicked = FALSE;
                         }
                         
                     }];
}

#pragma mark - Custom Action Methods
-(CGFloat)selectTimeBase:(id)sender
{
    clockHandIndex=tagPoint;
    UIButton *selectedButton = (UIButton *)sender;
    currentIndex = (int)selectedButton.tag;
    clockHandIndex = currentIndex;
    CGFloat degreesToRotate = (currentIndex - previousIndex)*30;
    return degreesToRotate;
}
-(void)selectTime:(id)sender{
    CGFloat degreesToRotate = [self selectTimeBase:sender];
    [self rotateHand:clockHandView rotationDegree:degreesToRotate];
    
}
-(void)timeClicked:(id)sender{
    isCheckValidAbsentDate = YES;
    [self selectTime:sender];
    
    
}
-(void)changeTimeSystem:(id)sender{
    
    UIButton *timeButton = (UIButton *)sender;
    if (timeButton.tag == 85){
        if ([timeButton.titleLabel.text rangeOfString:LocalizedString(@"AM")].length>0) {
            isAMMode = YES;
            [self setEnableAlphaFor:timeModeLabelAM];
            [self setDisableAlphaFor:timeModeLabelPM];
            
        }else{
            isAMMode = NO;
            [self setEnableAlphaFor:timeModeLabelPM];
            [self setDisableAlphaFor:timeModeLabelAM];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(isLockMinuteView)] && [self.delegate respondsToSelector:@selector(isLockMinuteView)]) {
        if ([self.delegate isSelectedEndDate]) {
            [self checkValidAbsentEndDate: [hoursButton.titleLabel.text integerValue]];
        }
        else
        {
            [self checkValidAbsentStartDate: [hoursButton.titleLabel.text integerValue]];
        }
    }
    
}
- (BOOL)checkValidateDate
{
    if ([self.delegate isSameDate]) {
        if ([hoursButton.titleLabel.text integerValue] < [NSDate currentHour]) {
            return NO;
        }
        else if([hoursButton.titleLabel.text integerValue] == [NSDate currentHour] && [minuteButton.titleLabel.text integerValue] < [NSDate currentMinute])
        {
            return NO;
        }
    }
    return YES;
}
- (void)timeSelectionComplete:(id)sender{
    isFirstHour = NO;
    previousIndex = tagPoint;
    currentIndex = 0;
    clockHandIndex = tagPoint;
    if (sender == doneButton) {
        NSLog(@"%@", hoursButton.titleLabel.text);
        //        if (![self checkValidateDate]) {
        //            [delegate showStartSelectedDateError];
        //        }
        if ([self.delegate isSameDate]) {
            checkingMinutes = [self.delegate getCheckingMinutes];
            checkingHours = [self.delegate getCheckingHours];
            if ([self.delegate isAMMode] == isAMMode) {
                if ([checkingHours integerValue] <= [self isAM:[checkingHours integerValue]] == NO ? [hoursButton.titleLabel.text integerValue]%12+12 : [hoursButton.titleLabel.text integerValue]) {
                    if ([checkingMinutes integerValue] >= [minuteButton.titleLabel.text integerValue]) {
                        if ([self.delegate isSelectedEndDate]) {
                            [self.delegate showEndSelectedDateError];
                        }
                        else
                        {
                            [self.delegate showStartSelectedDateError];
                        }
                        return;
                    }
                    
                }
                else
                {
                    [self.delegate showEndSelectedDateError];
                    return;
                }
            }
            else
            {
                if ([self.delegate isAMMode] == NO && isAMMode == YES) {
                    [self.delegate showStartSelectedDateError];
                    return;
                }
            }
            
        }
        checkingHours = hoursButton.titleLabel.text;
        checkingMinutes = minuteButton.titleLabel.text;
        startHourType = isAMMode == YES ? LocalizedString(@"AM") : LocalizedString(@"PM");
        [delegate dismissClockViewWithHours:hoursButton.titleLabel.text andMinutes:minuteButton.titleLabel.text andTimeMode:isAMMode == YES ? LocalizedString(@"AM") : LocalizedString(@"PM")];
        [self removeFromSuperview];
    }
    else
    {
        [delegate dismissClockViewWithHours:@"" andMinutes:@"" andTimeMode:@""];
        [self removeFromSuperview];
    }
    
}
-(void)showHourClock{
    [self setEnableAlphaFor:hoursButton];
    [self setDisableAlphaFor:minuteButton];
    [hoursButton setTitleColor:selectedTimeColor forState:UIControlStateNormal];
    //    [minuteButton setTitleColor:textColor forState:UIControlStateNormal];
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         hoursCircle.transform = CGAffineTransformIdentity;
                         [hoursCircle setAlpha:1];
                         minutesCircle.transform = CGAffineTransformIdentity;
                         [minutesCircle setAlpha:0];
                         int degreeToRotate = [hoursButton.titleLabel.text intValue] *30;
                         clockHandView.transform = CGAffineTransformMakeRotation((degreeToRotate)*(M_PI/180));
                         
                     }completion:^(BOOL finished) {
                         isMinuteClockDisplayed = FALSE;
                         
                     }];
    
    hoursButton.transform = CGAffineTransformMakeScale(0.5,0.5);
    [UIView beginAnimations:@"fadeInNewView" context:NULL];
    [UIView setAnimationDuration:1.0];
    hoursButton.transform = CGAffineTransformMakeScale(1,1);
    [UIView commitAnimations];
    
}
-(void)showMinutesClock{
    [self setDisableAlphaFor:hoursButton];
    [self setEnableAlphaFor:minuteButton];
    //    [hoursButton setTitleColor:textColor forState:UIControlStateNormal];
    [minuteButton setTitleColor:selectedTimeColor forState:UIControlStateNormal];
    [UIView animateWithDuration:0.8
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         hoursCircle.transform = CGAffineTransformMakeScale(1.2, 1.2);
                         [hoursCircle setAlpha:0];
                         minutesCircle.transform = CGAffineTransformMakeScale(1.28, 1.28);
                         [minutesCircle setAlpha:1.0];
                         float degreeToRotate = (float)([minuteButton.titleLabel.text floatValue]/5);
                         clockHandView.transform = CGAffineTransformMakeRotation((degreeToRotate*30)*(M_PI/180));
                     }completion:^(BOOL finished) {
                         isMinuteClockDisplayed = TRUE;
                     }];
    minuteButton.transform = CGAffineTransformMakeScale(0.5,0.5);
    [UIView beginAnimations:@"fadeInNewView" context:NULL];
    [UIView setAnimationDuration:1.0];
    minuteButton.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
    
}

- (void)selectDate:(NSInteger)hour minute:(NSInteger)minute
{
    [minuteButton setTitle:[NSString stringWithFormat:@"%02ld", minute] forState:UIControlStateNormal];
    
    if (hour >= 12) {
        [self selectTime:[self viewWithTag:tagPoint + (hour == 12 ? 12 : (hour%12))]];
        [self setEnableAlphaFor:timeModeLabelPM];
        [self setDisableAlphaFor:timeModeLabelAM];
        isAMMode = NO;
    }
    else
    {
        [self selectTime:[self viewWithTag:tagPoint+hour]];
        [self setEnableAlphaFor:timeModeLabelAM];
        [self setDisableAlphaFor:timeModeLabelPM];
        isAMMode = YES;
    }
    
}


- (void)checkValidAbsentDate:(NSInteger)startAtHours startAtMinutes:(NSInteger)startAtMinutes endAt:(NSInteger)endAtHours endAtMinutes:(NSInteger)endAtMinutes hoursToCheck:(NSInteger)hoursToCheck
{
    if ([[self.delegate getSelectedDate] compareSameMonthAndYearWithOtherDay:[NSDate date]] == NSOrderedSame) {
        BOOL isAMModeToCompare = [self isAM:[[self.delegate getCheckingHours] integerValue]];
        if (isAMModeToCompare) {
            if ([NSDate currentHour]%12 < startAtHours%12 && [NSDate currentMinute] <= startAtMinutes) {
                [self selectDate:startAtHours minute:startAtMinutes];
            }
            else
            {
                [self selectDate:endAtHours minute:endAtMinutes];
            }
            
        }
        else if([NSDate currentHour]%12 < endAtHours%12)
        {
            [self selectDate:endAtHours minute:endAtMinutes];
        }
        else
        {
            if ([NSDate currentHour]%12 == endAtHours%12 && [NSDate currentMinute] <= endAtMinutes) {
                [self selectDate:endAtHours minute:endAtMinutes];
            }
            else
            {
                [self.delegate showStartOutOfAbsentDate];
                [delegate dismissClockViewWithHours:@"" andMinutes:@"" andTimeMode:@""];
            }
        }
    }
    else
    {
        
        if ((startAtHours >= 12 && endAtHours >= 12) || (startAtHours < 12 && endAtHours < 12)){
            NSInteger rangeHours = 0;
            startAtHours = startAtHours%12 + 12;
            endAtHours = endAtHours%12 + 12;
            NSInteger statement;
            if (hoursToCheck >= 6) {
                rangeHours = (12 - ABS(startAtHours - endAtHours))/2 + (ABS(startAtHours - endAtHours)%2 == 0 ? 1 : 0);
                statement = ABS(startAtHours - hoursToCheck);
            }
            else
            {
                rangeHours = ABS(startAtHours - endAtHours)/2 + (ABS(endAtHours - startAtHours)%2 == 0 ? 1 : 0);
                statement = ABS((startAtHours == 12 ? 0 : startAtHours) - hoursToCheck);
            }
            
            if (rangeHours > statement) {
                [self selectDate:startAtHours minute:startAtMinutes];
            }
            else
            {
                [self selectDate:endAtHours minute:endAtMinutes];
            }
        }
        else
        {
            if (isAMMode) {
                [self selectDate:startAtHours minute:startAtMinutes];
            }
            else
            {
                [self selectDate:endAtHours minute:endAtMinutes];
            }
        }
    }
    
}
- (BOOL)checkAbsentDate
{
    if ([self.delegate isLockMinuteView]) {
        if ([self.delegate isSelectedEndDate]) {
            [self checkValidAbsentEndDate: [hoursButton.titleLabel.text integerValue]];
        }
        else
        {
            [self checkValidAbsentStartDate: [hoursButton.titleLabel.text integerValue]];
        }
        
        return NO;
    }
    return YES;
}

- (void)checkValidAbsentStartDate:(NSInteger)hoursToCheck
{
    [self checkValidAbsentDate:8 startAtMinutes:0 endAt:13 endAtMinutes:30 hoursToCheck:hoursToCheck];
    
}

- (void)checkValidAbsentEndDate:(NSInteger)hoursToCheck
{
    [self checkValidAbsentDate:12 startAtMinutes:0 endAt:17 endAtMinutes:30 hoursToCheck:hoursToCheck];
    
}
#pragma mark - Gesture Handling Methods

- (void)rotateHand:(UIPanGestureRecognizer *)recognizer {
    UIView * currentView ;
    if (isMinuteClockDisplayed) {
        currentView = minutesCircle;
    }else{
        currentView = hoursCircle;
    }
    CGPoint translation = [recognizer locationInView:currentView];
    CGFloat angleInRadians = atan2f(translation.y - currentView.frame.size.height/2, translation.x - currentView.frame.size.width/2);
    if (isMinuteClockDisplayed) {
        float minutesFloat =(atan2f((translation.x - currentView.frame.size.height/2), (translation.y - currentView.frame.size.width/2)) * -(180/M_PI) + 180)/6;
        float roundedUp = lroundf(minutesFloat);
        if (roundedUp == 60)
            roundedUp = 00;
        [minuteButton setTitle:[NSString stringWithFormat:@"%02d", (int)roundedUp] forState:UIControlStateNormal];
    }else{
        //Calculate Hours.
        NSUInteger hours = (atan2f((translation.x - currentView.frame.size.height/2), (translation.y - currentView.frame.size.width/2)) * -(180/M_PI) + 180)/30;
        if (hours == 0)
            hours = 12;
        [hoursButton setTitle:[NSString stringWithFormat:@"%02d", (int)hours] forState:UIControlStateNormal];
    }
    float angle = angleInRadians + M_PI/2;
    NSLog(@"%f", angle);
    clockHandView.transform = CGAffineTransformMakeRotation(angle);
    if(recognizer.state == UIGestureRecognizerStateEnded){
        //Code that manages when hour selection is done.
        if (![self checkAbsentDate]) {
            return;
        }
        if (!isMinuteClockDisplayed)
            [self showMinutesClock];
    }
}
-(void) tapGestureHandler:(UITapGestureRecognizer *)sender {
    isTimevalueClicked = TRUE;
    CGPoint point = [sender locationInView:sender.view];
    if (point.y>170 && point.y<190) {
        int previousvalue = (int)(clockHandIndex-previousIndex)*30;
        clockHandIndex = clockHandIndex+6;
        if (clockHandIndex>122) {
            clockHandIndex = clockHandIndex-122+previousIndex;
        }
        [self rotateHand:clockHandView rotationDegree:180+previousvalue];
    }
}


#pragma mark - Custom UI Methods
-(void)createClockView{
    hoursCircle = [[UIView alloc] initWithFrame:CGRectMake(0,selectedTimeView.frame.size.height,self.frame.size.height*0.5, self.frame.size.height*0.5)];
    hoursCircle.center = CGPointMake(self.center.x, self.frame.size.height/4+hoursCircle.frame.size.height/2+self.frame.size.height/16);
    hoursCircle.alpha = 0.8;
    hoursCircle.layer.cornerRadius = hoursCircle.frame.size.width/2;
    hoursCircle.backgroundColor = CommonColor_LightGray;
    [self addSubview:hoursCircle];
    //Adding the Hours Number on hours Circle.
    [self addNumbers:TRUE];
    
    minutesCircle = [[UIView alloc] initWithFrame:CGRectMake(50,50,self.frame.size.width*0.6, self.frame.size.width*0.6)];
    minutesCircle.alpha = 0.0;
    minutesCircle.layer.cornerRadius = minutesCircle.frame.size.width/2;
    minutesCircle.backgroundColor = CommonColor_LightGray;
    minutesCircle.center = hoursCircle.center;
    [self addSubview:minutesCircle];
    //Adding the Minutes Number on Minutes Circle.
    [self addNumbers:FALSE];
    
    //View to Display the Selected Time.
    selectedTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/4)];
    selectedTimeView.backgroundColor = AppColor_MainAppTintColor;
    
    hoursButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.origin.x + 30 , selectedTimeView.frame.size.height/2 - self.frame.size.height/24, self.frame.size.width/4, self.frame.size.height/12)];
    [hoursButton setTitle:@"12" forState:UIControlStateNormal];
    [hoursButton setTitleColor:selectedTimeColor forState:UIControlStateNormal];
    [hoursButton.titleLabel setFont:[UIFont boldSystemFontOfSize:self.frame.size.width/6]];
    [hoursButton setBackgroundColor:[UIColor clearColor]];
    [hoursButton addTarget:self action:@selector(showHourClock) forControlEvents:UIControlEventTouchUpInside];
    [selectedTimeView addSubview:hoursButton];
    
    //Creating Seperator Label.
    
    seperatorLineView = [[UIView alloc] initWithFrame:CGRectMake(hoursButton.frame.origin.x + hoursButton.frame.size.width+10 , hoursButton.frame.origin.y, 10, 30)];
    seperatorLineView.center = CGPointMake(seperatorLineView.center.x, hoursButton.center.y);
    [seperatorLineView setBackgroundColor:[UIColor clearColor]];
    [selectedTimeView addSubview:seperatorLineView];
    [self addTimeSeperatorWith:CGRectMake(kColonOrigin,6,kColonWidth,kColonHeight )];
    [self addTimeSeperatorWith:CGRectMake(kColonOrigin,22,kColonWidth,kColonHeight)];
    
    //Creating Minute Label.
    
    minuteButton = [[UIButton alloc] initWithFrame:CGRectMake(seperatorLineView.frame.origin.x +seperatorLineView.frame.size.width+10 , hoursButton.frame.origin.y, self.frame.size.width/4, self.frame.size.height/12)];
    [minuteButton setTitle:@"00" forState:UIControlStateNormal];
    [minuteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setDisableAlphaFor:minuteButton];
    [minuteButton.titleLabel setFont:[UIFont boldSystemFontOfSize:self.frame.size.width/6]];
    [minuteButton setBackgroundColor:[UIColor clearColor]];
    [minuteButton addTarget:self action:@selector(showMinutesClock) forControlEvents:UIControlEventTouchUpInside];
    [selectedTimeView addSubview:minuteButton];
    
    //Creating TimeSystem Label.
    
    timeModeLabelAM = [[UIButton alloc] initWithFrame:CGRectMake(minuteButton.frame.origin.x + minuteButton.frame.size.width, hoursButton.frame.origin.y, 50, 30)];
    timeModeLabelAM.center = CGPointMake(timeModeLabelAM.center.x, hoursButton.center.y - 10);
    [timeModeLabelAM setTitle:LocalizedString(@"AM")  forState:UIControlStateNormal];
    [timeModeLabelAM setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [timeModeLabelAM.titleLabel setFont:[UIFont boldSystemFontOfSize:self.frame.size.width/12]];
    [timeModeLabelAM setBackgroundColor:[UIColor clearColor]];
    [timeModeLabelAM setTag:85];
    [timeModeLabelAM addTarget:self action:@selector(changeTimeSystem:) forControlEvents:UIControlEventTouchUpInside];
    [selectedTimeView addSubview:timeModeLabelAM];
    
    timeModeLabelPM = [[UIButton alloc] initWithFrame:CGRectMake(minuteButton.frame.origin.x + minuteButton.frame.size.width, hoursButton.frame.origin.y+20, 50, 30)];
    timeModeLabelPM.center = CGPointMake(timeModeLabelPM.center.x, hoursButton.center.y + 10);
    [self setDisableAlphaFor:timeModeLabelPM];
    [timeModeLabelPM setTitle:LocalizedString(@"PM") forState:UIControlStateNormal];
    [timeModeLabelPM setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [timeModeLabelPM.titleLabel setFont:[UIFont boldSystemFontOfSize:self.frame.size.width/12]];
    [timeModeLabelPM setBackgroundColor:[UIColor clearColor]];
    [timeModeLabelPM setTag:85];
    [timeModeLabelPM addTarget:self action:@selector(changeTimeSystem:) forControlEvents:UIControlEventTouchUpInside];
    [selectedTimeView addSubview:timeModeLabelPM];
    [self addSubview:selectedTimeView];
    
    
    doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height-50, self.frame.size.width/2, 50)];
    [doneButton setTitle:LocalizedString(@"TimePicker_OK") forState:UIControlStateNormal];
    [doneButton setTitleColor:textColor forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [doneButton addTarget:self action:@selector(timeSelectionComplete:) forControlEvents:UIControlEventTouchUpInside];
    doneButton.layer.borderColor = AppColor_BorderForView.CGColor;
    doneButton.layer.borderWidth = 1.0;
    [self addSubview:doneButton];
    
    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height-50, self.frame.size.width/2, 50)];
    [cancelButton setTitle:LocalizedString(@"TimePicker_Đóng") forState:UIControlStateNormal];
    [cancelButton setTitleColor:textColor forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    cancelButton.layer.borderColor = AppColor_BorderForView.CGColor;
    cancelButton.layer.borderWidth = 1.0;
    [cancelButton addTarget:self action:@selector(timeSelectionComplete:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    //Creating Clock Hand View.
    
    clockHandView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-15, hoursCircle.frame.origin.y, 30, 0.5*self.frame.size.height)];
    [clockHandView.layer setCornerRadius:5.0];
    [clockHandView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:clockHandView];
    
    //Creating the clock Hand.
    [self drawClockHand];
    
    self.layer.cornerRadius = 16;
    self.clipsToBounds = YES;
    
}
- (void)selectCurrentDate
{
    if (![self.delegate isLockMinuteView]) {
        [minuteButton setTitle:[NSString stringWithFormat:@"%02ld", [self currentMinute]] forState:UIControlStateNormal];
    }
    else
    {
        [minuteButton setTitle:@"00" forState:UIControlStateNormal];
    }
    
    if ([self isAM]) {
        isAMMode = YES;
        [self setEnableAlphaFor:timeModeLabelAM];
        [self setDisableAlphaFor:timeModeLabelPM];
    }
    else
    {
        isAMMode = NO;
        [self setEnableAlphaFor:timeModeLabelPM];
        [self setDisableAlphaFor:timeModeLabelAM];
    }
    [self selectTime:[self viewWithTag:tagPoint+([self currentHour]%12)]];
    [hoursButton setTitle:[NSString stringWithFormat:@"%02ld", [self currentHour]%12] forState:UIControlStateNormal];
}
-(void)addTimeSeperatorWith:(CGRect)rect{
    UIBezierPath *selectorCirclePath = [UIBezierPath bezierPathWithRect:rect];
    CAShapeLayer *selectorCircleLayer = [CAShapeLayer layer];
    selectorCircleLayer.path = selectorCirclePath.CGPath;
    [selectorCircleLayer setStrokeColor:[UIColor whiteColor].CGColor];
    selectorCircleLayer.lineWidth = MAINCIRCLE_LINE_WIDTH;
    [selectorCircleLayer setFillColor:textColor.CGColor];
    [seperatorLineView.layer addSublayer:selectorCircleLayer];
}

-(void)addNumbers:(BOOL)isHour{
    double perAngle = 2 * M_PI / 12;
    CGFloat x_point;
    CGFloat y_point;
    
    for (int i = 1; i < 13; i++) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setFrame:CGRectMake(0,0, 30, 30)];
        [bt setTag:tagPoint+i];
        
        [bt setBackgroundColor:[UIColor clearColor]];
        [bt.layer setCornerRadius:bt.frame.size.width/2];
        if (!isHour) {
            [bt.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0]];
            x_point = minutesCircle.frame.size.width/2 + sin(perAngle*i)*(minutesCircle.frame.size.width/2 - kMainCircleRadius);
            y_point = minutesCircle.frame.size.height/2 - cos(perAngle*i)*(minutesCircle.frame.size.width/2 - kMainCircleRadius);
            if (i*5 == 60) {
                [bt setTitle:@"00" forState:UIControlStateNormal];
            }else
                [bt setTitle:[NSString stringWithFormat:@"%02d",5*i] forState:UIControlStateNormal];
            [minutesCircle addSubview:bt];
            [bt setTitleColor:textColor forState:UIControlStateNormal];
        }else{
            [bt.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
            x_point = hoursCircle.frame.size.width/2 + sin(perAngle*i)*(hoursCircle.frame.size.width/2 - kMainCircleRadius);
            y_point = hoursCircle.frame.size.height/2 -cos(perAngle*i)*(hoursCircle.frame.size.width/2 - kMainCircleRadius);
            [bt setTitle:[NSString stringWithFormat:@"%02d",i] forState:UIControlStateNormal];
            [bt setTitleColor:textColor forState:UIControlStateNormal];
            [hoursCircle addSubview:bt];
        }
        
        [bt setCenter:CGPointMake(x_point, y_point)];
        [bt addTarget:self action:@selector(timeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self bringSubviewToFront:bt];
        
        
    }
    
    
}
- (void)drawClockHand{
    // Define shape
    NSEnumerator *enumerator = [mask.sublayers reverseObjectEnumerator];
    for(CALayer *layer in enumerator) {
        [layer removeFromSuperlayer];
    }
    
    // Shape layer mask
    mask = [CAShapeLayer layer];
    [mask setFillRule:kCAFillRuleEvenOdd];
    [mask setFillColor:[[UIColor colorWithHue:0.0f saturation:0.0f brightness:0.0f alpha:0.9f] CGColor]];
    [mask setBackgroundColor:[[UIColor clearColor] CGColor]];
    [clockHandView.layer addSublayer:mask];
    UIBezierPath *centerCirclePath = [UIBezierPath bezierPath];
    
    CGPoint centerCirclePoint =  CGPointMake(clockHandView.frame.size.width/2, clockHandView.frame.size.height/2);
    centerCirclePath = [UIBezierPath bezierPathWithArcCenter:centerCirclePoint
                                                      radius:kSmallCircleRadius
                                                  startAngle:0 endAngle:DEGREES_TO_RADIANS(360)
                                                   clockwise:NO];
    
    [centerCirclePath moveToPoint:CGPointMake(clockHandView.frame.size.width/2, clockHandView.frame.size.height/2)];
    CGPoint line_Point = CGPointMake(centerCirclePoint.x,centerCirclePoint.y - (hoursCircle.frame.size.width/2 - kMainCircleRadius/2)); //coordinates
    [centerCirclePath addLineToPoint:CGPointMake(centerCirclePoint.x,centerCirclePoint.y - (hoursCircle.frame.size.width/2 - 2*kMainCircleRadius))];//line to circle
    UIBezierPath *selectorCirclePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(line_Point.x-1.0f, line_Point.y + kMainCircleRadius/2)
                                                                      radius:kMainCircleRadius
                                                                  startAngle:0
                                                                    endAngle:DEGREES_TO_RADIANS(360)
                                                                   clockwise:NO];
    CAShapeLayer *selectorCircleLayer = [CAShapeLayer layer];
    selectorCircleLayer.path = selectorCirclePath.CGPath;
    [selectorCircleLayer setStrokeColor:clockPointerColor.CGColor];
    selectorCircleLayer.lineWidth = MAINCIRCLE_LINE_WIDTH;
    [selectorCircleLayer setFillColor:clockPointerColor.CGColor];
    selectorCircleLayer.opacity = 0.5f;
    
    //Small Circle Layer
    CAShapeLayer *centerCircleLayer = [CAShapeLayer layer];
    centerCircleLayer.path = centerCirclePath.CGPath;
    [centerCircleLayer setStrokeColor:clockPointerColor.CGColor];
    centerCircleLayer.lineWidth = 1.0f;
    [centerCircleLayer setFillColor:clockPointerColor.CGColor];
    centerCircleLayer.opacity = 1.5f;
    [mask addSublayer:selectorCircleLayer];
    [mask addSublayer:centerCircleLayer];
}

- (void)setDisableAlphaFor:(UIView *)subView
{
    subView.alpha = 0.5;
}
- (void)setEnableAlphaFor:(UIView *)subView
{
    subView.alpha = 1.0;
}
@end
