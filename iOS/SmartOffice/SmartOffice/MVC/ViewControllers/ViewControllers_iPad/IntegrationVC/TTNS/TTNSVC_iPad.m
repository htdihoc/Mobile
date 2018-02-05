//
//  TTNSVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNSVC_iPad.h"
#import "WorkListVC_iPad.h"
#import "IncomeInfoVC_iPad.h"
#import "KIInfoVC_iPad.h"
#import "NSException+Custom.h"
#import "Common.h"
#import "SOErrorView.h"

@interface TTNSVC_iPad ()<SOErrorViewDelegate>{
    
}

@end

@implementation TTNSVC_iPad

#pragma mark LifeCycler

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![Common checkNetworkAvaiable]) {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}

#pragma mark UI

- (void)addViews{
    if ([Common checkNetworkAvaiable]) {
        WorkListVC_iPad *workListVC         = NEW_VC_FROM_NIB(WorkListVC_iPad, @"WorkListVC_iPad");
        IncomeInfoVC_iPad *inComeInfoVC     = NEW_VC_FROM_NIB(IncomeInfoVC_iPad, @"IncomeInfoVC_iPad");
        KIInfoVC_iPad *kiInfoVC             = NEW_VC_FROM_NIB(KIInfoVC_iPad, @"KIInfoVC_iPad");
        
        [self displayVC:workListVC container:self.containerView1];
        [self displayVC:inComeInfoVC container:self.containerView2];
        [self displayVC:kiInfoVC container:self.containerView3];
    } else {
        [self showNotConnectedView];
    }
}

- (void)showNotConnectedView{
    SOErrorView *errorView = (SOErrorView*)([[UINib nibWithNibName:@"SOErrorView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    
    errorView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    errorView.backgroundColor = AppColor_MainAppBackgroundColor;
    errorView.delegate  = self;
    [self.view addSubview:errorView];
}

#pragma mark SOErrorViewDelegate
- (void)didRefreshOnErrorView:(SOErrorView *)errorView{
    [self addViews];
}

@end
