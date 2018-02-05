//
//  QLTT_MasterVCBase.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLTT_MasterView.h"
#import "QLTT_InfoDetailController.h"
@interface QLTT_MasterVCBase : BaseVC
@property (strong, nonatomic) QLTT_MasterView *qltt_MasterView;
@property (weak, nonatomic) id<PassingMasterDocumentModel> delegate;
@property (strong, nonatomic) QLTT_InfoDetailController *qltt_InfoDetailController;
@property (nonatomic, assign) BOOL isTreeVC;
@property (strong, nonatomic) NSIndexPath *lastIndex;
@property (assign) BOOL isSearch;
@property (assign) BOOL isSearchVC;
- (void)setParams:(NSDictionary *)params;
- (void)didSelectFirstItem;
- (void)selectCurrentItem;
- (void)addRightBarButton;
- (void)reloadAPIData:(BOOL)isRefresh;
- (void)checkLike;
- (void)loadDetailDocument;
- (QLTTMasterDocumentModel *)getMasterDocumentModel;
- (void)setDetailModel:(NSInteger)index;
- (void)showError:(BOOL)success error:(NSDictionary *)error exception:(NSException *)exception;
- (void)showError:(BOOL)success error:(NSDictionary *)error exception:(NSException *)exception inView:(UIView *)view;
- (void)clearData;
- (void)setDefaultValues;
@end
