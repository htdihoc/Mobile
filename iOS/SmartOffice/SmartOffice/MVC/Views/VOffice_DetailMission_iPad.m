//
//  VOffice_DetailMission_iPad.m
//  SmartOffice
//
//  Created by KhacViet Dinh, is impelemeted by nguyenvantu on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_DetailMission_iPad.h"
#import "VOffice_DetailMissionCell_iPad.h"
@interface VOffice_DetailMission_iPad() <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic)VOffice_MissionDetailController* missionDetailController;
@end
@implementation VOffice_DetailMission_iPad


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.missionDetailController = [[VOffice_MissionDetailController alloc] init];
    self.lbl_Title.text = LocalizedString(@"VOffice_DetailMission_iPad_Chi_tiết_nhiệm_vụ");
    self.tbl_Detail.dataSource = self;
    self.tbl_Detail.delegate = self;
}
- (void)reloadData
{
    [self.tbl_Detail reloadData];
}
- (void)endEditView
{
    [self.delegate endEditView];
}
- (void)didSelectVOffice
{
    [self.delegate didSelectVOffice];
}
#pragma mark - UITableView DataSource
//Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (![self.delegate getMissionDetailModel]) {
        return 0;
    }
    if (self.checkReturn == 0) {
        return 8;
    } else {
        return 7;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID_CELL = @"VOffice_DetailMissionCell_iPad";
    VOffice_DetailMissionCell_iPad *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"VOffice_DetailMissionCell_iPad" bundle:nil] forCellReuseIdentifier:ID_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupDataByModel:[self.delegate getMissionDetailModel] atIndex:indexPath.row];
    return cell;
}


@end
