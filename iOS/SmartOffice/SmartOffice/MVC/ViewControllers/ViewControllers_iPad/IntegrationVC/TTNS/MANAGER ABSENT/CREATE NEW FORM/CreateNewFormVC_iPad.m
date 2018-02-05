//
//  CreateNewFormVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "CreateNewFormVC_iPad.h"
#import "RegisterFormVC_iPad.h"
#import "ListRegisterTakeLeave.h"
#import "RegisterFurloughDetail.h"
#import "RegisterPrivateWorkDetail.h"
#import "RegisterSickLeaveDetail.h"
#import "RegisterWifeSpawnDetail.h"

typedef enum {
    RegisterTakeLeaveType_Furlough = 0,
    RegisterTakeLeaveType_PrivateWork,
    RegisterTakeLeaveType_SickLeave,
    RegisterTakeLeaveType_ChildSick,
    RegisterTakeLeaveType_WifeSpawn,
} reason;

@interface CreateNewFormVC_iPad (){
@protected ListRegisterTakeLeave *listOffVC;
@protected RegisterFurloughDetail *detailFurloughVC;
@protected RegisterPrivateWorkDetail *detailPrivateWorkVC;
@protected RegisterSickLeaveDetail *detailSickLeaveVC;
@protected RegisterWifeSpawnDetail *detailWifeSpawnsVC;
}


@end

@implementation CreateNewFormVC_iPad

#pragma mark LifeCycler
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
}

#pragma mark UI

- (void)setupUI{
//    self.VOffice_title     = @"";
//    self.VOffice_buttonTitles = @[[[NavButton_iPad alloc]initWithTitleAndIconName:@"      " iconName:@"nav_home"], @"T.T.N.S", LocalizedString(@"QL Nghỉ phép"), LocalizedString(@"Tạo mới đơn xin nghỉ")];
    
    self.TTNS_title          = @"";
     self.TTNS_buttonTitles = @[[[NavButton_iPad alloc]initWithTitleAndIconName:@"      " iconName:@"nav_home"], @"TTNS", LocalizedString(@"QL Nghỉ phép"), LocalizedString(@"Tạo mới đơn xin nghỉ")];
    
    self.jumpVC = -1;
    [self isTTNSVC:YES];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self addContainerListOffView];
    [self addContainerFurloughViews];
}


- (void)passingData:(ListRegisterTakeLeave *)controller didFinishChooseItem:(NSInteger)item {
    DLog(@"%ld",(long)item);
    [self.view endEditing:YES];
    if (item == RegisterTakeLeaveType_Furlough) {
        [self addContainerFurloughViews];
    } else if (item == RegisterTakeLeaveType_PrivateWork) {
        [self addContainerPrivateWorkViews];
    } else if (item == RegisterTakeLeaveType_SickLeave || item == RegisterTakeLeaveType_ChildSick) {
        [self addContainerSickLeaveViews];
    } else if (item == RegisterTakeLeaveType_WifeSpawn) {
        [self addContainerWifeSpawnsViews];
    }
}



- (void)addContainerListOffView {
    
    listOffVC = [[ListRegisterTakeLeave alloc] initWithNibName:@"ListRegisterTakeLeave" bundle:nil];
    listOffVC.delegate = self;
    [self displayVC:listOffVC container:self.containerView1];
}

- (void)addContainerFurloughViews {
    detailFurloughVC = [[RegisterFurloughDetail alloc] initWithNibName:@"RegisterFurloughDetail" bundle:nil];
    [self displayVC:detailFurloughVC container:self.containerView2];
}

- (void)addContainerPrivateWorkViews {
    detailPrivateWorkVC = [[RegisterPrivateWorkDetail alloc] initWithNibName:@"RegisterPrivateWorkDetail" bundle:nil];
    [self displayVC:detailPrivateWorkVC container:self.containerView2];
}

- (void)addContainerSickLeaveViews {
    detailSickLeaveVC = [[RegisterSickLeaveDetail alloc] initWithNibName:@"RegisterSickLeaveDetail" bundle:nil];
    [self displayVC:detailSickLeaveVC container:self.containerView2];
}

- (void)addContainerWifeSpawnsViews {
    detailWifeSpawnsVC = [[RegisterWifeSpawnDetail alloc] initWithNibName:@"RegisterWifeSpawnDetail" bundle:nil];
    [self displayVC:detailWifeSpawnsVC container:self.containerView2];
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
