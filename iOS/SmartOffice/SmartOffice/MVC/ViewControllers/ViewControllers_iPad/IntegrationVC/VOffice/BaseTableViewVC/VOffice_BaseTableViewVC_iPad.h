//
//  VOfficeBaseTableViewVC.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOffice_BaseSubView_iPad.h"
#import "FullWidthSeperatorTableView.h"
@interface VOffice_BaseTableViewVC_iPad : VOffice_BaseSubView_iPad<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) FullWidthSeperatorTableView *baseTableView;
@property (assign) CGFloat spaceTop;
- (void)registerCellWith:(NSString *)identifer;
- (void)deSelectRow:(NSIndexPath *)indexPath;
@property (strong, nonatomic) NSArray *itemsToShow;
- (void)selectFirstItem;
- (void)selectItemsAt:(NSIndexPath *)index;
- (void)addHeaderView:(UIView *)view;
@end
