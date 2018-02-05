//
//  More_ListSurvey_iPad.m
//  SmartOffice
//
//  Created by NguyenDucBien on 5/19/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "More_ListSurvey_iPad.h"
#import "ListSurveyCell.h"
#import "PerformSurveyViewController.h"
#import "SOTableViewRowAction.h"
#import "ReminderSurveyVC.h"
#import "SurveyProcessor.h"
#import "SurveyListModel.h"
#import "WorkNoDataView.h"
#import "SOErrorView.h"
#import "MBProgressHUD.h"
#import "Common.h"



@interface More_ListSurvey_iPad () <UITableViewDelegate, UITableViewDataSource, SOErrorViewDelegate>{
    SurveyListModel *surveylistModel;
    NSMutableArray *surveyList;
    SOErrorView *soErrorView;
}
@property (assign, nonatomic) NSInteger countSurvey;

@end

@implementation More_ListSurvey_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.checkOutTableView.delegate = self;
    self.checkOutTableView.dataSource = self;
    self.mTitle.text = @"Khảo sát";
    soErrorView = (SOErrorView *)([[UINib nibWithNibName:@"SOErrorView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    soErrorView.delegate = self;
    soErrorView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    soErrorView.lblErrorInfo.text = LocalizedString(@"KMORE_ERROR_SERVER_SURVEY");
    [self.view addSubview:soErrorView];
    soErrorView.hidden = YES;
    surveyList = [NSMutableArray new];
    [self countData];
}

- (void) countData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameter = @{
                                @"username": @"102026",
                                @"password": @"123456a@"
                                };
    [SurveyProcessor getCountDataSurvey:parameter handle:^(id result, NSString *error) {
        self.countSurvey = [result[@"return"] integerValue];
        [self getDataSurvey];
    } onError:^(NSString *Error) {
        [self donotInternet];
    } onException:^(NSString *Exception) {
        [self errorServer];
    }];
}

- (void) getDataSurvey {
    NSDictionary *parameter = @{
                                @"username": @"102026",
                                @"token": @"dgr34g",
                                @"start": IntToString(0),
                                @"limit": IntToString(self.countSurvey)
                                };
        [SurveyProcessor getDataSurvey:parameter handle:^(id result, NSString *error) {
            NSArray *array = result[@"result"];
            surveyList = (NSMutableArray *)[surveyList arrayByAddingObjectsFromArray:array];
            surveyList = [SurveyListModel arrayOfModelsFromDictionaries:array error:nil];
            if (surveyList.count > 0 ) {
                soErrorView.hidden = YES;
                self.checkOutTableView.hidden = NO;
                [self.checkOutTableView reloadData];
                [self hidenProcess];
            } else {
                [self errorSurvey];
            }
        } onError:^(NSString *Error) {
            [self errorServer];
        } onException:^(NSString *Exception) {
            [self donotInternet];
    }];
}

- (void) errorSurvey {
    self.checkOutTableView.hidden = YES;
    WorkNoDataView *workNoDataView = (WorkNoDataView *)([[UINib nibWithNibName:@"WorkNoDataView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    workNoDataView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    workNoDataView.contenLB.text = LocalizedString(@"KMORE_NO_DATA_SURVEY");
    [self.view addSubview:workNoDataView];
}

- (void) donotInternet {
    [self hidenProcess];
    soErrorView.hidden = NO;
}

- (void) errorServer {
    [self hidenProcess];
    [self errorSurvey];
}

- (void) hidenProcess {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)pushSurveyReminderVC {
    ReminderSurveyVC *rmVC = NEW_VC_FROM_NIB(ReminderSurveyVC, @"ReminderSurveyVC");
    [self.navigationController pushViewController:rmVC animated:YES];
}

#pragma mark Tableview Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return surveyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID_CELL = @"ListSurveyCell_iPad";
    
    ListSurveyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:@"ListSurveyCell" bundle:nil] forCellReuseIdentifier:ID_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    }
    SurveyListModel *surveyModel = surveyList[indexPath.row];
    cell.contentLabel.text = surveyModel.name;
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970: (surveyModel.startDate/1000)];
    NSDateFormatter *formatStart = [NSDateFormatter new];
    formatStart.dateFormat = @"HH:mm - dd/MM/yyyy";
    cell.timeStartUpLabel.text = [formatStart stringFromDate:startDate];
    
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970: (surveyModel.endDate/1000)];
    NSDateFormatter *formatEnd = [NSDateFormatter new];
    formatEnd.dateFormat = @"HH:mm - dd/MM/yyyy";
    cell.timeDeadlineLabel.text = [formatEnd stringFromDate:endDate];
    
    if (surveyModel.status == true) {
        cell.statusImage.image = [UIImage imageNamed:@"point_orange"];
    } else {
        cell.statusImage.image = [UIImage imageNamed:@"point_gray"];
    }
    
    cell.selectionStyle = UIAccessibilityTraitNone;
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    SOTableViewRowAction *reminderAction = [SOTableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:LocalizedString(@"KMORE_REMINDER") icon:[UIImage imageNamed:@"swipe_cell_reminder_icon"] color:RGB(243, 142, 49) handler:^(UITableViewRowAction* action, NSIndexPath* indexPath) {
        [self pushSurveyReminderVC];
    }];
    
    return @[reminderAction];
}

- (void) didRefreshOnErrorView:(SOErrorView *)errorView {
    [self countData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
