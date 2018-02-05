//
//  RegisterMore_iPad.m
//  SmartOffice
//
//  Created by Administrator on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "RegisterMore_iPad.h"
#import "UIView+BorderView.h"
#import "UIButton+BorderDefault.h"
#import "TimePickerVC.h"
#import "MZFormSheetController.h"
#import "Common.h"

typedef enum : NSInteger{
    choiseTimeFrom = 1,
    choiseTimeEnd
}choiseTime;

typedef enum :NSInteger{
    nameTV_reason = 1,
    nameTV_location
}nameTV;

@interface RegisterMore_iPad ()<TimePickerVCDelegate, UITextViewDelegate>{
@protected NSDate *_selectedDate;
@protected NSString *_stringStartDate;
@protected NSString *_stringEndDate;
@protected NSString *_stringStartTimeDetail;
@protected NSString *_stringEndTimeDetail;
@protected NSString *currentTime;
@protected choiseTime choiseTimeType;
}
@end

@implementation RegisterMore_iPad

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    [self setTextForLB];
    [self setBorderForView];
    [self setTagforTV];
    currentTime = [NSString stringWithFormat:@"  %@ -> %@", [[Common shareInstance] getCurrentTime], [[Common shareInstance] getCurrentTime]];
    [self.fromTimeButton setTitle:currentTime forState:UIControlStateNormal];
    [self.endTimeButton setTitle:currentTime forState:UIControlStateNormal];
    self.locationTV.delegate    = self;
    self.reasonTV.delegate      = self;
    [self.clearReasonButton setHidden:YES];
    [self.clearLocationButton setHidden:YES];
}

- (void)setTextForLB{
    self.fromTimeLB.text    = LocalizedString(@"TTNS_RegisterOtherFreeDay_Nghỉ_trước_từ");
    
    self.endTimeLB.text     = LocalizedString(@"TTNS_RegisterOtherFreeDay_Nghỉ_sau_từ");
    
    self.reasonLB.text      = LocalizedString(@"TTNS_RegisterOtherFreeDay_Nhập_lý_do_chi_tiết");
    
    self.locationLB.text    = LocalizedString(@"TTNS_RegisterOtherFreeDay_Nơi_nghỉ");
}

- (void)setTagforTV{
    self.reasonTV.tag = nameTV_reason;
    self.locationTV.tag = nameTV_location;
}

- (void)setBorderForView{
    [self.fromTimeButton setDefaultBorder];
    [self.endTimeButton setDefaultBorder];
    [self.reasonTV setBorderForView];
    [self.locationTV setBorderForView];
}

#pragma mark Action
- (void)showTimePicker {
    
//    if(self.timePickerVC == nil){
        self.timePickerVC = NEW_VC_FROM_NIB(TimePickerVC, @"TimePickerVC");
        self.timePickerVC.delegate = self;
//    }
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:self.timePickerVC];
    formSheet.presentedFormSheetSize = CGSizeMake(SCREEN_WIDTH_LANDSCAPE/2, SCREEN_HEIGHT_LANDSCAPE - (SCREEN_HEIGHT_LANDSCAPE/2.5));
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.cornerRadius = 12;
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    }];
}

- (void)setTextForTimeGoOut:(NSString *)startDate startDateDetail:(NSString *)startDateDetail endDate:(NSString *)endDate endDateDetail:(NSString *)endDateDetail choiseTime:(choiseTime)choiseTime{
    
    NSString *startTime     = [NSString stringWithFormat:@"%@ - %@", startDateDetail, startDate];
    NSString *endTime       = [NSString stringWithFormat:@"%@ - %@", endDateDetail, endDate];
    
    switch (choiseTime) {
        case 1:
            [self.fromTimeButton setTitle:[NSString stringWithFormat:@"  %@ -> %@", startTime, endTime] forState:UIControlStateNormal];
            break;
        case 2:
            [self.endTimeButton setTitle:[NSString stringWithFormat:@"  %@ -> %@", startTime, endTime] forState:UIControlStateNormal];
            break;
    }
    
}

#pragma mark IBAction

- (IBAction)fromTimeAction:(id)sender {
    [self showTimePicker];
    choiseTimeType = choiseTimeFrom;
}

- (IBAction)endTimeAction:(id)sender {
    [self showTimePicker];
    choiseTimeType = choiseTimeEnd;
}

- (IBAction)closeAction:(id)sender {
    [self.delegate pressButton:sender];
}
 - (IBAction)registerAction:(id)sender {
    
}

- (IBAction)clearReasonAction:(id)sender {
    self.reasonTV.text = @"";
}

- (IBAction)clearLocationAction:(id)sender {
    self.locationTV.text = @"";
}

#pragma mark TimePickerDelegate
- (void)didDismissView:(NSString *)startDate startDateDetail:(NSString *)startDateDetail endDate:(NSString *)endDate endDateDetail:(NSString *)endDateDetail
{
    _stringStartDate = startDate;
    _stringStartTimeDetail = startDateDetail;
    _stringEndDate = endDate;
    _stringEndTimeDetail = endDateDetail;
//    [self setTextForTimeGoOut:startDate startDateDetail:startDateDetail endDate:endDate endDateDetail:endDateDetail];
    [self setTextForTimeGoOut:startDate startDateDetail:startDateDetail endDate:endDate endDateDetail:endDateDetail choiseTime:choiseTimeType];
}

- (NSString *)getStartDate
{
    return _stringStartDate;
}
- (NSString *)getStartDateDetail
{
    return _stringStartTimeDetail;
}
- (NSString *)getEndDate
{
    return _stringEndDate;
}
- (NSString *)getEndDateDetail
{
    return _stringEndTimeDetail;
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    switch (textView.tag) {
        case nameTV_reason:
            [self.clearReasonButton setHidden:NO];
            break;
            
        case nameTV_location:
            [self.clearLocationButton setHidden:NO];
            break;
            
        default:
            break;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    switch (textView.tag) {
        case nameTV_reason:
            [self.clearReasonButton setHidden:YES];
            break;
            
        case nameTV_location:
            [self.clearLocationButton setHidden:YES];
            break;
            
        default:
            break;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        // Disable return key in keyboard
        //[textView resignFirstResponder];
        return NO;
    }
    
    if(textView.text.length + (text.length - range.length)> 256){
        DLog(@"Show Toast");
        [self showToastWithMessage:@"Không vượt quá 256 ký tự"];
    }
    return textView.text.length + (text.length - range.length) <= 256;
}

@end
