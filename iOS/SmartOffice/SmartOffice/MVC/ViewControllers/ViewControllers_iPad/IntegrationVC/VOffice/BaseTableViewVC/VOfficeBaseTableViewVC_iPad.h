//
//  VOfficeBaseTableViewVC.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VOfficeBaseTableViewVC_iPad : UIViewController
@property (strong, nonatomic) UITableView *baseTableView;
- (void)registerCellWith:(NSString *)identifer;
- (void)deSelectRow:(NSIndexPath *)indexPath;
@property (strong, nonatomic) NSArray *array;
@end
