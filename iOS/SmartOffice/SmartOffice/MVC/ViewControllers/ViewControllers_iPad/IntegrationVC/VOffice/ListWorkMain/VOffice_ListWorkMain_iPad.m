//
//  VOffice_ListWorkMain_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/27/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_ListWorkMain_iPad.h"
#import "Common.h"
#import "VOfficeProcessor.h"
#import "WorkModel.h"
#import "SVPullToRefresh.h"
#import "DetailWorkModel.h"
#import "NSException+Custom.h"
#import "NSString+Util.h"
#import "VOffice_ListView_iPad.h"
//ListWorkType - Using on ListWorkVC
typedef enum : NSUInteger{
    ListWorkTypeFromView_Perform = 0,     //Loại Công việc thực hiện
    ListWorkTypeFromView_Shipped 	  // Loại công việc giao đi
}ListWorkTypeFromView;
@interface VOffice_ListWorkMain_iPad () <UITableViewDelegate, UITableViewDataSource, VOffice_ListView_iPadDelegate, WYPopoverControllerDelegate, ContentFilterVCDelegate, VOffice_DetailWork_iPadDelegate>{
    WYPopoverController* popoverController;
    WorkFilterType _filterType;
    //Check loadMore
    BOOL _isLoadedAllWorks;
    BOOL _isLoadMore;
    NSString *_lastPerformRequest;
    NSString *_lastShippedRequest;
    NSIndexPath *_lastPerformIndex;
    NSIndexPath *_lastShippedIndex;
    DetailWorkModel *_detailWork;
    NSMutableArray *_listworkFilter;
    
    NSMutableArray *_listWorkPerform;
    NSMutableArray *_listWorkShipped;
    __weak VOffice_ListWorkMain_iPad *weakSelf;
}

@end

@implementation VOffice_ListWorkMain_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self initValues];
}
- (void)createUI
{
    self.VOffice_title = LocalizedString(@"VOffice_ListWorkMain_iPad_Danh_sách_công_việc");
    self.VOffice_buttonTitles = @[@"VOffice"];
    self.containerView.backgroundColor = AppColor_MainAppBackgroundColor;
    [AppDelegateAccessor setupSegment:_segment];
    self.listWork.tbl_ListContents.delegate = self;
    self.listWork.tbl_ListContents.dataSource = self;
    self.listWork.searchBar.placeholder = LocalizedString(@"VOffice_Work_Tìm_kiếm_theo_tên_công_việc_tên_người");
    self.listWork.delegate = self;
    [self.listWork.tbl_ListContents registerNib:[UINib nibWithNibName:@"VOffice_ListWorkCell_iPad" bundle:nil] forCellReuseIdentifier:@"VOffice_ListWorkCell_iPad"];
    
    if (self.listWorkType == ListWorkType_Shipped) {
        [self.listWork.sgm_WorkType setSelectedSegmentIndex:1];
        [self setEnableButton:self.listWork.btn_Filter enable:NO];
        
    }else{
        [self.listWork.sgm_WorkType setSelectedSegmentIndex:0];
        [self setEnableButton:self.listWork.btn_Filter enable:YES];
        
    }
    [self.listWork updateFrameSearchBarFrom:self.listWorkType];

    //Add Pull to refresh
    weakSelf = self;
    self.listWork.tbl_ListContents.showsInfiniteScrolling = NO;
    [self.listWork.tbl_ListContents addInfiniteScrollingWithActionHandler: ^{
        DLog(@"+++ scroll to load");
        [weakSelf.listWork.tbl_ListContents.infiniteScrollingView stopAnimating];
        if (_isLoadedAllWorks == NO) {
            _isLoadMore = YES;
            [self loadData:NO];
        }
        else{
            weakSelf.listWork.tbl_ListContents.showsInfiniteScrolling = NO;
        }
    }];
    
    self.listWork.tbl_ListContents.showsPullToRefresh = NO;
    [self.listWork.tbl_ListContents addPullToRefreshWithActionHandler:^{
        [weakSelf.listWork.tbl_ListContents.pullToRefreshView stopAnimating];
        if (self.listWorkType == ListWorkType_Perform) {
            _lastPerformIndex = nil;
        }
        else
        {
            _lastShippedIndex = nil;
        }
        if ([Common checkNetworkAvaiable]) {
            [self.listWork.listWorks removeAllObjects];
            [self loadData:YES];
        }else
        {
            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view isInstant:NO];
        }
    } position:SVPullToRefreshPositionTop];
}
- (void)initValues
{
    _lastPerformIndex = nil;
    _lastShippedIndex = nil;
    _lastPerformRequest = @"";
    _lastShippedRequest = @"";
    _isLoadedAllWorks = NO;
    _filterType  = WorkFilterType_All;
    self.listWork.workType = WorkType_All;
    self.listWork.listWorks   = @[].mutableCopy;
    _listworkFilter = @[].mutableCopy;
    self.workDetail.delegate = self;
    [self loadData:YES];
}
- (void)showPopOver:(UIButton *)sender
{
    if (popoverController.popoverVisible) {
        [popoverController dismissPopoverAnimated:YES];
        return;
    }
    NSArray *contentFilter = @[LocalizedString(@"- Tất cả -"), LocalizedString(@"Công việc cá nhân"), LocalizedString(@"Công việc phối hợp"), LocalizedString(@"Công việc được giao")];
    ContentFilterVC *filterVC = [[ContentFilterVC alloc] initWithFilterSelected:_filterType content:contentFilter];
    filterVC.preferredContentSize = CGSizeMake(240, contentFilter.count*44);
    filterVC.delegate = self;
    filterVC.modalInPopover = NO;
    popoverController = [[WYPopoverController alloc] initWithContentViewController:filterVC];
    popoverController.delegate = self;
    popoverController.passthroughViews = @[sender];
    popoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    popoverController.wantsDefaultContentAppearance = NO;
    
    [popoverController presentPopoverFromRect:sender.bounds
                                       inView:sender
                     permittedArrowDirections:WYPopoverArrowDirectionAny
                                     animated:YES
                                      options:WYPopoverAnimationOptionFadeWithScale];
}

