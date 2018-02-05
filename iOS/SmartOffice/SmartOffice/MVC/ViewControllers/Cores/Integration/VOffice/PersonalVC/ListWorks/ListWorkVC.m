//
//  ListWorkVC.m
//  SmartOffice
//
//  Created by Kaka on 4/13/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ListWorkVC.h"
#import "SOSearchBarView.h"
#import "ListWorkCell.h"
#import "VOfficeProcessor.h"
#import "Common.h"
#import "WYPopoverController.h"
#import "ContentFilterVC.h"
#import "DetailWorkVC.h"
#import "WorkModel.h"
#import "SVPullToRefresh.h"
#import "DiscussionListVC.h"
#import "NSException+Custom.h"
#import "NSString+Util.h"

#define WIDTH_FILTER ((int) 34)

@interface ListWorkVC ()<WYPopoverControllerDelegate, ContentFilterVCDelegate, SOSearchBarViewDelegate>{
    
    NSMutableArray *_listPerformWork;
    NSMutableArray *_listShippedWork;
    NSMutableArray *_listworkFilter;
    
    //Check loadMore
    BOOL _isLoadedAllWorks;
    NSString *_lastRequest;
    WYPopoverController* popoverController;
    WorkFilterType _filterType;
    WorkType _workType;
    
    BOOL _isFirstLoadShippedWork;
	//Cache last request
	NSString *_lastPerformRequest;
	NSString *_lastShippedRequest;
    
    __weak ListWorkVC *weakSelf;
    
}

@end

