//
//  VOffice_ListMission_iPad.h
//  SmartOffice
//
//  Created by Nguyen Van Tu on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOffice_ListView_iPad.h"
#import "MissionGroupModel.h"
@interface VOffice_ListMission_iPad : VOffice_ListView_iPad
- (void)reloadData;
- (NSIndexPath *)getSelectedIndex;
@end
