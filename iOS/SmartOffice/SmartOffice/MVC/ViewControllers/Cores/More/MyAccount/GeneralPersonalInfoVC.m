//
//  GeneralPersonalInfoVC.m
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 4/6/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "GeneralPersonalInfoVC.h"
//#import "PersonalAssetInfoVC.h"
#import "PersonalInfoView.h"
#import "PersonalInfoSegmentView.h"

@interface GeneralPersonalInfoVC () {
    PersonalInfoView *personalView;
}

@end

@implementation GeneralPersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)closeModalView {
    [self dismissViewControllerAnimated:YES completion:^{
        DLog(@"GeneralPersonalInfoVC dismissViewControllerAnimated");
        [[AppDelegate getInstance] removeMoreVCFromApp];
    }];
}


- (IBAction)btnClose:(id)sender {
    
}

#pragma mark - Table datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellGPIndentifier = @"cellGPIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellGPIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellGPIndentifier];
    }
    
    [self configCellSection0:cell indexPath:indexPath];
    
    return cell;
}

- (void)configCellSection0: (UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    [cell.imageView setImage:[UIImage imageNamed:@"tabbar_contact_icon"]];
    switch (indexPath.row) {
        case 0:
            [cell.textLabel setText:KGENERALINFO_SCR_PERSIONAL_ASSEST];
            break;
        case 1:
            [cell.textLabel setText:KGENERALINFO_SCR_TRAINING_PROCESS];
            break;
        case 2:
            [cell.textLabel setText:KGENERALINFO_SCR_SALARY];
            break;
        case 3:
            [cell.textLabel setText:KGENERALINFO_SCR_INSTRUMENT];
            break;
        case 4:
            [cell.textLabel setText:KGENERALINFO_SCR_BONUS];
            break;
        case 5:
            [cell.textLabel setText:KGENERALINFO_SCR_SOCIAL_INST];
            break;
        case 6:
            [cell.textLabel setText:KGENERALINFO_SCR_PER_TYPE];
            break;
        case 7:
            [cell.textLabel setText:KGENERALINFO_SCR_AWARD];
            break;
        case 8:
            [cell.textLabel setText:KGENERALINFO_SCR_TAX];
            break;
        case 9:
            [cell.textLabel setText:KGENERALINFO_SCR_FILES];
            break;
        case 10:
            [cell.textLabel setText:KGENERALINFO_SCR_RELATIONSHIP];
            break;
        
        default:
            break;
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[PersonalInfoView identifier]];
    if (headerView == nil) {
        [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:[PersonalInfoView identifier]];
        headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[PersonalInfoView identifier]];
    }
    if (personalView == nil) {
        personalView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PersonalInfoView class]) owner:self options:nil] firstObject];
        [personalView setFrame:headerView.frame];
    }
    
    
    [headerView addSubview:personalView];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120;
}

#pragma mark - Table delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectedTableViewSection0:tableView indexPath:indexPath];
}

- (void)selectedTableViewSection0:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            PersonalInfoSegmentView *persionalAssetInfoVC = [[PersonalInfoSegmentView alloc] initWithNibName:@"PersonalInfoSegmentView" bundle:nil];
            [self.navigationController pushViewController:persionalAssetInfoVC animated:YES];
        }
            break;
        case 1:
        {
            //Setting
        }
            break;
            
        default:
            break;
    }
}

@end
