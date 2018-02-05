//
//  ListRegisterInOutFormVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ListRegisterInOutFormVC_iPad.h"
#import "ListRegisterInOutFormCell_iPad.h"
#import "SOTableViewRowAction.h"
#import "Common.h"
#import "TTNSProcessor.h"
#import "RegisterInOutModel.h"
#import "WorkNoDataView.h"
#import "NSException+Custom.h"
#import "SVPullToRefresh.h"

@interface ListRegisterInOutFormVC_iPad ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>{
@protected NSMutableArray<RegisterInOutModel*> *checkOutDetails;
@protected RegisterInOutModel *model;
@protected WorkNoDataView *workNoDataView;
@protected NSInteger _personalFormId;
    
@protected NSInteger _currentItems;
@protected NSInteger _increateItems;
}

@end

@implementation ListRegisterInOutFormVC_iPad

@synthesize delegate;

#pragma mark LifeCycler

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadingData];
    [self setupUI];
    [self addPullRefresh];
    [self addLongPressForTableView];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark UI
- (void)setupUI{
    self.mTitle.text = @"Danh sách đăng ký";
    self.tableView.estimatedRowHeight   = 130;
    self.tableView.rowHeight            = UITableViewAutomaticDimension;
}

- (void)addPullRefresh{
    _currentItems = 20;
    _increateItems = 20;
    
    // add pull to refresh
    __weak ListRegisterInOutFormVC_iPad *weakSelf = self;
    weakSelf.tableView.showsInfiniteScrolling = NO;
    [weakSelf.tableView addInfiniteScrollingWithActionHandler: ^{
        DLog(@"+++ scroll to load");
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        if ([Common checkNetworkAvaiable]) {
            if(checkOutDetails.count > _currentItems){
                _currentItems = (checkOutDetails.count - _currentItems > _increateItems ? _increateItems : checkOutDetails.count - _currentItems) + _currentItems;
                [weakSelf.tableView reloadData];
                //                [baseTableView setContentOffset:CGPointZero animated:YES]; // auto scroll top tableview
            } else {
                weakSelf.tableView.showsInfiniteScrolling = NO;
            }
        }
        else
        {
            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
        }
    }];
    
    weakSelf.tableView.showsPullToRefresh = NO;
    [weakSelf.tableView addPullToRefreshWithActionHandler:^{
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
    workNoDataView =  (WorkNoDataView *)([[UINib nibWithNibName:@"WorkNoDataView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    workNoDataView.frame            = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    workNoDataView.contenLB.text    = LocalizedString(@"Không có dữ liệu");
    [self.view insertSubview:workNoDataView belowSubview:self.registerNewFormInOutButton];
}

- (void)addLongPressForTableView{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1;
    longPress.delegate = self;
    [self.tableView addGestureRecognizer:longPress];
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
        NSDictionary *params = @{
                                 @"from_time" : @(1378368420000),
                                 @"end_time"  : @(1424514600000),
                                 @"status"    : @(4)
                                 };
        
        //        NSInteger employeeId = 41652;
        [[Common shareInstance]showHUDWithTitle:@"Loadding..." inView:self.view];
        [TTNSProcessor getListInOutRegWithIdEffective:[GlobalObj getInstance].ttns_managerID paramaters:params callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            [[Common shareInstance]dismissHUD];
            if(success){
                DLog(@"Request success : %@", resultDict);
                NSArray *data = [resultDict valueForKey:@"data"];
                NSArray *entity = [data valueForKey:@"entity"];
                
                checkOutDetails = [RegisterInOutModel arrayOfModelsFromDictionaries:entity error:nil];
                checkOutDetails = [self removeObjectFormArr:checkOutDetails];
                checkOutDetails = [self sortArray:checkOutDetails];
                
                if(checkOutDetails.count == 0){
                    [self showViewNoData];
                } else {
                    [self.delegate getFirstEmpId:checkOutDetails[0].empOutRegId];
                    [self.tableView reloadData];
                }
            } else {
                [self showViewNoData];
                [self handleErrorFromResult:resultDict withException:exception inView:self.view];
            }
        }];
    } else {
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
    }
}



#pragma mark UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return checkOutDetails.count > _currentItems ? _currentItems : checkOutDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier          = @"ListRegisterInOutFormCell_iPad";
    
    ListRegisterInOutFormCell_iPad  *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if(cell == nil){
        [tableView registerNib:[UINib nibWithNibName:Identifier bundle:nil] forCellReuseIdentifier:Identifier];
        cell                = [tableView dequeueReusableCellWithIdentifier:Identifier];
    }
    
    // set data for cell
    model = checkOutDetails[indexPath.row];
    
    cell.addresLB.text = [NSString stringWithFormat:@"%@", model.workPlace];
    
    NSString *timeStart = [self convertTimeStampToDateStr:model.timeStart format:@"HH'h':mm - dd/MM/yyyy"];
    NSString *timeEnd   = [self convertTimeStampToDateStr:model.timeEnd format:@"HH'h':mm - dd/MM/yyyy"];
    
    cell.timeLB.text    = [NSString stringWithFormat:@"%@ -> %@", timeStart, timeEnd];
    [cell.reasonLB setHidden:YES];
    [cell.reasonContentLB setHidden:YES];
    
    switch (model.status) {
        case 0:
            cell.stateLB.text  = @"Bị từ chối";
            cell.stateLB.textColor = [UIColor redColor];
            [cell.stateIcon setImage:[UIImage imageNamed:@"icon_bi_tu_choi"]];
            [cell.reasonLB setHidden:NO];
            [cell.reasonContentLB setHidden:NO];
            break;
        case 1:
            cell.stateLB.text = @"Đã phê duyệt";
            cell.stateLB.textColor = [UIColor blueColor];
            [cell.stateIcon setImage:[UIImage imageNamed:@"icon_da_phe_duyet"]];
            break;
        case 2:
            cell.stateLB.text = @"Đang chờ phê duyệt";
            cell.stateLB.textColor = [UIColor orangeColor];
            [cell.stateIcon setImage: [UIImage imageNamed:@"icon_cho_ky_duyet"]];
            break;
        case 3:
            cell.stateLB.text  = @"Chưa trình ký";
            [cell.stateIcon setImage:[UIImage imageNamed:@"add"]];
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    // Chua trinh ky return YES
    // else return NO
    if(model.status == 3){
        return YES;
    } else {
        return NO;
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    SOTableViewRowAction *cancel = [SOTableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                      title:@"  Hủy   "
                                                                       icon:[UIImage imageNamed:@"icon_swipe_cancel"]
                                                                      color:[UIColor redColor]
                                                                    handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                        DLog(@"%ld",(long)indexPath.row);
                                                                    }];
    
    cancel.font =  [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    return @[cancel];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    model = checkOutDetails[indexPath.row];
    [self.delegate getSelectedEmpId:model.empOutRegId];
}

#pragma mark Action
- (IBAction)RegisterNewFormInOutAction:(id)sender {
    if([Common checkNetworkAvaiable]){
        [self.delegate pressButton:sender];
    } else {
        [[Common shareInstance] showErrorHUDWithMessage:LocalizedString(@"Không có kết nối mạng") inView:self.view];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)longPress{
    CGPoint p =  [longPress locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    
    if(indexPath == nil){
        DLog(@"Long Press on table view but not on a row");
    } else if (longPress.state == UIGestureRecognizerStateBegan) {
        
        DLog(@"long press on tableview at row %ld", indexPath.row);
        DLog(@"show popup delete row");
        model = checkOutDetails[indexPath.row];
        if(model.status == 3){
            _personalFormId = model.empOutRegId;
            
            UIAlertAction *closeButton = [UIAlertAction
                                          actionWithTitle:LocalizedString(@"Huỷ bỏ")
                                          style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertAction *rightAction = [UIAlertAction
                                          actionWithTitle:LocalizedString(@"Đồng ý")
                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                              [self deleteFormNotConfirm:_personalFormId]; // delete form with id
                                          }];
            
            
            [self   showDialog:nil
                      messages:LocalizedString(@"Bạn chắc chắn muốn xoá đăng ký này?")
                    leftAction:closeButton rightAction:rightAction
                 rightBtnColor:[UIColor redColor]
                     tintColor:AppColor_MainAppTintColor];
        }
    } else{
        DLog(@"long press state = %ld", longPress.state);
    }
}
@end
