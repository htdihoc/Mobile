//
//  BaseListView.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseListView : BaseVC
@property (strong, nonatomic) UITableView *baseTableView;
- (void)registerCellWith:(NSString *)identifer;
@end
