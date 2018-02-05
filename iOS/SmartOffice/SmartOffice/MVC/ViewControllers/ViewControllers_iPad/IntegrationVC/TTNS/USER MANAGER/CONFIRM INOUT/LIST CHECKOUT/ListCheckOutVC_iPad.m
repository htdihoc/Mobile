//
//  ListCheckOutVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ListCheckOutVC_iPad.h"
#import "InfoEmployCheckOut.h"
#import "ListCheckOut.h"

#import "RegisterInOutModel.h"
#import "WorkNoDataView.h"

#import "Common.h"
#import "TTNSProcessor.h"
#import "SVPullToRefresh.h"
#import "NSException+Custom.h"

@interface ListCheckOutVC_iPad ()<UITableViewDataSource, UITableViewDelegate>{
@protected NSMutableArray<RegisterInOutModel *> *infoEmployDetails;
@protected RegisterInOutModel *inOutModel;
@protected BOOL _isEmpty;
@protected NSInteger _currentItems;
@protected NSInteger _increateItems;
    
}

@end

@implementation ListCheckOutVC_iPad

#pragma mark Lifecycler
- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCellWith:@"ListCheckOut"];
    [self addPullRefresh];
    [self loadData];
    [self setupUI];
    [self.baseTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.baseTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}


#pragma mark UI

- (void)setupUI{
    self.baseTableView.delegate         = self;
    self.baseTableView.dataSource       = self;
}

- (void)addPullRefresh{
    _currentItems = 20;
    _increateItems = 20;
    
    // add pull to refresh
    __weak ListCheckOutVC_iPad *weakSelf = self;
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

#pragma mark action
- (NSMutableArray*)sortArray:(NSMutableArray*)inputArray{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"fromDate" ascending:NO];
    
    NSArray *sortedArray = [inputArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSMutableArray *sortedMutableArr = [[NSMutableArray alloc]initWithArray:sortedArray];
    return sortedMutableArr;
}

- (NSMutableArray*)removeObjectFormArr:(NSMutableArray<RegisterInOutModel *>*)inputArr{
    NSMutableArray *discardedItems = [NSMutableArray array];
    RegisterInOutModel *item;
    NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    NSInteger currentTime = [timestamp integerValue];
    
    for(item in inputArr){
        if(item.timeEnd < currentTime){
            [discardedItems addObject:item];
        }
    }
    
    [inputArr removeObjectsInArray:discardedItems];
    return inputArr;
}

#pragma mark networking

- (void)loadData{
    if([Common checkNetworkAvaiable]){
        [self showHUDWithTitle:@"Loading..." inView:self.view];
        [self getListRegisterInOut:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if(success){
                NSArray *data = resultDict[@"data"];
                infoEmployDetails = [RegisterInOutModel arrayOfModelsFromDictionaries:data error:nil];
//                infoEmployDetails = [self removeObjectFormArr:infoEmployDetails];
//                infoEmployDetails = [self sortArray:infoEmployDetails];
                [self.baseTableView reloadData];
//                if(infoEmployDetails.count == 0){
//                    [self showViewNoData];
//                }
                [self dismissHub];
            }else {
                [self showViewNoData];
                [self dismissHub];
                [self handleErrorFromResult:resultDict withException:exception inView:self.view];
            }
        }];
    } else {
    
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}

#pragma mark requerst server

- (void)getListRegisterInOut:(Callback)callBack{
    [TTNSProcessor getListRegisterInOut:nil callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}

// API Approve Register In Out Form.
- (void)postApproveRegisterInOut:(NSDictionary*)params callBack:(Callback)callBack{
    [TTNSProcessor postApproveRegisterInOut:params callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}


- (void)showViewNoData{
    self.baseTableView.hidden = YES;
    WorkNoDataView *workNoDataView = (WorkNoDataView *)([[UINib nibWithNibName:@"WorkNoDataView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    workNoDataView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    workNoDataView.contenLB.text = LocalizedString(@"TTNS_NO_DATA");
    [self.view addSubview:workNoDataView];
}


#pragma mark uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return infoEmployDetails.count > _currentItems ? _currentItems : infoEmployDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"ListCheckOut";
    
    ListCheckOut *cell             = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ListCheckOut alloc]initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
    }
    inOutModel = infoEmployDetails[indexPath.row];
    //    //    cell.imgProfile.image              = [UIImage imageNamed:infoEmployDetails[indexPath.row]];
    //    cell.lblName.text = infoEmployDetails[indexPath.row].name;
    //    cell.lblTitle.text = infoEmployDetails[indexPath.row].content;
    //    cell.lblSubTitle.text = infoEmployDetails[indexPath.row].time;
    //    cell.lblTitle.text = inOutModel.reasonDetail;
    
    NSString *timeStr = [NSString stringWithFormat:@"%@ -> %@", [self convertTimeStampToDateStr:inOutModel.timeStart format:@"HH:mm - dd/MM/yyyy"], [self convertTimeStampToDateStr:inOutModel.timeEnd format:@"HH:mm - dd/MM/yyyy"]];
    
    cell.lblSubTitle.text = timeStr;
    return cell;
}

#pragma mark uitable delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtInydexPath:(NSIndexPath *)indexPath{
    DLog(@"Push to Detail");
}

#pragma mark ContentViewDelegate
- (void)isEmpty:(BOOL)isEmpty
{
    _isEmpty = isEmpty;;
}
#pragma mark swipeAction

- (void)reject{
    [self showDismissTimeKeeping:^{
        if(_isEmpty)
        {
            [[Common shareInstance] showErrorHUDWithMessage:LocalizedString(@"Bạn phải nhập Lý do từ chối") inView:self.view];
        }
        else
        {
            DLog(@"reject success");
        }
    } andLeftAction:nil];
}

- (void)accpet{
    
}



@end
