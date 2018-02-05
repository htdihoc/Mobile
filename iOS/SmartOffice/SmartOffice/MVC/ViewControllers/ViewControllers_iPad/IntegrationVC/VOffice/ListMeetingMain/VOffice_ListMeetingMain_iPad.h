//
//  VOffice_ListMeetingMain_iPad.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOffice_Meeting_iPad.h"
#import "WorkNoDataView.h"
#import "VOffice_MeettingDetail_iPad.h"
#import "VOffice_BaseBottomView_iPad.h"

@interface VOffice_ListMeetingMain_iPad : VOffice_BaseBottomView_iPad
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *listMeeting;
@property (weak, nonatomic) IBOutlet UIView *listMeetingDetail;
@property (weak, nonatomic) id<VOfficeProtocol> delegate;
@end
