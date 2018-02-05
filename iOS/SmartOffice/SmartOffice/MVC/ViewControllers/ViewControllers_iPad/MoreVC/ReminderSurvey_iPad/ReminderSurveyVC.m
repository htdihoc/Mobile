//
//  ReminderSurveyVC.m
//  SmartOffice
//
//  Created by NguyenDucBien on 5/22/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "ReminderSurveyVC.h"
#import "DetaiReminderListVC.h"
#import "CreateReminderVC_iPad.h"


@interface ReminderSurveyVC ()<ListReminderDetailDelegate>

@end

@implementation ReminderSurveyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self addReminderListVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setupUI {
    self.VOffice_title = @"";
    self.VOffice_buttonTitles = @[@"More", @"Survey", @"Reminder"];
}

- (void)addReminderListVC {
    DetaiReminderListVC *reminderVC = NEW_VC_FROM_NIB(DetaiReminderListVC, @"DetaiReminderListVC");
    reminderVC.delegate = self;
    [self displayVC:reminderVC container:self.containerList];
    
}

- (void)addCreatNewReminderVC {
    CreateReminderVC_iPad *creatRD = NEW_VC_FROM_NIB(CreateReminderVC_iPad, @"CreateReminderVC_iPad");
    [self displayVC:creatRD container:self.containerDetail];
}


- (void)pressButton:(UIButton *)sender {
    [self addCreatNewReminderVC];
}


@end
