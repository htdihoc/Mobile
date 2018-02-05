//
//  WorkListVC_iPad.h
//  SmartOffice
//
//  Created by Administrator on 4/25/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>

@interface WorkInfoVC_iPad : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *workInfoLB;

@property (weak, nonatomic) IBOutlet UIView *congPheDuyetView;

@property (weak, nonatomic) IBOutlet UILabel *congPheDuyetLB;

@property (weak, nonatomic) IBOutlet UILabel *countCongPheDuyetLB;

@property (weak, nonatomic) IBOutlet UIView *congChuaPheDuyetView;

@property (weak, nonatomic) IBOutlet UILabel *congChuaPheDuyetLB;

@property (weak, nonatomic) IBOutlet UILabel *countCongChuaPheDuyetLB;

@property (weak, nonatomic) IBOutlet UIView *nghiKhongLuongView;

@property (weak, nonatomic) IBOutlet UILabel *nghiKhongLuongLB;

@property (weak, nonatomic) IBOutlet UILabel *countNghiKhongLuongLB;

@property (weak, nonatomic) IBOutlet UIView *chuaChamCongView;

@property (weak, nonatomic) IBOutlet UILabel *chuaChamCongLB;

@property (weak, nonatomic) IBOutlet UILabel *countChuaChamCongLB;

@property (weak, nonatomic) IBOutlet UILabel *quanLyTrucLeLB;

@property (weak, nonatomic) IBOutlet PieChartView *workInfoChartView;

- (IBAction)calendarAction:(id)sender;
- (IBAction)quanLyTrucLeAction:(id)sender;

@end
