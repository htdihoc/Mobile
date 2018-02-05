//
//  VOfice_PersonalMainView_iPad.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOffice_Document_iPad.h"
#import "VOffice_Meeting_iPad.h"
#import "VOffice_MissionPlan_iPad.h"
#import "VOffice_WorkPlan_iPad.h"
#import "WorkNoDataView.h"
@interface VOfice_PersonalMainView_iPad : BaseVC
@property (weak, nonatomic) IBOutlet UIView *containerWorkPlan;
@property (weak, nonatomic) IBOutlet UIView *containerDocumentView;

@property (weak, nonatomic) IBOutlet UIView *containerMeetingView;

@end
