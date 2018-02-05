//
//  ManagerInOutVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ManagerInOutVC_iPad.h"
#import "ListRegisterInOutFormVC_iPad.h"
#import "RegisterNewFormInOutVC_iPad.h"
#import "RegisterDetailVC_iPad.h"

@interface ManagerInOutVC_iPad ()<ListRegisterInOutDelegate>{
@protected NSInteger _firstEmpId;
@protected NSInteger _selectedEmpId;
@protected ListRegisterInOutFormVC_iPad *registerInOutVC;
@protected RegisterDetailVC_iPad *detailVC;
@protected RegisterNewFormInOutVC_iPad *registerNewVC;
}

@end

@implementation ManagerInOutVC_iPad

#pragma mark LifeCycler
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
    if(_firstEmpId){
        [self displayRegisterDetailVC];
    }
    
    [self setupUI];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self displayListRegisterInOutVC];
}

#pragma mark UI

- (void)initView{
    registerInOutVC = NEW_VC_FROM_NIB(ListRegisterInOutFormVC_iPad, @"ListRegisterInOutFormVC_iPad");
    registerInOutVC.delegate = self;
    
    detailVC = NEW_VC_FROM_NIB(RegisterDetailVC_iPad, @"RegisterDetailVC_iPad");
    
    registerNewVC = NEW_VC_FROM_NIB(RegisterNewFormInOutVC_iPad, @"RegisterNewFormInOutVC_iPad");
}

- (void)setupUI{
    self.title = @"";
    self.TTNS_buttonTitles = @[[[NavButton_iPad alloc]initWithTitleAndIconName:@"      " iconName:@"nav_home"], @"TTNS", LocalizedString(@"K_INFO_HUMAN_VC_MANAGER_IN_OUT")];
    self.jumpVC = - 1;
//    [self isTTNSVC:YES];
    [self addTappGesture];
}



- (void)displayListRegisterInOutVC{
    [self displayVC:registerInOutVC container:self.containerView1];
}

- (void)displayRegisterDetailVC{
    [self displayVC:detailVC container:self.containerView2];
}

- (void)displayRegisterNewFormVC{
    [self displayVC:registerNewVC container:self.containerView2];
}

#pragma mark ListRegisterInOutDelegate
- (void)pressButton:(UIButton *)sender{
    [self displayRegisterNewFormVC];
}

- (void)getSelectedEmpId:(NSInteger)empRegOutId{
    _selectedEmpId = empRegOutId;
    [detailVC loadingData:_selectedEmpId];
    [self displayRegisterDetailVC];
}

- (void)getFirstEmpId:(NSInteger)firstEmpId{
    _firstEmpId = firstEmpId;
    [detailVC loadingData:firstEmpId];
}

#pragma mark RegisterDetailVC_iPad
//- (NSInteger)getEmpRegOutId{
//    if(_selectedEmpId){
//        return _selectedEmpId;
//    }
//    return _firstEmpId;
//}


- (void)addTappGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark action
- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

@end
