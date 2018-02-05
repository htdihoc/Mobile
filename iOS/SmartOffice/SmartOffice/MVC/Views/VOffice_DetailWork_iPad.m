//
//  VOfice_DetailWork_iPad.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_DetailWork_iPad.h"
#import "VOffice_DetailWorkCell_iPad.h"
#import "Common.h"
#import "VOfficeProcessor.h"
#import "DetailWorkModel.h"

@interface VOffice_DetailWork_iPad() <UITableViewDataSource, UITableViewDelegate>
{
    DetailWorkModel *_detailWork;
}
@end
@implementation VOffice_DetailWork_iPad
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.lbl_Title.text = LocalizedString(@"VOffice_DetailMission_iPad_Chi_tiết_công_việc");
    self.tbl_Detail.dataSource = self;
    self.tbl_Detail.delegate = self;
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
	_detailWork = [self.delegate getDetailWorkModel];
	if (_setSegment == 0) {
		return [Common numberRowsOfCommandTypeWork:_detailWork.commandType];
	}
	return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID_CELL = @"VOffice_DetailWorkCell_iPad";
    VOffice_DetailWorkCell_iPad *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"VOffice_DetailWorkCell_iPad" bundle:nil] forCellReuseIdentifier:ID_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupDataByModel:[self.delegate getDetailWorkModel] atIndex:indexPath.row segment:self.setSegment];
    return cell;
}

@end
