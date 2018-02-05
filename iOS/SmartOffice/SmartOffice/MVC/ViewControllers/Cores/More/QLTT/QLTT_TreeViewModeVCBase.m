//
//  QLTT_TreeViewMode.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "QLTT_TreeViewModeVCBase.h"
#import "QLTT_TreeViewModeController.h"
#import "QLTTMasterDocumentModel.h"
#import "QLTT_TreeViewCell.h"
#import "QLTT_MasterVC.h"
#import "NSException+Custom.h"
#import "SVPullToRefresh.h"
#import "Common.h"
@interface QLTT_TreeViewModeVCBase () <RATreeViewDelegate, RATreeViewDataSource>
@property (strong, nonatomic) QLTT_TreeViewModeController *treeViewModeController;
@end

@implementation QLTT_TreeViewModeVCBase
{
    NSMutableArray *_listTreeDoc;
    NSMutableArray *_listDoc;
    NSMutableArray *_selectedItems;
    __weak QLTT_TreeViewModeVCBase *_weakTreeSelf;
    BOOL _isLoadAll;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.backTitle = LocalizedString(@"QLTT_TreeViewMode_Danh_mục");
    //    [self addNavView];
    //    [self settingTreeMode];
    [self initValues];
    //    [self loadDataForTreeMode];
}

- (void)initValues
{
    self.qltt_TreeView = [[QLTT_TreeView alloc] initWithFrame:self.view.frame];
    _listTreeDoc = [NSMutableArray new];
    _listDoc = [NSMutableArray new];
    _selectedItems = [NSMutableArray new];
    self.treeViewModeController = [[QLTT_TreeViewModeController alloc] init];
}
- (void)addActionToTreeVC
{
    if (_weakTreeSelf) {
        return;
    }
    _weakTreeSelf = self;
//    self.qltt_TreeView.tbl_TreeView.scrollView.showsInfiniteScrolling = NO;
//    [self.qltt_TreeView.tbl_TreeView.scrollView addInfiniteScrollingWithActionHandler: ^{
//        DLog(@"Loadmore data here");
//        if ([Common checkNetworkAvaiable]) {
//            
//        }
//        else
//        {
//            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
//        }
//        
//    }];
    //
    [self.qltt_TreeView.tbl_TreeView getTableView].showsPullToRefresh = NO;
    [[self.qltt_TreeView.tbl_TreeView getTableView] addPullToRefreshWithActionHandler:^{
        DLog(@"Refresh data here");
        if ([Common checkNetworkAvaiable]) {
            if ([self.delegate respondsToSelector:@selector(clearContent)]) {
                [self.delegate clearContent];
            }
            [self loadDataForTreeMode:YES];
        }else
        {
            [self dismissRefreshActivity];
            if ([self.delegate respondsToSelector:@selector(showError:isInstant:ismasterQLTT:)]) {
                [self.delegate showError:[NSException initWithNoNetWork] isInstant:NO ismasterQLTT:NO];
            }
            else
            {
                [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
            }
            
        }
    } position:SVPullToRefreshPositionTop];

}
- (void)resetLoadMore
{
    _isLoadAll = NO;
    [_weakTreeSelf.qltt_TreeView.tbl_TreeView getTableView].showsInfiniteScrolling = YES;
}
- (void)dismissRefreshActivity
{
    [[_weakTreeSelf.qltt_TreeView.tbl_TreeView getTableView].pullToRefreshView stopAnimating];
}
- (void)dismissVC:(UIGestureRecognizer *)recognizer
{
    if ([self.delegate respondsToSelector:@selector(dismissVC:)])
    {
        [self.delegate dismissVC:recognizer];
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addActionToTreeVC];
}

#pragma mark process data
- (void)loadDataForTreeMode{
    [self loadDataForTreeMode:NO];
}
- (void)loadDataForTreeMode:(BOOL)isRefresh
{
    if (!isRefresh) {
        [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
    }
    NSDictionary *params = @{@"type" : @1};
    [self.treeViewModeController loadData:params completion:^(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error) {
        if (isRefresh) {
            [self dismissRefreshActivity];
        }
        else
        {
            [self dismissHub];
        }
        
        if (exception) {
            [self.qltt_TreeView.tbl_TreeView reloadData];
            [self handleErrorFromResult:nil withException:exception inView:self.view];
            return;
        }
        if (success) {
            [_listDoc removeAllObjects];
            [_listTreeDoc removeAllObjects];
            _listDoc = [QLTTMasterDocumentModel arrayOfModelsFromDictionaries:resultArray error:nil];
            [self calculateModelForTreeView];
        }
        else
        {
            [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
        }
        [self.qltt_TreeView.tbl_TreeView reloadData];
        
    }];
}
- (QLTTMasterDocumentModel *)findRootLevel:(NSInteger)level identifier:(NSString *)identifier
{
    for (QLTTMasterDocumentModel *model in _listDoc) {
        if (model.level == level && [model.levelPath[level-1] isEqualToString:identifier]) {
            return model;
        }
    }
    return nil;
}
- (void)calculateModelForTreeView
{
    for (QLTTMasterDocumentModel *model in _listDoc)
    {
        NSMutableArray *levelPath = [[NSMutableArray alloc] initWithArray:[model.path componentsSeparatedByString:@"/"]];
        //remove redundancy character
        if (levelPath.count > 2) {
            [levelPath removeLastObject];
            [levelPath removeObjectAtIndex:0];
        }
        model.level = levelPath.count;
        model.levelPath = levelPath;
        
        if (model.level == 1) {
            [_listTreeDoc addObject:model];
        }
        else
        {
            [[self findRootLevel:model.level-1 identifier:model.levelPath[model.level-2]].children addObject:model];
        }
    }
}

#pragma setup UI
- (void)settingTreeMode
{
    self.qltt_TreeView = [[QLTT_TreeView alloc] initWithFrame:self.view.bounds];
    [self.qltt_TreeView.tbl_TreeView registerNib:[UINib nibWithNibName:@"QLTT_TreeViewCell" bundle:nil] forCellReuseIdentifier:@"QLTT_TreeViewCell"];
    
    self.qltt_TreeView.tbl_TreeView.delegate = self;
    self.qltt_TreeView.tbl_TreeView.dataSource = self;
    self.qltt_TreeView.tbl_TreeView.treeFooterView = nil;
    self.qltt_TreeView.tbl_TreeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    
    //    UIRefreshControl *refreshControl = [UIRefreshControl new];
    //    [refreshControl addTarget:self action:@selector(refreshControlChanged:) forControlEvents:UIControlEventValueChanged];
    //    [self.qltt_TreeView.tbl_TreeView.scrollView addSubview:refreshControl];
    
    [self.qltt_TreeView.tbl_TreeView reloadData];
}

#pragma mark - Actions

- (void)refreshControlChanged:(UIRefreshControl *)refreshControl
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refreshControl endRefreshing];
    });
}


