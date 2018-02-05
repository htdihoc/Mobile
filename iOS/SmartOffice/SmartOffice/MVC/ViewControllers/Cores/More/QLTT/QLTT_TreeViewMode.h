//
//  QLTT_TreeViewMode.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLTT_TreeView.h"
#import "QLTTMasterDocumentModel.h"
#import "QLTT_TreeViewCell.h"
#import "QLTT_MasterVC.h"

@interface QLTT_TreeViewMode : BaseVC
@property (weak, nonatomic) IBOutlet QLTT_TreeView *qltt_TreeView;
@property (weak, nonatomic) id<PassingMasterDocumentModel> delegate;
@end
