//
//  VOffice_ListMissionMain_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/27/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_ListMissionMain_iPad.h"
#import "SVPullToRefresh.h"
#import "NSException+Custom.h"
#import "NSString+Util.h"

#define HEIGHT_SUB_SHOW (22)
#define HEIGHT_SUB_HIDE (0)

@interface VOffice_ListMissionMain_iPad () <UITableViewDataSource, UITableViewDelegate, VOffice_ListView_iPadDelegate, WYPopoverControllerDelegate, ContentFilterAndSearchBarVCDelegate, VOffice_DetailMission_iPadDelegate>{
    WYPopoverController* popoverController;
    WYPopoverController* popoverControllerWithOutSearchBar;
    NSInteger _filterType;
    NSInteger _filterCopany;
    BOOL _isLoadedAllMission;
    BOOL _isFilterCompany;
    BOOL _isLoadMore;
    NSString *_lastPerformRequest;
    NSString *_lastShippedRequest;
    DetailMissionModel *_modelDetail;
    NSIndexPath *_lastPerformIndex;
    NSIndexPath *_lastShippedIndex;
    NSInteger _missionType;
    NSMutableArray *_listFilterMission;
    NSMutableArray *_listMission;
    NSMutableArray *_listPerformMission;
    NSMutableArray *_listShippedMission;
    __weak VOffice_ListMissionMain_iPad *weakSelf;
    MissionGroupModel *_model;
}
@property(strong, nonatomic)VOffice_MissionDetailController* missionDetailController;

@end

@implementation VOffice_ListMissionMain_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initValues];
    self.missionDetailView.delegate = self;
    // Do any additional setup after loading the view from its nib.
    [self configNav];
    [self setupUI];
    [self loadData:YES];
    
}
- (void)setValueForSegment
{
    self.listMissionView.sgm_WorkType.selectedSegmentIndex = [self.delegate getcurrentListType];
}
- (void)checkHiddenForFilter
{
    [self setHiddenForFilterButton:YES];
//    if (_missionType == ListMissionType_Perform) {
//        [self setHiddenForFilterButton:NO];
//    }
//    else
//    {
//        [self setHiddenForFilterButton:YES];
//    }
}
- (void)setupUI
{
    self.containerView.backgroundColor = AppColor_MainAppBackgroundColor;
    self.listMissionView.tbl_ListContents.delegate = self;
    self.listMissionView.tbl_ListContents.dataSource = self;
    [AppDelegateAccessor setupSegment:_segment];
    //Add Pull to refresh
    weakSelf = self;
	
	//Load More
	//LoadMore
	[self.listMissionView.tbl_ListContents.infiniteScrollingView stopAnimating];
	[self.listMissionView.tbl_ListContents.infiniteScrollingView setHiddenActivitiView:YES];
    [self.listMissionView.tbl_ListContents addInfiniteScrollingWithActionHandler: ^{
        DLog(@"+++ scroll to load");
        if (_isLoadedAllMission == NO) {
			[weakSelf.listMissionView.tbl_ListContents.infiniteScrollingView setHiddenActivitiView:NO];
			[weakSelf.listMissionView.tbl_ListContents.infiniteScrollingView startAnimating];
            _isLoadMore = YES;
            [self loadData:NO];
        }
        else{
			[weakSelf.listMissionView.tbl_ListContents.infiniteScrollingView stopAnimating];
			[weakSelf.listMissionView.tbl_ListContents.infiniteScrollingView setHiddenActivitiView:YES];

        }
    }];
    
    self.listMissionView.tbl_ListContents.showsPullToRefresh = NO;
    [self.listMissionView.tbl_ListContents addPullToRefreshWithActionHandler:^{
        DLog(@"Refresh data here");
        [weakSelf.listMissionView.tbl_ListContents.pullToRefreshView stopAnimating];
        if (_missionType == ListMissionType_Perform) {
            _lastPerformIndex = nil;
        }
        else
        {
            _lastShippedIndex = nil;
        }
        if ([Common checkNetworkAvaiable]) {
            [_listMission removeAllObjects];
            [self loadData:YES];
        }else
        {
            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view isInstant:NO];
        }
        
        
        //Refresh data here
        // prepend data to dataSource, insert cells at top of table view
        // call [tableView.pullToRefreshView stopAnimating] when done
    } position:SVPullToRefreshPositionTop];
    
    self.listMissionView.delegate = self;
    
    self.listMissionView.searchBar.placeholder = LocalizedString(@"VOffice_Mission_Tìm_kiếm_theo_tên_nhiệm_vụ");
    
    [self.listMissionView.tbl_ListContents registerNib:[UINib nibWithNibName:@"VOffice_ListMissionCell_iPad" bundle:nil] forCellReuseIdentifier:@"VOffice_ListMissionCell_iPad"];
    [self checkHiddenForFilter];
    [self setValueForSegment];
}
- (void)resetLoadMore
{
    _isLoadedAllMission = NO;
    weakSelf.listMissionView.tbl_ListContents.showsInfiniteScrolling = YES;
}
- (void)configNav
{
    self.VOffice_title = LocalizedString(@"VOffice_ListMissionMain_iPad_Danh_sách_nhiệm_vụ");
    _filterCopany = [self.delegate getCurrentIndexPath].row;
    self.VOffice_subTitle = [self.delegate didSelectRow:_filterCopany].msGroupName;
    self.VOffice_buttonTitles = @[@"VOffice"];
}
- (void)initValues
{
    _missionType = [self.delegate getcurrentListType];
    _lastPerformIndex = nil;
    _lastShippedIndex = nil;
    _lastPerformRequest = @"";
    _lastShippedRequest = @"";
    _listMission = @[].mutableCopy;
    _listFilterMission = @[].mutableCopy;
    _isLoadedAllMission = NO;
    self.missionDetailController = [[VOffice_MissionDetailController alloc] init];
}
- (void)setHiddenForFilterButton:(BOOL)isHidden
{
    [self.listMissionView setHiddenForFilterButton:isHidden];
}
- (void)showPopOverWithoutSearchBar:(UIButton *)sender contentFilter:(NSArray *)contentFilter

