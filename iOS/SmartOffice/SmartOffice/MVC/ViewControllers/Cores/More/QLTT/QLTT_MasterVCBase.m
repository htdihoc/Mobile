//
//  QLTT_MasterVCBase.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "QLTT_MasterVCBase.h"
#import "QLTT_MasterViewCell.h"
#import "WYPopoverController.h"
#import "ContentFilterVC.h"
#import "QLTT_TreeVCMode.h"
#import "QLTT_MasterController.h"
#import "QLTTMasterDocumentModel.h"
#import "QLTT_DetailInfoNormalController.h"
#import "AlertFlatView.h"
#import "QLTTFileAttachmentModel.h"
#import "NSException+Custom.h"
#import "QLTT_SearchVC.h"
#import "SVPullToRefresh.h"
#import "Common.h"
#import "NSString+Util.h"
#import "SOErrorView.h"
//DocDetailType
typedef enum : NSUInteger {
    QLTT_Master_All = 0, //Tất cả
    QLTT_Master_New,	//Mới nhất
    QLTT_Master_Read,// Xem nhiều nhất
} QLTT_MasterType;
@interface QLTT_MasterVCBase ()<UITableViewDelegate, UITableViewDataSource, QLTT_MasterViewDelegate, ContentFilterVCDelegate, WYPopoverControllerDelegate, PassingMasterDocumentModel, SOErrorViewDelegate, QLTT_MasterViewCellDelegate>
{
    
}
@end

@implementation QLTT_MasterVCBase
{
    WYPopoverController* popoverController;
    QLTTMasterDocumentModel *_modelDetail;
    QLTT_DetailInfoNormalController *_qltt_detailInfoController;
    QLTT_MasterController *_masterController;
    NSMutableArray *_listDoc;
    NSMutableArray *_listFilteredDoc;
    NSMutableDictionary *_params;
    NSNumber *_lastFilter;
    BOOL isInitVC;
    ContentFilterVC *_filterVC;
    NSString *_lastQuery;
    SOErrorView *_errorView;
    __weak QLTT_MasterVCBase *_weakSelf;
    NSInteger _page;
    NSInteger _recordPerPage;
    BOOL _isLoadAll;
    NSString *_lastCategory;
    
    BOOL _isLoadedData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //default param.
    self.view.backgroundColor = AppColor_MainAppBackgroundColor;
    [self initValues];
    [self configUI];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)loadData
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [self.qltt_MasterView.masterTableView addGestureRecognizer:tap];
    
    [self loadData:_params delayedBatching:NO isRefresh:NO isSelectFirst:YES isLoadMore:NO];
    
}
- (void)addErrorView:(NSString *)content
{
    if (!_errorView) {
        _errorView = [[SOErrorView alloc] initWithFrame:self.qltt_MasterView.view.bounds inforError:nil];
        [_errorView setBackgroundColor:[UIColor clearColor]];
        _errorView.delegate = self;
        [self.qltt_MasterView.view addSubview:_errorView];
    }
    else
    {
        [self hiddenErrorView:NO];
    }
    [_errorView setErrorInfo:content];
    
}
- (void)hiddenErrorView:(BOOL)hidden
{
    [_errorView setHidden:hidden];
}
- (void)setParams:(NSDictionary *)params
{
    _params = [[NSMutableDictionary alloc] initWithDictionary:params];
}
- (void)didTapOnTableView:(UIGestureRecognizer*) recognizer
{
    CGPoint tapLocation = [recognizer locationInView:self.qltt_MasterView.masterTableView.tb_QLTTList];
    NSIndexPath *indexPath = [self.qltt_MasterView.masterTableView.tb_QLTTList indexPathForRowAtPoint:tapLocation];
    
    if (indexPath) { //we are in a tableview cell, let the gesture be handled by the view
        recognizer.cancelsTouchesInView = NO;
    }
    [self endEditCurrentView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self dismissHub];
    if (isInitVC == YES) {
        return;
    }
    isInitVC = YES;
    if (_isTreeVC)
    {
        //        self.qltt_MasterView.cst_FilterWidth.constant = 0;
        //        self.qltt_MasterView.btn_Filter.hidden = YES;
        [self reloadAPIData:NO];
    }
    else
    {
        [self loadData];
    }
}

