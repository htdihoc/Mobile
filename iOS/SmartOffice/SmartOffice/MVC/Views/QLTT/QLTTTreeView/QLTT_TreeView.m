//
//  QLTT_TreeView.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "QLTT_TreeView.h"

@implementation QLTT_TreeView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tbl_TreeView.estimatedRowHeight = 80;
    self.tbl_TreeView.rowHeight = UITableViewAutomaticDimension;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
