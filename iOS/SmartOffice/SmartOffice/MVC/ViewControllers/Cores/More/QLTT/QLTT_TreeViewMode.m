//
//  QLTT_TreeViewMode.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "QLTT_TreeViewMode.h"
#import "QLTT_TreeViewModeController.h"
@interface QLTT_TreeViewMode () <RATreeViewDelegate, RATreeViewDataSource, PassingMasterDocumentModel>
@property (strong, nonatomic) QLTT_TreeViewModeController *treeViewModeController;
@end

@implementation QLTT_TreeViewMode
{
    QLTTMasterDocumentModel *_lastModel;
    NSMutableArray *_listTreeDoc;
    NSMutableArray *_listDoc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.backTitle = LocalizedString(@"QLTT_TreeViewMode_Danh_mục");
    [self addNavView];
    [self settingTreeMode];
    [self initValues];
    [self loadDataForTreeMode];
}

- (void)initValues
{
    _listTreeDoc = [NSMutableArray new];
    _listDoc = [NSMutableArray new];
    self.treeViewModeController = [[QLTT_TreeViewModeController alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark process data
- (void)loadDataForTreeMode
{
    NSDictionary *params = @{@"type" : @1};
    [self.treeViewModeController loadData:params completion:^(BOOL success, NSArray *resultArray, NSException *exception, BOOL isConnectNetwork) {
        if (isConnectNetwork == NO) {
            
            return ;
        }
        if (success) {
            _listDoc = [QLTTMasterDocumentModel arrayOfModelsFromDictionaries:resultArray error:nil];
            [self calculateModelForTreeView];
            [self.qltt_TreeView.tbl_TreeView reloadData];
        }
        else
        {
            
        }
        
    }];
//    if ([Common checkNetworkAvaiable]) {
    
//        [QLTTProcessor getQLTTDocCategoryWithComplete:params WithComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
//            if (success) {
//                DLog(@"Get AccessToken Success")
//                NSArray *dictModels = resultDict[@"data"][@"result"];
//                
//                //                VOfficeSessionModel *model = [[VOfficeSessionModel alloc] initWithDictionary:dicSession error:nil];
//                //                [SOSessionManager sharedSession].vofficeSession = model;
//                //                [[SOSessionManager sharedSession] saveData];
//            }
//            else
//            {
//                //error
//            }
//        }];
//    }else{
//        //network error
//        //        [self showErrorView:YES];
//    }
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


#pragma mark TreeView Delegate methods

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item
{
    QLTT_MasterVC *masterDetailVC = NEW_VC_FROM_NIB(QLTT_MasterVC, @"QLTT_MasterVC");
    _lastModel = item;
    masterDetailVC.delegate  = self;
    masterDetailVC.isTreeVC = YES;
    masterDetailVC.navView.title = ((QLTTMasterDocumentModel *)item).levelPath.lastObject;
    [self.navigationController pushViewController:masterDetailVC animated:YES];
    
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    QLTTMasterDocumentModel *dataObject = item;
    NSInteger level = [self.qltt_TreeView.tbl_TreeView levelForCellForItem:item];
    
    QLTT_TreeViewCell *cell = [self.qltt_TreeView.tbl_TreeView dequeueReusableCellWithIdentifier:NSStringFromClass([QLTT_TreeViewCell class])];
    [cell setupWithTitle:dataObject.levelPath.lastObject level:level additionButtonHidden:NO];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak typeof(self) weakSelf = self;
    cell.additionButtonTapAction = ^(id sender){
        if (![weakSelf.qltt_TreeView.tbl_TreeView isCellForItemExpanded:dataObject] || weakSelf.qltt_TreeView.tbl_TreeView.isEditing) {
            [weakSelf.qltt_TreeView.tbl_TreeView expandRowForItem:item];
            return;
        }
        [weakSelf.qltt_TreeView.tbl_TreeView collapseRowForItem:item];
    };
    
    return cell;
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
@end
