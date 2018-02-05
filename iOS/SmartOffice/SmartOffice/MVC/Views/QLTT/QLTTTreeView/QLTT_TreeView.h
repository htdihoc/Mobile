//
//  QLTT_TreeView.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSubView.h"
#import "FullWidthSeperatorTableView.h"
#import "RATreeView.h"
@interface QLTT_TreeView : BaseSubView
@property (weak, nonatomic) IBOutlet RATreeView *tbl_TreeView;

@end
