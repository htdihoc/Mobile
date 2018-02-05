//
//  QLTT_DetailInfoNormal.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "QLTT_DetailInfoNormalVC.h"
#import "QLTT_DetailInfoNormalController.h"
#import "AlertFlatView.h"
#import "NSException+Custom.h"
#import "QLTTMasterDocumentModel.h"
#import "SVPullToRefresh.h"
#import "UIView+GetUIViewController.h"
#import "QLTT_DetailVC.h"
#import "QLTT_DetailSubVC_iPad.h"
#import "Common.h"
#import "QLTT_MasterViewCell.h"
#import "QLTT_DetailViewContentCell.h"
@interface QLTT_DetailInfoNormalVC () <UITableViewDelegate, UITableViewDataSource, QLTT_DetailViewDelegate, PassingMasterDocumentModel, QLTT_MasterViewCellDelegate, QLTT_DetailViewContentCellDelegate>
{
    NSMutableArray<QLTTMasterDocumentModel *> *_listSameCategoryDoc;
    NSIndexPath *_lastIndex;
    NSInteger _page;
    NSInteger _recordPerPage;
    BOOL _lastLike;
    BOOL _isLoadAll;
    __weak QLTT_DetailInfoNormalVC *weakSelf;
}
@property (strong, nonatomic) QLTT_DetailInfoNormalController *qltt_detailInfoController;
@end

@implementation QLTT_DetailInfoNormalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateModel:)
                                                 name:@"updateQLTTMasterDocumentModel"
                                               object:nil];
    [self initValues];
    [self reloadData:NO isFirst:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self dismissHub];
}
- (void)reloadData:(BOOL)isRefresh
{
    [self reloadData:isRefresh isFirst:NO];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"updateQLTTMasterDocumentModel"
                                                  object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dismissVC:(UIGestureRecognizer *)recognizer
{
    CGPoint tapLocation = [recognizer locationInView:self.qltt_DetailView.qltt_MasterTableView.tb_QLTTList];
    NSIndexPath *indexPath = [self.qltt_DetailView.qltt_MasterTableView.tb_QLTTList indexPathForRowAtPoint:tapLocation];
    
    if (indexPath) { //we are in a tableview cell, let the gesture be handled by the view
        recognizer.cancelsTouchesInView = NO;
    }
    if ([self.delegate respondsToSelector:@selector(dismissVC:)])
    {
        [self.delegate dismissVC:recognizer];
    }
}
- (void)setDefaultValues
{
    _page = 0;
    _recordPerPage = 20;
}
- (void)initValues
{
    [self setDefaultValues];
    _listSameCategoryDoc = [[NSMutableArray alloc] init];
    self.qltt_detailInfoController = [[QLTT_DetailInfoNormalController alloc] init];
    self.qltt_DetailView.delegate = self;
    self.qltt_DetailView.qltt_MasterTableView.tb_QLTTList.delegate = self;
    self.qltt_DetailView.qltt_MasterTableView.tb_QLTTList.dataSource = self;
    
    weakSelf = self;
    self.qltt_DetailView.qltt_MasterTableView.tb_QLTTList.showsInfiniteScrolling = NO;
    [self.qltt_DetailView.qltt_MasterTableView.tb_QLTTList addInfiniteScrollingWithActionHandler: ^{
        
        if ([Common checkNetworkAvaiable]) {
            [self hiddenInfiniteScrollView:NO];
            if (!_isLoadAll) {
                _page++;
                [self loadDocumentWithSameCategory:YES isLoadMore:YES];
            }
            else{
                weakSelf.qltt_DetailView.qltt_MasterTableView.tb_QLTTList.showsInfiniteScrolling = NO;
            }
        }
        else
        {
            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
        }
        
    }];
    //
    self.qltt_DetailView.qltt_MasterTableView.tb_QLTTList.showsPullToRefresh = NO;
    [self.qltt_DetailView.qltt_MasterTableView.tb_QLTTList addPullToRefreshWithActionHandler:^{
        DLog(@"Refresh data here");
        if ([Common checkNetworkAvaiable]) {
            [self hiddenPullRefreshView:NO];
            _page = 0;
            [self loadDetailDocumentWith:[self.delegate getMasterDocumentDetailModel].documentId isRefresh:YES];
        }else
        {
            [self dismissRefreshActivity];
            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
        }
    } position:SVPullToRefreshPositionTop];
}
- (void)appendData:(NSArray *)arrData{
    [self removeContentLabel];
    [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[self.delegate getMasterDocumentDetailModel].documentId compare:((QLTTMasterDocumentModel*)obj).documentId] != NSOrderedSame){
            [_listSameCategoryDoc addObject:obj];
        }
        
    }];
    NSLog(@"");
