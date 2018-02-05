//
//  ListMissionVC.m
//  SmartOffice
//
//  Created by Kaka on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ListMissionVC.h"
#import "SOSearchBarView.h"
#import "VOfficeProcessor.h"
#import "Common.h"
#import "WYPopoverController.h"
#import "ContentFilterVC.h"
#import "SOTableViewRowAction.h"
#import "ListMissionCell.h"
#import "DetailMissionVC.h"
#import "ReminderViewController.h"
#import "MissionModel.h"
#import "SVPullToRefresh.h"
#import "DiscussionListVC.h"
#import "MissionGroupModel.h"
#import "NSException+Custom.h"
#import "NSString+Util.h"
#import "Common.h"
#define WIDTH_FILTER_SHOW 0
#define WIDTH_FILTER_HIDEN 0

@interface ListMissionVC ()<WYPopoverControllerDelegate, ContentFilterVCDelegate, SOSearchBarViewDelegate>{
    WYPopoverController* popoverController;
    NSMutableArray *_listMissionPerform;
	NSMutableArray *_listMissionShipped;
    NSMutableArray *_listFilterMission;
    NSString *_lastRequest;
    BOOL _isLoadedAllMission;
	
	MissionType _missionType;
	//Cache last request
	NSString *_lastPerformRequest;
	NSString *_lastShippedRequest;
	
	BOOL _isFirstLoadShippedMission;
    __weak ListMissionVC *weakSelf;
}

@end

@implementation ListMissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _listMissionPerform = @[].mutableCopy;
	_listMissionShipped = @[].mutableCopy;
    _listFilterMission = @[].mutableCopy;
	
	_lastPerformRequest = @"";
	_lastShippedRequest = @"";
	
	_isFirstLoadShippedMission = NO;
    _isLoadedAllMission = NO;
    _lastRequest = @"";
	_missionType = MissionType_All;
    self.listMisstionController = [[VOffice_ListMissionController alloc] init];
    [self.listMisstionController setMissionType:_missionType missionGroupModel:_groupModel listType:_listType];
    [self createUI];
    
	[self loadData: YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self loadData:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CreateUI
- (void)createUI{
//	self.searchBar.returnKeyType = UIReturnKeySearch;
    _searchBar.placeholder = LocalizedString(@"VOffice_Mission_Tìm_kiếm_theo_tên_nhiệm_vụ");
    _searchBar.delegate = self;
    [AppDelegateAccessor setupSegment:_segmentControl];
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:AppFont_MainFontWithSize(13), NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} forState:UIControlStateNormal];
    if (_listType == ListMissionType_Perform) {
        [_segmentControl setSelectedSegmentIndex:ListMissionType_Perform];
    }else{
        [_segmentControl setSelectedSegmentIndex:ListMissionType_Shipped];
    }
	[self setupFilterByType:_listType];
    
    [self setupColor];
    [self setupNav];
    [self setupLanguage];

    weakSelf = self;
	//Load more
    [_tblContent addInfiniteScrollingWithActionHandler: ^{
        DLog(@"+++ scroll to load");
        if (_isLoadedAllMission == NO) {
			[self hiddenInfiniteScrollView:NO];
            [self loadData:NO];
		}else{
			[self hiddenInfiniteScrollView:YES];
		}
    }];
    [_tblContent.infiniteScrollingView setHiddenActivitiView:YES];
	
	//Refresh
	
	[_tblContent addPullToRefreshWithActionHandler:^{
        //_tblContent.showsPullToRefresh = NO;
        DLog(@"Refresh data here");
        //[weakSelf.tblContent.pullToRefreshView stopAnimating];
        if ([Common checkNetworkAvaiable]) {
			if (_listType == ListMissionType_Perform) {
				[_listMissionPerform removeAllObjects];
			}else{
				[_listMissionShipped removeAllObjects];
			}
            [_listFilterMission removeAllObjects];
			[self hiddenPullRefreshView:NO];
            [self loadData:NO];
        }else
        {
            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
			[self hiddenPullRefreshView:YES];
        }
    } position:SVPullToRefreshPositionTop];
	_tblContent.showsPullToRefresh = YES;
}
- (void)resetLoadMore
{
    _isLoadedAllMission = NO;
    weakSelf.tblContent.showsInfiniteScrolling = YES;
}
- (void)setupFilterByType:(ListMissionType)type{
	if (type == ListMissionType_Perform) {
		_btnFilter.alpha = 1.0;
		_btnFilter.enabled = YES;
        self.constrain_width_filter.constant = WIDTH_FILTER_SHOW;
	}else{
		_btnFilter.alpha = 0.3;
		_btnFilter.enabled = NO;
        self.constrain_width_filter.constant = WIDTH_FILTER_HIDEN;
	}
}