@implementation ListWorkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Initial data
    _isLoadedAllWorks = NO;
    _isFirstLoadShippedWork = NO;
	_lastPerformRequest = @"";
	_lastShippedRequest = @"";
    self.search_view.delegate = self;
    _listPerformWork = @[].mutableCopy;
    _listShippedWork = @[].mutableCopy;
    _listworkFilter  = @[].mutableCopy;
    _filterType  = WorkFilterType_All;
    _workType = WorkType_All;
    _lastRequest = @"";
    [self createUI];
	    
    //Load data
    [self loadData:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CreateUI
- (void)createUI{
    self.search_view.placeholder = LocalizedString(@"VOffice_Work_Tìm_kiếm_theo_tên_công_việc_tên_người");
    self.backTitle  = LocalizedString(@"LW_SCREEN_TITLE");
    self.search_view.delegate = self;
    [AppDelegateAccessor setupSegment:_segmentControl];
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:AppFont_MainFontWithSize(13), NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} forState:UIControlStateNormal];
    [self setupColor];
    if (_listWorkType == ListWorkType_Shipped) {
        [_segmentControl setSelectedSegmentIndex:1];
        [self setEnableButton:_btlFilter enable:NO];
        self.constrain_filter_width.constant = 0;
    }else{
        [_segmentControl setSelectedSegmentIndex:0];
        [self setEnableButton:_btlFilter enable:YES];
        self.constrain_filter_width.constant = WIDTH_FILTER;
    }
	_tblContent.estimatedRowHeight = 110;
    //Add LoadMore
    weakSelf = self;
    [_tblContent addInfiniteScrollingWithActionHandler: ^{
        DLog(@"+++ scroll to load");
        if (_isLoadedAllWorks == NO) {
			[self hiddenInfiniteScrollView:NO];
            [self loadData:NO];
        }
        else{
			[self hiddenInfiniteScrollView:YES];
        }
    }];
	[_tblContent.infiniteScrollingView setHiddenActivitiView:YES];
	
	//Refresh
    [_tblContent addPullToRefreshWithActionHandler:^{
        DLog(@"Refresh data here");
        if ([Common checkNetworkAvaiable]) {
            if (_listWorkType == ListWorkType_Perform) {
                [_listPerformWork removeAllObjects];
            }else{
                [_listShippedWork removeAllObjects];
            }
			[self hiddenPullRefreshView:NO];
			[self loadData:NO];
        }else
        {
			[self hiddenPullRefreshView:YES];
			[self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
        }
    } position:SVPullToRefreshPositionTop];
	_tblContent.showsPullToRefresh = YES;
	[self.view layoutIfNeeded];
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

- (void)resetLoadMore
{
    _isLoadedAllWorks = NO;
    weakSelf.tblContent.showsInfiniteScrolling = YES;
}
- (void)setupColor{
    //_topView.backgroundColor = AppColor_MainAppTintColor;
    _segmentControl.tintColor = AppColor_MainAppTintColor;
    self.view.backgroundColor = AppColor_MainAppBackgroundColor;
    _searchView.backgroundColor = RGB(227, 227, 232);
}

- (void)setEnableButton:(UIButton *)button enable:(BOOL)enable{
    if (enable) {
        button.alpha = 1.0;
    }else{
        button.alpha = 0.3;
    }
    button.enabled = enable;
}

#pragma handle UITap Recognizer
- (void)didTapOnView:(UITapGestureRecognizer *)tap{
	DLog(@"+++ Tap Tap Tap");
	if ([Common isTextEditControll:tap.view] == NO) {
		[self dismissKeyboard];
	}
}
- (void)dismissKeyboard{
	 [self.search_view.searchBar resignFirstResponder];
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

- (void)loadData:(BOOL)showHub
{
    if ([Common checkNetworkAvaiable]) {
        if (showHub) {
            [[Common shareInstance] showHUDWithTitle:@"Loading..." inView:self.view];
        }
        NSInteger countCurrentList = _listWorkType == ListWorkType_Perform ? _listPerformWork.count : _listShippedWork.count;
        [self searchTaskByName: self.search_view.text listTaskType:_listWorkType taskType:_workType startRecord:countCurrentList completeHandler:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            [[Common shareInstance] dismissHUD];
            if (success) {
                NSArray *dictArr = resultDict[@"data"];
                NSMutableArray *arrData = [WorkModel arrayOfModelsFromDictionaries:dictArr error:nil];
                if (arrData.count < PAGE_SIZE_NUMBER){
                    _isLoadedAllWorks = YES;
                }
                [self appendData:arrData];
            }else{
                DLog(@"+++ Error search listWork");
                [self handleErrorFromResult:resultDict withException:exception inView:self.view];
            }
            [_tblContent reloadData];
			[self hiddenPullRefreshView:YES];
			[self hiddenInfiniteScrollView:YES];
        }];
    }
    else
    {
		[self hiddenPullRefreshView:YES];
		[self hiddenInfiniteScrollView:YES];
		_listPerformWork = @[].mutableCopy;
        _listShippedWork = @[].mutableCopy;
        _listworkFilter  = @[].mutableCopy;
        [_tblContent reloadData];
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    
}

- (void)reloadData{
    if (_listWorkType == ListWorkType_Perform) {
        [_listPerformWork removeAllObjects];
    }else{
        [_listShippedWork removeAllObjects];
    }
    [self loadData:YES];
}


#pragma mark - Util Search Task From API
- (void)searchTaskByName:(NSString *)taskName listTaskType:(NSInteger)listType taskType:(NSInteger)taskType startRecord:(NSInteger)startRecord completeHandler:(Callback)complete{
    [VOfficeProcessor searchTask:taskName listTaskType:listType taskType:taskType startRecord:startRecord isSum:NO callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        complete(success, resultDict, exception);
    }];
}

- (void)appendData:(NSArray *)arrData{
    [self removeContentLabel];
    if (arrData.count == 0) {
        if (_listWorkType == ListWorkType_Perform) {
			if (_listPerformWork.count == 0) {
				[self addContentLabel:LocalizedString(@"Không tìm thấy kết quả")];
			}
        }else{
			if (_listShippedWork.count == 0) {
				[self addContentLabel:LocalizedString(@"Không tìm thấy kết quả")];
			}
        }
    }
    [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (_listWorkType == ListWorkType_Perform) {
            [_listPerformWork addObject:obj];
        }else{
            [_listShippedWork addObject:obj];
        }
    }];
    
    if (_listWorkType == ListWorkType_Perform) {
        _listworkFilter = [[NSMutableArray alloc] initWithArray:_listPerformWork];
    }else{
        _listworkFilter = [[NSMutableArray alloc] initWithArray:_listShippedWork];
    }
}
#pragma mark - Actions
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSegmentedControlClicked:(UISegmentedControl *)sender {
    //self.search_view.text = @"";
    [AppDelegateAccessor setupSegment:sender];
    if (sender.selectedSegmentIndex == 0) {
        _listWorkType = ListWorkType_Perform;
        _listworkFilter = [[NSMutableArray alloc] initWithArray:_listPerformWork];
        [self setEnableButton:_btlFilter enable:YES];
        self.constrain_filter_width.constant = WIDTH_FILTER;
    }else{
        _listWorkType = ListWorkType_Shipped;
        _listworkFilter = [[NSMutableArray alloc] initWithArray:_listShippedWork];
        [self setEnableButton:_btlFilter enable:NO];
        self.constrain_filter_width.constant = 0;
    }
	
	self.search_view.text = _listWorkType == ListWorkType_Perform? _lastPerformRequest : _lastShippedRequest;
	//Show or hidden note Label
	if (_listworkFilter.count > 0) {
		[self removeContentLabel];
	}else{
		[self showNotationLabel];
	}
	if (!_isFirstLoadShippedWork) {
		[self loadData:YES];
		_isFirstLoadShippedWork = YES;
	}else{
		//Only reload data at Local
		[self.tblContent reloadData];
	}
	

	[AppDelegateAccessor setupSegment:sender];
    [self.view layoutIfNeeded];
	[self localSearch: self.search_view.text];
}

