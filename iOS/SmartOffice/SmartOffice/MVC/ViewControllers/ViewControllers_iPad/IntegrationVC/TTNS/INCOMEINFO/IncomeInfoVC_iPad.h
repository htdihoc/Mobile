//
//  IncomeInfoVC_iPad.h
//  SmartOffice
//
//  Created by Administrator on 4/25/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BaseVC.h"
#import <Charts/Charts.h>

@interface IncomeInfoVC_iPad : BaseVC

@property (weak, nonatomic) IBOutlet UILabel *inComeInfoLB;

@property (weak, nonatomic) IBOutlet PieChartView *chartView;

@property (weak, nonatomic) IBOutlet UIView *descriptionView;

@property (weak, nonatomic) IBOutlet UIView *luongKiView;

@property (weak, nonatomic) IBOutlet UILabel *luongKiLB;

@property (weak, nonatomic) IBOutlet UILabel *countLuongLB;

@property (weak, nonatomic) IBOutlet UIView *luongSXKDView;

@property (weak, nonatomic) IBOutlet UILabel *luongSXKDLB;

@property (weak, nonatomic) IBOutlet UILabel *countLuongSXDKDLB;

@property (weak, nonatomic) IBOutlet UIView *luongKhacView;

@property (weak, nonatomic) IBOutlet UILabel *luongkhacLB;

@property (weak, nonatomic) IBOutlet UILabel *countLuongKhacLB;

@property (weak, nonatomic) IBOutlet UILabel *donViTinhLB;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *quanLyNgiPhepLB;

@property (weak, nonatomic) IBOutlet UIButton *centerChartView;

@property (weak, nonatomic) IBOutlet UIButton *btn_NextIncome;

@property (weak, nonatomic) IBOutlet UIButton *btn_PreviousIncome;


- (IBAction)quanLyNgiPhepAction:(id)sender;

- (IBAction)centerChartviewAction:(id)sender;

- (IBAction)arrowRightAction:(id)sender;

- (IBAction)arrowLeftAction:(id)sender;

@end