#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    QLTTMasterDocumentModel *dataObject = item;
    NSInteger level = [self.qltt_TreeView.tbl_TreeView levelForCellForItem:item];
    
    QLTT_TreeViewCell *cell = [self.qltt_TreeView.tbl_TreeView dequeueReusableCellWithIdentifier:NSStringFromClass([QLTT_TreeViewCell class])];
    if ([_selectedItems containsObject:dataObject]) {
        [cell setBackgroundColor:COLOR_FROM_HEX(0xd9d9d9)];
    }
    else
    {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    [cell setState:dataObject.isSelectedModel];
    [cell setupWithTitle:dataObject.name level:level additionButtonHidden:NO];
    if(dataObject.isSelectedModel && dataObject.children.count > 0)
    {
        [cell setImageMinusIconForCell];
    }
    else
    {
        [cell setImageForCell:dataObject.children.count > 0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak typeof(self) weakSelf = self;
    cell.additionButtonTapAction = ^(id sender){
        dataObject.isSelectedModel = !dataObject.isSelectedModel;
        if (![weakSelf.qltt_TreeView.tbl_TreeView isCellForItemExpanded:dataObject] || weakSelf.qltt_TreeView.tbl_TreeView.isEditing) {
            [weakSelf.qltt_TreeView.tbl_TreeView expandRowForItem:item];
            return;
        }
        [weakSelf.qltt_TreeView.tbl_TreeView collapseRowForItem:item];
    };
    
    return cell;
}

- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item
{
    QLTT_TreeViewCell *cell = (QLTT_TreeViewCell *)[treeView cellForItem:item];
    QLTTMasterDocumentModel *data = item;
    [cell setState:NO];
    [cell setImageForCell:data.children.count > 0];
}
- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [_listTreeDoc count];
    }
    
    QLTTMasterDocumentModel *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    QLTTMasterDocumentModel *data = item;
    if (item == nil) {
        return [_listTreeDoc objectAtIndex:index];
    }
    
    return data.children[index];
}

#pragma mark PassingMasterDocumentModel
- (NSArray *)getMasterTreeDocumentModel
{
    return @[_lastModel];
}
- (void)didCheckLike
{
    [self dismissHub];
}

- (void)addItemToSelectedArray:(QLTTMasterDocumentModel *)model
{
    [_selectedItems addObject:model];
}
- (void)removeItemFromSelectedArray:(QLTTMasterDocumentModel *)model
{
    [_selectedItems removeObject:model];
}
- (void)removeSelectedItemsWithLevel:(NSInteger)level
{
    NSArray *tmp = [_selectedItems copy];
    [_selectedItems removeAllObjects];
    [self.qltt_TreeView.tbl_TreeView reloadRowsForItems:tmp withRowAnimation:RATreeViewRowAnimationNone];
    
//    for (QLTTMasterDocumentModel *model in _listDoc) {
//        if (model.level == level) {
//            [self removeItemFromSelectedArray:model];
//        }
//    }
}
- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item
{
    return NO;
}
@end
