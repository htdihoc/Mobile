//
//  VOffice_MiddelVC.m
//  SmartOffice
//
//  Created by NguyenVanTu on 8/2/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "VOffice_MiddelVC.h"
#import "Common.h"
#import "SOErrorView.h"
#import "VOffice_PersonalMainView_iPad.h"
#import "VOffice_MainView_iPad.h"
@interface VOffice_MiddelVC () <SOErrorViewDelegate, VOffice_PersonalMainView_iPadDelegate>
{
    BOOL _isSuccess;
    NSString *_errorContent;
    BOOL _isManager;
    SOErrorView *_errorView;
    VOffice_PersonalMainView_iPad *_personalVOfficeVC;
    VOffice_MainView_iPad *_vOfficeVC;
}
@end

@implementation VOffice_MiddelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainController = [[VOffice_MainController alloc] init];
    [self loadData];
}

- (void)loadData
{
    if ([Common checkNetworkAvaiable]) {
        [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
        [self.mainController loadData:^(BOOL network, BOOL success, NSException *exception, NSDictionary *error){
            [self dismissHub];
            if(success)
            {
                _isSuccess = YES;
                if ([Common isHasManagedRoleFromRoles:[SOSessionManager sharedSession].vofficeSession.userRolesArr])
                {
                    _isManager = YES;
                    [self addContainerView:_isManager];
                    
                }
                else
                {
                    _isManager = NO;
                    [self addContainerView:_isManager];
                }
            }
            else
            {
                _isSuccess = NO;
                _errorContent = LocalizedString(@"Không có dữ liệu");
                if (error != nil) {
                    [self showErrorViewWithMessage:LocalizedString(@"Không có dữ liệu")];
                    return ;
                }
                [self showErrorViewWithMessage:nil];
            }
        }];
    }
    else
    {
		[self showErrorViewWithMessage:LocalizedString(@"Mất kết nối mạng")];
    }
}
- (void)addContainerView:(BOOL)isManager
{
    if (!isManager) {
        _personalVOfficeVC = NEW_VC_FROM_NIB(VOffice_PersonalMainView_iPad, @"VOffice_PersonalMainView_iPad");
        _personalVOfficeVC.title = @"VOFFICE";
        _personalVOfficeVC.delegate = self;
        [self displayVC:_personalVOfficeVC container:self.view];
    }
    else
    {
         _vOfficeVC = NEW_VC_FROM_NIB(VOffice_MainView_iPad, @"VOffice_MainView_iPad");
        _vOfficeVC.title = @"VOFFICE";
        _vOfficeVC.delegate = self;
        [self displayVC:_vOfficeVC container:self.view];
    }
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
    //[_errorView setBackgroundColor:[UIColor clearColor]];
    _errorView.delegate = self;
    return _errorView;
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
- (void)reloadData
{
    if (!_isManager) {
        if (!_personalVOfficeVC) {
            [self loadData];
        }
        else
        {
            [_personalVOfficeVC loadData];
        }
        
    }
    else
    {
        if (!_vOfficeVC) {
            [self loadData];
        }
        else
        {
            [_vOfficeVC loadData];
        }
    }
}
#pragma mark VOffice_PersonalMainView_iPadDelegate
- (BOOL)isSuccess
{
    return _isSuccess;
}

- (NSString *)errorContent
{
    return _errorContent;
}
#pragma mark SOErrorViewDelegate
- (void)didRefreshOnErrorView:(SOErrorView *)errorView
{
    [self loadData];
}
@end
