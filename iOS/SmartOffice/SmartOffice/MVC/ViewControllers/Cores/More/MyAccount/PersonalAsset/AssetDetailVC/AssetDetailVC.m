//
//  AssetDetailVC.m
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 4/6/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "AssetDetailVC.h"
#import "AssetDetailCell.h"

@interface AssetDetailVC ()

@end

@implementation AssetDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.tbAssetDetail registerNib:[UINib nibWithNibName:@"AssetDetailCell" bundle:nil]forCellReuseIdentifier:[AssetDetailCell cellIdentifier]];
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
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AssetDetailCell *cell = (AssetDetailCell *)[tableView dequeueReusableCellWithIdentifier:[AssetDetailCell cellIdentifier]];
    if (cell == nil) {
        cell = [[AssetDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[AssetDetailCell cellIdentifier]];
    }
    
    [self configCellSection0:cell indexPath:indexPath];
    
    return cell;
}

- (void)configCellSection0: (UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            
            break;
            
        default:
            break;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 120;
//}

#pragma mark - Table delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectedTableViewSection0:tableView indexPath:indexPath];
}

- (void)selectedTableViewSection0:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
