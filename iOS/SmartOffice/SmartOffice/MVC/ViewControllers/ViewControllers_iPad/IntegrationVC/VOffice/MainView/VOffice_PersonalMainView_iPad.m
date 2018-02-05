//
//  VOffice_MainView_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_PersonalMainView_iPad.h"
#import "NSException+Custom.h"
#import "SOErrorView.h"
@interface VOffice_PersonalMainView_iPad () <SOErrorViewDelegate, DataNUllDelegate>
{
    SOErrorView *_errorView;
    VOffice_WorkPlan_iPad *workPlanVC;
    VOffice_Meeting_iPad *meetingVC;
    VOffice_Document_iPad *documentVC;
}
@end

@implementation VOffice_PersonalMainView_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}
- (void)loadData
{
    if ([Common checkNetworkAvaiable]) {
        if (!self.containerWorkPlan) {
            [self addContainerNoDataViews];
        }
        if (_errorView) {
            [self hiddenErrorView:YES];
        }
        [self hiddenNoDataViews:NO];
        if ([self.delegate isSuccess]) {
            [self addContainerViews];
        }
        else
        {
            if ([self.delegate errorContent]) {
                [self showErrorViewWithMessage:LocalizedString(@"Không có dữ liệu")];
            }
            else
            {
                [self showErrorViewWithMessage:nil];
            }
        }
    }
    else
    {
        if (!self.containerWorkPlan) {
            [self hiddenNoDataViews:YES];
        }
        //[self showErrorViewWithMessage:nil];
		[[Common shareInstance] showErrorHUDWithMessage:LocalizedString(@"Mất kết nối mạng") inView:self.view];
    }
}
- (void)showErrorViewWithMessage:(NSString *)message
{
    if (!_errorView) {
        [self addNoNetworkViewWithError:message];
    }
    else
    {
        [self hiddenErrorView:NO];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![Common checkNetworkAvaiable]) {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    
}
- (void)addContainerNoDataViews
{
    [self.containerWorkPlan addSubview:[self newNoDataView]];
    [self.containerMeetingView addSubview:[self newNoDataView]];
    [self.containerDocumentView addSubview:[self newNoDataView]];
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

- (void)addNoNetworkViewWithError:(NSString *)error
{
    [self.view addSubview:[self getErrorViewWithError:error]];
}
- (SOErrorView *)getErrorViewWithError:(NSString *)errorStr
{
    _errorView = [[SOErrorView alloc] initWithFrame:self.view.bounds inforError:errorStr];
    [_errorView setBackgroundColor:[UIColor whiteColor]];
    _errorView.delegate = self;
    return _errorView;
}
- (void)removeSubViews:(UIView *)mainView
{
    for (UIView *subView in mainView.subviews) {
        [subView removeFromSuperview];
    }
}
-(UIView *)newNoDataView{
    WorkNoDataView *nodataView = [[WorkNoDataView alloc] initWithFrame:self.containerWorkPlan.bounds contentData:LocalizedString(@"VOffice_MainView_iPad_Hiện_tại_Đ/c_không có_nhiệm_vụ_nào")];
    nodataView.backgroundColor = [UIColor whiteColor];
    return nodataView;
}
- (void)addContainerViews
{
    if (!_isAddContainerViews) {
        _isAddContainerViews = YES;
        workPlanVC = NEW_VC_FROM_NIB(VOffice_WorkPlan_iPad, @"VOffice_WorkPlan_iPad");
        [self displayVC:workPlanVC container:self.containerWorkPlan];
        
        meetingVC = NEW_VC_FROM_NIB(VOffice_Meeting_iPad, @"VOffice_Meeting_iPad");
        [self displayVC:meetingVC container:self.containerMeetingView];
        
        documentVC = NEW_VC_FROM_NIB(VOffice_Document_iPad, @"VOffice_Document_iPad");
        [self displayVC:documentVC container:self.containerDocumentView];
        
    }
    else
    {
        [workPlanVC loadData];
        [meetingVC loadData];
        [documentVC loadData];
    }
    
}

- (void)dataNULL {
    
}

#pragma mark SOErrorViewDelegate
- (void)didRefreshOnErrorView:(SOErrorView *)errorView
{
    [self loadData];
}
@end
