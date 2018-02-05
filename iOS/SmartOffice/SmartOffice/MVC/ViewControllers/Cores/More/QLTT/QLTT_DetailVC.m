//
//  QLTT_DetailView.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "QLTT_DetailVC.h"
#import "Common.h"
#import "NSException+Custom.h"

static CGFloat kHeightStatusAndNavigationBar = 64.0;

@implementation QLTT_DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backTitle = LocalizedString(@"QLTT_DetailVC_Chi_tiết_tài_liệu");
    [self addNavView];
    [self reloaDetailData];
    
}

- (void)reloaDetailData
{
    if ([Common checkNetworkAvaiable]) {
        [self createUI:kHeightStatusAndNavigationBar];
    }
    else
    {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}
@end
