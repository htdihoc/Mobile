//
//  VOffice_ListWork_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/27/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_ListWork_iPad.h"
#import "VOffice_ListWorkCell_iPad.h"
@interface VOffice_ListWork_iPad () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation VOffice_ListWork_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tbl_ListMission registerNib:[UINib nibWithNibName:@"VOffice_ListWorkCell_iPad" bundle:nil] forCellReuseIdentifier:@"VOffice_ListWorkCell_iPad"];
    self.tbl_ListMission.estimatedRowHeight = 80;
    self.tbl_ListMission.rowHeight = UITableViewAutomaticDimension;
    self.tbl_ListMission.delegate = self;
    self.tbl_ListMission.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}

#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID_CELL = @"VOffice_ListWorkCell_iPad";
    VOffice_ListWorkCell_iPad *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    return cell;
}

#pragma mark UITableViewDelegate

@end
