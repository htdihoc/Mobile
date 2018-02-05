//
//  CheckIn.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "CheckOut.h"
#import "ListCheckOut.h"
#import "InfoEmployCheckOut.h"
#import "SOTableViewRowAction.h"
#import "DismissTimeKeeping.h"
#import "CheckOutDetail.h"
#import "BottomView.h"
#import "RegisterInOutModel.h"
#import "WorkNoDataView.h"

#import "Common.h"
#import "TTNSProcessor.h"
#import "SVPullToRefresh.h"
#import "NSException+Custom.h"

@interface CheckOut () <UITableViewDataSource, UITableViewDelegate>
{
    //    InfoEmployCheckOut
@protected NSMutableArray<RegisterInOutModel *> *infoEmployDetails;
@protected RegisterInOutModel *inOutModel;
@protected NSInteger _currentItems;
@protected NSInteger _increateItems;
@protected BOOL _isEmpty;
    
}

@end

@implementation CheckOut

- (IBAction)back:(id)sender
{
    [self popToIntegrationRoot];
    
}

#pragma mark lifecycler

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setupUI];
    [self.baseTableView reloadData];
}

#pragma mark UI

- (void)setupUI{
    self.backTitle = LocalizedString(@"TTNS_CheckOut_Phê_duyệt_đăng_ký_ra_ngoài");
    [self registerCellWith:@"ListCheckOut"];
    [self addPullRefresh];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
}

- (void)addPullRefresh{
    _currentItems = 20;
    _increateItems = 20;
    
    // add pull to refresh
    __weak CheckOut *weakSelf = self;
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
        [[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
        [self getListRegisterInOut:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if(success){
                NSArray *data = resultDict[@"data"];
                DLog(@"result : %@", resultDict);
                infoEmployDetails = [RegisterInOutModel arrayOfModelsFromDictionaries:data error:nil];
                //                infoEmployDetails = [self removeObjectFormArr:infoEmployDetails];
                //                infoEmployDetails = [self sortArray:infoEmployDetails];
                [self.baseTableView reloadData];
                //                if(infoEmployDetails.count == 0){
                //                    [self showViewNoData];
                //                }
                [[Common shareInstance]dismissHUD];
            }else {
                [self showViewNoData];
                [[Common shareInstance]dismissHUD];
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

#pragma mark Action
- (void)pushToDetailView:(int)index
{
    RegisterInOutModel *model = infoEmployDetails[index];
    CheckOutDetail *checkOutDetail = NEW_VC_FROM_NIB(CheckOutDetail, @"CheckOutDetail");
    checkOutDetail.empOutRegId      = model.empOutRegId;
    [self pushIntegrationVC:checkOutDetail];
}

- (void)showViewNoData{
    self.baseTableView.hidden = YES;
    WorkNoDataView *workNoDataView  = (WorkNoDataView*)([[UINib nibWithNibName:@"WorkNoDataView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    workNoDataView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    workNoDataView.contenLB.text    = LocalizedString(@"TTNS_NO_DATA");
    [self.view addSubview:workNoDataView];
}

#pragma mark UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return infoEmployDetails.count > _currentItems ? _currentItems : infoEmployDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"ListCheckOut";
    
    ListCheckOut *cell             = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ListCheckOut alloc]initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushToDetailView:(int)indexPath.row];
}

#pragma mark ContentViewDelegate
- (void)isEmpty:(BOOL)isEmpty
{
    _isEmpty = isEmpty;;
}
#pragma mark swipeAction

- (void)reject{
    [self showDismissTimeKeeping:^{
        if(_isEmpty){
            [[Common shareInstance] showErrorHUDWithMessage:LocalizedString(@"Bạn phải nhập Lý do từ chối") inView:self.view];
        }else{
            DLog(@"reject success");
        }
    } andLeftAction:nil];
}

- (void)accpet{
    
}

@end
