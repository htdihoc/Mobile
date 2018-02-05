//
//  QLTT_TreeVCMode.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/25/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "QLTT_TreeVCMode.h"
#import "QLTT_MasterVC.h"
@interface QLTT_TreeVCMode ()

@end

@implementation QLTT_TreeVCMode

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.backTitle = LocalizedString(@"QLTT_TreeViewMode_Danh_mục");
    [self addNavView];
    [self settingTreeMode];
    [self addComtainerView];
    [self loadDataForTreeMode];
    
}

- (void)addComtainerView
{
    [self addView:self.qltt_TreeView toView:self.containerView];
}

#pragma mark TreeView Delegate methods
//- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item
//{
//    ((QLTTMasterDocumentModel *)item).isSelectedModel = NO;
//
//    [treeView reloadRowsForItems:@[item] withRowAnimation:RATreeViewRowAnimationNone];
//    self.lastModel = item;
//    [self.delegate didSelect:item];
//}
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item
{
    [self removeSelectedItemsWithLevel:((QLTTMasterDocumentModel *)item).level];
    [self addItemToSelectedArray:item];
    ((QLTTMasterDocumentModel *)item).isSelectedModel = NO;
    self.lastModel = item;
    [treeView reloadRowsForItems:@[item] withRowAnimation:RATreeViewRowAnimationNone];
    QLTT_MasterVC *masterDetailVC = NEW_VC_FROM_NIB(QLTT_MasterVC, @"QLTT_MasterVC");
    masterDetailVC.delegate  = self;
    masterDetailVC.isTreeVC = YES;
    masterDetailVC.backTitle = ((QLTTMasterDocumentModel *)item).name;
    [self.navigationController pushViewController:masterDetailVC animated:YES];
    
}
@end
