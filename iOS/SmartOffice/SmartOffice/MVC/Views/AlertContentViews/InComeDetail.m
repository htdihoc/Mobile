//
//  ViewController.m
//  autolayout
//
//  Created by Admin on 4/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "InComeDetail.h"
#import "InfoHumanVC.h"

@interface InComeDetail ()
{
    NSArray *_data;
    double vndTotalOtherIncome;
    double vndTotalSXKD;
    double vndTotalPeriod;
    double totalInCome;
}
@property (weak, nonatomic) IBOutlet UILabel *lbl_SalaryTerm1;
@property (weak, nonatomic) IBOutlet UILabel *lbl_SalarySXKD;
@property (weak, nonatomic) IBOutlet UILabel *lbl_OtherSalary;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Sum;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Money;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TotalPeriod;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TotalSXKD;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TotalOtherIncome;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Total;

@end

@implementation InComeDetail


- (void)viewDidLoad {
    [super viewDidLoad];
    _lbl_SalaryTerm1.textColor = AppColor_MainTextColor;
    _lbl_SalarySXKD.textColor = AppColor_MainTextColor;
    _lbl_OtherSalary.textColor = AppColor_MainTextColor;
    _lbl_Sum.textColor = AppColor_MainTextColor;
    _lbl_Money.textColor = AppColor_MainTextColor;
    
    _lbl_SalaryTerm1.text = LocalizedString(@"TTNS_IncomeDetail_Lương_kỳ_1:");
    _lbl_SalarySXKD.text = LocalizedString(@"TTNS_IncomeDetail_Lương_SXKD:");
    _lbl_OtherSalary.text = LocalizedString(@"TTNS_IncomeDetail_Thu_nhập_khác:");
    _lbl_Sum.text = LocalizedString(@"TTNS_IncomeDetail_Tổng");
    _lbl_Money.text = [NSString stringWithFormat:@"%@: %@", LocalizedString(@"TTNS_IncomeDetail_Đơn_vị_tính"), @"VNĐ"];
    
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    numberFormatter.locale = [NSLocale currentLocale];// this ensures the right separator behavior
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.usesGroupingSeparator = YES;
    [numberFormatter setGroupingSeparator:@"."];
    _lbl_TotalOtherIncome.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithDouble:vndTotalOtherIncome]]];
    _lbl_TotalSXKD.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithDouble:vndTotalSXKD]]];
    _lbl_TotalPeriod.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithDouble:vndTotalPeriod]]];
    _lbl_Total.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithDouble:totalInCome]]];
 //   [self setDataForView];
    // Do any additional setup after loading the view, typically from a nib. 
}

//- (void)setDataForView:(NSArray *)data
//{
//    _data = data;
//}
//- (void)setDataForView
//{
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
//    numberFormatter.locale = [NSLocale currentLocale];// this ensures the right separator behavior
//    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
//    numberFormatter.usesGroupingSeparator = YES;
//    [numberFormatter setGroupingSeparator:@"."];
//    
//    double totalOtherIncome = [_data.firstObject doubleValue]*1000000;
//    double totalSXKD = [_data[(int)_data.count/2] doubleValue]*1000000;
//    double totalPeriod = [_data.lastObject doubleValue]*1000000;
//    double totalInCome = totalOtherIncome + totalSXKD + totalPeriod;
//    _lbl_TotalOtherIncome.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithDouble:totalOtherIncome]]];
//    _lbl_TotalSXKD.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithDouble:totalSXKD]]];
//    _lbl_TotalPeriod.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithDouble:totalPeriod]]];
//    _lbl_Total.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithDouble:totalInCome]]];
//}

- (void)setDataForView:(double)totalOtherIncome totalSXKD:(double)totalSXKD totalPeriod:(double)totalPeriod
{
    
    vndTotalOtherIncome = totalOtherIncome*1000000;
    vndTotalSXKD = totalSXKD*1000000;
    vndTotalPeriod = totalPeriod*1000000;
    totalInCome = vndTotalOtherIncome + vndTotalSXKD + vndTotalPeriod;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