- (void)setEnableButton:(UIButton *)button enable:(BOOL)enable{
    if (enable) {
        button.alpha = 1.0;
        button.hidden = NO;
        _workDetail.setSegment = 0;
    }else{
        button.alpha = 0.3;
        button.hidden = YES;
        _workDetail.setSegment = 1;
    }
    button.enabled = enable;
}

#pragma mark - Util Type
- (WorkType)typeWorkFromFilter:(WorkFilterType)filter{
    WorkType _type;
    switch (filter) {
        case WorkFilterType_All:
            _type = WorkType_All;
            break;
        case WorkFilterType_Personal:
            _type = WorkType_CreateMySelf;
            break;
        case WorkFilterType_Combinated:
            _type = WorkType_Combined;
            break;
        case WorkFilterType_WasAssigned:
            _type = WorkType_WasAssinged;
            break;
        default:
            _type = WorkType_All;
            break;
    }
    return _type;
}

- (WorkFilterType)filterTypeFromWorkType:(WorkType)type{
    WorkFilterType _filter;
    switch (type) {
        case WorkType_All:
            _filter = WorkFilterType_All;
            break;
        case WorkType_CreateMySelf:
            _filter = WorkFilterType_Personal;
            break;
            
        case WorkType_Combined:
            _filter = WorkFilterType_Combinated;
            break;
            
        case WorkType_WasAssinged:
            _filter = WorkFilterType_WasAssigned;
            break;
            
        default:
            _filter = WorkFilterType_All;
            break;
    }
    return _filter;
}

