//
//  QLTT_MasterVC_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "QLTT_TreeVC_iPad.h"
#import "QLTT_DetailVC_iPad.h"
#import "QLTT_MasterVC.h"
#import "QLTT_TreeVCMode_iPad.h"
#import "WYPopoverController.h"
#import "ContentFilterVC.h"
#import "QLTT_MasterVC_iPad.h"
@interface QLTT_TreeVC_iPad () <PassingMasterDocumentModel>
{
    BOOL isInitVC;
    BOOL isAddRightBarButton;
    BOOL _isActiveTreeMode;
    QLTTMasterDocumentModel *_selectedModel;
}

@property (strong, nonatomic) QLTT_MasterVC_iPad *masterVCTreeMode;
@property (strong, nonatomic) QLTT_TreeVCMode_iPad *treeVC;
@property (strong, nonatomic) QLTT_DetailVC_iPad *detailVC;
@end

@implementation QLTT_TreeVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.VOffice_title = LocalizedString(@"QLTT_MasterVC_Danh_mục_dạng_cây");
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.VOffice_buttonTitles = @[LocalizedString(@"QLTT_MasterVC_Quản_lý_tri_thức")];
    [self addTreeView];
    [self settingForLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void) dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)pushVC:(UIViewController *)vc
{
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)dismissVC:(UIGestureRecognizer *)recognizer
{
    [self endEditCurrentView];
}
- (void)addRightBarButton
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 200, 44);
    [rightButton setImage:[UIImage imageNamed:@"treeMode"] forState:UIControlStateNormal];
    [self.nav_iPad addRightBarButton:rightButton];
}

- (void)hiddenTreeDetailView:(BOOL)isHidden
{
    self.treeVC.view.hidden = isHidden;
}
- (void)hiddenTreeMasterView:(BOOL)isHidden
{
    self.masterVCTreeMode.view.hidden = isHidden;
}
- (void)hiddenExplanningLabel:(BOOL)isHidden
{
    if(_explanningLabel)
    {
        _explanningLabel.hidden = isHidden;
    }
}

- (void)addTreeView
{
    self.treeVC = NEW_VC_FROM_NIB(QLTT_TreeVCMode_iPad, @"QLTT_TreeVCMode_iPad");
    self.treeVC.delegate = self;
    [self displayVC:self.treeVC container:self.qltt_ContainerMasterView];
    
}
- (void)setTitleForSearchView:(NSString *)title
{
    self.masterVCTreeMode.qltt_MasterView.searchBar.text = title;
}
- (void)addMasterVCForTreeMode
{
    if (self.masterVCTreeMode == nil) {
        self.masterVCTreeMode = NEW_VC_FROM_NIB(QLTT_MasterVC_iPad, @"QLTT_MasterVC_iPad");
        self.masterVCTreeMode.isTreeVC = YES;
        self.masterVCTreeMode.delegate = self;
        [self displayVC:self.masterVCTreeMode container:self.qltt_MainDetailView];
        
        self.detailVC = NEW_VC_FROM_NIB(QLTT_DetailVC_iPad, @"QLTT_DetailVC_iPad");
        [self displayVC:self.detailVC container:self.qltt_MainDetailView];
        self.detailVC.detailVC.delegate = self.masterVCTreeMode;
        self.detailVC.view.hidden = YES;
        
        [_explanningLabel removeFromSuperview];
    }
    else
    {
        [self.masterVCTreeMode setDefaultValues];
        [self.masterVCTreeMode reloadAPIData:NO];
    }
}
- (void)settingForLabel
{
    _explanningLabel.text = LocalizedString(@"QLTT_DetailVC_Lựa_chọn_tài_liệu");
    _explanningLabel.textColor = AppColor_MainTextColor;
}

#pragma mark PassingMasterDocumentModel
- (void)clearContent
{
    [self.masterVCTreeMode clearData];
    [self.masterVCTreeMode.qltt_MasterView reloadTableView];
}
- (void)showError:(NSException *)exception isInstant:(BOOL)isInstant ismasterQLTT:(BOOL)ismasterQLTT
{
    [self handleErrorFromResult:nil withException:exception inView:self.view isInstant:isInstant];
}
- (void)didCheckLike
{
    [self dismissHub];
}
- (void)didSelect:(id)item
{
    QLTTMasterDocumentModel *data = item;
    _selectedModel = data;
//    self.VOffice_title = data.name;
    self.detailVC.view.hidden = YES;
    [self setTitleForSearchView:@""];
    [self addMasterVCForTreeMode];
}
- (void)setTile:(NSString *)title subTitle:(NSString *)subTitle
{
    [self.detailVC setTitleLabel:title];
    [self.detailVC setSubTitleLabel:subTitle];
}
- (void)didSelectRowAt:(NSIndexPath *)indexPath
{
    self.detailVC.view.hidden = NO;
    [self.detailVC.detailVC hiddenContent:NO];
    [self.detailVC setTitleLabel:[self.detailVC.detailVC.delegate getMasterDocumentModel].name];
    [self.detailVC setSubTitleLabel:[NSString stringWithFormat:@"(%@ %@)",LocalizedString(@"QLTT_MasterViewCell_Phiên_bản"), [self.detailVC.detailVC.delegate getMasterDocumentModel].version]];
    [self.detailVC.detailVC createUI:0];
}
- (NSArray *)getMasterTreeDocumentModel
{
    return @[_selectedModel];
}
@end
