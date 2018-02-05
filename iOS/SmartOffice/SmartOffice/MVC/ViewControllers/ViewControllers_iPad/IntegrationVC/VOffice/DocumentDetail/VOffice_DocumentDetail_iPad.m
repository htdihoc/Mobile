//
//  VOffice_DocumentDetail_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_DocumentDetail_iPad.h"
#import "VOffice_DocumentDetailCell_iPad.h"
#import "VOfficeProcessor.h"
#import "DocModel.h"
#import "Common.h"
#import "FullWidthSeperatorTableView.h"
#import "TextModel.h"
#import "SVPullToRefresh.h"
#import "NSException+Custom.h"
#import "NSString+Util.h"
@interface VOffice_DocumentDetail_iPad () <UITableViewDelegate, UITableViewDataSource, SOSearchBarViewDelegate>
{
    NSMutableArray *_listDoc;
    NSMutableArray *_listFilterDoc;
    BOOL _isLoadedAllDoc;
    NSString *_lastRequest;
    NSIndexPath *_lastIndex;
    BOOL _isLoadMore;
    __weak VOffice_DocumentDetail_iPad *weakSelf;
}

@property (nonatomic) BOOL isSearch;

@end

@implementation VOffice_DocumentDetail_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSearch = false;
    self.tb_ListDocument.estimatedRowHeight = 110;
    self.tb_ListDocument.rowHeight = UITableViewAutomaticDimension;
    [self initValues];
    [self createUI];
    [self loadData:YES];
}
- (void)initValues
{
    _lastIndex = nil;
    _lastRequest = @"";
    self.searchBar.delegate = self;
    self.tb_ListDocument.delegate = self;
    self.tb_ListDocument.dataSource = self;
    [self.tb_ListDocument registerNib:[UINib nibWithNibName:@"VOffice_DocumentDetailCell_iPad" bundle:nil] forCellReuseIdentifier:@"VOffice_DocumentDetailCell_iPad"];
    _listDoc = [NSMutableArray new];
    _listFilterDoc = [NSMutableArray new];
    self.searchBar.placeholder = LocalizedString(@"VOffice_ListDocument_Tìm_kiếm_theo_tên_văn_bản_tên_người_trình_ký");
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [self.tb_ListDocument addGestureRecognizer:tap];
}
- (void)didTapOnTableView:(UIGestureRecognizer*) recognizer
{
    CGPoint tapLocation = [recognizer locationInView:self.tb_ListDocument];
    NSIndexPath *indexPath = [self.tb_ListDocument indexPathForRowAtPoint:tapLocation];
    
    if (indexPath) { //we are in a tableview cell, let the gesture be handled by the view
        recognizer.cancelsTouchesInView = NO;
    }
    [self.delegate endEditVC];
}
- (void)resetLoadMore
{
    _isLoadedAllDoc = NO;
    weakSelf.tb_ListDocument.showsInfiniteScrolling = YES;
}
- (void)createUI
{
    //Add Pull to refresh
    weakSelf = self;
    _tb_ListDocument.showsInfiniteScrolling = NO;
    [_tb_ListDocument addInfiniteScrollingWithActionHandler: ^{
        DLog(@"+++ scroll to load");
        [weakSelf.tb_ListDocument.infiniteScrollingView stopAnimating];
        if (_isLoadedAllDoc == NO) {
            _isLoadMore = YES;
            [self loadData:NO];
        }
        else{
            weakSelf.tb_ListDocument.showsInfiniteScrolling = NO;
        }
        
    }];
    
    _tb_ListDocument.showsPullToRefresh = NO;
    [_tb_ListDocument addPullToRefreshWithActionHandler:^{
        DLog(@"Refresh data here");
        _lastIndex = nil;
        [weakSelf.tb_ListDocument.pullToRefreshView stopAnimating];
        if ([Common checkNetworkAvaiable]) {
            [_listDoc removeAllObjects];
            [self loadData:YES];
        }else
        {
            [self.delegate showError:nil withException:[NSException initWithNoNetWork]];
        }
    } position:SVPullToRefreshPositionTop];
    //    [AppDelegateAccessor setPropertyItalic:self.searchBar fontsize:15];
}



