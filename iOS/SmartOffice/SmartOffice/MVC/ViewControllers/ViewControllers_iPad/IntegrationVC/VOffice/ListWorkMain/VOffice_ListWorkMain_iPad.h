//
//  VOffice_ListWorkMain_iPad.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/27/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOffice_BaseBottomView_iPad.h"
#import "VOffice_ListWork_iPad.h"
#import "VOffice_ListWorkCell_iPad.h"
#import "WYPopoverController.h"
#import "ContentFilterVC.h"
#import "VOffice_DetailWork_iPad.h"

@interface VOffice_ListWorkMain_iPad : VOffice_BaseBottomView_iPad
@property (weak, nonatomic) IBOutlet VOffice_ListWork_iPad *listWork;
@property (weak, nonatomic) IBOutlet VOffice_DetailWork_iPad *workDetail;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (assign, nonatomic) ListWorkType listWorkType;
@property (weak, nonatomic) UISegmentedControl *segment;
@end