#pragma mark - Load data
- (void)loadData:(BOOL)showHub{
    if ([Common checkNetworkAvaiable]) {
        if (showHub) {
            [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
        }
        NSString *query = @"";
        if (self.listWorkType == ListWorkType_Perform) {
            query = [_lastPerformRequest convertLatinCharacters];
        }
        else
        {
            query = [_lastShippedRequest convertLatinCharacters];
        }
        [self searchTaskByName:query listTaskType:self.listWorkType taskType:self.listWork.workType startRecord:self.listWork.listWorks.count completeHandler:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            [self resetLoadMore];
            if (success) {
                NSArray *dictArr = resultDict[@"data"];
                NSMutableArray *arrData = [WorkModel arrayOfModelsFromDictionaries:dictArr error:nil];
                if (arrData.count < PAGE_SIZE_NUMBER){
                    _isLoadedAllWorks = YES;
                }
                [self appendData:arrData];
            }else{
                [self handleErrorFromResult:nil withException:[NSException initWithCode:[NSNumber numberWithInteger:RESP_CODE_REQUEST_NOTCONNECT]] inView:self.view];
            }
            [self.listWork.tbl_ListContents reloadData];
            [self dismissHub];
            
            if (self.listWork.listWorks.count > 0)
            {
                if (self.listWorkType == ListWorkType_Perform) {
                    if ((self.listWork.listWorks.count < _lastPerformIndex.row) || !_lastPerformIndex) {
                        _lastPerformIndex = [NSIndexPath indexPathForRow:0 inSection:0];
                    }
                }
                else
                {
                    if ((self.listWork.listWorks.count < _lastShippedIndex.row) || !_lastShippedIndex) {
                        _lastShippedIndex = [NSIndexPath indexPathForRow:0 inSection:0];
                    }
                }
                
                [self loadDetailWithCurrentIndex];
            }
            else
            {
                [self refreshDetailView];
            }
            
        }];
    }
    else
    {
        self.listWork.listWorks   = @[].mutableCopy;
        _listworkFilter = @[].mutableCopy;
        _listWorkPerform = @[].mutableCopy;
        _listWorkShipped = @[].mutableCopy;
        [self endEditCurrentView];
        [self refreshDetailView];
        [self.listWork.tbl_ListContents reloadData];
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view isInstant:NO];
    }
    
}
- (void)loadDetailWithCurrentIndex
{
    NSIndexPath *_lastIndex;
    if (self.listWorkType == ListWorkType_Perform) {
        _lastIndex = _lastPerformIndex;
    }
    else
    {
        _lastIndex = _lastShippedIndex;
    }
    if (_lastIndex && _listworkFilter.count > _lastIndex.row) {
        if (_isLoadMore) {
            [self.listWork selectItemWithNoFocusCurrentItem:_lastIndex];
        }
        else
        {
            [self.listWork selectItem:_lastIndex];
        }
        [self loadDataDetail:((WorkModel *)self.listWork.listWorks[_lastIndex.row]).taskId];
    }
    _isLoadMore = NO;
}
- (void)refreshDetailView
{
    _detailWork = nil;
    [self.workDetail.tbl_Detail reloadData];
}
- (void)reloadData{
    [self.listWork.listWorks removeAllObjects];
    [self loadData:YES];
}
- (void)loadDataDetail:(NSInteger)taskID{
    if ([Common checkNetworkAvaiable]) {
        [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
        [VOfficeProcessor getDetailWorkFromId:taskID callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            [self removeContentLabel];
            [self dismissHub];
            if (_listworkFilter.count < 1) {
                [self refreshDetailView];
                return ;
            }
            if (success) {
                NSDictionary *dictModel = resultDict[@"data"];
                _detailWork = [[DetailWorkModel alloc] initWithDictionary:dictModel error:nil];
            }else{
                //Parse Error here
                [self handleErrorFromResult:resultDict withException:exception inView:self.workDetail];
            }
            [self.workDetail.tbl_Detail reloadData];
        }];
    }
    else
    {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view isInstant:NO];
        _detailWork = nil;
        [self.workDetail.tbl_Detail reloadData];
    }
}
#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listworkFilter.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID_CELL = @"VOffice_ListWorkCell_iPad";
    VOffice_ListWorkCell_iPad *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    if (indexPath.row >= _listworkFilter.count) {
        return cell;
    }
    WorkModel *model = _listworkFilter[indexPath.row];
    [cell setupDataByModel:model withListWorkType:self.listWorkType];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listWorkType == ListWorkType_Perform) {
        _lastPerformIndex = indexPath;
    }
    else
    {
        _lastShippedIndex = indexPath;
    }
    [self endEditCurrentView];
    [self loadDataDetail:((WorkModel *)self.listWork.listWorks[indexPath.row]).taskId];
    
}

