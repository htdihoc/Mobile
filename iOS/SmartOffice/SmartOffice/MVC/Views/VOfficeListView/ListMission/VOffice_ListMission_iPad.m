//
//  VOffice_ListMission_iPad.m
//  SmartOffice
//
//  Created by Nguyen Van Tu on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_ListMission_iPad.h"

@implementation VOffice_ListMission_iPad

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)reloadData
{
    [self.tbl_ListContents reloadData];
}
- (NSIndexPath *)getSelectedIndex
{
    return [self.tbl_ListContents indexPathForSelectedRow];
}
@end
