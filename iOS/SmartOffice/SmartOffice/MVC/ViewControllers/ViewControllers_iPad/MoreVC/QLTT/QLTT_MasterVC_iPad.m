//
//  QLTT_MasterVC_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "QLTT_MasterVC_iPad.h"
#import "QLTT_TreeVCMode.h"
#import "QLTT_DetailSubVC_iPad.h"
#import "MZFormSheetController.h"
#import "Common.h"
#import "NSException+Custom.h"
@interface QLTT_MasterVC_iPad () <UITableViewDelegate, QLTT_MasterViewDelegate, MZFormSheetBackgroundWindowDelegate>
{
    BOOL isFirst;
}
@end

@implementation QLTT_MasterVC_iPad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.lastIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    [self addView:self.qltt_MasterView toView:self.containerView];
    
    // Do any additional setup after loading the view from its nib.
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
- (void)didSelectItemAt:(NSIndexPath *)indexPath
{
//    [self setMasterDocumentDetailModel:[self getMasterDocumentModel]];
    [self.delegate didSelectRowAt:indexPath];
    if (!isFirst) {
        isFirst = YES;
        [self actionAPIWhenSelectItem];
    }
    
}
- (void)actionAPIWhenSelectItem
{
    [self loadDetailDocument];
    [self checkLike];
}
- (void)didSelectFirstItem
{
    self.lastIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    [self setDetailModel:0];
    [self.qltt_MasterView selectItem:self.lastIndex];
    [self didSelectItemAt:self.lastIndex];
    
}
- (void)selectCurrentItem
{
    [self.qltt_MasterView selectItem:self.lastIndex];
    [self didSelectItemAt:self.lastIndex];
}
- (void)setTile:(NSString *)title subTitle:(NSString *)subTitle;
{
//    [self.qltt_MasterView.masterTableView.tb_QLTTList deselectRowAtIndexPath:[self.qltt_MasterView.masterTableView.tb_QLTTList indexPathForSelectedRow] animated:YES];
    if ([self.delegate respondsToSelector:@selector(setTile:subTitle:)]) {
        [self.delegate setTile:title subTitle:subTitle];
    }
}
#pragma mark QLTT_MasterViewDelegate
- (void)clearContent
{
    if ([self.delegate respondsToSelector:@selector(clearContent)]) {
        [self.delegate clearContent];
    }
    
}
- (void)showLoading
{
    if ([self.delegate respondsToSelector:@selector(showLoading)]) {
        [self.delegate showLoading];
    }
}
- (void)dismissLoading
{
    if ([self.delegate respondsToSelector:@selector(dismissLoading)]) {
        [self.delegate dismissLoading];
    }
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.lastIndex = indexPath;
    //Dòng này sẽ clear filter data bên master
//    [self clearContent];
    if (![Common checkNetworkAvaiable]) {
        if ([self.delegate respondsToSelector:@selector(showError:isInstant:ismasterQLTT:)]) {
            [self.delegate showError:[NSException initWithNoNetWork] isInstant:NO ismasterQLTT:YES];
        }
        return;
    }
    if ([self getMasterDocumentModel].secretLevel == YES) {
        [self showSecretAlert];
        return;
        
    }
	[self setDetailModel:indexPath.row];
    if (self.isTreeVC) {
        [self actionAPIWhenSelectItem];
        [self.delegate didSelectRowAt:indexPath];
    }
    else
    {
       [self didSelectItemAt:indexPath];
    }
}

@end
