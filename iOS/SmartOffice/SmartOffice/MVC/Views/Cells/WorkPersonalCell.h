//
//  WorkPersonalCell.h
//  SmartOffice
//
//  Created by Kaka on 4/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>

@class SOPieChartView;

@class SumWorkModel;

@protocol WorkPersonalCellDelegate <NSObject>

@optional
- (void)didTapOnChartView:(ChartViewBase *)chartView withType:(ListWorkType)type;

@end
@interface WorkPersonalCell : UITableViewCell{
    
}

//View Content
@property (weak, nonatomic) IBOutlet UIView *notePersonalView;
@property (weak, nonatomic) IBOutlet UIView *noteShipperView;

//Icon
@property (weak, nonatomic) IBOutlet UIImageView *profilePerformWork;
@property (weak, nonatomic) IBOutlet UIImageView *profileShippedWork;


//PerformWork Info
@property (weak, nonatomic) IBOutlet UILabel *lblSumPersonalWork;
@property (weak, nonatomic) IBOutlet UILabel *lblPersonalWork_Low;
@property (weak, nonatomic) IBOutlet UILabel *lblPersonalWork_NotProgress;

//ShippedWork info
@property (weak, nonatomic) IBOutlet UILabel *lblSumShipperWork;
@property (weak, nonatomic) IBOutlet UILabel *lblShipperWork_Low;
@property (weak, nonatomic) IBOutlet UILabel *lblShipperWork_NotProgress;

//Chart
@property (weak, nonatomic) IBOutlet PieChartView *shipperChartView;
@property (weak, nonatomic) IBOutlet PieChartView *personalChartView;

@property (weak, nonatomic) id<WorkPersonalCellDelegate>delegate;

- (void)setupViewFromModel:(SumWorkModel *)_performWork shippedWork:(SumWorkModel *)_shippedWork;


@end
