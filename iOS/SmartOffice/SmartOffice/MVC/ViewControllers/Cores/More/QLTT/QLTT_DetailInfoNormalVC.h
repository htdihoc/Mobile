//
//  QLTT_DetailInfoNormal.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLTT_DetailView.h"

typedef enum : NSInteger {
    DetailContentType_Content = 0,
    DetailContentType_Category = 1
} DetailContentType;
@interface QLTT_DetailInfoNormalVC : BaseVC
@property (weak, nonatomic) IBOutlet QLTT_DetailView *qltt_DetailView;
@property (weak, nonatomic) id<PassingMasterDocumentModel> delegate;
@property (nonatomic, assign) BOOL isTreeVC;
- (void)reloadData:(BOOL)isRefresh;
- (void)clearCategoryData;
- (void)reloadLastIndex;
;
@end
