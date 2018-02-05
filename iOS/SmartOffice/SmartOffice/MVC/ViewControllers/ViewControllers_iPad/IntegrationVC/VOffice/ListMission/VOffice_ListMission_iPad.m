//
//  VOffice_ListMission_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/27/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_ListMission_iPad.h"
#import "VOffice_ListMissionCell_iPad.h"
@interface VOffice_ListMission_iPad () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation VOffice_ListMission_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tbl_ListMission registerNib:[UINib nibWithNibName:@"VOffice_ListMissionCell_iPad" bundle:nil] forCellReuseIdentifier:@"VOffice_ListMissionCell_iPad"];
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
    static NSString *ID_CELL = @"VOffice_ListMissionCell_iPad";
    VOffice_ListMissionCell_iPad *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    return cell;
}

#pragma mark UITableViewDelegate


@end
