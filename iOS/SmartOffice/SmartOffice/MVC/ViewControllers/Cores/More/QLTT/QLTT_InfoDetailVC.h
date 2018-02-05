//
//  QLTT_InfoDetailVC.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLTT_InfoDetail.h"
#import "QLTT_InfoDetailContentCell.h"
#import "QLTT_InfoDetailDocumentCell.h"
#import "QLTT_InfoDetailController.h"
#import "QLTT_PreviewVC.h"


@interface QLTT_InfoDetailVC : BaseVC
@property (weak, nonatomic) IBOutlet QLTT_InfoDetail *qltt_InfoDetail;
@property (weak, nonatomic) id<PassingMasterDocumentModel> delegate;
- (void)reloadData;
@end
