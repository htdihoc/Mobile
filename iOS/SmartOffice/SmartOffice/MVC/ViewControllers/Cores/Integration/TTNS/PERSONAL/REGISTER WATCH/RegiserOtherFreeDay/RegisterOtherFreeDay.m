//
//  RegisterInformation.m
//  AdditionalRegistrationInformation
//
//  Created by NguyenDucBien on 4/17/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import "RegisterOtherFreeDay.h"
#import "UIButton+BorderDefault.h"
#import "UIView+BorderView.h"
@interface RegisterOtherFreeDay ()
@property (weak, nonatomic) IBOutlet UILabel *lbl_StartDay;
@property (weak, nonatomic) IBOutlet UILabel *lbl_EndDay;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Reason;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Place;

@end

@implementation RegisterOtherFreeDay

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.preferredContentSize = CGSizeMake(100, 100);
    self.backTitle = LocalizedString(@"TTNS_RegisterOtherFreeDay_Thông_tin_đăng_ký_thêm");
    [self setBorder];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupTextForViews
{
    _lbl_StartDay.textColor = AppColor_MainTextColor;
    _lbl_EndDay.textColor = AppColor_MainTextColor;
    _lbl_Reason.textColor = AppColor_MainTextColor;
    _lbl_Place.textColor = AppColor_MainTextColor;
    
    _lbl_StartDay.text = LocalizedString(@"TTNS_RegisterOtherFreeDay_Nghỉ_trước_từ");
    _lbl_EndDay.text = LocalizedString(@"TTNS_RegisterOtherFreeDay_Nghỉ_sau_từ");
    _lbl_Reason.text = LocalizedString(@"TTNS_RegisterOtherFreeDay_Nhập_lý_do_chi_tiết");
    _lbl_Place.text = LocalizedString(@"TTNS_RegisterOtherFreeDay_Nơi_nghỉ");
    
}
- (void)setBorder {
    [_btnTimeBeforeOff setTitleColor:AppColor_MainTextColor forState:UIControlStateNormal];
    [_btnTimeAfterOff setTitleColor:AppColor_MainTextColor forState:UIControlStateNormal];
    _textViewContentReason.textColor = AppColor_MainTextColor;
    
    [_btnTimeBeforeOff setDefaultBorder];
    [_btnTimeAfterOff setDefaultBorder];
    [_textViewContentReason setBorderForView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendRegisterAction:(id)sender {
}
@end
