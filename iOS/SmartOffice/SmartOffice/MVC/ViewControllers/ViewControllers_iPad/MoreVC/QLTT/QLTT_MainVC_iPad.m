//
//  QLTT_MasterVC_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "QLTT_MainVC_iPad.h"
#import "QLTT_DetailVC_iPad.h"
#import "QLTT_MasterVC.h"
#import "QLTT_TreeVCMode_iPad.h"
#import "WYPopoverController.h"
#import "ContentFilterVC.h"
#import "QLTT_MasterVC_iPad.h"
#import "QLTT_TreeVC_iPad.h"
#import "SOErrorView.h"
#import "Common.h"
#import "NSException+Custom.h"
@interface QLTT_MainVC_iPad () <PassingMasterDocumentModel, SOErrorViewDelegate>
{
    UILabel *explanningLabel;
    BOOL isInitVC;
    BOOL isAddRightBarButton;
    SOErrorView *_errorView;
}

@property (strong, nonatomic) QLTT_MasterVC_iPad *masterVC;
@property (strong, nonatomic) QLTT_DetailVC_iPad *detailVC;
@end

@implementation QLTT_MainVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.VOffice_buttonTitles = @[LocalizedString(@"QLTT_MasterVC_Quản_lý_tri_thức")];
    //if you use "nav_home", you will have to enter 6 spaces to the title field of nav button.
//    self.VOffice_buttonTitles = @[[[NavButton_iPad alloc] initWithTitleAndIconName:@"" iconName:@"nav_homeOnly"], LocalizedString(@"KTABBAR_ITEM_MORE_TITLE")];
    //Enable isTTNSVC variable if you want to display notification view.
//    [self isTTNSVC:YES];
//    LocalizedString(@"KTABBAR_ITEM_MORE_TITLE")
    self.disableBackIcon = YES;
    [self loadData];
    
}
- (void)loadData
{
    if ([Common checkNetworkAvaiable]) {
        [self.qltt_ContainerMasterView setHidden:NO];
        [self.qltt_MainDetailView setHidden:NO];
        if (_errorView) {
            [_errorView setHidden:YES];
        }
        [self addContainerView];
    }
    else
    {
        [self addErrorView: LocalizedString(@"Mất kết nối mạng")];
    }
}
- (void)addErrorView:(NSString *)content
{
    [self.qltt_ContainerMasterView setHidden:YES];
    [self.qltt_MainDetailView setHidden:YES];
    if (!_errorView) {
        [self addNoNetworkView];
    }
    else
    {
        [_errorView setHidden:NO];
    }
    [_errorView setErrorInfo:content];
}
- (void)setMainTitle:(NSString *)title
{
    
}
- (void)addContainerView
{
    self.masterVC = NEW_VC_FROM_NIB(QLTT_MasterVC_iPad, @"QLTT_MasterVC_iPad");
    self.masterVC.delegate = self;
    [self displayVC:self.masterVC container:self.qltt_ContainerMasterView];
    
    
    self.detailVC = NEW_VC_FROM_NIB(QLTT_DetailVC_iPad, @"QLTT_DetailVC_iPad");
    [self displayVC:self.detailVC container:self.qltt_MainDetailView];
    
    self.detailVC.detailVC.delegate = self.masterVC;
    
    
    [self.qltt_ContainerMasterView setHidden:YES];
    [self.qltt_MainDetailView setHidden:YES];
    
}
- (void)endEditCommentView
{
	[self.detailVC endEditCommentView];
}

- (void)addNoNetworkView
{
    [self.view addSubview:[self getErrorView]];
}
- (SOErrorView *)getErrorView
{

    _errorView = [[SOErrorView alloc] initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height - 70) inforError:nil];
    [_errorView setBackgroundColor:[UIColor clearColor]];
    _errorView.delegate = self;
    return _errorView;
}
- (void)pushVC:(UIViewController *)vc
{
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if(self.nav_iPad && isAddRightBarButton == NO) {
        isAddRightBarButton = YES;
        [self addRightBarButton];
    }
    
}
- (void)addRightBarButton
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 200, 44);
    [rightButton setImage:[UIImage imageNamed:@"treeMode"] forState:UIControlStateNormal];
    [self.nav_iPad addRightBarButton:rightButton];
}
- (void)hiddenDetailView:(BOOL)isHidden
{
    self.detailVC.view.hidden = isHidden;
}

- (void)didTapRightButton:(UIButton *)sender
{
    QLTT_TreeVC_iPad *treeVC = NEW_VC_FROM_NIB(QLTT_TreeVC_iPad, @"QLTT_TreeVC_iPad");
    treeVC.delegate = self;
    [self.navigationController pushViewController:treeVC animated:YES];
}

#pragma mark PassingMasterDocumentModel
- (void)loadCompleteAPI
{
    [self.qltt_ContainerMasterView setHidden:NO];
    [self.qltt_MainDetailView setHidden:NO];
}
- (void)setTile:(NSString *)title subTitle:(NSString *)subTitle
{
    if ([title isEqualToString:@""] && [subTitle isEqualToString:@""]) {
        self.detailVC.view.hidden = YES;
    }
    else
    {
        self.detailVC.view.hidden = NO;
    }
    [self.detailVC setSubTitleLabel:subTitle];
    [self.detailVC setTitleLabel:title];
    
}
- (void)didCheckLike
{
    [self dismissHub];
}
- (void)didSelectRowAt:(NSIndexPath *)indexPath
{
    if ([Common checkNetworkAvaiable]) {
        [self showLoading];
        [self.detailVC.detailVC hiddenContent:NO];
        [self.detailVC.detailVC reloadIndexDetail];
        [self.detailVC.detailVC clearCategoryData];
        [self setTile:[self.detailVC.detailVC.delegate getMasterDocumentModel].name subTitle:[NSString stringWithFormat:@"(%@ %@)",LocalizedString(@"QLTT_MasterViewCell_Phiên_bản"), [self.detailVC.detailVC.delegate getMasterDocumentModel].version]];
        [self.detailVC.detailVC createUI:0];
    }
    else
    {
        [self clearContent];
//        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.detailVC.view];
    }
}
- (NSArray *)getMasterTreeDocumentModel
{
    return [self.delegate getMasterTreeDocumentModel];
}
- (void)clearContent
{
    [self setTile:@"" subTitle:@""];
    [self.detailVC.detailVC hiddenContent:YES];
}
#pragma mark SOErrorViewDelegate
- (void)didRefreshOnErrorView:(SOErrorView *)errorView
{
    [self loadData];
}
- (void)showError:(NSException *)exception isInstant:(BOOL)isInstant ismasterQLTT:(BOOL)ismasterQLTT
{
//    if (ismasterQLTT) {
//        [self addErrorView];
//    }else
//    {
        [self handleErrorFromResult:nil withException:exception inView:self.view isInstant:isInstant];
//    }
    
}
- (void)showErrorWith:(id)result isInstant:(BOOL)isInstant ismasterQLTT:(BOOL)ismasterQLTT
{
    if (ismasterQLTT) {
        [self addErrorView: LocalizedString(@"Mất kết nối tới hệ thống")];
    }else
    {
        [self handleErrorFromResult:result withException:nil inView:self.view isInstant:isInstant];
    }
    
}
- (void)showLoading
{
    [self dismissLoading];
    [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
}
- (void)dismissLoading
{
    [self dismissHub];
}
@end
