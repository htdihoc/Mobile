//
//  ConfirmInOutVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ConfirmInOutVC_iPad.h"
#import "ListCheckOutVC_iPad.h"
#import "CheckOutDetail.h"
#import "UIButton+BorderDefault.h"
#import "TTNSProcessor.h"
#import "Common.h"

@interface ConfirmInOutVC_iPad ()<DismissTimeKeepingDelegate>{
@protected BOOL _isEmpty;
}
@property DismissTimeKeeping *content;
@end

@implementation ConfirmInOutVC_iPad

#pragma mark LifeCycler
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.bottomView.layer.zPosition = 2;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    ListCheckOutVC_iPad *listCheckOutVC = NEW_VC_FROM_NIB(ListCheckOutVC_iPad, @"ListCheckOutVC_iPad");
    [self displayVC:listCheckOutVC container:self.containerView1];
    
    CheckOutDetail *checkOutDetailVC = NEW_VC_FROM_NIB(CheckOutDetail, @"CheckOutDetail");
    [self displayVC:checkOutDetailVC container:self.containerView2];
    
    checkOutDetailVC.view.layer.zPosition = 1;
    
}

#pragma mark UI
- (void)setupUI{
    //    self.VOffice_buttonTitles = @[@"TTNS", LocalizedString(@"Phê duyệt ra ngoài")];
    self.jumpVC = -1;
    self.TTNS_title = @"";
    self.TTNS_buttonTitles = @[[[NavButton_iPad alloc] initWithTitleAndIconName:@"      " iconName:@"nav_home"], @"TTNS", LocalizedString(@"Phê duyệt ra vào")];
//    [self isTTNSVC:YES];
    [self.cancelButton setBorderForButton:3 borderWidth:1 borderColor:AppColor_BorderForCancelButton.CGColor];
}

#pragma mark Action

- (void)showPopupConfirm:(void (^)(void))rightAction andLeftAction:(void (^)(void))leftAction{
    _content = [[DismissTimeKeeping alloc] initWithNibName:@"DismissTimeKeeping" bundle:nil];
    _content.delegate = self;
    [self showAlert:_content title:LocalizedString(@"TTNS_TTNSBaseSwipeView_Từ_chối_phê_duyệt") leftButtonTitle: LocalizedString(@"Huỷ") rightButtonTitle:LocalizedString(@"TTNS_CheckOut_Từ_chối") leftHander:leftAction rightHander:rightAction];
}

#pragma mark networking

#pragma mark request server
// API Approve Register In Out Form.
- (void)postApproveRegisterInOut:(NSDictionary*)params callBack:(Callback)callBack{
    [TTNSProcessor postApproveRegisterInOut:params callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}

#pragma mark IBAction

- (IBAction)confirmAction:(id)sender {
    [[Common shareInstance]showErrorHUDWithMessage:LocalizedString(@"Bản ghi đã được phê duyệt") inView:self.view];
}

- (IBAction)cancelAction:(id)sender {
    [self showPopupConfirm:^{
        if(_isEmpty){
            
        }else {
            DLog(@"Reject success");
        }
    } andLeftAction:^{
        //
    }];
}

#pragma mark DismissTimeKeepingDelegate
- (void)isEmpty:(BOOL)isEmpty{
    _isEmpty = isEmpty;
}

@end
