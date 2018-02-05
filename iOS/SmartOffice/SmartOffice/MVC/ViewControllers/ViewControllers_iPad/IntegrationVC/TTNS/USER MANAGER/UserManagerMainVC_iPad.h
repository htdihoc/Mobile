//
//  UserManagerMainVC_iPad.h
//  SmartOffice
//
//  Created by Administrator on 5/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BaseVC.h"
#import <Charts/Charts.h>
#import "SOBadgeButton.h"

@interface UserManagerMainVC_iPad : BaseVC

@property (weak, nonatomic) IBOutlet UIView *sectionManagerView;

@property (weak, nonatomic) IBOutlet UIView *quansoView;

@property (weak, nonatomic) IBOutlet UILabel *sectionManagerLB;

@property (weak, nonatomic) IBOutlet UIView *sectionPersonalView;

@property (weak, nonatomic) IBOutlet UILabel *sectionPersonalLB;

@property (weak, nonatomic) IBOutlet UIView *managerView;

@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UIButton *arrowRightButton;

@property (weak, nonatomic) IBOutlet UIButton *arrowLeftButton;

@property (weak, nonatomic) IBOutlet PieChartView *countChartView;

@property (weak, nonatomic) IBOutlet UILabel *workLB;

@property (weak, nonatomic) IBOutlet UILabel *notWorkLB;

@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UILabel *pheDuyetRaNgoaiLB;

@property (weak, nonatomic) IBOutlet UILabel *pheDuyetCongLB;

@property (weak, nonatomic) IBOutlet UILabel *traCuuNVLB;

@property (weak, nonatomic) IBOutlet UIView *personalView;

@property (weak, nonatomic) IBOutlet UIView *thongTinCongView;

@property (weak, nonatomic) IBOutlet UIView *incomeView;

@property (weak, nonatomic) IBOutlet UIView *kIInfoView;


@property (weak, nonatomic) IBOutlet UIButton *centerChartButton;

@property (weak, nonatomic) IBOutlet SOBadgeButton *badgedButton;

// block

- (IBAction)arrowRightAction:(id)sender;

- (IBAction)arrowLeftAction:(id)sender;

- (IBAction)pheDuyetRaNgoaiAction:(id)sender;

- (IBAction)pheDuyetCongAction:(id)sender;

- (IBAction)traCuuNVAction:(id)sender;

- (IBAction)centerChartAction:(id)sender;

@end



















