//
//  ListRegisterTakeLeave.m
//  SmartOffice
//
//  Created by NguyenDucBien on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "ListRegisterTakeLeave.h"
#import "ListTakeLeaveCell.h"


@interface ListRegisterTakeLeave () {
@protected NSArray *icon;
@protected NSArray *status;
}

@end

@implementation ListRegisterTakeLeave

#pragma mark LifeCycler

- (void)viewDidLoad {
    [super viewDidLoad];
    self.checkOutListTableview.delegate = self;
    self.checkOutListTableview.dataSource = self;
    self.mTitle.text = @"Danh sách loại đơn";
    self.checkOutListTableview.backgroundColor = AppColor_MainAppBackgroundColor;
    
    
    icon = @[@"icon_home", @"icon_ngi_viec_rieng", @"icon_ngi_om", @"icon_children", @"icon_ngi_vo_sinh"];
    status = @[LocalizedString(@"TTNS_NGHI_PHEP"), LocalizedString(@"TTNS_NGHI_VIEC_RIENG"), LocalizedString(@"TTNS_NGHI_OM"), LocalizedString(@"TTNS_NGHI_CON_OM"),LocalizedString(@"TTNS_NGHI_VO_SINH_CON")];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.checkOutListTableview selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark UI

#pragma mark Delegate???

- (void)passDataBack {
    NSInteger itemToPassBack = currentIndex;
    [self.delegate passingData:self didFinishChooseItem:itemToPassBack];
}

#pragma mark Tableview Datasource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return icon.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID_Cell = @"myCell";
    
    ListTakeLeaveCell *cell = [tableView dequeueReusableCellWithIdentifier:ID_Cell];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ListTakeLeaveCell" bundle:nil] forCellReuseIdentifier:ID_Cell];
        cell = [tableView dequeueReusableCellWithIdentifier:ID_Cell];
        
    }
    cell.iconImage.image = [UIImage imageNamed:icon[indexPath.row]];
    cell.statusLabel.text = [status objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

#pragma mark Tableview Delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    lastIndex = indexPath;
    currentIndex = indexPath.row;
    [self passDataBack];
}

@end