#pragma mark VOffice_ListView_iPadDelegate
- (void)localSearch:(NSString *)searchText
{
    searchText = [searchText noSpaceString];
    [self refreshDetailView];
    if (![searchText checkSpace] && searchText != nil) {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"taskName CONTAINS[cd] %@ or commanderName CONTAINS[cd] %@", searchText, searchText];
        _listworkFilter = [NSMutableArray arrayWithArray:[self.listWork.listWorks filteredArrayUsingPredicate:p]];
        if (_listworkFilter.count < 1) {
            if (self.listWorkType == ListWorkType_Perform) {
                _lastPerformIndex = nil;
            }
            else
            {
                _lastShippedIndex = nil;
            }
        }
    }
    else
    {
        _listworkFilter = [[NSMutableArray alloc] initWithArray:self.listWork.listWorks];
    }
    [self.listWork.tbl_ListContents reloadData];
    [self loadDetailWithCurrentIndex];
}
- (void)beginSearch
{
    [self refreshDetailView];
}
- (void)searchBar:(UITextField *)searchBar textDidChange:(NSString *)searchText
{
    if (self.listWorkType == ListWorkType_Perform) {
        _lastPerformIndex = nil;
        _lastPerformRequest = searchText;
    }
    else
    {
        _lastShippedIndex = nil;
        _lastShippedRequest = searchText;
    }
    DLog(@"textDidChange");
    //    if ([searchText isEqualToString:@""]) {
    //        DLog(@"Clear search Bar");
    //        [self reloadData];
    //        return;
    //    }
    
    //    [self executeSearchForQuery:searchText delayedBatching:YES];
    [self localSearch:searchText];
}
#pragma mark - Calculate to search on SearchBar
//Execute search from SearchBar
- (void)executeSearchForQuery:(NSString *)query delayedBatching:(BOOL)delayedBatching {
    if (delayedBatching) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, DELAY_SEARCH_UTIL_QUERY_UNCHANGED_FOR_TIME_OFFSE);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [self executeSearchForQuery:query];
        });
    }
    else {
        [self executeSearchForQuery:query];
    }
}

