//
//  RegisterList.m
//  RegisterList
//
//  Created by NguyenDucBien on 4/17/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import "RegisterList.h"
#import "ContentTableViewCell.h"
#import "RegisterWatch.h"
#import "WorkNoDataView.h"

@interface RegisterList () {
    NSArray *content;
}

@end

@implementation RegisterList

#pragma mark LifeCycler

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark UI

- (void)setupUI{
    self.backTitle = LocalizedString(@"TTNS_RegisterList_Danh_sách_ĐK_trực_nghỉ");
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    [self registerCellWith:@"ContentTableViewCell"];
    content = [[NSArray alloc] initWithObjects:@"Ngày giải phóng Miền Nam(30/04/2017) và quốc tế lao động (01/05/2017)", @"Ngày thành lập tập đoàn 01/06/2017", nil];
}

- (void)showViewNoData{
    self.baseTableView.hidden = YES;
    WorkNoDataView *workNoDataView  = (WorkNoDataView *)([[UINib nibWithNibName:@"WorkNoDataView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    workNoDataView.frame            = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    workNoDataView.contenLB.text    = LocalizedString(@"TTNS_NO_DATA");
        [self.view addSubview:workNoDataView];
}
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentTableViewCell_ID"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"ContentTableViewCell_ID"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContentTableViewCell_ID"];
    }
    
    cell.lbContent.text = [content objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RegisterWatch *registerWatch = NEW_VC_FROM_NIB(RegisterWatch, @"RegisterWatch");
    [self pushIntegrationVC:registerWatch];
}

@end
