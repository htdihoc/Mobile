//
//  SurveyViewController_iPad.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 8/22/29 H.
//  Copyright © 29 Heisei ITSOL. All rights reserved.
//

#import "SurveyViewController_iPad.h"
#import "SurveyViewController.h"
#import "CreateReminderVC_iPad.h"
#import "MZFormSheetController.h"
#import "Reachability.h"
#import "Common.h"

@interface SurveyViewController_iPad () <HideViewDelegate>

@property (strong, nonatomic) SurveyViewController *survey;
@property (strong, nonatomic) CreateReminderVC_iPad *createReminderVC;
@property (strong, nonatomic) MZFormSheetController *formSheet;

@end

@implementation SurveyViewController_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViewController];
    [self addTitle:@"Khảo sát"];
    self.survey.delegate = self;
}

- (void)hidenView {
    self.viewNoData.hidden = YES;
}

- (void)showView {
    self.viewNoData.hidden = NO;
}

- (void) addViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Survey" bundle:nil];
    self.survey = (SurveyViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SurveyViewController"];
    self.survey.iPad = YES;
    self.survey.view.frame = CGRectMake(0, 0, self.survey_view.frame.size.width, self.survey_view.frame.size.height);
    [self addChildViewController:self.survey];
    [self.survey_view addSubview:self.survey.view];
}

- (void)didselectDelegate:(NSString *)stringUrl {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[Common shareInstance] showErrorHUDWithMessage:@"Mất kết nối mạng" inView: self.view];
    } else {
        NSURL *url = [NSURL URLWithString:stringUrl];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:urlRequest];
    }
}

- (IBAction)reminderAction:(id)sender {
    if (self.createReminderVC == nil) {
        self.createReminderVC = NEW_VC_FROM_NIB(CreateReminderVC_iPad, @"CreateReminderVC_iPad");
//        self.createReminderVC.delegate  = self;
    }
    _formSheet = [[MZFormSheetController alloc] initWithViewController:self.createReminderVC];
    _formSheet.presentedFormSheetSize = CGSizeMake(SCREEN_WIDTH_LANDSCAPE - (SCREEN_WIDTH_LANDSCAPE/2), SCREEN_HEIGHT_LANDSCAPE - (SCREEN_HEIGHT_LANDSCAPE/2.5));
    //    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
    _formSheet.shadowRadius = 2.0;
    _formSheet.shadowOpacity = 0.3;
    _formSheet.cornerRadius = 12;
    _formSheet.shouldDismissOnBackgroundViewTap = YES;
    _formSheet.shouldCenterVertically = YES;
    _formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    [self mz_presentFormSheetController:_formSheet animated:YES completionHandler:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
