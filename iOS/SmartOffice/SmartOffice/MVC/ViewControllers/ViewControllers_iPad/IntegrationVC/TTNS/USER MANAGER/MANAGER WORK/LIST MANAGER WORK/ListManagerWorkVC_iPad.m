//
//  ListManagerWorkVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ListManagerWorkVC_iPad.h"
#import "InfoEmployCheckOut.h"
#import "TimeKeepingCell.h"
#import "Common.h"
#import "SVPullToRefresh.h"
#import "NSException+Custom.h"
#import "WorkNoDataView.h"

@interface ListManagerWorkVC_iPad ()<UITableViewDataSource, UITableViewDelegate>{
@protected NSMutableArray<InfoEmployCheckOut *>*infoEmployDetails;
    
@protected NSInteger _currentItems;
@protected NSInteger _increateItems;
}

@end

@implementation ListManagerWorkVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self addPullRefresh];
    [self generateData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.baseTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark UI

- (void)setupUI{
    self.baseTableView.delegate     = self;
    self.baseTableView.dataSource   = self;
    self.titleLB.text               = LocalizedString(@"Danh sách nhân viên");
}

- (void)addPullRefresh{
    _currentItems = 20;
    _increateItems = 20;
    
    // add pull to refresh
    __weak ListManagerWorkVC_iPad *weakSelf = self;
    weakSelf.baseTableView.showsInfiniteScrolling = NO;
    [weakSelf.baseTableView addInfiniteScrollingWithActionHandler: ^{
        DLog(@"+++ scroll to load");
        [weakSelf.baseTableView.infiniteScrollingView stopAnimating];
        if ([Common checkNetworkAvaiable]) {
            if(infoEmployDetails.count > _currentItems){
                _currentItems = (infoEmployDetails.count - _currentItems > _increateItems ? _increateItems : infoEmployDetails.count - _currentItems) + _currentItems;
                [weakSelf.baseTableView reloadData];
                //                [baseTableView setContentOffset:CGPointZero animated:YES]; // auto scroll top tableview
            } else {
                weakSelf.baseTableView.showsInfiniteScrolling = NO;
            }
        }
        else
        {
            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
        }
    }];
    
    weakSelf.baseTableView.showsPullToRefresh = NO;
    [weakSelf.baseTableView addPullToRefreshWithActionHandler:^{
        DLog(@"Refresh data here");
        [weakSelf.baseTableView.pullToRefreshView stopAnimating];
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

#pragma mark data

- (void)generateData
{
    if ([Common checkNetworkAvaiable]) {
        infoEmployDetails = [[NSMutableArray alloc] init];
        for(int i = 0; i < 10; i++)
        {
            NSString *name = [NSString stringWithFormat:@"Nguyễn Tuấn Anh %d", i];
            NSString *content = [NSString stringWithFormat:@"ANHVT%d@gmail.com", i];
            NSString *time = [NSString stringWithFormat:@"Tổng ngày công thực tế: 2%d", i];
            InfoEmployCheckOut *info = [[InfoEmployCheckOut alloc]
                                        initWithImg:[UIImage new]
                                        name:name
                                        content:content
                                        time:time];
            [infoEmployDetails addObject:info];
            
        }
        [self.baseTableView reloadData];
    } else {
        [[Common shareInstance] showErrorHUDWithMessage:LocalizedString(@"Không có kết nối mạng") inView:self.view];
    }
}

#pragma mark uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return infoEmployDetails.count > _currentItems ? _currentItems : infoEmployDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"TimeKeepingCell";
    
    TimeKeepingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    //    cell.imgProfile.image              = [UIImage imageNamed:infoEmployDetails[indexPath.row]];
    cell.lblName.text = infoEmployDetails[indexPath.row].name;
    cell.lblTitle.text = infoEmployDetails[indexPath.row].content;
    cell.lblSubTitle.text = infoEmployDetails[indexPath.row].time;
    return cell;
}

#pragma mark uitableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"show Calendar");
}

@end
