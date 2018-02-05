//
//  QLTT_TreeViewModeVCBase.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/25/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLTT_TreeView.h"

@interface QLTT_TreeViewModeVCBase : BaseVC <PassingMasterDocumentModel>
@property (strong, nonatomic) QLTT_TreeView *qltt_TreeView;
@property (weak, nonatomic) id<PassingMasterDocumentModel> delegate;
@property (strong, nonatomic) QLTTMasterDocumentModel *lastModel;

- (void)settingTreeMode;
- (void)loadDataForTreeMode;
- (void)resetLoadMore;
- (void)addItemToSelectedArray:(QLTTMasterDocumentModel *)model;
- (void)removeItemFromSelectedArray:(QLTTMasterDocumentModel *)model;
- (void)removeSelectedItemsWithLevel:(NSInteger)level;
@end
