//
//  RegisterWatchCell.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/21/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "RegisterWatchCell.h"
#import "UIButton+BorderDefault.h"
#import "ButtonCheckBox.h"
#import "RegisterOtherFreeDay.h"
#import "TTNS_WorkList.h"
#import "CheckList.h"
#import "UIButton+BorderDefault.h"
#import "ChoiseLocationVC_iPad.h"



@interface RegisterWatchCell() <CheckListDelegate>



@end

@implementation RegisterWatchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
    
    _lbl_RegisterType.textColor = AppColor_MainTextColor;
//    _lbl_Absent.textColor = AppColor_MainTextColor;
//    _lbl_Watch.textColor = AppColor_MainTextColor;
    _lbl_WorkContent.textColor = AppColor_MainTextColor;
    _lbl_Place.textColor = AppColor_MainTextColor;
    _lbl_MoreDay.textColor = AppColor_MainTextColor;
    [_btn_WorkType setTitleColor:AppColor_MainTextColor forState:UIControlStateNormal] ;
    [_btn_WorkType setDefaultBorder];
    [_btn_MoreOption setTitleColor:AppColor_MainTextColor forState:UIControlStateNormal];
    [_btn_MoreOption setDefaultBorder];
    
    _lbl_RegisterType.text = LocalizedString(@"TTNS_RegisterWatchCell_Loại_đăng_ký");
    _lbl_Absent.text = LocalizedString(@"TTNS_RegisterWatchCell_Nghỉ");
    _lbl_Watch.text = LocalizedString(@"TTNS_RegisterWatchCell_Trực");
    _lbl_WorkContent.text = LocalizedString(@"TTNS_RegisterWatchCell_Nội_dung_công_việc");
    _lbl_Place.text = LocalizedString(@"TTNS_RegisterAbsentCell_Nơi_nghỉ");
    _lbl_MoreDay.text = LocalizedString(@"TTNS_RegisterWatchCell_Đăng_ký_thêm_ngoài_số_ngày_được_nghỉ_theo_quy_định");
    [_btn_WorkType setTitle:LocalizedString(@"TTNS_RegisterWatchCell_Chọn") forState:UIControlStateNormal];
    [_btn_MoreOption setTitle:LocalizedString(@"TTNS_RegisterWatchCell_Chưa_đăng_ký") forState:UIControlStateNormal];
    
    [_locationButton setTitle:LocalizedString(@"TTNS_RegisterWatchCell_Chon_Dia_Diem") forState:UIControlStateNormal];
    [self.locationButton setDefaultBorder];
    [self.locationButton setTitleColor:AppColor_MainTextColor forState:UIControlStateNormal];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark UI

- (void)setupUI{
//    [_ckOff2 setSelected:YES];
 
}

- (void)hideView{
    self.heightOfRegisterMoreView.constant  = 0;
    self.heightOfContentWorkView.constant   = 0;
    [self.contentWorkView setHidden:YES];
    [self.registerMoreView setHidden:YES];
}

- (void)showView{
    _heightOfContentWorkView.constant   = 70;
    _heightOfRegisterMoreView.constant  = 70;
    [self.contentWorkView setHidden:NO];
    [self.registerMoreView setHidden:NO];
}

#pragma mark - WatchDelegate
- (void) passDataString:(CheckList *)controller didFinishChooseItem:(NSString *)item {
    [self.btn_WorkType setTitle:item forState:UIControlStateNormal];
}
- (void)didFinishChoiseWorkPlace:(CheckList *)vc workPlaceId:(NSInteger)workPlaceId address:(NSString *)address
{
    
}
#pragma mark - action
- (IBAction)registerOtherFreeDay:(id)sender {
    RegisterOtherFreeDay *registerOtherFreeDay = NEW_VC_FROM_NIB(RegisterOtherFreeDay, @"RegisterOtherFreeDay");
    if(IS_PAD) {
        DLog(@"IPAD SHOW A Alert")
    } else {
        [AppDelegateAccessor.navIntegrationVC pushViewController:registerOtherFreeDay animated:YES];
    }
    
}

- (IBAction)chooseWorkContent:(UIButton *)sender {
    TTNS_WorkList *worksVC = NEW_VC_FROM_NIB(TTNS_WorkList, @"TTNS_WorkList");
    //    worksVC.delegate = self;
    if(IS_PAD){
        DLog(@"Show alert Register more");
    } else {
        [AppDelegateAccessor.navIntegrationVC pushViewController:worksVC animated:YES];
    }
}

- (void)checkRefresh {
    [_ckOff2 refresh];
    [_ckWork2 refresh];
}

- (IBAction)checkOff2:(ButtonCheckBox *)sender {
    [self checkRefresh];
    [self hideView];
    [sender setSelected:!sender.selected];
    
    [self.delegate pressButtonUnExpand:sender];
}

- (IBAction)checkWork2:(ButtonCheckBox *)sender {
    [self checkRefresh];
    [self showView];
    [sender setSelected:!sender.selected];
    [self.delegate pressButtonExpand:sender];
}

- (IBAction)LocationAction:(id)sender {
}
@end
