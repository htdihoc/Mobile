//
//  VOffice_DocumentTypicalDetailCell_iPad.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VOffice_DocumentTypicalDetailCell_iPad : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitleCell;
@property (weak, nonatomic) IBOutlet UILabel *lblContentCell;
@property (weak, nonatomic) IBOutlet UIView *bottomBorder;

- (void)setupData:(id)model atIndex:(NSInteger)index;
@end