- (void)selectCurrentIndexItem
{
    if (_lastIndex && _listFilterDoc.count > _lastIndex.row) {
        if (_isLoadMore) {
            [self.tb_ListDocument selectRowAtIndexPath:_lastIndex animated:YES  scrollPosition:UITableViewScrollPositionNone];
        }
        else
        {
            [self.tb_ListDocument selectRowAtIndexPath:_lastIndex animated:YES  scrollPosition:UITableViewScrollPositionBottom];
        }
        [self.delegate didSelectDocWithID:[self getDocIDWithIndex: _lastIndex.row]];
    }
    
    _isLoadMore = NO;
    
}
- (NSString *)getDocIDWithIndex:(NSInteger)index{
    NSString *_docId = @"";
    if (_listDoc.count > 0) {
        if ([self.delegate docType] == DocType_Express) {
            _docId = [self checkActiveSearchBar] == YES ? ((DocModel *)_listFilterDoc[index]).documentId : ((DocModel *)_listDoc[index]).documentId;
        }else{
            _docId = [self checkActiveSearchBar] == YES ? ((TextModel *)_listFilterDoc[index]).textId:  ((TextModel *)_listDoc[index]).textId;
        }
    }
    
    return _docId;
}
#pragma mark - Load Data
- (void)loadData:(BOOL)showHub{
    if([Common checkNetworkAvaiable])
    {
        if (self.delegate) {
            [self.delegate reloadTypicalDetailView];
            DocType docType = [self.delegate docType];
            if (showHub) {
                [self.delegate showLoading];
            }
            NSString *query = [_searchBar.text convertLatinCharacters];
            
            [self startSearchingDocByTitle:query docType:docType startRecord:_listDoc.count completionHandler:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
                [self resetLoadMore];
                if (success) {
                    NSArray *dictModels = resultDict[@"data"];
                    NSMutableArray *arrDocs = @[].mutableCopy;
                    if (docType == DocType_Express) {
                        arrDocs = [DocModel arrayOfModelsFromDictionaries:dictModels error:nil];
                        
                    }else{
                        arrDocs = [TextModel arrayOfModelsFromDictionaries:dictModels error:nil];
                    }
                    if (arrDocs.count < PAGE_SIZE_NUMBER) {
                        _isLoadedAllDoc = YES;
                    }
                    if (arrDocs.count > 0) {
                        if (!_lastIndex || arrDocs.count < _lastIndex.row) {
                            _lastIndex = [NSIndexPath indexPathForRow:0 inSection:0];
                        }
                        
                    }
                    [self appendDocs:arrDocs];
                    _listFilterDoc = [[NSMutableArray alloc] initWithArray:_listDoc copyItems:YES];
                }else{
                    //Parse Error from API
                    if ([exception.userInfo[@"_kCFStreamErrorCodeKey"] integerValue] == RESP_CODE_EXCEPTION_NO_INTERNET) {
                        [self.delegate showNetworkNotAvailable];
                    }
                    else
                    {
                        
                        [self.delegate showError:resultDict withException:exception];
                    }
                    
                }
                
                [_tb_ListDocument performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                if (_listDoc.count > 0) {
                    if (_listDoc.count < _lastIndex.row) {
                        _lastIndex = [NSIndexPath indexPathForRow:0 inSection:0];
                    }
                    [self selectCurrentIndexItem];
                }
                [self.delegate dismissLoading];
            }];
        }
    }
    else
    {
        [_listDoc removeAllObjects];
        [_listFilterDoc removeAllObjects];
        [_tb_ListDocument reloadData];
        [self.delegate showError:nil withException:[NSException initWithNoNetWork]];
    }
    
}

- (void)appendDocs:(NSArray *)docs{
    [self removeContentLabel];
    if (docs.count == 0) {
        [_listDoc removeAllObjects];
        _lastIndex = nil;
        [self.delegate setCanShowDetail:NO];
        if (self.isSearch == false) {
            [self addContentLabel:LocalizedString(@"Không có dữ liệu")];
        } else {
            [self addContentLabel:LocalizedString(@"Không tìm thấy kết quả")];
        }
        [self.delegate hiddenBottomView:YES];
        return;
    }
    [self.delegate hiddenBottomView:NO];
    [self.delegate setCanShowDetail:YES];
    [docs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_listDoc addObject:obj];
    }];
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
    [self.delegate reloadTypicalDetailView];
    [_listDoc removeAllObjects];
    [self loadData:YES];
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _lastIndex = indexPath;
    [self.delegate didSelectDocWithID:[self getDocIDWithIndex: indexPath.row]];
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self checkActiveSearchBar] == YES ? [_listFilterDoc count] : [_listDoc count];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID_CELL = @"VOffice_DocumentDetailCell_iPad";
    VOffice_DocumentDetailCell_iPad *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    
    if ([self checkActiveSearchBar] == YES) {
        if (indexPath.row >= _listFilterDoc.count) {
            return cell;
        }
        [cell setupDataByModel:_listFilterDoc[indexPath.row]];
    }
    else
    {
        if (indexPath.row >= _listDoc.count) {
            return cell;
        }
        [cell setupDataByModel:_listDoc[indexPath.row]];
    }
    
    return cell;
}