- (void)initValues
{
    _qltt_InfoDetailController = [[QLTT_InfoDetailController alloc] init];
    _qltt_detailInfoController = [[QLTT_DetailInfoNormalController alloc] init];
    self.qltt_MasterView = [[QLTT_MasterView alloc] initWithFrame:self.view.frame];
    _modelDetail = [[QLTTMasterDocumentModel alloc] init];
    _lastFilter = [NSNumber numberWithInteger:0];
    _listDoc = [[NSMutableArray alloc] init];
    _listFilteredDoc = [[NSMutableArray alloc] init];
    _masterController = [[QLTT_MasterController alloc] init];
    [self setDefaultValues];
    if (_params == nil) {
        [self setvaluesForFilter];
    }
    
    
}
- (void)setvaluesForFilter
{
    _params = [[NSMutableDictionary alloc] initWithDictionary:@{@"type" : _lastFilter, @"page" : [NSNumber numberWithInteger:_page], @"recordPerPage" : [NSNumber numberWithInteger:_recordPerPage]}];
}
- (void)setDetailModel:(NSInteger)index
{
    if (_isSearch == NO) {
        if (index > _listFilteredDoc.count || _listFilteredDoc.count == 0) {
            _modelDetail = nil;
        }
        else
        {
            _modelDetail = _listFilteredDoc[index];
        }
        
    }
    else
    {
        if (index > _listDoc.count || _listDoc.count == 0) {
            _modelDetail = nil;
        }
        else
        {
            _modelDetail = _listDoc[index];
        }
        
    }
}
- (void)setDefaultValues
{
    [self resetLoadMore];
    NSString *currentCategory = [_params valueForKey:@"documentCategoryId"];
    _lastQuery = @"";
    _page = 0;
    _recordPerPage = 20;
    
    _params = [[NSMutableDictionary alloc] initWithDictionary:@{@"type" : _lastFilter, @"page" : [NSNumber numberWithInteger:0], @"recordPerPage" : [NSNumber numberWithInteger:_recordPerPage],  @"name": _lastQuery}];
    [_params setValue:currentCategory forKey:@"documentCategoryId"];
}
- (void)loadDetailInfo
{
    
}
- (void)loadMore
{
    _page = _page + 1;
    [_params setValue:@"" forKey:@"documentCategoryId"];
    [_params setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
    [self loadData:_params delayedBatching:NO isRefresh:YES isSelectFirst:NO isLoadMore:YES];
}
- (void)setIsSearching:(BOOL)isSearch
{
    _isSearch = isSearch;
}
- (void)clearData
{
    if (_isSearch == NO) {
        if (_listFilteredDoc.count == 1) {
            _listFilteredDoc = [NSMutableArray new];
        }
        else
        {
            [_listFilteredDoc removeAllObjects];
        }
        
    }
    else
    {
        if (_listDoc.count == 1) {
            _listDoc = [NSMutableArray new];
        }
        else
        {
            [_listDoc removeAllObjects];
        }
    }
}

- (void)reloadAPIData:(BOOL)isRefresh
{
    //    [self clearData];
    [self.qltt_MasterView reloadTableView];
    QLTTMasterDocumentModel *model = (QLTTMasterDocumentModel *)[self.delegate getMasterTreeDocumentModel].firstObject;
    [self getDocumentWithCategoryID:model.documentCategoryId isRefresh:isRefresh];
    
}

- (void)getDocumentWithCategoryID:(NSString *)categoryID isRefresh:(BOOL)isRefresh
{
    _lastCategory = categoryID;
    [self loadDataWithCategoryID:categoryID isRefresh:isRefresh page:_page isLoadMore:NO completion:^(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error, BOOL isSubView) {
        [self hiddenPullRefreshView:YES];
        if (![_lastCategory isEqualToString:categoryID]) {
            return;
        }
        [self removeContentLabel];
        if (self.isTreeVC && !isRefresh) {
            [self dismissHub];
        }
        if (success) {
            _listDoc = [QLTTMasterDocumentModel arrayOfModelsFromDictionaries:resultArray error:nil];
            //            _listDoc = [NSMutableArray arrayWithArray:[self filterWithType:[[_params valueForKey:@"type"] integerValue]]];
            if (_listDoc.count < _recordPerPage) {
                _isLoadAll = YES;
            }
            if (_listDoc.count > 0) {
                _listFilteredDoc = [NSMutableArray arrayWithArray:_listDoc];
                
                [self.qltt_MasterView reloadTableView];
                [self.qltt_MasterView scrollToTop];
            }
            else
            {
                _listFilteredDoc = [NSMutableArray new];
                [self.qltt_MasterView reloadTableView];
                [self addContentLabel:LocalizedString(@"Không tìm thấy kết quả")];
            }
        }
        else
        {
            if (exception) {
                [self showError:NO error:nil exception:exception];
                return;
            }
            if (error) {
                [self showError:NO error:[error valueForKey:@"resultCode"] exception:nil];
            }
            
        }
        
    }];
}
- (void)didSelectFirstItem
{
    
}
- (void)selectCurrentItem
{
    
}
- (void)pushVC:(UIViewController *)vc
{
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)filterFromServer:(NSString *)searchText
{
    NSString *trimmedString = [searchText noSpaceString];
    if (!_lastFilter ||
        !searchText) {
        return;
    }
    //    NSDictionary *params = @{@"type":_lastFilter,
    //                             @"name": trimmedString};
    
    _params = [[NSMutableDictionary alloc] initWithDictionary:@{@"type" : _lastFilter, @"page" : [NSNumber numberWithInteger:0], @"recordPerPage" : [NSNumber numberWithInteger:_recordPerPage],  @"name": trimmedString}];
    //    ,
    //    @"description": trimmedString,
    //    @"authorName": trimmedString
    if (!_isTreeVC) {
        [self loadData:_params delayedBatching:YES isRefresh:NO isSelectFirst:YES isLoadMore:NO];
    }
    else
    {
        [self reloadAPIData:NO];
    }
    
}

- (NSArray *)sortArrayWithFirstFilter:(NSArray *)data
{
    NSArray *sortedArray;
    sortedArray = [data sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *date1 = [(QLTTMasterDocumentModel*)a createdDate];
        NSString *date2 = [(QLTTMasterDocumentModel*)b createdDate];
        NSString *first = date1 == nil ? [(QLTTMasterDocumentModel*)a effectiveDate] : date1;
        NSString *second = date2 == nil ? [(QLTTMasterDocumentModel*)b effectiveDate] : date2;
        return [second compare:first];
    }];
    return sortedArray;
}
- (NSArray *)sortArrayWithSecondFilter:(NSArray *)data
{
    NSArray *sortedArray;
    sortedArray = [data sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSNumber *first = [(QLTTMasterDocumentModel*)a numRead] == nil ? [NSNumber numberWithInt:0] : [(QLTTMasterDocumentModel*)a numRead];
        NSNumber *second = [(QLTTMasterDocumentModel*)b numRead] == nil ? [NSNumber numberWithInt:0] : [(QLTTMasterDocumentModel*)b numRead];
        return [second compare:first];
    }];
    return sortedArray;
}
- (NSArray *)filterWithType:(QLTT_MasterType)type
{
    [self setDefaultValues];
    [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
    _isSearch = YES;
    NSArray *arrayToSort;
    switch (type) {
        case QLTT_Master_New:
            arrayToSort = [NSMutableArray arrayWithArray:[self sortArrayWithFirstFilter:_listDoc]];
            break;
        case QLTT_Master_Read:
            arrayToSort = [NSMutableArray arrayWithArray:[self sortArrayWithSecondFilter:_listDoc]];
        default:
            break;
    }
    [self dismissHub];
    return arrayToSort;
}
- (void)filterLocal:(NSString *)searchText
{
    [self removeContentLabel];
    NSString *trimmedString = [searchText noSpaceString];
    [self filterLocal:trimmedString reloadData:YES];
}
- (void)filterLocal:(NSString *)searchText reloadData:(BOOL)reloadData
{
    _isSearch = NO;
    
    if ([searchText checkSpace] || searchText == nil) {
        _listFilteredDoc = [NSMutableArray arrayWithArray:_listDoc];
    }
    else
    {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ or authorName CONTAINS[cd] %@ or createdUser CONTAINS[cd] %@", searchText, searchText, searchText];
        _listFilteredDoc = [NSMutableArray arrayWithArray:[_listDoc filteredArrayUsingPredicate:p]];
    }
    [_params setValue:searchText forKey:@"name"];
    if (_listFilteredDoc.count == 0) {
        _lastIndex = nil;
        [self addContentLabel:LocalizedString(@"Không tìm thấy kết quả")];
    }
    if (reloadData) {
        [self.qltt_MasterView reloadTableView];
    }
    
    
}
#pragma working with data
- (void)loadDataWithCategoryID:(NSString *)categoryID isRefresh:(BOOL)isRefresh page:(NSInteger)page isLoadMore:(BOOL)isLoadMore completion:(CallbackQLTT_DetailInfoNormal)completion
{
    if (!isRefresh && !isLoadMore) {
        if (self.isTreeVC) {
            [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
        }
        else if ([self.delegate respondsToSelector:@selector(showLoading)]) {
            [self.delegate showLoading];
        }
        else
        {
            [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
        }
        //        else
        //        {
        //           [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
        //        }
        
    }
    [_params setValue:categoryID forKey:@"documentCategoryId"];
    [_params setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    NSMutableDictionary *subParams = [[NSMutableDictionary alloc] initWithDictionary:[_params copy]];
    
    if (!_isTreeVC) {
        [subParams setValue:@"" forKey:@"name"];
    }
    //    NSDictionary *params = @{@"type" : @0, @"documentCategoryId":categoryID == nil ? @"" : categoryID, @"page" : [NSNumber numberWithInteger:page], @"recordPerPage" : [NSNumber numberWithInteger:_recordPerPage]};
    [_masterController loadData:subParams delayedBatching:NO completion:^(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error) {
        if (!isRefresh) {
            if ([self.delegate respondsToSelector:@selector(showLoading)]) {
                [self.delegate dismissLoading];
            }
            else
            {
                [self dismissHub];
            }
        }
        else
        {
            [self dismissRefreshActivity];
        }
        completion(success, resultArray, exception, error, NO);
    }];
}

- (void)loadDetailDocumentWith:(NSNumber *)documentID isRefresh:(BOOL)isRefresh
{
    if (!documentID) {
        documentID = _modelDetail.documentId;
    }
    [_qltt_detailInfoController getMasterDocDetail:documentID completion:^(BOOL success, QLTTMasterDocumentModel *model, NSException *exception, NSDictionary *error) {
        [self.delegate didCheckLike];
        if (model) {
            BOOL _isLike = _modelDetail.isLike;
            _modelDetail = model;
            _modelDetail.isLike = _isLike;
        }
        else
        {
            _modelDetail = [[QLTTMasterDocumentModel alloc] init];
        }
        NSString *refresh = isRefresh == YES ? @"true" : @"false";
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"updateQLTTMasterDocumentModel"
         object:[NSString stringWithFormat:@"loadSameCategory|%@",refresh]];
        [self showError:success error:error exception:exception];
        
    }];
}

- (void)loadDetailDocument
{
    [self loadDetailDocumentWith:[self getDocumentId] isRefresh:NO];
}
- (void)checkLike
{
    [_qltt_detailInfoController checkLikeDocument:[self getMasterDocumentModel].documentId employeeID:[GlobalObj getInstance].qltt_employID completion:^(BOOL success, NSNumber *resultCode, NSException *exception, BOOL isLike, NSDictionary *error) {
        [self.delegate didCheckLike];
        [self getMasterDocumentDetailModel].isLike = isLike;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"updateQLTTMasterDocumentModel"
         object:@"isMasterVC"];
        [self showError:success error:error exception:exception];
    }];
}
- (void)showError:(BOOL)success error:(NSDictionary *)error exception:(NSException *)exception
{
    [self showError:success error:error exception:exception inView:self.view];
}
- (void)showError:(BOOL)success error:(NSDictionary *)error exception:(NSException *)exception inView:(UIView *)view
{
    if (exception) {
        if ([self.delegate respondsToSelector:@selector(showError:isInstant:ismasterQLTT:)]) {
            [self.delegate showError:exception isInstant:NO ismasterQLTT:YES];
            //Tuongnh rem code
        }
        else
        {
            [self handleErrorFromResult:nil withException:exception inView:view];
        }
        
        return;
    }
    if (!success) {
        if ([self.delegate respondsToSelector:@selector(showErrorWith:isInstant:ismasterQLTT:)]) {
            NSString *errorString = [[error valueForKey:@"data"] valueForKey:@"result"];
            if (errorString) {
                if ([self.delegate respondsToSelector:@selector(showError:isInstant:ismasterQLTT:)]) {
                    [self.delegate showError:[NSException initWithString:errorString] isInstant:NO ismasterQLTT:YES];
                    //Tuongnh rem code
                }
                else
                {
                    [self showError:success error:nil exception:[NSException initWithString:errorString]];
                }
                
            }
            else
            {
                [self.delegate showErrorWith:[error valueForKey:@"resultCode"] isInstant:NO ismasterQLTT:YES];
            }
            
        }
        else
        {
            id errorDic = [error valueForKey:@"data"];
            NSString *errorString;
            if ([errorDic isKindOfClass:[NSDictionary class]]) {
                errorString = [errorDic valueForKey:@"result"];
            }
            else if ([errorDic isKindOfClass:[NSString class]])
            {
                errorString = errorDic ;
            }
            if (errorString) {
                [self showError:success error:nil exception:[NSException initWithString:errorString]];
            }
            else
            {
                [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:view];
            }
        }
    }
}
- (void)getQLTTMasterDocumentModelFromTreeModel:(NSArray *)models
{
    for (QLTTMasterDocumentModel *model in models) {
        if (model.children.count == 0) {
            [_listDoc addObject:model];
        }
        else
        {
            [self getQLTTMasterDocumentModelFromTreeModel:model.children];
        }
    }
}
- (void)loadData:(NSDictionary *)params delayedBatching:(BOOL)delayedBatching isRefresh:(BOOL)isRefresh isSelectFirst:(BOOL)isSelectFirst isLoadMore:(BOOL)isLoadMore{
    //Check Network here
    [self removeContentLabel];
    _isSearch = YES;
    if (!isRefresh) {
        if ([self.delegate respondsToSelector:@selector(showLoading)]) {
            [self.delegate showLoading];
        }
        else
        {
            [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
        }
        
    }
    
    [_masterController loadData:params delayedBatching:delayedBatching completion:^(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error) {
        [self hiddenPullRefreshView:YES];
        [self hiddenInfiniteScrollView:YES];
        if (!isRefresh) {
            if ([self.delegate respondsToSelector:@selector(showLoading)]) {
                [self.delegate dismissLoading];
            }
            else
            {
                [self dismissHub];
            }
        }
        else
        {
            [self dismissRefreshActivity];
        }
        if (exception) {
            
            if (_listDoc.count > 0) {
                
                [self showError:NO error:nil exception:exception];
            }
            else
            {
                NSString *errorContent = @"";
                if ([exception.reason isEqualToString:LocalizedString(@"Mất kết nối mạng")]) {
                    errorContent = LocalizedString(@"Mất kết nối mạng");
                }
                else
                {
                    errorContent = LocalizedString(@"Mất kết nối tới hệ thống");
                }
                if ([self.delegate respondsToSelector:@selector(addErrorView:)]) {
                    [self.delegate addErrorView:errorContent];
                    
                }
                else
                {
                    [self addErrorView:errorContent];
                    
                }
            }
            return;
        }
        if (success) {
            [self.qltt_MasterView reloadTableView];
            if (!isLoadMore) {
                [self clearData];
            }
            [self hiddenErrorView:YES];
            NSArray *listDocs = [QLTTMasterDocumentModel arrayOfModelsFromDictionaries:resultArray error:nil];
            if (listDocs.count < _recordPerPage) {
                _isLoadAll = YES;
                _weakSelf.qltt_MasterView.masterTableView.tb_QLTTList.showsInfiniteScrolling = NO;
            }
            else
            {
                _weakSelf.qltt_MasterView.masterTableView.tb_QLTTList.showsInfiniteScrolling = YES;
            }
            [self appendData:listDocs];
            if (!_isSearchVC) {
                [self.qltt_MasterView reloadTableView];
            }
            if (listDocs.count > 0) {
                _isLoadedData = YES;
                if ([self.delegate respondsToSelector:@selector(loadCompleteAPI)]) {
                    [self.delegate loadCompleteAPI];
                }
                if ([_lastFilter integerValue] == QLTT_Master_New || [_lastFilter integerValue] == QLTT_Master_Read)
                {
                    NSString *searchKey = [params valueForKey:@"name"];
                    searchKey = searchKey == nil ? _lastQuery : searchKey;
                    [self filterLocal:searchKey == nil ? @"":searchKey];
                }
                
                if (!_isTreeVC) {
                    if (_isSearch == NO) {
                        if (_listFilteredDoc.count > 0 && isSelectFirst) {
                            [self didSelectFirstItem];
                        }
                    }
                    else
                    {
                        if(isSelectFirst)
                        {
                            [self didSelectFirstItem];
                        }
                    }
                    
                }
            }
            else
            {
                //Tea check no data
                if (_listDoc.count == 0) {
                    if ([self.delegate respondsToSelector:@selector(addErrorView:)] && !_isLoadedData) {
                        [self.delegate addErrorView:LocalizedString(@"Không có dữ liệu")];
                    }
                    else
                    {
                        
                        [self addErrorView:LocalizedString(@"Không có dữ liệu")];
                        
                        
                    }
                }
            }
        }
        else
        {
            if (_listDoc > 0) {
                [self showError:success error:error exception:exception];
            }
            else
            {
                if ([self.delegate respondsToSelector:@selector(addErrorView:)]) {
                    [self.delegate addErrorView:LocalizedString(@"Mất kết nối tới hệ thống")];
                }
                else
                {
                    [self addErrorView:LocalizedString(@"Mất kết nối tới hệ thống")];
                }
            }
            
        }
    }];
}
- (void)appendData:(NSArray *)arrData{
    [self removeContentLabel];
    [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_listDoc addObject:obj];
    }];
    if (_listDoc.count == 0) {
        [self addContentLabel:LocalizedString(@"Không tìm thấy kết quả") forView:self.view];
    }
    
}
#pragma mark create UI
- (void)configUI
{
    if (_isTreeVC) {
        [self.qltt_MasterView hiddenFilter];
    }
    self.qltt_MasterView.masterTableView.tb_QLTTList.delegate = self;
    self.qltt_MasterView.masterTableView.tb_QLTTList.dataSource = self;
    self.qltt_MasterView.delegate = self;
    [self.qltt_MasterView.masterTableView.tb_QLTTList registerNib:[UINib nibWithNibName:@"QLTT_MasterViewCell" bundle:nil] forCellReuseIdentifier:@"QLTT_MasterViewCell"];
    
    _weakSelf = self;
    self.qltt_MasterView.masterTableView.tb_QLTTList.showsInfiniteScrolling = NO;
    [self.qltt_MasterView.masterTableView.tb_QLTTList addInfiniteScrollingWithActionHandler: ^{
        DLog(@"+++ scroll to load");
        if ([Common checkNetworkAvaiable]) {
            if (!_isLoadAll && [_lastFilter integerValue] != QLTT_Master_New && [_lastFilter integerValue] != QLTT_Master_Read) {
                [self hiddenInfiniteScrollView:NO];
                [self loadMore];
            }
            else
            {
                [self hiddenInfiniteScrollView:YES];
            }
        }
        else
        {
            [self showError:YES error:nil exception:[NSException initWithNoNetWork]];
        }
    }];
    
    self.qltt_MasterView.masterTableView.tb_QLTTList.showsPullToRefresh = NO;
    [self.qltt_MasterView.masterTableView.tb_QLTTList addPullToRefreshWithActionHandler:^{
        DLog(@"Refresh data here");
        if ([Common checkNetworkAvaiable]) {
            [self resetLoadMore];
            [self hiddenPullRefreshView:NO];
            _page = 0;
            [_params setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
            if (_isTreeVC) {
                [self reloadAPIData:YES];
            }
            else
            {
                [_params setValue:@"" forKey:@"documentCategoryId"];
                [self loadData:_params delayedBatching:NO isRefresh:YES isSelectFirst:YES isLoadMore:NO];
            }
            
        }else
        {
            [self dismissRefreshActivity];
            [self showError:NO error:nil exception:[NSException initWithNoNetWork]];
        }
        //Refresh data here
        // prepend data to dataSource, insert cells at top of table view
        // call [tableView.pullToRefreshView stopAnimating] when done
    } position:SVPullToRefreshPositionTop];
}
- (void)resetLoadMore
{
    _isLoadAll = NO;
    _weakSelf.qltt_MasterView.masterTableView.tb_QLTTList.showsInfiniteScrolling = YES;
    [self hiddenInfiniteScrollView:YES];
}
- (void)hiddenInfiniteScrollView:(BOOL)hidden{
    if (hidden) {
        [_weakSelf.qltt_MasterView.masterTableView.tb_QLTTList.infiniteScrollingView setHiddenActivitiView:YES];
        [_weakSelf.qltt_MasterView.masterTableView.tb_QLTTList.infiniteScrollingView stopAnimating];
    }else{
        [_weakSelf.qltt_MasterView.masterTableView.tb_QLTTList.infiniteScrollingView setHiddenActivitiView:NO];
        [_weakSelf.qltt_MasterView.masterTableView.tb_QLTTList.infiniteScrollingView startAnimating];
    }
}
- (void)hiddenPullRefreshView:(BOOL)hidden{
    if (hidden) {
        [_weakSelf.qltt_MasterView.masterTableView.tb_QLTTList.pullToRefreshView stopAnimating];
        [_weakSelf.qltt_MasterView.masterTableView.tb_QLTTList.pullToRefreshView hiddenPullToRefresh:YES];
        
    }else{
        [_weakSelf.qltt_MasterView.masterTableView.tb_QLTTList.pullToRefreshView startAnimating];
        [_weakSelf.qltt_MasterView.masterTableView.tb_QLTTList.pullToRefreshView hiddenPullToRefresh:NO];
    }
}
- (void)dismissRefreshActivity
{
    [_weakSelf.qltt_MasterView.masterTableView.tb_QLTTList.pullToRefreshView stopAnimating];
}
- (void)addRightBarButton
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 200, 44);
    [rightButton setImage:[UIImage imageNamed:@"treeMode"] forState:UIControlStateNormal];
    [self.navView addRightBarButton:rightButton isButtonTile:NO];
}


