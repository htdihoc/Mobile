//
//  ListRegisterCereVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 5/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ListRegisterCereVC_iPad.h"

#import "ContentTableViewCell.h"
#import "Common.h"
#import "SVPullToRefresh.h"
#import "NSException+Custom.h"
#import "WorkNoDataView.h"

@interface ListRegisterCereVC_iPad ()<UITableViewDataSource, UITableViewDelegate>{
@protected   NSArray *content;
@protected NSInteger _currentItems;
@protected NSInteger _increateItems;
}

@end

@implementation ListRegisterCereVC_iPad

#pragma mark lifecycler

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self addPullRefresh];
    [self passData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark UI

- (void)setupUI{
    self.mTitle.text = @"Danh sách ngày lễ đăng ký";
}

- (void)addPullRefresh{
    _currentItems = 20;
    _increateItems = 20;
    
    // add pull to refresh
    __weak ListRegisterCereVC_iPad *weakSelf = self;
    weakSelf.tableView.showsInfiniteScrolling = NO;
    [weakSelf.tableView addInfiniteScrollingWithActionHandler: ^{
        DLog(@"+++ scroll to load");
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        if ([Common checkNetworkAvaiable]) {
            if(content.count > _currentItems){
                _currentItems = (content.count - _currentItems > _increateItems ? _increateItems : content.count - _currentItems) + _currentItems;
                [weakSelf.tableView reloadData];
                //                [self.tableView setContentOffset:CGPointZero animated:YES]; // auto scroll top tableview
            } else {
                weakSelf.tableView.showsInfiniteScrolling = NO;
            }
        }
        else
        {
            [weakSelf handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
        }
    }];
    
    weakSelf.tableView.showsPullToRefresh = NO;
    [ weakSelf.tableView addPullToRefreshWithActionHandler:^{
        DLog(@"Refresh data here");
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        if ([Common checkNetworkAvaiable]) {
            
        }else
        {
            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
        }
        //Refresh data here
        // prepend data to dataSource, insert cells at top of table view
        // call [tableView.pullToRefreshView stopAnimating] when done
    } position:SVPullToRefreshPositionTop];
}

- (void)showViewNoData{
    self.tableView.hidden = YES;
    WorkNoDataView *workNoDataView = (WorkNoDataView *)([[UINib nibWithNibName:@"WorkNoDataView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    workNoDataView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    workNoDataView.contenLB.text = LocalizedString(@"TTNS_NO_DATA");
    [self.view addSubview:workNoDataView];
}

- (void)passData{
    content = [[NSArray alloc] initWithObjects:@"Ngày giải phóng Miền Nam(30/04/2017) và quốc tế lao động (01/05/2017)", @"Ngày thành lập tập đoàn 01/06/2017", nil];
}

#pragma mark tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return content.count > _currentItems ? _currentItems : content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *Identifier = @"ContentTableViewCell_ID";
    
    ContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if(cell == nil){
        [tableView registerNib:[UINib nibWithNibName:@"ContentTableViewCell" bundle:nil] forCellReuseIdentifier:Identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    }
    cell.lbContent.text = [content objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

#pragma mark tableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([Common checkNetworkAvaiable]){
        // Do something
    } else {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}

@end
