//
//  ListDocVC.m
//  SmartOffice
//
//  Created by Kaka on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ListDocVC.h"
#import "ListDocCell.h"
#import "SOSearchBarView.h"
#import "WYPopoverController.h"
#import "ContentFilterVC.h"
#import "Common.h"
#import "VOfficeProcessor.h"
#import "DetailDocVC.h"
#import "DocModel.h"
#import "TextModel.h"
#import "SVPullToRefresh.h"
#import "SOTableViewRowAction.h"
#import "DiscussionListVC.h"
#import "NSException+Custom.h"

#import "NSString+Util.h"
@interface ListDocVC ()<WYPopoverControllerDelegate, ContentFilterVCDelegate, SOSearchBarViewDelegate>{
	WYPopoverController* popoverController;
	NSMutableArray *_listDoc;
    NSMutableArray *_listFilterDoc;
	BOOL _isLoadedAllDoc;
    NSString *_lastRequest;
    __weak ListDocVC *weakSelf;
}

@end

@implementation ListDocVC

- (void)viewDidLoad {
    [super viewDidLoad];
	_listDoc = @[].mutableCopy;
    _listFilterDoc = @[].mutableCopy;
    _lastRequest = @"";
	[self createUI];
    [self loadData:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CreateUI
- (void)createUI{
	[self setupColor];
    [self setupNav];
	//Placeholder
	_searchBar.placeholder = LocalizedString(@"VOffice_ListDocument_Tìm_kiếm_theo_tên_văn_bản_tên_người_trình_ký");
    _searchBar.delegate = self;
	//Add Pull to refresh
	weakSelf = self;
    _tblContent.allowsMultipleSelectionDuringEditing = NO;
	
	//LoadMore
	[_tblContent.infiniteScrollingView stopAnimating];
	[_tblContent.infiniteScrollingView setHiddenActivitiView:YES];

	[_tblContent addInfiniteScrollingWithActionHandler: ^{
		DLog(@"+++ scroll to load");
		if (_isLoadedAllDoc == NO) {
			[self hiddenInfiniteScrollView:NO];
            [self loadData:NO];
        }else{
			[self hiddenInfiniteScrollView:YES];
			//[self hiddenPullRefreshView:YES];
        }
	}];
	
	//refresh
	[_tblContent addPullToRefreshWithActionHandler:^{
		DLog(@"Refresh data here");
        if ([Common checkNetworkAvaiable]) {
            [_listDoc removeAllObjects];
            [_listFilterDoc removeAllObjects];
			[self hiddenPullRefreshView:NO];
            [self loadData:NO];
        }else
        {
            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
			[self hiddenInfiniteScrollView:YES];
			[self hiddenPullRefreshView:YES];
		}
	} position:SVPullToRefreshPositionTop];
	_tblContent.showsPullToRefresh = YES;
}
- (void)resetLoadMore
{
    _isLoadedAllDoc = NO;
    weakSelf.tblContent.showsInfiniteScrolling = YES;
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
		weakSelf.tblContent.showsPullToRefresh = YES;
	}
}


- (void)setupColor{
	self.view.backgroundColor = AppColor_MainAppBackgroundColor;
	_searchView.backgroundColor = RGB(227, 227, 232);
}

- (void)setupNav{
    self.backTitle  = @"Văn bản";
    self.subTitle   = [self getTitleDocBy:_docType];
}


- (NSString *)getTitleDocBy:(DocType)type{
	NSString *title = @"";
	switch (type) {
		case DocType_Waiting:
			title = kDOC_WAITING_SIGN;
			break;
		case DocType_Flash:
			title = kDOC_FLASH;
			break;
		case DocType_Express:
			title = kDOC_EXPRESS;
			break;
		default:
			break;
	}
	return title;
}

#pragma mark - Load Data
- (void)loadData:(BOOL)showHub
{
    if (showHub) {
        [[Common shareInstance] showHUDWithTitle:@"Loading..." inView:self.view];
    }
	[self startSearchingDocByTitle:_searchBar.text docType:_docType startRecord:_listDoc.count completionHandler:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        [self resetLoadMore];
		if (success) {
			NSArray *dictModels = resultDict[@"data"];
			NSMutableArray *arrDocs = @[].mutableCopy;
			if (_docType == DocType_Express) {
				arrDocs = [DocModel arrayOfModelsFromDictionaries:dictModels error:nil];

			}else{
				arrDocs = [TextModel arrayOfModelsFromDictionaries:dictModels error:nil];
			}
			if (arrDocs.count < PAGE_SIZE_NUMBER) {
				_isLoadedAllDoc = YES;
			}
			[self appendDocs:arrDocs];
		}else{
			//Parse Error from API
			dispatch_async(dispatch_get_main_queue(), ^{
				[self handleErrorFromResult:resultDict withException:exception inView:self.view];
			});

		}
        
		dispatch_async(dispatch_get_main_queue(), ^{
			[[Common shareInstance] dismissHUD];
			[self hiddenInfiniteScrollView:YES];
			[self hiddenPullRefreshView:YES];
			[_tblContent reloadData];
		});
	}];
}

