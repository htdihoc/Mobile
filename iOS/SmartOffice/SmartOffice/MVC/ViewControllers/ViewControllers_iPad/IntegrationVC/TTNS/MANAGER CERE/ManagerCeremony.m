//
//  ManagerCeremony.m
//  SmartOffice
//
//  Created by Administrator on 5/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ManagerCeremony.h"
#import "ListRegisterCereVC_iPad.h"
#import "CereDetailFormVC_iPad.h"

@interface ManagerCeremony ()
{
@protected ListRegisterCereVC_iPad *listRegisterCereVC;
@protected CereDetailFormVC_iPad *cereDetailFormVC;
}
@end

@implementation ManagerCeremony

#pragma mark Lifecycler

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark UI
- (void)setupUI{
    self.TTNS_title     = @"";
    self.TTNS_buttonTitles = @[[[NavButton_iPad alloc] initWithTitleAndIconName:@"      " iconName:@"nav_home"], @"TTNS", LocalizedString(@"TTNS_UserManagement_Quản_lý_trực_lễ")];
    //    Enable isTTNSVC variable if you want to display notification view.
//    [self isTTNSVC:YES];
    self.jumpVC = -1;
//    [self addTappGesture];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    listRegisterCereVC = NEW_VC_FROM_NIB(ListRegisterCereVC_iPad, @"ListRegisterCereVC_iPad");
    [self displayVC:listRegisterCereVC container:self.containerView1];
    
    cereDetailFormVC = NEW_VC_FROM_NIB(CereDetailFormVC_iPad, @"CereDetailFormVC_iPad");
    [self displayVC:cereDetailFormVC container:self.containerView2];
}


- (void)addTappGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark action
- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

@end
