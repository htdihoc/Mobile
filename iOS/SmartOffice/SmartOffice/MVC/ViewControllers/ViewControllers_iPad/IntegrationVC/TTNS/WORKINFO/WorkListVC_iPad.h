//
//  WorkListVC_iPad.h
//  SmartOffice
//
//  Created by Administrator on 4/25/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BaseVC.h"
#import <Charts/Charts.h>
#import "TTNS_TimeKeepingCalendarDetailController.h"

@interface WorkListVC_iPad : BaseVC

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

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *ContentView;

@property (weak, nonatomic) IBOutlet UIButton *workInfoCenterButton;

- (IBAction)workInfoCenterAction:(id)sender;

- (IBAction)calendarAction:(id)sender;

- (IBAction)quanLyTrucLeAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *arrowRightButton;

@property (weak, nonatomic) IBOutlet UIButton *arrowLeftButton;

- (IBAction)arrowRightAction:(id)sender;

- (IBAction)arrowLeftAction:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfNotesConstraint;

@property (nonatomic) BOOL isShowCalendar;

@end
