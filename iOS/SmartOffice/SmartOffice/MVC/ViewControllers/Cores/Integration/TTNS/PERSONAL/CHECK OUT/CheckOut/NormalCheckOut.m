//
//  MainView.m
//  QuanLyRaVao
//
//  Created by NguyenHienTuong on 4/12/17.
//  Copyright © 2017 NguyenHienTuong. All rights reserved.
//

#import "NormalCheckOut.h"
#import "NormalCheckOutCell.h"
#import "NormalRegisterDetail.h"
#import "CheckOutDetailModel.h"
#import "TTNS_RegistryGoOut.h"

#import "TTNSProcessor.h"
#import "RegisterInOutModel.h"

#import "Common.h"
#import "SVPullToRefresh.h"
#import "NSException+Custom.h"
#import "SOTableViewRowAction.h"

#import "WorkNoDataView.h"

@interface NormalCheckOut () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate> {
@protected NSMutableArray<RegisterInOutModel *> *checkOutDetails;
@protected RegisterInOutModel *model;
@protected NSInteger _employeeId;
@protected NSInteger _personalFormId;

@protected NSInteger _currentItems;
@protected NSInteger _increateItems;
}

@end

@implementation NormalCheckOut

- (IBAction)back:(id)sender
{
    [self popToIntegrationRoot];
    
}

#pragma mark LifeCycler
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadingData];
    [self.baseTableView reloadData];
    [self setupUI];
    [self.baseTableView reloadData];
}

#pragma mark UI
- (void)setupUI{
    self.backTitle = LocalizedString(@"TTNS_NormalCheckOut_Quản_lý_vào_ra");
    [self addCustomButton];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.estimatedRowHeight = 100;
    self.baseTableView.rowHeight = UITableViewAutomaticDimension;
    [self addPullRefresh];
}