//    if (_listSameCategoryDoc.count == 0) {
//        [self addContentLabel:LocalizedString(@"Không tìm thấy kết quả") forView:self.view];
//    }
    
}
- (void)resetLoadMore
{
    _page = 0;
    _isLoadAll = NO;
    weakSelf.qltt_DetailView.qltt_MasterTableView.tb_QLTTList.showsInfiniteScrolling = YES;
    [weakSelf.qltt_DetailView.qltt_MasterTableView.tb_QLTTList.infiniteScrollingView stopAnimating];
}

- (void)hiddenInfiniteScrollView:(BOOL)hidden{
    if (hidden) {
        [weakSelf.qltt_DetailView.qltt_MasterTableView.tb_QLTTList.infiniteScrollingView setHiddenActivitiView:YES];
        [weakSelf.qltt_DetailView.qltt_MasterTableView.tb_QLTTList.infiniteScrollingView stopAnimating];
    }else{
        [weakSelf.qltt_DetailView.qltt_MasterTableView.tb_QLTTList.infiniteScrollingView setHiddenActivitiView:NO];
        [weakSelf.qltt_DetailView.qltt_MasterTableView.tb_QLTTList.infiniteScrollingView startAnimating];
    }
}
- (void)hiddenPullRefreshView:(BOOL)hidden{
    if (hidden) {
        [weakSelf.qltt_DetailView.qltt_MasterTableView.tb_QLTTList.pullToRefreshView stopAnimating];
        [weakSelf.qltt_DetailView.qltt_MasterTableView.tb_QLTTList.pullToRefreshView hiddenPullToRefresh:YES];
        
    }else{
        [weakSelf.qltt_DetailView.qltt_MasterTableView.tb_QLTTList.pullToRefreshView startAnimating];
        [weakSelf.qltt_DetailView.qltt_MasterTableView.tb_QLTTList.pullToRefreshView hiddenPullToRefresh:NO];
    }
}
- (void)dismissRefreshActivity
{
    [weakSelf.qltt_DetailView.qltt_MasterTableView.tb_QLTTList.pullToRefreshView stopAnimating];
}
- (void)dismissRefreshDetailViewActivity
{
    [weakSelf.qltt_DetailView.sc_Detail.pullToRefreshView stopAnimating];
}
-(void)scrollToTopTableContent
{
    [self.qltt_DetailView scrollTableView:nil animation:NO];
}


