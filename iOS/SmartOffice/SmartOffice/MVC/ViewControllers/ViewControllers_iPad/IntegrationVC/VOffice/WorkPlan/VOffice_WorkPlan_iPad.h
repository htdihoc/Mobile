//
//  VOffice_WorkPlan.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOffice_BaseSubView_iPad.h"
#import <Charts/Charts.h>

@class SumWorkModel;

@interface VOffice_WorkPlan_iPad : VOffice_BaseSubView_iPad
@property (weak, nonatomic) IBOutlet UIView *notePersonalView;
@property (weak, nonatomic) IBOutlet UIView *noteShipperView;

@property (weak, nonatomic) IBOutlet UILabel *lblSumPersonalWork;
@property (weak, nonatomic) IBOutlet UILabel *lblPersonalWork_Low;
@property (weak, nonatomic) IBOutlet UILabel *lblPersonalWork_NotProgress;


@property (weak, nonatomic) IBOutlet UILabel *lblSumShipperWork;
@property (weak, nonatomic) IBOutlet UILabel *lblShipperWork_Low;
@property (weak, nonatomic) IBOutlet UILabel *lblShipperWork_NotProgress;

@property (weak, nonatomic) IBOutlet PieChartView *shipperChartView;
@property (weak, nonatomic) IBOutlet PieChartView *personalChartView;

- (void)setupViewFromModel:(SumWorkModel *)_performWork shippedWork:(SumWorkModel *)_shippedWork;

- (void)loadData;
@end
