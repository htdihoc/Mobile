//
//  BirthLeaveFormVC.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BirthLeaveFormVC.h"
#import "ChoiseUserVC.h"

@interface BirthLeaveFormVC ()

@end

@implementation BirthLeaveFormVC

#pragma mark lifeCycler
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];
    [self setupUI];
    self.backTitle = @"Xin nghỉ vợ sinh con";
}

#pragma mark UI
-(void)setupUI{
    self.timeButton.layer.borderColor           = AppColor_BorderForView.CGColor;
    self.locationTV.layer.borderColor           = AppColor_BorderForView.CGColor;
    self.handoverView.layer.borderColor         = AppColor_BorderForView.CGColor;
    self.managerView.layer.borderColor          = AppColor_BorderForView.CGColor;
    
    [self.handOverUserView setHidden:YES];
    [self.managerUserView setHidden:YES];
    [self setupTitleForLB];
    [self addTappGesture];
}

- (void)setupTitleForLB{
    self.timeLB.text                            = LocalizedString(@"TTNS_THOI_GIAN_NGHI");
    self.locationLB.text                        = LocalizedString(@"TTNS_NOI_NGHI");
    self.phoneNumberLB.text                     = LocalizedString(@"TTNS_SDT");
    self.handOverUserLB.text                    = LocalizedString(@"TTNS_NGUOI_DUOC_BAN_GIAO");
    self.choiseHandOverLB.text                  = [NSString stringWithFormat:@"- %@ -",LocalizedString(@"TTNS_CHON_NGUOI_BAN_GIAO")];
    self.managerUserLB.text                     = LocalizedString(@"TTNS_CHI_HUY_DON_VI");
    self.choiseManagerLB.text                   = [NSString stringWithFormat:@"- %@ -",LocalizedString(@"TTNS_CHON_CHI_HUY_DON_VI")];
    
    [self.ghiLaiButton setTitle:LocalizedString(@"TTNS_GHI_LAI") forState:UIControlStateNormal];
    [self.trinhKyButton setTitle:LocalizedString(@"TTNS_TRINH_KY") forState:UIControlStateNormal];
}

- (void)addTappGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark Action
- (void)dismissKeyboard{
    [self.view endEditing:YES];
}


#pragma mark IBAction
- (IBAction)handOverAction:(id)sender {
    ChoiseUserVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChoiseUserVC"];
    [AppDelegateAccessor.navIntegrationVC pushViewController:vc animated:YES];
}

- (IBAction)managerAction:(id)sender {
    ChoiseUserVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChoiseUserVC"];
    [AppDelegateAccessor.navIntegrationVC pushViewController:vc animated:YES];
}

- (IBAction)ghiLaiAction:(id)sender {
}

- (IBAction)trinhKyAction:(id)sender {
}
@end
