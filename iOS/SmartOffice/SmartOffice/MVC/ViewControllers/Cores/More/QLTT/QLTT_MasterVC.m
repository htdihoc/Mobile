//
//  QLTT_MasterVC.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "QLTT_MasterVC.h"
#import "QLTT_TreeVCMode.h"
#import "QLTT_DetailVC.h"
#import "MZFormSheetController.h"
@interface QLTT_MasterVC () <UITableViewDelegate, PassingMasterDocumentModel, QLTT_MasterViewDelegate, MZFormSheetBackgroundWindowDelegate>
{
    BOOL isInitVC;
    QLTT_DetailVC *qltt_DetailVC;
}
@end

@implementation QLTT_MasterVC
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [AppDelegateAccessor.mainTabbarController.tabBar setHidden:YES];
    if (self.backTitle == nil) {
        self.backTitle = LocalizedString(@"QLTT_MasterVC_Quản_lý_tri_thức");
    }
    [self addNavView];
    [self addView:self.qltt_MasterView toView:self.containerView];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)clearContent
{
    [self clearData];
    [self.qltt_MasterView reloadTableView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //_isTreeVC to check if this VC come from TreeVC or Not
    if (self.isTreeVC == NO) {
        [self addRightBarButton];
    }
}
- (void)dismissVC:(UIGestureRecognizer *)recognizer
{
    [self endEditCurrentView];
}
- (void)didTapRightButton
{
    QLTT_TreeVCMode *treeVC = NEW_VC_FROM_NIB(QLTT_TreeVCMode, @"QLTT_TreeVCMode");
    //    treeVC.delegate = self;
    [self.navigationController pushViewController:treeVC animated:YES];
}
- (void)showError:(BOOL)success error:(NSDictionary *)error exception:(NSException *)exception
{
    [self showError:success error:error exception:exception inView:qltt_DetailVC.view == nil ? self.view : qltt_DetailVC.view];
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //check [getMasterDocumentDetailModel];
	self.lastIndex = indexPath;
    if ([self getMasterDocumentModel].secretLevel == YES) {
        [self showSecretAlert];
        return;
    }
        if ([self checkVisibleKeyBoard]) {
            [self endEditCurrentView];
        }
        else
        {
            [self setDetailModel:indexPath.row];
            [self checkLike];
            if (!qltt_DetailVC) {
                [self loadDetailDocument];
                qltt_DetailVC = NEW_VC_FROM_NIB(QLTT_DetailVC, @"QLTT_DetailVC");
                qltt_DetailVC.delegate = self;
            }
            else
            {
                [qltt_DetailVC reloaDetailData];
            }
            [self.navigationController pushViewController:qltt_DetailVC animated:YES];
        }
}
@end