- (void)appendDocs:(NSArray *)docs{
    [self removeContentLabel];
    if (docs.count == 0) {
        [_listDoc removeAllObjects];
        [self addContentLabel:LocalizedString(@"Không tìm thấy kết quả")];
        return;
    }
	[docs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[_listDoc addObject:obj];
	}];
    _listFilterDoc = [[NSMutableArray alloc] initWithArray:_listDoc];
    
}

#pragma mark - API

- (void)startSearchingDocByTitle:(NSString *)title docType:(NSInteger)type startRecord:(NSInteger)startRecord completionHandler:(Callback)callBack{
	if (type == DocType_Express) {
		[VOfficeProcessor searchExpressDocByTitle:title startRecord:startRecord isSum:NO callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
			callBack(success, resultDict, exception);
		}];
	}else{
		[VOfficeProcessor searchNormalDocByTitle:title docType:type startRecord:startRecord isSum:NO callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
			callBack(success, resultDict, exception);
		}];
	}
}
- (void)refreshData{
	[_listDoc removeAllObjects];
    [_listFilterDoc removeAllObjects];
    [self loadData:YES];
}
#pragma mark - Actions

- (IBAction)back:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onFilterButtonClicked:(UIButton *)sender {
	[self dismissKeyboard];
	NSArray *contentFilter = @[LocalizedString(@"VOffice_ListDocumentMain_iPad_Văn_bản_chờ_ký_duyệt"), LocalizedString(@"VOffice_ListDocumentMain_iPad_văn_bản_ký_nháy"), LocalizedString(@"VOffice_ListDocumentMain_iPad_Văn_bản_hoả_tốc")];
	ContentFilterVC *filterVC = [[ContentFilterVC alloc] initWithFilterSelected:_docType content:contentFilter];
	filterVC.delegate = self;
	popoverController = [[WYPopoverController alloc] initWithContentViewController:filterVC];
	popoverController.delegate = self;
	[popoverController setPopoverContentSize:filterVC.view.frame.size];
	[popoverController presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
}


#pragma mark - UITableView DataSource
//Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [_listFilterDoc count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *ID_CELL = @"ListDocCell_ID";
	ListDocCell *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    if (indexPath.row >= _listFilterDoc.count) {
        return cell;
    }
	[cell setupDataByModel:_listFilterDoc[indexPath.row]];
	return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	DetailDocVC *detailVC = NEW_VC_FROM_STORYBOARD(@"VOffice", @"DetailDocVC");
	NSString *_docId = @"";
	if (_docType == DocType_Express) {
		_docId = ((DocModel *)_listFilterDoc[indexPath.row]).documentId;
	}else{
		_docId = ((TextModel *)_listFilterDoc[indexPath.row]).textId;
	}
	detailVC.docId = _docId;
	detailVC.type = _docType;
    [self endEditCurrentView];
	[self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark SOSearchBarViewDelegate
- (void)textField:(UITextField *)textField textDidChange:(NSString *)searchText
{
    _lastRequest = searchText;
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
    [self.searchBar resignFirstResponder];
    DLog(@"Seach clicked");
    [self searchDataWhenReturn:self.searchBar.text];
    return YES;
}

- (void)localSearch:(NSString *)searchText
{
    searchText = [searchText noSpaceString];
    if (![searchText checkSpace] && searchText != nil) {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ or searchName CONTAINS[cd] %@", searchText, searchText];
        _listFilterDoc = [NSMutableArray arrayWithArray:[_listDoc filteredArrayUsingPredicate:p]];
    }
    else
    {
        _listFilterDoc = [[NSMutableArray alloc] initWithArray:_listDoc];
    }
    [_tblContent reloadData];
}
- (void)searchDataWhenReturn:(NSString *)searchText
{
    if (searchText.length > 0) {
        [self executeSearchForQuery:searchText delayedBatching:YES];
    }else{
        //Search no titile when searchBar.text = @""
        [self refreshData];
    }
}
#pragma mark - Apply Search by Text
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
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[Common shareInstance] showHUDWithTitle:@"Loading..." inView:self.view];
	[self startSearchingDocByTitle:query docType:_docType startRecord:0 completionHandler:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        [[Common shareInstance] dismissHUD];
        if ([_lastRequest isEqualToString:query]) {
            [_listDoc removeAllObjects];
            [_listFilterDoc removeAllObjects];
            if (success) {
                NSArray *dictModels = resultDict[@"data"];
                NSMutableArray *arrDocs = @[].mutableCopy;
                if (_docType == DocType_Express) {
                    arrDocs = [DocModel arrayOfModelsFromDictionaries:dictModels error:nil];
                    
                }else{
                    arrDocs = [TextModel arrayOfModelsFromDictionaries:dictModels error:nil];
                }
                if (arrDocs.count < PAGE_SIZE_NUMBER) {
                    _isLoadedAllDoc = YES;
                }
                [self appendDocs:arrDocs];
            }else{
                //Parse Error from API
                [self handleErrorFromResult:resultDict withException:exception inView:self.view];
            }
            [_tblContent reloadData];
        }
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

- (void)dismissKeyboard{
	[self.searchBar dismissKeyboard];
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
	if (_docType == filterType) {
		return;
	}
	//Reload data here
    _isLoadedAllDoc = NO;
	_searchBar.text = @"";
	_docType = filterType;
	self.navView.subTitle  = [self getTitleDocBy:_docType];	
	[popoverController dismissPopoverAnimated:YES];
	//Call API Refresh data here
	[self refreshData];
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