#pragma mark SOSearchBarViewDelegate
- (void)textField:(UITextField *)textField textDidChange:(NSString *)searchText
{
    _lastRequest = searchText;
    _lastIndex = nil;
    [self localSearch:searchText];
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.isSearch = true;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _lastIndex = nil;
    if (![Common checkNetworkAvaiable]) {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view isInstant:NO];
    }
    else
    {
        [_listDoc removeAllObjects];
        [self executeSearchForQuery:textField.text];
    }
    return YES;
}

#pragma mark - UISearchBarDelegate
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    [searchBar resignFirstResponder];
//    DLog(@"Seach clicked");
//    _lastIndex = nil;
//    if (![searchBar.text checkSpace]) {
//        if (![Common checkNetworkAvaiable]) {
//            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view isInstant:YES];
//        }
//        else
//        {
//            [_listDoc removeAllObjects];
//            [self loadData:YES];
//        }
//    }
//}
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
//    DLog(@"seach bar end editting");
//    //    [self refreshData];
//    self.isSearch = true;
//}
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    DLog(@"Cancel searchBar clicked");
//}
////Text Dic Change
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    _lastRequest = searchText;
//    _lastIndex = nil;
//    [self localSearch:searchText];
//}
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    //    [self.delegate reloadTypicalDetailView];
//}

#pragma mark - Apply Search by Text
- (BOOL)checkActiveSearchBar
{
    return YES;
}
- (void)localSearch:(NSString *)searchText
{
    [self.delegate setCanShowDetail:YES];
    searchText = [searchText noSpaceString];
    [self.delegate reloadTypicalDetailView];
    _lastIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    if (![searchText checkSpace] && searchText != nil) {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ or searchName CONTAINS[cd] %@", searchText, searchText];
        _listFilterDoc = [NSMutableArray arrayWithArray:[_listDoc filteredArrayUsingPredicate:p]];
        if (_listFilterDoc.count < 1) {
            _lastIndex = nil;
            [self.delegate setCanShowDetail:NO];
        }
    }
    else
    {
        _listFilterDoc = [[NSMutableArray alloc] initWithArray:_listDoc];
    }
    [_tb_ListDocument performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [self selectCurrentIndexItem];
    
    
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
    if ([Common checkNetworkAvaiable]) {
        [self.delegate showLoading];
        [self.delegate reloadTypicalDetailView];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [self startSearchingDocByTitle:query docType:[self.delegate docType] startRecord:0 completionHandler:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            [self.delegate dismissLoading];
            if ([_lastRequest isEqualToString:query]) {
                [_listDoc removeAllObjects];
                if (success) {
                    NSArray *dictModels = resultDict[@"data"];
                    NSMutableArray *arrDocs = @[].mutableCopy;
                    if ([self.delegate docType] == DocType_Express) {
                        arrDocs = [DocModel arrayOfModelsFromDictionaries:dictModels error:nil];
                        
                    }else{
                        arrDocs = [TextModel arrayOfModelsFromDictionaries:dictModels error:nil];
                    }
                    if (arrDocs.count > 0) {
                        if (!_lastIndex || arrDocs.count < _lastIndex.row) {
                            _lastIndex = [NSIndexPath indexPathForRow:0 inSection:0];
                        }
                        
                    }
                    if (arrDocs.count < PAGE_SIZE_NUMBER) {
                        _isLoadedAllDoc = YES;
                    }
                    [self appendDocs:arrDocs];
                    _listFilterDoc = [[NSMutableArray alloc] initWithArray:_listDoc];
                    [self localSearch:query];
                    //                    [_tb_ListDocument reloadData];
                    //                    [self refreshData];
                }else{
                    //Parse Error from API
                    [self.delegate showError:resultDict withException:exception];
                }
                
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
    }
    else
    {
        [self.delegate showError:nil withException:[NSException initWithNoNetWork]];
    }
}

- (void)reloadDataWhenFilter
{
    self.isSearch = false;
    _searchBar.text = @"";
    _lastIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    //Call API Refresh data here
    [self refreshData];
}
@end
