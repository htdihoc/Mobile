//
//  QLTT_SearchVC.m
//  SmartOffice
//
//  Created by NguyenVanTu on 6/5/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "QLTT_SearchVC.h"
#import "QLTT_DetailVC.h"
@interface QLTT_SearchVC () <QLTT_MasterViewDelegate, PassingMasterDocumentModel>

@end

@implementation QLTT_SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppDelegateAccessor.mainTabbarController.tabBar setHidden:YES];
    [self.view setBackgroundColor:AppColor_MainAppTintColor];
    self.backTitle = LocalizedString(@"QLTT_MasterVC_Tìm_kiếm");
    [self addNavView];
    self.isSearchVC = YES;
    [self addView:self.qltt_MasterView toView:self.containerView];
    [self.qltt_MasterView loadComponents];
}

- (BOOL)isSearchView
{
    return YES;
}
- (void)didSelectFilter_QLTT_MasterView:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([self checkVisibleKeyBoard]) {
        [self endEditCurrentView];
    }
    self.lastIndex = indexPath;
    [self loadDetailDocument];
    [self checkLike];
    QLTT_DetailVC *qltt_DetailVC = NEW_VC_FROM_NIB(QLTT_DetailVC, @"QLTT_DetailVC");
    qltt_DetailVC.delegate = self;
    [self.navigationController pushViewController:qltt_DetailVC animated:YES];
    
    
    
}

@end
