//
//  InComeDetailInfoAndKi.m
//  SmartOffice
//
//  Created by NguyenVanTu on 6/20/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "InComeDetailInfoAndKi.h"

@interface InComeDetailInfoAndKi ()
{
    NSArray *_data;
    NSString *_title;
}
@property (weak, nonatomic) IBOutlet UILabel *lbl_SalaryTerm1;
@property (weak, nonatomic) IBOutlet UILabel *lbl_SalarySXKD;
@property (weak, nonatomic) IBOutlet UILabel *lbl_OtherSalary;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Money;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TotalPeriod;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TotalSXKD;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TotalOtherIncome;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Title;

@end

@implementation InComeDetailInfoAndKi


- (void)viewDidLoad {
    [super viewDidLoad];
    _lbl_SalaryTerm1.textColor = AppColor_MainTextColor;
    _lbl_SalarySXKD.textColor = AppColor_MainTextColor;
    _lbl_OtherSalary.textColor = AppColor_MainTextColor;
    _lbl_Money.textColor = AppColor_MainTextColor;
    
    _lbl_SalaryTerm1.text = LocalizedString(@"TTNS_IncomeDetail_Lương_kỳ_1:");
    _lbl_SalarySXKD.text = LocalizedString(@"TTNS_IncomeDetail_Lương_SXKD:");
    _lbl_OtherSalary.text = LocalizedString(@"TTNS_IncomeDetail_Thu_nhập_khác:");
    _lbl_Money.text = [NSString stringWithFormat:@"%@ %@", LocalizedString(@"TTNS_IncomeDetail_Đơn_vị_tính"), @"VNĐ"];
    [self setDataForView];
    [self setTitleForView];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)setTitleForView:(NSString *)title
{
    _title = title;
}
- (void)setDataForView:(NSArray *)data
{
    _data = data;
}
- (void)setTitleForView
{
    _lbl_Title.text = _title;
}
- (void)setDataForView
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    numberFormatter.locale = [NSLocale currentLocale];// this ensures the right separator behavior
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.usesGroupingSeparator = YES;
    [numberFormatter setGroupingSeparator:@"."];
    
    double totalOtherIncome = [_data.lastObject doubleValue]*1000000;
    double totalSXKD = [_data[(int)_data.count/2] doubleValue]*1000000;
    double totalPeriod = [_data.firstObject doubleValue]*1000000;
    _lbl_TotalOtherIncome.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithDouble:totalOtherIncome]]];
    _lbl_TotalSXKD.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithDouble:totalSXKD]]];
    _lbl_TotalPeriod.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithDouble:totalPeriod]]];
}
@end
