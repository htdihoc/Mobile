//
//  BBBGInfoVC.m
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 4/6/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BBBGInfoVC.h"
#import "PersonalAssetInfoCell.h"
#import "AssetDetailVC.h"

@interface BBBGInfoVC ()

@end

@implementation BBBGInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.tbBBBG registerNib:[UINib nibWithNibName:@"PersonalAssetInfoCell" bundle:nil]forCellReuseIdentifier:[PersonalAssetInfoCell cellIdentifier]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalAssetInfoCell *cell = (PersonalAssetInfoCell *)[tableView dequeueReusableCellWithIdentifier:[PersonalAssetInfoCell cellIdentifier]];
    if (cell == nil) {
        cell = [[PersonalAssetInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PersonalAssetInfoCell cellIdentifier]];
    }
    
    [self configCellSection0:cell indexPath:indexPath];
    
    return cell;
}

- (void)configCellSection0: (PersonalAssetInfoCell *)cell indexPath:(NSIndexPath *)indexPath {
    [cell.btnIndex setTitle:[NSString stringWithFormat:@"%ld", indexPath.row] forState:UIControlStateNormal];
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
            AssetDetailVC *assetDetail = [[AssetDetailVC alloc] initWithNibName:@"AssetDetailVC" bundle:nil];
            [self.navigationController pushViewController:assetDetail animated:YES];
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