- (void)setupLanguage{
    [_segmentControl setTitle:LocalizedString(@"KVOFF_PERFORM_TITLE") forSegmentAtIndex:0];
    [_segmentControl setTitle:LocalizedString(@"KVOFF_SHIPPED_TITLE") forSegmentAtIndex:1];
}
- (void)setupColor{
    _segmentControl.tintColor = AppColor_MainAppTintColor;
    self.view.backgroundColor = AppColor_MainAppBackgroundColor;
    _searchView.backgroundColor = RGB(227, 227, 232);
}

- (void)setupNav{
    self.backTitle  = LocalizedString(@"LI_SCREEN_TITLE");
    self.subTitle   = _groupModel.msGroupName;
}

#pragma mark - LoadData
- (void)loadData:(BOOL)showHub
{
	[self removeContentLabel];
    if([Common checkNetworkAvaiable])
    {
        if (showHub) {
			[[Common shareInstance] showCustomHudInView:self.view];
        }
        NSInteger countCurrentList = _listType == ListMissionType_Perform ? _listMissionPerform.count : _listMissionShipped.count;
        [self.listMisstionController loadData:self.searchBar.text startRecord:countCurrentList completion:^(BOOL success, BOOL isLoadedAllMission, NSArray *resultArray, NSException *exception, NSDictionary *error) {
            [[Common shareInstance] dismissCustomHUD];
            if (success) {
                [self appendData:resultArray];
                _isLoadedAllMission = isLoadedAllMission;
            }
            else
            {
                [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
            }
            
            [self.tblContent reloadData];
			[self hiddenPullRefreshView:YES];
        }];
    }
    else
    {
		[self hiddenInfiniteScrollView:YES];
		[self hiddenPullRefreshView:YES];
		[self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}
#pragma mark - Hidden Refresh/ Loadmore View
- (void)hiddenInfiniteScrollView:(BOOL)hidden{
	if (hidden) {
		[weakSelf.tblContent.infiniteScrollingView setHiddenActivitiView:YES];
		[weakSelf.tblContent.infiniteScrollingView stopAnimating];
	}else{
		[weakSelf.tblContent.infiniteScrollingView setHiddenActivitiView:NO];
		[weakSelf.tblContent.infiniteScrollingView startAnimating];
	}
}
- (void)hiddenPullRefreshView:(BOOL)hidden{
	if (hidden) {
		[weakSelf.tblContent.pullToRefreshView stopAnimating];
		[weakSelf.tblContent.pullToRefreshView hiddenPullToRefresh:YES];
		
	}else{
		[weakSelf.tblContent.pullToRefreshView startAnimating];
		[weakSelf.tblContent.pullToRefreshView hiddenPullToRefresh:NO];
	}
}


- (void)reloadData{
    [self requestWith:_searchBar.text];
}
#pragma mark - Utils VC
- (void)dismissKeyboard{
	[self.searchBar.searchBar resignFirstResponder];
}
//Call API
- (void)searchMissionDataByName:(NSString *)name orgId:(NSString *)orgId typeMission:(NSInteger)type listType:(ListMissionType)listType startRecord:(NSInteger)startRecord completeHandler:(Callback)completeHandler{
    [VOfficeProcessor searchMissionByName:name orgID:orgId typeMission:type listType:listType startRecord:startRecord callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        completeHandler(success, resultDict, exception);
    }];
}

- (void)appendData:(NSArray *)arrData{
    [self removeContentLabel];
    if (arrData.count == 0) {
        if (_listType == ListMissionType_Perform) {
			if (_listMissionPerform.count == 0) {
				 [self addContentLabel:LocalizedString(@"Không tìm thấy kết quả")];
			}
            //[_listMissionPerform removeAllObjects];
        }else{
            //[_listMissionShipped removeAllObjects];
			if (_listMissionShipped.count == 0) {
				[self addContentLabel:LocalizedString(@"Không tìm thấy kết quả")];
			}
        }
    }
    [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if (_listType == ListMissionType_Perform) {
			[_listMissionPerform addObject:obj];
		}else{
			[_listMissionShipped addObject:obj];
		}
    }];
	if (_listType == ListMissionType_Perform) {
		_listFilterMission = [[NSMutableArray alloc] initWithArray:_listMissionPerform];
	}else{
		_listFilterMission = [[NSMutableArray alloc] initWithArray:_listMissionShipped];
	}
}

#pragma mark - SOSearchBarDelegate
- (void)textField:(UITextField *)textField textDidChange:(NSString *)searchText
{
    _lastRequest = searchText;
    if (_listType == ListMissionType_Perform) {
        _lastPerformRequest = searchText;
    }else{
        _lastShippedRequest = searchText;
    }
    [self localSearch:searchText];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    DLog(@"Seach clicked");
    [self loadDataWhenReturn:textField.text];
    return YES;
}

#pragma mark - Calculate to search on SearchBar
- (void)localSearch:(NSString *)searchText
{
    searchText = [searchText noSpaceString];
    if (![searchText checkSpace] && searchText != nil) {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"missionName CONTAINS[cd] %@", searchText];
		  _listFilterMission = [NSMutableArray arrayWithArray:[_listType == ListMissionType_Perform ? _listMissionPerform : _listMissionShipped filteredArrayUsingPredicate:p]];
    }
    else
    {
		_listFilterMission = [[NSMutableArray alloc] initWithArray:_listType == ListMissionType_Perform ? _listMissionPerform : _listMissionShipped];
    }
    [_tblContent reloadData];
}
- (void)loadDataWhenReturn:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        DLog(@"Clear search Bar");
        [self reloadData];
        return;
    }
    [self requestWith:searchText];
}
//Execute search from SearchBar
- (void)requestWith:(NSString *)query
{
    if ([Common checkNetworkAvaiable]) {
        query = [query convertLatinCharacters];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		[[Common shareInstance] showCustomHudInView:self.view];
        [self.listMisstionController executeSearchForQuery:query delayedBatching:YES completion:^(BOOL success, BOOL isLoadedAllMission, NSArray *resultArray, NSException *exception, NSDictionary *error) {
            [self resetLoadMore];
            [[Common shareInstance] dismissCustomHUD];
            //No need check by last request
            if (_listType == ListMissionType_Perform) {
                [_listMissionPerform removeAllObjects];
            }else{
                [_listMissionShipped removeAllObjects];
            }
            [_listFilterMission removeAllObjects];
            if (success) {
                [self appendData:resultArray];
            }
            else
            {
                [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
            }
            _isLoadedAllMission = isLoadedAllMission;
            [self.tblContent reloadData];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
    }
    else
    {
        _listMissionPerform = @[].mutableCopy;
        _listMissionShipped = @[].mutableCopy;
        _listFilterMission = @[].mutableCopy;
        [self.tblContent reloadData];
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    
}

#pragma mark - Util Get Type Mission

- (NSInteger)valueFromTypeMission:(MissionType)type{
    NSInteger value = 0;
    switch (type) {
        case MissionType_DirectorateAssigned:
            value = 1;
            break;
        case MissionType_Combined:
            value = 2;
            break;
        case MissionType_Registered:
            value = 3;
            break;
            break;
        default:
            value = 0;
            break;
    }
    return value;
}



//Refresh scroll toTop
- (void)scrollToTopData{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tblContent scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
#pragma mark - Actions
- (IBAction)onSegmentedControlClicked:(UISegmentedControl *)sender {
	_listType = sender.selectedSegmentIndex;
    //Refresh data here
	[self setupFilterByType:_listType];
	[self.listMisstionController setListMissionType:_listType];
	_searchBar.text = _listType == ListMissionType_Perform? _lastPerformRequest : _lastShippedRequest;
	if (_listType == ListMissionType_Perform) {
		_listFilterMission = [[NSMutableArray alloc] initWithArray:_listMissionPerform];
	}else{
		_listFilterMission = [[NSMutableArray alloc] initWithArray:_listMissionShipped];
	}
	//Show or hidden note Label
	if (_listFilterMission.count > 0) {
		[self removeContentLabel];
	}else{
		[self showNotationLabel];
	}
    if (!_isFirstLoadShippedMission) {
		[self reloadData];
		_isFirstLoadShippedMission = YES;
	}else{
		//Only reload data at Local
		[self.tblContent reloadData];
	}
	[AppDelegateAccessor setupSegment:sender];
	[self.view layoutIfNeeded];
	//Refresh by Load from Local
	[self localSearch:_searchBar.text];
}

- (IBAction)onFilterButtonClicked:(UIButton *)sender {
	[self dismissKeyboard];
    NSArray *contentFilter = @[@"- Tất cả -", @"Nhiệm vụ BGĐ giao", @"Nhiệm vụ phối hợp", @"Nhiệm vụ đăng ký"];
    NSInteger selectedFilterPosition = [self valueFromTypeMission:_missionType];
    ContentFilterVC *filterVC = [[ContentFilterVC alloc] initWithFilterSelected:selectedFilterPosition content:contentFilter];
    filterVC.delegate = self;
    popoverController = [[WYPopoverController alloc] initWithContentViewController:filterVC];
    popoverController.delegate = self;
    [popoverController setPopoverContentSize:filterVC.view.frame.size];
    [popoverController presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
}

#pragma mark - UITableView DataSource
//Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _listFilterMission.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (_listType == ListMissionType_Perform) {
		return 94.0f;
	}
	return 78.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID_CELL = @"ListMissionCell_ID";
    ListMissionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    if (indexPath.row >= _listFilterMission.count) {
        return cell;
    }
    MissionModel *model = _listFilterMission[indexPath.row];
    [cell setupDataByModel:model byType:_listType misstionType:_missionType];
    return cell;
}

//Swipe Cell
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SOTableViewRowAction *chatAction = [SOTableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                          title:@"Chat"
                                                                           icon:[UIImage imageNamed:@"swipe_cell_chat_icon"]
                                                                          color:RGB(59, 111, 169)
                                                                        handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                            //Action here
																			DLog(@"select chat");
																			[self pushToChatView];
                                                                            
                                                                        }];
    
    SOTableViewRowAction *reminderAction = [SOTableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                              title:@"Reminder"
                                                                               icon:[UIImage imageNamed:@"swipe_cell_reminder_icon"]
                                                                              color:RGB(255, 150, 0)
                                                                            handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                                //Action here
                                                                                [self pushToReminderView];
                                                                            }];
    
    return @[chatAction, reminderAction];
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailMissionVC *detailVC = NEW_VC_FROM_STORYBOARD(@"VOffice", @"DetailMissionVC");
    detailVC.subTitle = _groupModel.msGroupName;
    MissionModel *model = _listFilterMission[indexPath.row];
    detailVC.missionModel = model;
    if (_listType == ListMissionType_Perform) {
        detailVC.segmentCurrent = 0;
    } else {
        detailVC.segmentCurrent = (long*)1;
    }
    //Passing data here
    [self endEditCurrentView];
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - Using Touch
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	if (![Common isTextEditControll:touch.view]) {
		[self dismissKeyboard];
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

#pragma mark - ContentFilterVCDelegate
- (void)didSelectedFilterVC:(ContentFilterVC *)filterVC withFilterType:(NSInteger)filterType{
    //Check Current Filter Type
    NSInteger _currentFilterType = [self valueFromTypeMission:_missionType];
    if (_currentFilterType == filterType) {
        return;
    }
    //get new Mission Type
    _missionType = [VOffice_ListMissionController typeMissionFromValue:filterType];
    [self.listMisstionController setMissionType:_missionType];
    [popoverController dismissPopoverAnimated:YES];
    [self reloadData];
}

@end