- (void)executeSearchForQuery:(NSString *)query{
    if ([Common checkNetworkAvaiable]) {
        [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
        [self removeContentLabel];
        [self refreshDetailView];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [self searchTaskByName:query listTaskType:self.listWorkType taskType:self.listWork.workType startRecord:self.listWork.listWorks.count completeHandler:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            [self dismissHub];
            NSString *_lastRequest = @"";
            if (self.listWorkType == ListWorkType_Perform) {
                _lastRequest = _lastPerformRequest;
            }
            else
            {
                _lastRequest = _lastShippedRequest;
            }
            if ([_lastRequest isEqualToString:query]) {
                [self.listWork.listWorks removeAllObjects];
                if (success) {
                    NSArray *dictArr = resultDict[@"data"];
                    NSMutableArray *arrData = [WorkModel arrayOfModelsFromDictionaries:dictArr error:nil];
                    if (arrData.count < PAGE_SIZE_NUMBER){
                        _isLoadedAllWorks = YES;
                    }
                    if (arrData.count > 0)
                    {
                        if (self.listWorkType == ListWorkType_Perform) {
                            if(!(arrData.count < _lastPerformIndex.row) || !_lastPerformIndex) {
                                _lastPerformIndex = [NSIndexPath indexPathForRow:0 inSection:0];
                            }
                        }
                        else
                        {
                            if(!(arrData.count < _lastShippedIndex.row) || !_lastShippedIndex) {
                                _lastShippedIndex = [NSIndexPath indexPathForRow:0 inSection:0];
                            }
                        }
                    }
                    
                    [self appendData:arrData];
                    [self localSearch:_lastRequest];
//                    [self.listWork.tbl_ListContents reloadData];
//                    [self loadDetailWithCurrentIndex];
                }else{
                    [self handleErrorFromResult:nil withException:[NSException initWithCode:[NSNumber numberWithInteger:RESP_CODE_REQUEST_NOTCONNECT]] inView:self.view];
                }
                
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
    }
    else
    {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view isInstant:NO];
    }
}

#pragma mark Action
- (void)buttonPressed:(UIButton *)sender
{
	[self endEditView];
    [self showPopOver:sender];
    DLog(@"press");
}
- (void)switchSegment:(UISegmentedControl *)segment
{
    DLog(@"switch segment");
    NSString *_lastQuery;
    [AppDelegateAccessor setupSegment:segment];
    if (segment.selectedSegmentIndex == ListWorkTypeFromView_Perform) {
        if (_listWorkPerform) {
             self.listWork.listWorks = [[NSMutableArray alloc] initWithArray:_listWorkPerform];
        }
        _lastQuery = _lastPerformRequest;
        self.listWorkType = ListWorkType_Perform;
        [self setEnableButton:self.listWork.btn_Filter enable:YES];
    }else{
        if (_listWorkShipped) {
            self.listWork.listWorks = [[NSMutableArray alloc] initWithArray:_listWorkShipped];
        }
        _lastQuery = _lastShippedRequest;
        self.listWorkType = ListWorkType_Shipped;
        [self setEnableButton:self.listWork.btn_Filter enable:NO];
    }
    [self.listWork setTextForSearchBar: _lastQuery];
    
    if (!_listWorkShipped || !_listWorkPerform || _listWorkShipped.count == 0 || _listWorkPerform.count == 0) {
        [self reloadData];
    }
    else
    {
        _listworkFilter = [[NSMutableArray alloc] initWithArray:self.listWork.listWorks];
        [self localSearch:_lastQuery];
    }
    
}

#pragma mark - WYPopoverController Delegate
- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    popoverController.delegate = nil;
    popoverController = nil;
}
- (void)resetLoadMore
{
    _isLoadedAllWorks = NO;
    weakSelf.listWork.tbl_ListContents.showsInfiniteScrolling = YES;
}
#pragma mark - ContentFilterVCDelegate
- (void)didSelectedFilterVC:(ContentFilterVC *)filterVC withFilterType:(NSInteger)filterType
{
    //Reload data here
    if (self.listWorkType == ListWorkType_Perform) {
        _lastPerformIndex = nil;
    }
    else
    {
        _lastShippedIndex = nil;
    }
	//Reset data at first
	[_listworkFilter removeAllObjects];

    _filterType = filterType;
    self.listWork.workType = [self typeWorkFromFilter:filterType];
    [popoverController dismissPopoverAnimated:YES];
    [self reloadData];
}

#pragma mark VOfficeBottomViewDelegate
//- (void)didSelectChatButton
//{
//    DLog(@"Select Chat");
//}
//- (void)didSelectReminderButton
//{
//    DLog(@"Select Reminder");
//}

#pragma mark - Util Search Task From API
- (void)searchTaskByName:(NSString *)taskName listTaskType:(NSInteger)listType taskType:(NSInteger)taskType startRecord:(NSInteger)startRecord completeHandler:(Callback)complete{
    [VOfficeProcessor searchTask:taskName listTaskType:listType taskType:taskType startRecord:startRecord isSum:NO callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        complete(success, resultDict, exception);
    }];
}

- (void)appendData:(NSArray *)arrData{
    [self removeContentLabel];
    [super hiddenBottomView:NO];
    [_workDetail.view setHidden:NO];
    if (arrData.count == 0) {
        if (self.listWorkType == ListWorkType_Perform) {
            [_listWorkPerform removeAllObjects];
            _lastPerformIndex = nil;
        }
        else
        {
            [_listWorkShipped removeAllObjects];
            _lastShippedIndex = nil;
        }
        [super hiddenBottomView:YES];
        [_workDetail.view setHidden:YES];
        [self addContentLabel:LocalizedString(@"Không tìm thấy kết quả") forView:_listWork];
        return;
    }
    [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.listWork.listWorks addObject:obj];
    }];
    
    if (self.listWorkType == ListWorkType_Perform) {
        _listWorkPerform = [[NSMutableArray alloc] initWithArray:self.listWork.listWorks];
    }
    else
    {
       _listWorkShipped = [[NSMutableArray alloc] initWithArray:self.listWork.listWorks];
    }
    _listworkFilter = [[NSMutableArray alloc] initWithArray:self.listWork.listWorks];
}

#pragma mark VOffice_DetailWork_iPadDelegate
- (DetailWorkModel *)getDetailWorkModel
{
    return _detailWork;
}
- (void)didSelectVOffice
{
    DLog(@"Tới VOffice");
}
- (void)endEditView
{
    [self endEditCurrentView];
}
- (void)searchBarReturn
{
    if (![Common checkNetworkAvaiable]) {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    else
    {
        [self.listWork.listWorks removeAllObjects];
        [self loadData:YES];
    }
}
@end
