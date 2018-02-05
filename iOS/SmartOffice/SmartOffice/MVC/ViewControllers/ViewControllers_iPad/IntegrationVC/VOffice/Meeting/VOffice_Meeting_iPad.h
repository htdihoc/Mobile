//
//  VOffice_Meeting_iPad.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOffice_BaseTableViewVC_iPad.h"
#import "VOffice_MeetingCell_iPad.h"
#import "VOffice_ListMeetingMain_iPad.h"

@interface VOffice_Meeting_iPad : VOffice_BaseTableViewVC_iPad
@property (assign) BOOL isViewDetail;
@property (weak, nonatomic) id<VOfficeProtocol> delegate;
- (void)loadData;
@end