- (void)addPullRefresh{
    _currentItems = 20;
    _increateItems = 20;
    
    // add pull to refresh
    __weak NormalCheckOut *weakSelf = self;
    weakSelf.baseTableView.showsInfiniteScrolling = NO;
    [weakSelf.baseTableView addInfiniteScrollingWithActionHandler: ^{
        DLog(@"+++ scroll to load");
        [weakSelf.baseTableView.infiniteScrollingView stopAnimating];
        if ([Common checkNetworkAvaiable]) {
            if(checkOutDetails.count > _currentItems){
                _currentItems = (checkOutDetails.count - _currentItems > _increateItems ? _increateItems : checkOutDetails.count - _currentItems) + _currentItems;
                [weakSelf.baseTableView reloadData];
                //                [self.tableView setContentOffset:CGPointZero animated:YES]; // auto scroll top tableview
            } else {
                weakSelf.baseTableView.showsInfiniteScrolling = NO;
            }
        }
        else
        {
            [weakSelf handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
        }
    }];
    
     weakSelf.baseTableView.showsPullToRefresh = NO;
    [ weakSelf.baseTableView addPullToRefreshWithActionHandler:^{
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

- (void)addCustomButton
{
    self.btnAction = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.btnAction addTarget:self action:@selector(registryCheckingOut) forControlEvents:UIControlEventTouchUpInside];
    [self.btnAction setImage:[UIImage imageNamed:@"plus_icon"] forState:UIControlStateNormal];
    self.btnAction.clipsToBounds = YES;
    self.btnAction.layer.cornerRadius = self.btnAction.bounds.size.height/2.0f;
    [self.view addSubview:self.btnAction];
    self.btnAction.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.btnAction attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.btnAction attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-10];
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.btnAction attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.btnAction attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40];
    [self.view addConstraints:@[bottom, height, right, width]];
}

- (void)showViewNoData{
    self.baseTableView.hidden = YES;
    WorkNoDataView *workNoDataView  = (WorkNoDataView *)([[UINib nibWithNibName:@"WorkNoDataView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    workNoDataView.frame            = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    workNoDataView.contenLB.text    = LocalizedString(@"Không có dữ liệu");
    [self.view insertSubview:workNoDataView belowSubview:self.btnAction];
}

#pragma mark Action

- (NSMutableArray*)sortArray:(NSMutableArray*)inputArray{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"timeStart" ascending:NO];
    
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

#pragma mark request server

- (void)loadingData{
    if([Common checkNetworkAvaiable]){
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
        // NSTimeInterval is defined as double
        //Tea
        NSNumber *timeStampObj = [NSNumber numberWithLong:timeStamp];
        NSDictionary *params    = @{
                                    @"from_time" : @(1378368420000),
                                    @"end_time"  : timeStampObj,
                                    @"status"    : @(4)
                                    };
//        _employeeId            = 41652;
        [[Common shareInstance]showHUDWithTitle:@"Loadding..." inView:self.view];
        [TTNSProcessor getListInOutRegWithIdEffective:[GlobalObj getInstance].ttns_employID paramaters:params callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if(success){
                DLog(@"Request success : %@", resultDict);
                NSArray *data = [resultDict valueForKey:@"data"];
                NSArray *entity = [data valueForKey:@"entity"];
                
                checkOutDetails = [RegisterInOutModel arrayOfModelsFromDictionaries:entity error:nil];
                //Tea
                /*
                checkOutDetails = [self removeObjectFormArr:checkOutDetails];
                 */
                checkOutDetails = [self sortArray:checkOutDetails];
                [self.baseTableView reloadData];
                
                if(checkOutDetails.count == 0){
                    [self showViewNoData];
                }
                
                [[Common shareInstance]dismissHUD];
            } else {
                [[Common shareInstance]dismissHUD];
                [self handleErrorFromResult:resultDict withException:exception inView:self.view];
                [self showViewNoData];
            }
        }];
    } else {
        DLog(@"No Internet connected");
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}

- (void)deleteFormNotConfirm:(NSInteger)personalFormId{
    if([Common checkNetworkAvaiable]){
        [[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
        [TTNSProcessor postDeleteRegisterWithPersonalFormId:personalFormId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            [[Common shareInstance]dismissHUD];
            if(success){
                // do something here
                [[Common shareInstance]showErrorHUDWithMessage:LocalizedString(@"Huỷ đăng ký thành công") inView:self.view];
            } else {
                [self handleErrorFromResult:resultDict withException:exception inView:self.view];
            }
        }];
    } else {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}

#pragma mark tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return checkOutDetails.count > _currentItems ? _currentItems : checkOutDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NormalCheckOutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCheckOutCell"];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"NormalCheckOutCell" bundle:nil] forCellReuseIdentifier:@"NormalCheckOutCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCheckOutCell"];
    }
    
    model   = checkOutDetails[indexPath.row];
    
    cell.lbAddress.text         = [NSString stringWithFormat:@"%@", model.workPlace];
    
    NSString *timeStart     = [self convertTimeStampToDateStr:model.timeStart format:@"HH:mm - dd/MM/yyyy"];
    NSString *timeEnd       = [self convertTimeStampToDateStr:model.timeEnd format:@"HH:mm - dd/MM/yyyy"];
    cell.lbTime.text = [NSString stringWithFormat:@"%@ -> %@", timeStart, timeEnd];
    
    [cell.lbReason setHidden:YES];
    [cell.lbContentDeny setHidden:YES];
    
    switch (model.status) {
        case 0:
            cell.lbStatus.text  = @"Bị từ chối";
            cell.lbStatus.textColor = [UIColor redColor];
            [cell.iconStatus setImage:[UIImage imageNamed:@"icon_bi_tu_choi"]];
            [cell.lbReason setHidden:NO];
            [cell.lbContentDeny setHidden:NO];
            break;
        case 1:
            cell.lbStatus.text = @"Đã phê duyệt";
            cell.lbStatus.textColor = [UIColor blueColor];
            [cell.iconStatus setImage:[UIImage imageNamed:@"icon_da_phe_duyet"]];
            break;
        case 2:
            cell.lbStatus.text = @"Đang chờ phê duyệt";
            cell.lbStatus.textColor = [UIColor orangeColor];
            [cell.iconStatus setImage: [UIImage imageNamed:@"icon_cho_ky_duyet"]];
            break;
        case 3:
            cell.lbStatus.text  = @"Chưa trình ký";
            [cell.iconStatus setImage:[UIImage imageNamed:@"add"]];
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    model   = checkOutDetails[indexPath.row];
    
    if(model.status == 0){
        return UITableViewAutomaticDimension;
    }
    return 100;
}

#pragma mark tableviewdelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    model = checkOutDetails[indexPath.row];
    if(model.status == 3){ // Chưa trình ký
        return YES;
    }
    return NO;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SOTableViewRowAction *delete = [SOTableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                        title:@"   Huỷ   "
                                                                        icon:[UIImage imageNamed:@"icon_swipe_cancel"]
                                                                        color:[UIColor redColor]
                                                                        handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                        // delete row action
                                                                        // Show alertAction
                                                                            model = checkOutDetails[indexPath.row];
                                                                            _personalFormId = model.empOutRegId;
                                                                            UIAlertAction *closeButton = [UIAlertAction
                                                                                                      actionWithTitle:LocalizedString(@"Huỷ bỏ")
                                                                                                      style:UIAlertActionStyleCancel handler:nil];
                                                                        
                                                                            UIAlertAction *rightAction = [UIAlertAction
                                                                                                      actionWithTitle:LocalizedString(@"Đồng ý")
                                                                                                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                                                          [self deleteFormNotConfirm:_personalFormId]; // delete form with id
                                                                                                      }];
                                                                        
                                                                            [self showDialog:nil
                                                                                    messages:LocalizedString(@"Bạn muốn xoá đơn nghỉ phép này?")
                                                                                    leftAction:closeButton rightAction:rightAction
                                                                                    rightBtnColor:[UIColor redColor]
                                                                                    tintColor:AppColor_MainAppTintColor];
                                                                    }];
    
    delete.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    return @[delete];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    model = checkOutDetails[indexPath.row];
    [self deSelectRow:indexPath];
    NormalRegisterDetail *normalCheckOut = NEW_VC_FROM_NIB(NormalRegisterDetail, @"NormalRegisterDetail");
    normalCheckOut.empOutRegId          = model.empOutRegId;
    [self pushIntegrationVC:normalCheckOut];
}

#pragma mark IBAction

- (IBAction)buttonAddEvent:(id)sender {
    
}

- (void)registryCheckingOut
{
    if([Common checkNetworkAvaiable]){
        TTNS_RegistryGoOut *registryGoOut = NEW_VC_FROM_NIB(TTNS_RegistryGoOut, @"TTNS_RegistryGoOut");
        [self pushIntegrationVC:registryGoOut];
    } else {
        [[Common shareInstance] showErrorHUDWithMessage:LocalizedString(@"Không có kết nối mạng") inView:self.view];
    }
}

@end