- (void) updateModel:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"updateQLTTMasterDocumentModel"])
    {
        if ([notification.object isEqualToString:@"isMasterVC"]) {
            _lastLike = [self.delegate getMasterDocumentDetailModel].isLike;
        }
        else if ([[notification.object componentsSeparatedByString:@"|"].firstObject isEqualToString:@"loadSameCategory"])
        {
            if ([[notification.object componentsSeparatedByString:@"|"].lastObject isEqualToString:@"true"]) {
                [self loadDocumentWithSameCategory:YES isLoadMore:NO];
            }
            else
            {
                [self loadDocumentWithSameCategory:NO isLoadMore:NO];
            }
            
        }
        [self.qltt_DetailView reloadTableData];
    }
}
- (void)clearCategoryData
{
    [self.qltt_DetailView reloadSections:[[NSIndexSet alloc] initWithIndex:DetailContentType_Category]];
    [_listSameCategoryDoc removeAllObjects];
}
- (void)loadDocumentWithSameCategory:(BOOL)isRefresh isLoadMore:(BOOL)isLoadMore
{
//    if (!isLoadMore) {
//        [_listSameCategoryDoc removeAllObjects];
//    }
    
    [self.qltt_DetailView.qltt_MasterTableView.tb_QLTTList reloadData];
    [self.delegate getDocumentWithSameCategory:_page isLoadMore:isLoadMore isRefresh: isRefresh completion:^(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error, BOOL isSubView) {
        [self hiddenInfiniteScrollView:YES];
        [self dismissRefreshActivity];
        if (exception) {
            [self handleErrorFromResult:nil withException:exception inView:self.view];
            return;
        }
        if (success) {
            NSInteger _currentRow = _listSameCategoryDoc.count;
            NSArray  *listSameCategoryDoc = [QLTTMasterDocumentModel arrayOfModelsFromDictionaries:resultArray error:nil];
            if (listSameCategoryDoc.count < _recordPerPage) {
                _isLoadAll = YES;
                weakSelf.qltt_DetailView.qltt_MasterTableView.tb_QLTTList.showsInfiniteScrolling = NO;
            }
            if (!isLoadMore) {
                [_listSameCategoryDoc removeAllObjects];
            }
            [self appendData:listSameCategoryDoc];
            if (!isLoadMore) {
                [self scrollToTopTableContent];
                [self.qltt_DetailView reloadSections:[[NSIndexSet alloc] initWithIndex:DetailContentType_Category]];

            }
            else
            {
                if (_currentRow > 1) {
                    [self.qltt_DetailView scrollTableView: [NSIndexPath indexPathForRow:_currentRow-1 inSection:DetailContentType_Category] animation:NO];
                }
                [self.qltt_DetailView.qltt_MasterTableView.tb_QLTTList reloadData];
                
            }
            
            
        }
        else
        {
            [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
        }
        
    }];
}
- (void)reloadLastIndex
{
    _lastIndex = nil;;
}
- (void)reloadData:(BOOL)isRefresh isFirst:(BOOL)isFirst
{
    if ([Common checkNetworkAvaiable]) {
        [self resetLoadMore];
        if (!isFirst) {
            [self loadDetailDocumentWith:[self.delegate getMasterDocumentDetailModel].documentId isRefresh:isRefresh];
        }
        else
        {
            _lastLike = [self.delegate getMasterDocumentDetailModel].isLike;
        }
        
    }
    else
    {
        [_listSameCategoryDoc removeAllObjects];
        [self.delegate setMasterDocumentDetailModel:nil];
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}
- (void)checkLike
{
    
    [_qltt_detailInfoController checkLikeDocument:[self.delegate getMasterDocumentDetailModel].documentId employeeID:[GlobalObj getInstance].qltt_employID completion:^(BOOL success, NSNumber *resultCode, NSException *exception, BOOL isLike, NSDictionary *error) {
        [self dismissHub];
        if (exception) {
            [self handleErrorFromResult:nil withException:exception inView:self.view];
            return;
        }
        if (success) {
            _lastLike = isLike;
            [self.delegate getMasterDocumentDetailModel].isLike = isLike;
            [self scrollToTopTableContent];
            [self.qltt_DetailView reloadSections:[[NSIndexSet alloc] initWithIndex:DetailContentType_Content]];
            //            [self.qltt_DetailView enterDataToView:_modelDetail];
        }
        else
        {
            [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
        }
        
    }];
}
- (void)loadDetailDocumentWith:(NSNumber *)documentID isRefresh:(BOOL)isRefresh
{
    if (IS_IPHONE) {
        if (!isRefresh) {
            [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
        }
    }
    [_qltt_detailInfoController getMasterDocDetail:documentID completion:^(BOOL success, QLTTMasterDocumentModel *model, NSException *exception, NSDictionary *error) {
        [self hiddenPullRefreshView:YES];
        [self dismissRefreshActivity];
        if (exception) {
            [self handleErrorFromResult:nil withException:exception inView:self.view];
            return;
        }
        if (success) {
            model.isLike = _lastLike;
            [self.delegate setMasterDocumentDetailModel:model];
            [self loadDocumentWithSameCategory:isRefresh isLoadMore:NO];
            [self checkLike];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"updateQLTTMasterDocumentModel"
             object:nil];
        }
        else
        {
            [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
        }
    }];
}
- (void)likeDocumentWith:(NSNumber *)documentId
{
    [self.qltt_detailInfoController likeDocument:documentId employeeID:[GlobalObj getInstance].qltt_employID completion:^(BOOL success, NSNumber *resultCode, NSException *exception, NSDictionary *error) {
        if ([self.delegate respondsToSelector:@selector(dismissLoading)]) {
            [self.delegate dismissLoading];
        }
        else
        {
            [self dismissHub];
        }
        
        if (exception) {
            [self handleErrorFromResult:nil withException:exception inView:self.view];
            return;
        }
        if (success) {
            if (resultCode) {
                AlertFlatView *alertFlatView = NEW_VC_FROM_NIB(AlertFlatView, @"AlertFlatView");
                [self showAlert:alertFlatView title:LocalizedString(@"TTNS_UMTimeKeepingDetail_Thông_báo_lỗi") leftButtonTitle:nil rightButtonTitle:nil leftHander:nil rightHander:nil];
            }
            else
            {
                long numLike;
                BOOL _isLike = ![self.delegate getMasterDocumentDetailModel].isLike;
                [self.delegate getMasterDocumentDetailModel].isLike = _isLike;
                if (_isLike == YES) {
                    numLike = [[self.delegate getMasterDocumentDetailModel].numLike longValue] + 1;
                }
                else
                {
                    numLike = [[self.delegate getMasterDocumentDetailModel].numLike longValue] - 1;
                }
                
                [self.delegate getMasterDocumentDetailModel].numLike = [NSNumber numberWithLong:numLike];
//                [self scrollToTopTableContent];
                [self.qltt_DetailView reloadSections:[[NSIndexSet alloc] initWithIndex:DetailContentType_Content]];
            }
        }
        else
        {
            [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
        }
    }];
}
#pragma mark UITableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
        SOInsectTextLabel *label = [[SOInsectTextLabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
        label.textColor = AppColor_TittleTextColor;
        label.backgroundColor = AppColor_MainAppBackgroundColor;
        [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        NSString *string = LocalizedString(@"QLTT_DetailView_Cùng_chuyên_mục");
        [label setText:string];
        [view addSubview:label];
        view.backgroundColor = AppColor_MainAppBackgroundColor;
        return view;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    } else {
        return 0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == DetailContentType_Content) {
        return;
    }
    if (_listSameCategoryDoc[indexPath.row].secretLevel) {
        [self showSecretAlert];
        return;
    }
    _lastIndex = indexPath;
    [self.delegate setMasterDocumentDetailModel:_listSameCategoryDoc[indexPath.row]];
    if ([self.delegate respondsToSelector:@selector(setTile:subTitle:)]) {
        [self.delegate setTile:((QLTTMasterDocumentModel *)_listSameCategoryDoc[indexPath.row]).name subTitle:[NSString stringWithFormat:@"(%@ %@)",LocalizedString(@"QLTT_MasterViewCell_Phiên_bản"), ((QLTTMasterDocumentModel *)_listSameCategoryDoc[indexPath.row]).version]];
        //        if (IS_IPHONE) {
        [self reloadData:NO];
        //        }
        [self scrollToTopTableContent];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    }
    else
    {
        return 148.5;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (IS_IPAD) {
            return 430;
        }
        else
        {
            return 495.5;
        }
    }
    else
    {
        return 148.5;
    }
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == DetailContentType_Content) {
        NSString *nibName = @"QLTT_DetailViewContentCell";
        if (IS_IPAD) {
            nibName = [NSString stringWithFormat:@"%@_iPad", nibName];
        }
        [self.qltt_DetailView.qltt_MasterTableView.tb_QLTTList registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:@"QLTT_DetailViewContentCell"];
        return 1;
    }else
    {
        
        [self.qltt_DetailView.qltt_MasterTableView.tb_QLTTList registerNib:[UINib nibWithNibName:@"QLTT_MasterViewCell" bundle:nil] forCellReuseIdentifier:@"QLTT_MasterViewCell"];
        return _listSameCategoryDoc.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == DetailContentType_Content) {
        static NSString *ID_CELL = @"QLTT_DetailViewContentCell";
        QLTT_DetailViewContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell enterDataToView:[self.delegate getMasterDocumentDetailModel]];
        cell.delegate = self;
        //        [cell enterDataToCell:_listSameCategoryDoc[indexPath.row]];
        return cell;
    }else
    {
        static NSString *ID_CELL = @"QLTT_MasterViewCell";
        QLTT_MasterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
        if (_listSameCategoryDoc.count < indexPath.row) {
            return cell;
        }
        cell.delegate = self;
        [cell enterDataToCell:_listSameCategoryDoc[indexPath.row]];
        return cell;
    }
    
}

#pragma mark QLTT_DetailViewDelegate
- (void)didSelectLikeButton
{
    if (_lastIndex) {
        [self likeDocumentWith:_listSameCategoryDoc[_lastIndex.row].documentId];
    }
    else
    {
        [self likeDocumentWith:[self.delegate getMasterDocumentDetailModel].documentId];
    }
    
}
- (BOOL)isVisibleContentCell:(QLTT_DetailViewContentCell *)cell
{
    return [self.qltt_DetailView checkVisible:cell];
}
#pragma mark - PassingMasterDocumentModel
- (void)getDocumentWithSameCategory:(CallbackQLTT_DetailInfoNormal)completion
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:_listSameCategoryDoc];
    [array removeObjectAtIndex:_lastIndex.row];
    completion(YES, array, nil, nil, YES);
}
- (QLTTMasterDocumentModel *)getMasterDocumentDetailModel
{
    return (QLTTMasterDocumentModel *)_listSameCategoryDoc[_lastIndex.row];
}

- (QLTTFileAttachmentModel *)getAttachmentModel:(NSInteger)index
{
    return ((QLTTMasterDocumentModel *)_listSameCategoryDoc[_lastIndex.row]).fileAttachment[index];
}

- (NSInteger)numberOfFileAttachment
{
    return ((QLTTMasterDocumentModel *)_listSameCategoryDoc[_lastIndex.row]).fileAttachment.count;
}

- (NSNumber *)getDocumentId
{
    return ((QLTTMasterDocumentModel *)_listSameCategoryDoc[_lastIndex.row]).documentId;
}
- (void)pushVC:(UIViewController *)vc
{
    [self.delegate pushVC:vc];
}

#pragma mark QLTT_MasterViewCellDelegate
- (BOOL)isVisible:(QLTT_MasterViewCell *)cell
{
    return [self.qltt_DetailView checkVisible:cell];
    
}


@end
