//
//  SurveyViewController.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SurveyViewController.h"
#import "SurveyCell.h"
#import "PerformSurveyViewController.h"
#import "SOTableViewRowAction.h"
#import "ReminderViewController.h"
#import "SurveyProcessor.h"
#import "SurveyListModel.h"
#import "WorkNoDataView.h"
#import "MBProgressHUD.h"
#import "Common.h"
#import "SVPullToRefresh.h"
#import "SOErrorView.h"

@interface SurveyViewController () <UITableViewDelegate, UITableViewDataSource, TTNS_BaseNavViewDelegate, SOErrorViewDelegate> {
    SurveyListModel *surveylistModel;
    NSMutableArray *surveyList;
    //    UIRefreshControl *refreshControl;
    SOErrorView *soErrorView;
}

@property (weak, nonatomic) IBOutlet UITableView *surveyTableView;

@end

@implementation SurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backTitle = LocalizedString(@"KMORE_SURVEY");
    surveyList = [NSMutableArray new];
    [self initErrorView];
    [self getDataSurvey];
}

- (void) initErrorView {
    soErrorView = (SOErrorView *)([[UINib nibWithNibName:@"SOErrorView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    soErrorView.delegate = self;
    soErrorView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height);
    soErrorView.lblErrorInfo.text = LocalizedString(@"KMORE_ERROR_SERVER_SURVEY");
    [self.view addSubview:soErrorView];
    soErrorView.hidden = YES;
}

- (void)didRefreshOnErrorView:(SOErrorView *)errorView {
    [self getDataSurvey];
}

- (void) getDataSurvey {
    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"username": @"169202",
                                @"token": @"dgr34g",
                                @"start": IntToString(0),
                                @"limit": IntToString(self.countSurvey)
                                };
    [SurveyProcessor getDataSurvey:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        NSArray *array = result[@"result"];
        surveyList = (NSMutableArray *)[surveyList arrayByAddingObjectsFromArray:array];
        surveyList = [SurveyListModel arrayOfModelsFromDictionaries:array error:nil];
        if (surveyList.count > 0 ) {
            [self.surveyTableView reloadData];
            if (self.iPad == YES) {
                [self selectFirstRow];
                [self.delegate hidenView];
            }
            self.surveyTableView.hidden = NO;
            soErrorView.hidden = YES;
        } else {
            [self addNoDataView];
        }
    } onError:^(NSString *Error) {
        [self errorServer];
    } onException:^(NSString *Exception) {
        [self donotInternet];
    }];
}

- (void) addNoDataView {
    WorkNoDataView *workNoDataView  = (WorkNoDataView*)([[UINib nibWithNibName:@"WorkNoDataView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    workNoDataView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    workNoDataView.contenLB.text    = LocalizedString(@"KMORE_NO_DATA_SURVEY");
    [self.view addSubview:workNoDataView];
}

- (void) errorServer {
    soErrorView.hidden = NO;
    self.surveyTableView.hidden = YES;
    [[Common shareInstance] dismissCustomHUD];
}

- (void) donotInternet {
    soErrorView.hidden = NO;
    self.surveyTableView.hidden = YES;
    [[Common shareInstance] dismissCustomHUD];
    [[Common shareInstance] showErrorHUDWithMessage:@"Mất kết nối Internet" inView: self.view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return surveyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SurveyCellID";
    SurveyCell *surveyCell = (SurveyCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    SurveyListModel *surveyModel = surveyList[indexPath.row];
    
    surveyCell.name_survey.text = surveyModel.name;
    
    NSDate *now = [NSDate date];
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970: (surveyModel.startDate/1000)];
    NSDateFormatter *formatStart = [NSDateFormatter new];
    formatStart.dateFormat = @"HH:mm - dd/MM/yyyy";
    surveyCell.start_date.text = [formatStart stringFromDate:startDate];
    
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970: (surveyModel.endDate/1000)];
    NSDateFormatter *formatEnd = [NSDateFormatter new];
    formatEnd.dateFormat = @"HH:mm - dd/MM/yyyy";
    surveyCell.end_date.text = [formatEnd stringFromDate:endDate];
    
    if (surveyModel.status == true) {
        surveyCell.img_status.image = [UIImage imageNamed:@"point_orange"];
    } else {
        surveyCell.img_status.image = [UIImage imageNamed:@"point_gray"];
    }
    
    //    if (self.iPad == NO) {
    //        surveyCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    }
    
    NSComparisonResult result = [now compare:endDate];
    switch (result) {
        case NSOrderedDescending:
            surveyCell.userInteractionEnabled = NO;
            break;
        case NSOrderedAscending:
            surveyCell.userInteractionEnabled = YES;
            break;
        default:
            break;
    }
    
    if (surveyCell.userInteractionEnabled == YES) {
        surveyCell.backgroundColor = [UIColor whiteColor];
    } else {
        surveyCell.backgroundColor = [UIColor colorWithRed:247/255.0f green:247/255.0f blue:249/255.0f alpha:1.0f];
    }
    
    [self.surveyTableView addPullToRefreshWithActionHandler:^{
        [self.surveyTableView.pullToRefreshView stopAnimating];
        surveyList = NULL;
        [self.surveyTableView reloadData];
        [self getDataSurvey];
    }];
    return surveyCell;
}

- (void) selectFirstRow {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.surveyTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    if (surveyList.count > 0) {
        [self tableView:self.surveyTableView didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SurveyListModel *surveyModel = surveyList[indexPath.row];
    if (self.iPad == NO) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PerformSurvey" bundle:nil];
        PerformSurveyViewController *performSurvey = (PerformSurveyViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PerformSurveyViewController"];
        performSurvey.stringURL = surveyModel.url;
        [self.navigationController pushViewController:performSurvey animated:YES];
    } else {
        [self.delegate didselectDelegate:surveyModel.url];
    }
}

//Swipe Cell
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    SOTableViewRowAction *reminderAction = [SOTableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:LocalizedString(@"KMORE_REMINDER") icon:[UIImage imageNamed:@"swipe_cell_reminder_icon"] color:RGB(243, 142, 49) handler:^(UITableViewRowAction* action, NSIndexPath* indexPath) {
        [self pushRemider];
    }];
    if (self.iPad == NO) {
        return @[reminderAction];
    } else {
        return @[];
    }
}

- (void) pushRemider {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Reminder" bundle:nil];
    ReminderViewController *reminder = (ReminderViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ReminderViewController"];
    [self.navigationController pushViewController:reminder animated:YES];
}

- (void)didTapBackButton {
    [self popToMoreRoot];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