#pragma mark action
- (void)showFilter:(UIButton *)sender
{
    if (popoverController.popoverVisible) {
        [popoverController dismissPopoverAnimated:YES];
        return;
    }
    NSArray *contentFilter = @[LocalizedString(@"QLTT_MasterVC_Tất_cả"), LocalizedString(@"QLTT_MasterVC_Mới_nhất"), LocalizedString(@"QLTT_MasterVC_Xem_nhiều_nhất")];
    if (_filterVC == nil) {
        _filterVC = [[ContentFilterVC alloc] initWithFilterSelected:0 content:contentFilter];
        _filterVC.delegate = self;
    }
    else
    {
        _filterVC.filterType = [_lastFilter integerValue]-1;
    }
    popoverController = [[WYPopoverController alloc] initWithContentViewController:_filterVC];
    popoverController.delegate = self;
    [popoverController setPopoverContentSize:_filterVC.view.frame.size];
    [popoverController presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _isSearch == NO ? (_listFilteredDoc.count) : (_listDoc.count);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID_CELL = @"QLTT_MasterViewCell";
    QLTT_MasterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    cell.delegate = self;
    QLTTMasterDocumentModel *masterDocModel;
    if (_lastIndex != nil && [_lastIndex compare:indexPath] == NSOrderedSame) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    if (_isSearch == NO) {
        //fix crash reload data when scrolling masterTreeVC.
        if (indexPath.row >= _listFilteredDoc.count) {
            return cell;
        }
        masterDocModel =  _listFilteredDoc[indexPath.row];
    }
    else
    {
        if (indexPath.row >= _listDoc.count) {
            return cell;
        }
        masterDocModel = _listDoc[indexPath.row];
    }
    [cell enterDataToCell:masterDocModel];
    return cell;
    
    
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 138;//148.5;
}
#pragma mark QLTT_MasterViewDelegate
- (void)didSelectFilter_QLTT_MasterView:(UIButton *)sender
{
    [self endEditCurrentView];
    [self showFilter:sender];
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
    self.qltt_MasterView.searchBar.text = @"";
    //Reload data here
    [self clearContent];
    [self resetLoadMore];
    [popoverController dismissPopoverAnimated:YES];
    _lastFilter = [NSNumber numberWithLong:filterType];
    if ([_lastFilter integerValue] == QLTT_Master_New || [_lastFilter integerValue] == QLTT_Master_Read)
    {
        _weakSelf.qltt_MasterView.masterTableView.tb_QLTTList.showsInfiniteScrolling = NO;
    }
    else
    {
        [self resetLoadMore];
    }
    [self setvaluesForFilter];
    if ([Common checkNetworkAvaiable]) {
        if(_isTreeVC)
        {
            _listDoc = [NSMutableArray arrayWithArray:[self filterWithType:filterType]];
            [self filterLocal:_lastQuery];
            [self checkSelect];
        }
        else
        {
            [self loadData:_params delayedBatching:NO isRefresh:NO isSelectFirst:YES isLoadMore:NO];
        }
    }
    else
    {
        //        [_listDoc removeAllObjects];
        //        [_listFilteredDoc removeAllObjects];
        [self.qltt_MasterView reloadTableView];
        [self showError:NO error:nil exception:[NSException initWithNoNetWork]];
    }
    
    
}

#pragma mark QLTT_MasterViewDelegate
- (void)searchBarBeginEdit
{
    self.lastIndex = nil;
    //    QLTT_SearchVC *searchVC = NEW_VC_FROM_NIB(QLTT_SearchVC, @"QLTT_SearchVC");
    //    [searchVC setParams:_params];
    //    [self.navigationController pushViewController:searchVC animated:YES];
}
- (void)searchBarSearchButtonClicked:(NSString *)searchText
{
    [self setDefaultValues];
    [self resetLoadMore];
    [self endEditCurrentView];
    if ([Common checkNetworkAvaiable]) {
        //        if ((self.isTreeVC || _isTreeVC) && [self.qltt_MasterView isActiveSearchBar]) {
        //            [self filterLocal:searchText];
        //            if (_listFilteredDoc.count > 0) {
        //                _lastIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        //            }
        //        }
        //        else
        //        {
        [self filterFromServer:searchText];
        //        }
    }
    else
    {
        //        [_listFilteredDoc removeAllObjects];
        [self.qltt_MasterView reloadTableView];
        [self showError:NO error:nil exception:[NSException initWithNoNetWork]];
    }
    
}

- (void)searchBarTextDidChange:(NSString *)searchText
{
    _lastQuery = searchText;
    [self filterLocal:searchText];
    //    [self checkSelect];
}
- (void)searchBarCancelButtonClicked
{
    _lastQuery = @"";
    [self filterLocal:@""];
    //    [self checkSelect];
}
- (void)checkSelect
{
    if (!_isTreeVC) {
        if (_listFilteredDoc.count > 0) {
            _lastIndex = [NSIndexPath indexPathForRow:0 inSection:0];
            [self selectCurrentItem];
        }
    }
    
}
#pragma mark - PassingMasterDocumentModel
- (void)setMasterDocumentDetailModel:(QLTTMasterDocumentModel *)model
{
    if (!model) {
        model = [[QLTTMasterDocumentModel alloc] init];
    }
    _modelDetail = model;
    [_listDoc removeObjectAtIndex:_lastIndex.row ];
    [_listDoc insertObject:_modelDetail atIndex:_lastIndex.row ];
}
- (QLTT_InfoDetailController *)getQLTT_InfoDetailController
{
    return _qltt_InfoDetailController;
}
- (void)getDocumentWithSameCategory:(NSInteger)page isLoadMore:(BOOL)isLoadMore isRefresh:(BOOL)isRefresh completion:(CallbackQLTT_DetailInfoNormal)completion
{
    [self loadDataWithCategoryID:[self getMasterDocumentDetailModel].documentCategoryId isRefresh:isRefresh page:page isLoadMore:isLoadMore completion:completion];
}
- (QLTTMasterDocumentModel *)getMasterDocumentDetailModel
{
    if (!_modelDetail.documentId) {
        [self setDetailModel:self.lastIndex.row];
    }
    return _modelDetail;
}
- (QLTTMasterDocumentModel *)getMasterDocumentModel
{
    if (_isSearch) {
        if (_listDoc.count > 0) {
            return (QLTTMasterDocumentModel *)_listDoc[_lastIndex.row];
        }
    }
    else
    {
        if (_listFilteredDoc.count > 0) {
            return (QLTTMasterDocumentModel *)_listFilteredDoc[_lastIndex.row];
        }
    }
    
    return nil;
    
}

- (QLTTFileAttachmentModel *)getAttachmentModel:(NSInteger)index
{
    if (_isSearch) {
        if (_listDoc.count > 0) {
            return ((QLTTMasterDocumentModel *)_listDoc[_lastIndex.row]).fileAttachment[index];
        }
    }
    else
    {
        if (_listFilteredDoc.count > 0) {
            return ((QLTTMasterDocumentModel *)_listFilteredDoc[_lastIndex.row]).fileAttachment[index];
        }
    }
    
    return nil;
}

- (NSInteger)numberOfFileAttachment
{
    if (_isSearch) {
        if (_listDoc.count > 0) {
            return ((QLTTMasterDocumentModel *)_listDoc[_lastIndex.row]).fileAttachment.count;
        }
    }
    else
    {
        if (_listFilteredDoc.count > 0) {
            return ((QLTTMasterDocumentModel *)_listFilteredDoc[_lastIndex.row]).fileAttachment.count;
        }
    }
    
    return 0;
}

- (NSNumber *)getDocumentId
{
    if (_isSearch) {
        if (_listDoc.count > 0) {
            return ((QLTTMasterDocumentModel *)_listDoc[_lastIndex.row]).documentId;
        }
    }
    else
    {
        if (_listFilteredDoc.count > 0) {
            return ((QLTTMasterDocumentModel *)_listFilteredDoc[_lastIndex.row]).documentId;
        }
    }
    
    return [NSNumber numberWithDouble:-1];
}

#pragma  mark SOErrorViewDelegate
- (void)didRefreshOnErrorView:(SOErrorView *)errorView
{
    [self loadData];
}

#pragma mark QLTT_MasterViewCellDelegate
- (BOOL)isVisible:(QLTT_MasterViewCell *)cell
{
    if ([self.qltt_MasterView.masterTableView.tb_QLTTList.visibleCells containsObject:cell])
    {
        if (_listDoc.count == 0) {
            return NO;
        }
        //        [self.qltt_MasterView.masterTableView.tb_QLTTList reloadRowsAtIndexPaths:@[[self.qltt_MasterView.masterTableView.tb_QLTTList indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationNone];
        return YES;
    }
    return NO;
}
@end
