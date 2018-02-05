//
//  VOffice_DocumentDetail_iPad.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOSearchBarView.h"
#import "VOffice_Base_iPad.h"
#import "VOffice_Protocol.h"
@class FullWidthSeperatorTableView;
@interface VOffice_DocumentDetail_iPad : BaseVC
@property (weak, nonatomic) IBOutlet FullWidthSeperatorTableView *tb_ListDocument;
@property (weak, nonatomic) IBOutlet SOSearchBarView *searchBar;
@property (weak, nonatomic) id<VOfficeProtocol> delegate;
- (void)reloadDataWhenFilter;

@end
