//
//  KIInfoVC_iPad.h
//  SmartOffice
//
//  Created by Administrator on 4/25/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BaseVC.h"
#import <Charts/Charts.h>

@interface KIInfoVC_iPad : BaseVC
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet BarChartView *kIChartView;

@property (weak, nonatomic) IBOutlet UILabel *managerInOutLB;

@property (weak, nonatomic) IBOutlet UILabel *kIInfoLB;

@property (weak, nonatomic) IBOutlet UIView *boundChartView;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UILabel *pointLB;

@property (weak, nonatomic) IBOutlet UILabel *monthLB;

- (IBAction)arrowRightAction:(id)sender;

- (IBAction)arrowLeftAction:(id)sender;

- (IBAction)managerInOutAction:(id)sender;

@end