{
    if (popoverControllerWithOutSearchBar.popoverVisible) {
        [popoverControllerWithOutSearchBar dismissPopoverAnimated:YES];
        return;
    }
    ContentFilterAndSearchBarVC *filterVC = [[ContentFilterAndSearchBarVC alloc] initWithFilterSelected:_filterType content:contentFilter withoutSearchBar:YES];
    filterVC.preferredContentSize = CGSizeMake(240, contentFilter.count*44);
    filterVC.delegate = self;
    filterVC.modalInPopover = NO;
    popoverControllerWithOutSearchBar = [[WYPopoverController alloc] initWithContentViewController:filterVC];
    popoverControllerWithOutSearchBar.delegate = self;
    popoverControllerWithOutSearchBar.passthroughViews = @[sender];
    popoverControllerWithOutSearchBar.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    popoverControllerWithOutSearchBar.wantsDefaultContentAppearance = NO;
    [popoverControllerWithOutSearchBar presentPopoverFromRect:sender.bounds
                                                       inView:sender
                                     permittedArrowDirections:WYPopoverArrowDirectionAny
                                                     animated:YES
                                                      options:WYPopoverAnimationOptionFadeWithScale];
}
- (void)showPopOver:(UIButton *)sender contentFilter:(NSArray *)contentFilter
{
	[self endEditView];
    if (popoverController.popoverVisible) {
        [popoverController dismissPopoverAnimated:YES];
        return;
    }
    if (_model) {
        _filterCopany = [contentFilter indexOfObject:_model.msGroupName];
    }
    ContentFilterAndSearchBarVC *filterVC = [[ContentFilterAndSearchBarVC alloc] initWithFilterSelected: _filterCopany content:contentFilter withoutSearchBar:NO];
    filterVC.placeHolder = LocalizedString(@"VOffice_ListMissionMain_iPad_Tìm_kiếm_theo_tên_và_đơn_vị");
    filterVC.preferredContentSize = CGSizeMake(350, 4*44 + 44);
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

-(void)setMissionType:(MissionType)missionType missionGroupModel:(MissionGroupModel *) missionGroupModel
{
    self.listMisstionController = [[VOffice_ListMissionController alloc] init];
    [self.listMisstionController setMissionType:missionType missionGroupModel:missionGroupModel listType:_missionType];
}
#pragma mark Process Data
- (void)appendData:(NSArray *)arrData{
    [self removeContentLabel];
    [super hiddenBottomView:NO];
    [_missionDetailView.view setHidden:NO];
    if (arrData.count == 0) {
        if (_missionType == ListMissionType_Perform) {
            _lastPerformIndex = nil;
            [_listPerformMission removeAllObjects];
        }
        else
        {
            _lastShippedIndex = nil;
            [_listShippedMission removeAllObjects];
        }
        [super hiddenBottomView:YES];
        [_missionDetailView.view setHidden:YES];
        [self refreshDetailView];
        [self addContentLabel:LocalizedString(@"Không tìm thấy kết quả") forView:_listMissionView];
        return;
    }
    [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_listMission addObject:obj];
    }];
    
    if (_missionType == ListMissionType_Perform) {
        _listPerformMission = [[NSMutableArray alloc] initWithArray:_listMission];
    }
    else
    {
        _listShippedMission = [[NSMutableArray alloc] initWithArray:_listMission];
    }
    
    _listMission = [[NSMutableArray alloc] initWithArray:_listMission];

}
- (void)requestWith:(NSString *)query
{
    if ([Common checkNetworkAvaiable]) {
        [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
        [_listMission removeAllObjects];
        [self refreshDetailView];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [self.listMisstionController executeSearchForQuery:query delayedBatching:YES completion:^(BOOL success, BOOL isLoadedAllMission, NSArray *resultArray, NSException *exception, NSDictionary *error) {
            [self dismissHub];
            NSString *_lastRequest = @"";
            if (_missionType == ListMissionType_Perform) {
                _lastRequest = _lastPerformRequest;
            }
            else
            {
                _lastRequest = _lastShippedRequest;
            }
            if ([_lastRequest isEqualToString:query]) {
                [_listMission removeAllObjects];
                if (success) {
                    [self appendData:resultArray];
                    _listFilterMission = [[NSMutableArray alloc] initWithArray:_listMission];
                    if (resultArray.count > 0)
                    {
                        if (_missionType == ListMissionType_Perform) {
                            if(resultArray.count < _lastPerformIndex.row || !_lastPerformIndex) {
                                _lastPerformIndex = [NSIndexPath indexPathForRow:0 inSection:0];
                            }
                        }
                        else
                        {
                            if(resultArray.count < _lastShippedIndex.row || !_lastShippedIndex) {
                                _lastShippedIndex = [NSIndexPath indexPathForRow:0 inSection:0];
                            }
                        }
                        
                        [self localSearch:_lastRequest];
//                        [self loadDetailWithCurrentIndex];
                    }
                }
                else
                {
                    [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
                }
                _isLoadedAllMission = isLoadedAllMission;
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
    }
    else
    {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view isInstant:NO];
    }
    
}
- (void)refreshDetailView
{
    _modelDetail = nil;
    [self.missionDetailView reloadData];
}
- (void)loadData:(BOOL)showHub
{
    if ([Common checkNetworkAvaiable]) {
        if (showHub) {
            [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
        }
        [self.listMisstionController setListMissionType:_missionType];
        NSString *query = [self.listMissionView.searchBar.text convertLatinCharacters];
        [self.listMisstionController loadData:query startRecord:_listMission.count completion:^(BOOL success, BOOL isLoadedAllMission, NSArray *resultArray, NSException *exception, NSDictionary *error) {
            [self resetLoadMore];
            [self dismissHub];
			[weakSelf.listMissionView.tbl_ListContents.infiniteScrollingView stopAnimating];
			[weakSelf.listMissionView.tbl_ListContents.infiniteScrollingView setHiddenActivitiView:YES];

            if (success) {
				[self appendData:resultArray];
                _listFilterMission = [[NSMutableArray alloc] initWithArray:_listMission];
                _isLoadedAllMission = isLoadedAllMission;
            }
            else {
                if (exception) {
                    [self handleErrorFromResult:nil withException:exception inView:self.view];
                }
                else
                {
                    [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
                }
            }
            
            [self.listMissionView reloadData];
            if (_listMission.count > 0) {
                if (_missionType == ListMissionType_Perform) {
                    if(_listMission.count < _lastPerformIndex.row || !_lastPerformIndex) {
                        _lastPerformIndex = [NSIndexPath indexPathForRow:0 inSection:0];
                    }
                }
                else
                {
                    if(_listMission.count < _lastShippedIndex.row || !_lastShippedIndex) {
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
        [self resetList];
        [self endEditCurrentView];
        [self refreshDetailView];
        [self.listMissionView reloadData];
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view isInstant:NO];
    }
    
}
- (void)loadDetailWithCurrentIndex
{
    [self removeContentLabel];
    NSIndexPath *_lastIndex;
    if (_missionType == ListMissionType_Perform) {
        _lastIndex = _lastPerformIndex;
    }
    else
    {
        _lastIndex = _lastShippedIndex;
    }
    if (_lastIndex && _listFilterMission.count > _lastIndex.row) {
        if (_isLoadMore) {
            [self.listMissionView selectItemWithNoFocusCurrentItem:_lastIndex];
        }
        else
        {
            [self.listMissionView selectItem:_lastIndex];
        }
        [self loadMissionDetail];
    }
    _isLoadMore = NO;
}
- (void)loadMissionDetail
{
    [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
    [self.missionDetailController loadData:[self getModelToShow] completion:^(BOOL success, DetailMissionModel *missionDetail, NSException *exception, NSDictionary *error) {
        [self removeContentLabel];
        _modelDetail = nil;
        [self dismissHub];
        if (success) {
            if (_listMission.count < 1) {
                [self refreshDetailView];
                return ;
            }
            _modelDetail = missionDetail;
            //Fix modelDetail.date = listMission[lastindex] dateComplet
            NSIndexPath *_lastIndex;
            
            if (_missionType == ListMissionType_Perform) {
                _lastIndex = _lastPerformIndex;
            }
            else
            {
                _lastIndex = _lastShippedIndex;
            }
            if (_listMission.count >= _lastIndex.row) {
                _modelDetail.dateComplete = [_listMission[_lastIndex.row] dateComplete];
            }
            
        }else{
            if (exception) {
                [self handleErrorFromResult:nil withException:exception inView:self.view];
            }
            else
            {
                [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
            }
            
        }
        [self.missionDetailView reloadData];
    }];
    
}
- (void)reloadData{
    [_listMission removeAllObjects];
    [self loadData:YES];
}
#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listFilterMission.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID_CELL = @"VOffice_ListMissionCell_iPad";
    VOffice_ListMissionCell_iPad *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    if (indexPath.row >= _listFilterMission.count) {
        return cell;
    }
    switch (_missionType) {
        case ListMissionType_Perform:
        {
            cell.height_sub_info.constant = HEIGHT_SUB_SHOW;
        }
            break;
        case ListMissionType_Shipped:
        {
            cell.height_sub_info.constant = HEIGHT_SUB_HIDE;
        }
            break;
        default:
            cell.height_sub_info.constant = HEIGHT_SUB_HIDE;
            break;
    }
    [cell layoutIfNeeded];
    
    MissionModel *model = _listFilterMission[indexPath.row];
    [cell setupDataByModel:model byType:_missionType misstionType:[VOffice_ListMissionController typeMissionFromValue:_filterType]];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_missionType == ListMissionType_Perform) {
        _lastPerformIndex = indexPath;
    }
    else
    {
        _lastShippedIndex = indexPath;
    }
    [self endEditCurrentView];
    [self loadMissionDetail];
}
#pragma mark VOffice_ListView_iPadDelegate
- (void)buttonPressed:(UIButton *)sender
{
    //    @"- Tất cả -", @"Nhiệm vụ BGĐ giao", @"Nhiệm vụ phối hợp", @"Nhiệm vụ đăng ký"
    NSArray *contentFilter = @[LocalizedString(@"- Tất cả -"), LocalizedString(@"Nhiệm vụ BGĐ giao"), LocalizedString(@"Nhiệm vụ phối hợp"), LocalizedString(@"Nhiệm vụ đăng ký")];
    [self showPopOverWithoutSearchBar:sender contentFilter:contentFilter];
    DLog(
@"press");
}
- (void)switchSegment:(UISegmentedControl *)segment
{
    _missionDetailView.checkReturn = segment.selectedSegmentIndex;
    NSString *_lastQuery = @"";
    if (segment.selectedSegmentIndex == ListMissionType_Perform) {
        _lastQuery = _lastPerformRequest;
        _listMission = [[NSMutableArray alloc] initWithArray:_listPerformMission];
    }
    else
    {
        _lastQuery = _lastShippedRequest;
        _listMission = [[NSMutableArray alloc] initWithArray:_listShippedMission];
    }
    [self.listMissionView setTextForSearchBar:_lastQuery];
    DLog(@"Segmented Control type: %ld", (long)segment.selectedSegmentIndex);
    [AppDelegateAccessor setupSegment:segment];
    _missionType = segment.selectedSegmentIndex;
    [self.delegate setcurrentMissionType:_missionType];
    [self checkHiddenForFilter];
    //Refresh data here
    
    if (!_listShippedMission || !_listPerformMission || _listShippedMission.count == 0 || _listPerformMission.count == 0) {
        [_listMission removeAllObjects];
        [self reloadData];
    }
    else
    {
        _listFilterMission = [[NSMutableArray alloc] initWithArray:_listMission];
        [self localSearch:_lastQuery];
    }
}
- (void)localSearch:(NSString *)searchText
{
    searchText = [searchText noSpaceString];
    [self refreshDetailView];
    if (![searchText checkSpace] && searchText != nil) {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"missionName CONTAINS[cd] %@", searchText];
        _listFilterMission = [NSMutableArray arrayWithArray:[_listMission filteredArrayUsingPredicate:p]];
        if (_listFilterMission.count < 1) {
            if (_missionType == ListMissionType_Perform) {
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
        _listFilterMission = [[NSMutableArray alloc] initWithArray:_listMission];
    }
    [self.listMissionView reloadData];
    [self loadDetailWithCurrentIndex];
}
- (void)searchBarReturn
{
    if (![Common checkNetworkAvaiable]) {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view isInstant:NO];
    }
    else
    {
        [_listMission removeAllObjects];
        if (_missionType == ListMissionType_Perform) {
            [self requestWith:_lastPerformRequest];
        }
        else
        {
            [self requestWith:_lastShippedRequest];
        }
//        [self loadData:YES];
    }
}
- (void)beginSearch
{
    [self refreshDetailView];
}
- (void)searchBar:(UITextField *)searchBar textDidChange:(NSString *)searchText
{
    if (_missionType == ListMissionType_Perform) {
        _lastPerformRequest = searchText;
        _lastPerformIndex = nil;
    }
    else
    {
        _lastShippedRequest = searchText;
        _lastShippedIndex = nil;
    }
    [self localSearch:searchText];
//    if ([searchText isEqualToString:@""]) {
//        DLog(@"Clear search Bar");
//        [self reloadData];
//        return;
//    }
//    [self requestWith:searchText];
}
- (void)resetList
{
    _listFilterMission = @[].mutableCopy;
    _listMission = @[].mutableCopy;
    _listPerformMission = @[].mutableCopy;
    _listShippedMission = @[].mutableCopy;
}
#pragma mark ContentFilterAndSearbarDelegate
- (void)didSelectedFilterVC:(NSInteger)index
{
    [self refreshDetailView];
    DLog(@"%ld", (long)[self.listMisstionController getMissionType]);
    if (_missionType == ListMissionType_Perform) {
        _lastPerformIndex = nil;
    }
    else
    {
        _lastShippedIndex = nil;
    }
    if (_isFilterCompany) {
        [self resetList];
        _filterCopany = index;
        _model = [self.delegate didSelectRow:index];
        self.VOffice_subTitle = _model.msGroupName;
        [self.listMisstionController setMissionGroupModel:_model];
        _isFilterCompany = NO;
        [popoverController dismissPopoverAnimated:YES];
        popoverController.delegate = nil;
        popoverController = nil;
    }
    else
    {
        _filterType = index;
        [self.listMisstionController setMissionType:[VOffice_ListMissionController typeMissionFromValue:index]];
        [popoverControllerWithOutSearchBar dismissPopoverAnimated:YES];
        popoverControllerWithOutSearchBar.delegate = nil;
        popoverControllerWithOutSearchBar = nil;
    }
    
    [self reloadData];
}

#pragma mark VOffice_DetailMission_iPadDelegate
- (MissionModel *)getModelToShow
{
    NSIndexPath *_lastIndex;
    if (_missionType == ListMissionType_Perform) {
        _lastIndex = _lastPerformIndex;
    }
    else
    {
        _lastIndex = _lastShippedIndex;
    }
    MissionModel *model = _listMission.count > 0 ? _listMission[_lastIndex.row] : nil;
    return model;
}
- (DetailMissionModel *)getMissionDetailModel
{
    return _modelDetail;
}

- (void)didSelectVOffice
{
    DLog(@"Tới VOffice");
}
- (void)endEditView
{
    [self endEditCurrentView];
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

#pragma mark VOffice_NavBase_iPadDelegate
- (void)didSelectFilterButton:(UIButton *)sender
{
    _isFilterCompany = YES;
    NSArray *contentFilter = [self.delegate getListmMsGroupName];
    [self showPopOver:sender contentFilter:contentFilter];
}
@end
