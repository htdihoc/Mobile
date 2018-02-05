//
//  QLTT_TreeVCMode_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/25/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "QLTT_TreeVCMode_iPad.h"

@interface QLTT_TreeVCMode_iPad ()

@end

@implementation QLTT_TreeVCMode_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingTreeMode];
    [self addComtainerView];
    [self loadDataForTreeMode];
}

- (void)addComtainerView
{
    [self addView:self.qltt_TreeView toView:self.containerView];
}
- (void)pushVC:(UIViewController *)vc
{
    [self.delegate pushVC:vc];
}
#pragma mark TreeView Delegate methods

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item
{
    ((QLTTMasterDocumentModel *)item).isSelectedModel = NO;
    [self removeSelectedItemsWithLevel:((QLTTMasterDocumentModel *)item).level];
    [self addItemToSelectedArray:item];
    [treeView reloadRowsForItems:@[item] withRowAnimation:RATreeViewRowAnimationNone];
    self.lastModel = item;
    [self.delegate didSelect:item];
}
@end