- (IBAction)onFilterButtonClicked:(UIButton *)sender {
	[self dismissKeyboard];
    NSArray *contentFilter = @[@"- Tất cả -", @"Công việc cá nhân", @"Công việc phối hợp", @"Công việc được giao"];
    ContentFilterVC *filterVC = [[ContentFilterVC alloc] initWithFilterSelected:_filterType content:contentFilter];
    filterVC.delegate = self;
    popoverController = [[WYPopoverController alloc] initWithContentViewController:filterVC];
    popoverController.delegate = self;
    [popoverController setPopoverContentSize:filterVC.view.frame.size];
    [popoverController presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
}

#pragma mark - UITableView DataSource
//Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listworkFilter.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ID_CELL = @"";
    if (_listWorkType == ListWorkType_Perform) {
        NSString *ID_CELL = @"ListWorkCell_ID";
        if (_listWorkType == ListWorkType_Shipped) {
            ID_CELL = @"ListWorkShipped_ID";
        }
        ListWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
        if (indexPath.row >= _listworkFilter.count) {
            return cell;
        }
        WorkModel *model = _listworkFilter[indexPath.row];
        [cell setupDataByModel:model withListWorkType:_listWorkType];
        return cell;
    }else{
        ID_CELL = @"ListWorkShipped_ID";
        NSString *ID_CELL = @"ListWorkCell_ID";
        if (_listWorkType == ListWorkType_Shipped) {
            ID_CELL = @"ListWorkShipped_ID";
        }
        ListWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
        if (indexPath.row >= _listworkFilter.count) {
            return cell;
        }
        WorkModel *model = _listworkFilter[indexPath.row];
        [cell setupDataByModel:model withListWorkType:_listWorkType];
        return cell;
        
    }
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[self dismissKeyboard];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailWorkVC *detailVC = NEW_VC_FROM_STORYBOARD(@"VOffice", @"DetailWorkVC");
    //Passing data here
    detailVC.workModel = _listworkFilter[indexPath.row];
    [self endEditCurrentView];
    detailVC.segmentCurrent = _listWorkType;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark SOSearchBarViewDelegate
- (void)textField:(UITextField *)textField textDidChange:(NSString *)searchText
{
    _lastRequest = searchText;
    if (_listWorkType == ListWorkType_Perform) {
        _lastPerformRequest = searchText;
    }else{
        _lastShippedRequest = searchText;
    }
    [self localSearch:searchText];
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.search_view resignFirstResponder];
    [self loadDataWhenReturn: self.search_view.searchBar.text];
    DLog(@"Seach clicked");
    return YES;
}

- (void)loadDataWhenReturn:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        DLog(@"Clear search Bar");
        [self reloadData];
        return;
    }
    [self executeSearchForQuery:searchText delayedBatching:YES];
}
#pragma mark - Calculate to search on SearchBar
//Execute search from SearchBar
- (void)localSearch:(NSString *)searchText
{
    searchText = [searchText noSpaceString];
    if (![searchText checkSpace] && searchText != nil) {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"taskName CONTAINS[cd] %@ OR commanderName CONTAINS[cd] %@", searchText, searchText];
        _listworkFilter = [NSMutableArray arrayWithArray:[_listWorkType == ListWorkType_Perform ? _listPerformWork : _listShippedWork filteredArrayUsingPredicate:p]];
    }
    else
    {
        _listworkFilter = [[NSMutableArray alloc] initWithArray:_listWorkType == ListWorkType_Perform ? _listPerformWork : _listShippedWork];
    }
    [_tblContent reloadData];
}
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
    query = [query convertLatinCharacters];
    [[Common shareInstance] showHUDWithTitle:@"Loading..." inView:self.view];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSInteger countCurrentList = _listWorkType == ListWorkType_Perform ? _listPerformWork.count : _listShippedWork.count;
	//Refresh current list to search
	countCurrentList = 0;
    [self searchTaskByName:query listTaskType:_listWorkType taskType:_workType startRecord:countCurrentList completeHandler:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        [[Common shareInstance] dismissHUD];
		[_listworkFilter removeAllObjects];
		if (_listWorkType == ListWorkType_Perform) {
			[_listPerformWork removeAllObjects];
		}else{
			[_listShippedWork removeAllObjects];
		}
		if (success) {
			NSArray *dictArr = resultDict[@"data"];
			NSMutableArray *arrData = [WorkModel arrayOfModelsFromDictionaries:dictArr error:nil];
			if (arrData.count < PAGE_SIZE_NUMBER){
				_isLoadedAllWorks = YES;
			}
            if (arrData.count < PAGE_SIZE_NUMBER){
                _isLoadedAllWorks = YES;
            }
			[self appendData:arrData];
		}else{
			[self handleErrorFromResult:nil withException:[NSException initWithCode:[NSNumber numberWithInteger:RESP_CODE_REQUEST_NOTCONNECT]] inView:self.view];
		}
        
		[_tblContent reloadData];

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
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
    [self resetLoadMore];

    if (_filterType == filterType) {
        return;
    }
	//Reset data at first
	[_listworkFilter removeAllObjects];
	[_tblContent reloadData];
	
    //Reload data here
    _filterType = filterType;
    _workType = [self typeWorkFromFilter:filterType];
    [popoverController dismissPopoverAnimated:YES];
    //Reload Data here
    [self reloadData];
}

#pragma mark - Show Chat, Reminder
-(void)showChatViewAt:(NSIndexPath *)index
{
    [self pushToChatView];
}
-(void)showReminderAt:(NSIndexPath *)index
{
    [self pushToReminderView];
}
@end
