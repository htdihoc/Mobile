//
//  BaseListView.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNS_BaseVC.h"
#import "FullWidthSeperatorTableView.h"
@interface BaseListView : TTNS_BaseVC
@property (strong, nonatomic) FullWidthSeperatorTableView *baseTableView;
- (void)registerCellWith:(NSString *)identifer;
- (void)deSelectRow:(NSIndexPath *)indexPath;
@property (strong, nonatomic) NSArray *array;
@end
