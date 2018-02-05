//
//  QLTT_DetailVCBase.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLTT_DetailInfoNormalVC.h"
#import "QLTT_CommentVC.h"
#import "QLTT_InfoDetailVC.h"
#import "CAPSPageMenu.h"
typedef enum: NSUInteger {
	InfoNormal = 0,
	InfoDetail,
	InfoComent,
} TypeInfo;
@interface QLTT_DetailVCBase : BaseVC
@property (weak, nonatomic) id<PassingMasterDocumentModel> delegate;
@property (nonatomic, strong) CAPSPageMenu *pageMenu;
@property (assign) NSInteger currentSegmentIndex;
@property (assign) BOOL isTreeVC;
@property (assign) BOOL isPushPreview;
- (void)createUI:(CGFloat)spaceTop;
- (void)hiddenContent:(BOOL)isHidden;
- (void)clearCategoryData;
- (void)reloadData;
- (void)reloadIndexDetail;
- (void)reloadDataWith:(TypeInfo)type;
- (NSInteger)getSegmentNumber;
- (void)setSegment:(NSInteger)index;
-(void)swipeleft;
-(void)swiperight;
@end
