
//
//  MoreVC_iPad.m
//  SmartOffice
//
//  Created by Kaka on 4/24/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "MoreVC_iPad.h"
#import "QLTT_MainVC_iPad.h"
#import "SurveyViewController_iPad.h"
#import "PMTCViewController_iPad.h"

typedef enum : NSInteger{
    TableSection1Type_Reminder = 0,
    TableSection1Type_Storage,
    TableSection1Type_QLTT,
    TableSection1Type_Survey,
    TableSection1Type_KTTS,
    TableSection1Type_PMTC
}TableSection1Type;

#import "KTTS_PersonalInforVC_iPad.h"

@interface MoreVC_iPad () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation MoreVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    self.mainMoreTableView.delegate = self;
    self.mainMoreTableView.dataSource = self;
    
}
#pragma mark - Table datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return 6; //Reminder, Storage, Quan ly tri thuc, Survey, KTTS, PMTC
            break;
            
        default:
            return 2; //My Account & Setting
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellMoreIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell.imageView setImage:[UIImage imageNamed:@"tabbar_contact_icon"]];
    switch (indexPath.section) {
        case 1:
            [self configCellSection1:cell indexPath:indexPath];
            break;
            
        default: //section 0
            [self configCellSection0:cell indexPath:indexPath];
            break;
    }
    
    return cell;
}

- (void)pushSurveyView {
    SurveyViewController_iPad *surveyVC = NEW_VC_FROM_NIB(SurveyViewController_iPad, @"SurveyViewController_iPad");
    [self.navigationController pushViewController:surveyVC animated:YES];
}

- (void)pushQLTTView
{
    QLTT_MainVC_iPad *qltt_MasterVC = NEW_VC_FROM_NIB(QLTT_MainVC_iPad, @"QLTT_MainVC_iPad");
    [self.navigationController pushViewController:qltt_MasterVC animated:YES];
}
- (void)configCellSection1: (UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [cell.textLabel setText:KMORE_SCR_REMINDER];
            break;
        case 1:
            [cell.textLabel setText:KMORE_SCR_STORAGE];
            break;
        case 2:
            [cell.textLabel setText:KMORE_SCR_QLY_TRI_THUC];
            break;
        case 3:
            [cell.textLabel setText:KMORE_SCR_SURVEY];
            break;
        case 4:
            [cell.textLabel setText:KMORE_SCR_KTTS];
            break;
        case 5:
            [cell.textLabel setText:KMORE_SCR_PMTC];
            break;
        default:
            break;
    }
}

- (void)configCellSection0: (UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [cell.textLabel setText:KMORE_SCR_MY_ACCOUNT];
            break;
        case 1:
            [cell.textLabel setText:KMORE_SCR_SETTING];
            break;
        default:
            break;
    }
}

#pragma mark - Table delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"More setting select index: %ld", indexPath.row);
    switch (indexPath.section) {
        case 1:
            [self selectedTableViewSection1:tableView indexPath:indexPath];
            break;
            
        default: //section 0
            //            [self selectedTableViewSection0:tableView indexPath:indexPath];
            break;
    }

}

- (void)selectedTableViewSection1:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case TableSection1Type_QLTT:
        {
            [self pushQLTTView];
        }
            break;
        case TableSection1Type_Survey:
        {
            [self pushSurveyView];
        }
            break;
        case TableSection1Type_KTTS:
        {
            KTTS_PersonalInforVC_iPad *conversationVC = [[KTTS_PersonalInforVC_iPad alloc] initWithNibName:@"KTTS_PersonalInforVC_iPad" bundle:nil];
            [self.navigationController pushViewController:conversationVC animated:YES];
        }
            break;
        case TableSection1Type_PMTC:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PMTC_iPad" bundle:nil];
            PMTCViewController_iPad *pmtc_iPad = (PMTCViewController_iPad *)[storyboard instantiateViewControllerWithIdentifier:@"PMTCViewController_iPad"];
            [self.navigationController pushViewController:pmtc_iPad animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
