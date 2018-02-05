//
//  VOffice_DocumentTypicalDetail_iPad.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullWidthSeperatorTableView.h"
#import "VOffice_Protocol.h"
#import "VOffice_BaseTableViewVC_iPad.h"
@interface VOffice_DocumentTypicalDetail_iPad : VOffice_BaseTableViewVC_iPad
@property (weak, nonatomic) id<VOfficeProtocol> delegate;
- (void)loadData:(NSString *)docId;
- (void)reloadData;
- (void)clearData;
@end
