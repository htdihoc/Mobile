//
//  VOfice_PersonalMainView_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOfice_PersonalMainView_iPad.h"
#import "SOErrorView.h"
#import "Common.h"
@interface VOfice_PersonalMainView_iPad () <SOErrorViewDelegate>
{
    SOErrorView *_errorView;
}
@end

@implementation VOfice_PersonalMainView_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}
- (void)loadData
{
    if ([Common checkNetworkAvaiable]) {
        if (_errorView) {
            [self hiddenErrorView:YES];
        }
        [self newNoDataView];
        [self addContainerViews];
    }
    else
    {
        if (!_errorView) {
            [self addNoNetworkView];
        }
        else
        {
            [self hiddenErrorView:NO];
        }
        
    }
}

- (void)addContainerNoDataViews
{
    [self.containerWorkPlan addSubview:[self newNoDataView]];
    [self.containerMeetingView addSubview:[self newNoDataView]];
    [self.containerDocumentView addSubview:[self newNoDataView]];
}
-(UIView *)newNoDataView{
    WorkNoDataView *nodataView = [[WorkNoDataView alloc] initWithFrame:self.containerWorkPlan.bounds contentData:LocalizedString(@"VOffice_MainView_iPad_Hiện_tại_Đ/c_không có_nhiệm_vụ_nào")];
    nodataView.backgroundColor = [UIColor whiteColor];
    return nodataView;
}
- (void)hiddenNoDataViews:(BOOL)hidden
{
    [self.containerWorkPlan setHidden:hidden];
    [self.containerMeetingView setHidden:hidden];
    [self.containerDocumentView setHidden:hidden];
}

- (void)hiddenErrorView:(BOOL)hidden
{
    [_errorView setHidden:hidden];
}

- (void)addNoNetworkView
{
    [self.view addSubview:[self getErrorView]];
}
- (SOErrorView *)getErrorView
{
    _errorView = [[SOErrorView alloc] initWithFrame:self.view.bounds inforError:nil];
    [_errorView setBackgroundColor:[UIColor whiteColor]];
    _errorView.delegate = self;
    return _errorView;
}
- (void)addContainerViews
{
    VOffice_WorkPlan_iPad *workPlanVC = NEW_VC_FROM_NIB(VOffice_WorkPlan_iPad, @"VOffice_WorkPlan_iPad");
    [self displayVC:workPlanVC container:self.containerWorkPlan];
    
    VOffice_Meeting_iPad *meetingVC = NEW_VC_FROM_NIB(VOffice_Meeting_iPad, @"VOffice_Meeting_iPad");
    [self displayVC:meetingVC container:self.containerMeetingView];
    
    VOffice_Document_iPad *documentVC = NEW_VC_FROM_NIB(VOffice_Document_iPad, @"VOffice_Document_iPad");
    [self displayVC:documentVC container:self.self.containerDocumentView];
}

#pragma mark SOErrorViewDelegate
- (void)didRefreshOnErrorView:(SOErrorView *)errorView
{
    [self loadData];
}
@end
