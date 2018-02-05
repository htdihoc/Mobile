//
//  TakeLeaveList_iPad.m
//  SmartOffice
//
//  Created by NguyenDucBien on 5/23/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TakeLeaveList_iPad.h"
#import "ListRegisterFormVC_iPad.h"
#import "CancelRegisterVC_iPad.h"
#import "NotSubmitedVC_iPad.h"
#import "DeniedRegisterVC_iPad.h"
#import "CreateNewFormVC_iPad.h"
#import "ApprovedDetailVC_iPad.h"

@interface TakeLeaveList_iPad ()<ListRegisterFormVC_iPadDelegate>{
@protected ListRegisterFormVC_iPad *registerLeaveVC;
@protected CancelRegisterVC_iPad *cancelRegisterVC_iPad;
@protected NotSubmitedVC_iPad *notSubmidtedVC_IPad;
@protected DeniedRegisterVC_iPad *deniedRegisterVC_iPad;
@protected ApprovedDetailVC_iPad *approvedDetailVC_iPad;
@protected StatusType _status;
@protected NSInteger _personalFormFirstId;
@protected NSInteger _personalFormSelectedId;
}

@end

@implementation TakeLeaveList_iPad

#pragma mark Lifecycler
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self setupUI];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self displayLeaveRegisterList];
    
}

#pragma mark UI

- (void)initView{
    registerLeaveVC             = NEW_VC_FROM_NIB(ListRegisterFormVC_iPad, @"ListRegisterFormVC_iPad");
    registerLeaveVC.delegate    = self;
    cancelRegisterVC_iPad       = NEW_VC_FROM_NIB(CancelRegisterVC_iPad, @"CancelRegisterVC_iPad");
    notSubmidtedVC_IPad         = NEW_VC_FROM_NIB(NotSubmitedVC_iPad, @"NotSubmitedVC_iPad");
    deniedRegisterVC_iPad       = NEW_VC_FROM_NIB(DeniedRegisterVC_iPad, @"DeniedRegisterVC_iPad");
    approvedDetailVC_iPad       = NEW_VC_FROM_NIB(ApprovedDetailVC_iPad, @"ApprovedDetailVC_iPad");
    
}

- (void)setupUI {
    self.TTNS_title = @"";
    self.TTNS_buttonTitles = @[[[NavButton_iPad alloc]initWithTitleAndIconName:@"      " iconName:@"nav_home"], @"TTNS", LocalizedString(@"K_INFO_HUMAN_VC_MANAGER_ABSENT")];
    self.jumpVC = -1;
    
//    [self isTTNSVC:YES];
}

- (void)displayLeaveRegisterList {
    [self displayVC:registerLeaveVC container:self.containerList];
}

- (void)displayCancelRegister{
    [self displayVC:cancelRegisterVC_iPad container:self.containerDetail];
}

- (void)displayNotSubmitedDetailVC {
    [self displayVC:notSubmidtedVC_IPad container:self.containerDetail];
}

- (void)displayDeniedDetailVC {
    [self displayVC:deniedRegisterVC_iPad container:self.containerDetail];
}

- (void)displayApprovedDetailVC {
    [self displayVC:approvedDetailVC_iPad container:self.containerDetail];
}

#pragma mark ListRegisterDelegate

- (void)getFirstPersonalFormId:(NSInteger)perzsonalFormFristId status:(StatusType)status{
    _personalFormFirstId = perzsonalFormFristId;
    _status = status;
    
    switch (_status) {
        case StatusType_SIGN:
            [self displayNotSubmitedDetailVC];
            [notSubmidtedVC_IPad loadingData:_personalFormFirstId];
            break;
        case StatusType_Refuse:
            [self displayDeniedDetailVC];
            [deniedRegisterVC_iPad loadingData:_personalFormFirstId];
            break;
        case StatusType_Approval:
            [self displayApprovedDetailVC];
            [approvedDetailVC_iPad loadingData:_personalFormFirstId];
            break;
        case StatusType_NotApproval:
            [self displayCancelRegister];
            [cancelRegisterVC_iPad loadingData:_personalFormFirstId];
            break;
        default:
            break;
    }
}

- (void)getSelectedPersonalFormId:(NSInteger)personalFormSelectedId status:(StatusType)status{
    _personalFormSelectedId = personalFormSelectedId;
    _status    = status;
    
    switch (status) {
        case StatusType_SIGN:
            [self displayNotSubmitedDetailVC];
            [notSubmidtedVC_IPad loadingData:_personalFormSelectedId];
            break;
        case StatusType_Refuse:
            [self displayDeniedDetailVC];
            [deniedRegisterVC_iPad loadingData:_personalFormSelectedId];
            break;
        case StatusType_Approval:
            [self displayApprovedDetailVC];
            [approvedDetailVC_iPad loadingData:_personalFormSelectedId];
            break;
        case StatusType_NotApproval:
            [self displayCancelRegister];
            [cancelRegisterVC_iPad loadingData:_personalFormSelectedId];
            break;
        default:
            break;
    }
}

@end
