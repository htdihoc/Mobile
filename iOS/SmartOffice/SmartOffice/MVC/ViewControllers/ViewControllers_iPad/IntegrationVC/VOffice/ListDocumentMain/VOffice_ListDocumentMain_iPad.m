//
//  VOffice_ListDocumentMain.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_ListDocumentMain_iPad.h"
#import "ContentFilterVC.h"
#import "WYPopoverController.h"
#import "NSException+Custom.h"
#import "Common.h"
#import "NSException+Custom.h"
@interface VOffice_ListDocumentMain_iPad () <VOfficeProtocol, WYPopoverControllerDelegate, ContentFilterVCDelegate>{
    WYPopoverController* popoverController;
    NSIndexPath *_lastIndex;
    BOOL _canShowDetail;
}
@property(strong, nonatomic) VOffice_DocumentTypicalDetail_iPad *documentTypicalProfileDetail;
@property(strong, nonatomic) VOffice_DocumentDetail_iPad *documentDetail;
@end

@implementation VOffice_ListDocumentMain_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = AppColor_MainAppBackgroundColor;
    self.VOffice_title = LocalizedString(@"VOffice_ListDocumentMain_iPad_Danh_sách_văn_bản") ;
    self.VOffice_subTitle = [self getSubString];
    self.VOffice_buttonTitles = @[@"VOffice"];
    [self addContainerViews];
    
}

- (NSString *)getSubString
{
    switch ([self.delegate docType]) {
        case DocType_Waiting:
            return LocalizedString(@"VOffice_DocumentCell_iPad_Chờ_ký_duyệt");
        case DocType_Flash:
            return LocalizedString(@"VOffice_DocumentCell_iPad_Ký_nháy");
        default:
            return LocalizedString(@"VOffice_DocumentCell_iPad_Hoả_tốc");
    }
}

- (void)addContainerViews
{
    _documentDetail = NEW_VC_FROM_NIB(VOffice_DocumentDetail_iPad, @"VOffice_DocumentDetail_iPad");
    _documentDetail.delegate = self;
    [self displayVC:_documentDetail container:self.listDocument];
    
    _documentTypicalProfileDetail = NEW_VC_FROM_NIB(VOffice_DocumentTypicalDetail_iPad, @"VOffice_DocumentTypicalDetail_iPad");
    _documentTypicalProfileDetail.delegate = self;
    [self displayVC:_documentTypicalProfileDetail container:self.listDocumentDetail];
    
    
}

#pragma mark VOfficeProtocol
- (void)setCanShowDetail:(BOOL)show
{
    _canShowDetail = show;
}
- (void)hiddenBottomView:(BOOL)isHidden
{
    [_documentTypicalProfileDetail.view setHidden:isHidden];
    [super hiddenBottomView:isHidden];
}
- (BOOL)canShowDetail
{
    return _canShowDetail;
}
- (void)showLoading
{
    [self showHUDWithTitle:LocalizedString(@"Loading...") inView:self.view];
}
- (void)removeDetailContentLabel
{
    [_documentDetail removeContentLabel];
}
- (void)dismissLoading
{
    [self dismissHub];
}
- (void)showError:(id)result withException:(NSException *)exception
{
    [self handleErrorFromResult:result withException:exception inView:self.view isInstant:NO];
}
- (void)showNetworkNotAvailable
{
    [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view isInstant:NO];
}
- (DocType)docType
{
    if (self.delegate) {
        return [self.delegate docType];
    }
    return 0;
}
- (NSIndexPath *)lastIndex
{
    return _lastIndex;
}
- (void)didSelectDocWithID:(NSString *)docId
{
    if ([Common checkNetworkAvaiable]) {
        [self.documentTypicalProfileDetail loadData:docId];
    }
    else
    {
        [self reloadTypicalDetailView];
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    
}

- (void)reloadTypicalDetailView
{
    [_documentTypicalProfileDetail clearData];
    [_documentTypicalProfileDetail reloadData];
}
- (void)didSelectVOffice
{
    DLog(@"Tới VOffice");
}
- (void)endEditVC
{
    [self endEditCurrentView];
}
#pragma mark FilterAction
- (void)didSelectFilterButton:(UIButton *)sender
{
	[self endEditVC];
    if (popoverController.popoverVisible) {
        [popoverController dismissPopoverAnimated:YES];
        return;
    }
    NSArray *contentFilter = @[LocalizedString(@"VOffice_ListDocumentMain_iPad_Văn_bản_chờ_ký_duyệt"), LocalizedString(@"VOffice_ListDocumentMain_iPad_văn_bản_ký_nháy"), LocalizedString(@"VOffice_ListDocumentMain_iPad_Văn_bản_hoả_tốc")];
    ContentFilterVC *filterVC = [[ContentFilterVC alloc] initWithFilterSelected:[self.delegate docType] content:contentFilter];
    filterVC.delegate = self;
    popoverController = [[WYPopoverController alloc] initWithContentViewController:filterVC];
    popoverController.delegate = self;
    [popoverController setPopoverContentSize:filterVC.view.frame.size];
    [popoverController presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
}

#pragma mark - WYPopoverController Delegate
- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    popoverController.delegate = nil;
    popoverController = nil;
}

#pragma mark - ContentFilterVCDelegate
- (void)didSelectedFilterVC:(ContentFilterVC *)filterVC withFilterType:(NSInteger)filterType{
    if ([self.delegate docType] == filterType) {
        return;
    }
    //Reload data here
//    _searchBar.text = @"";
    [self.delegate setDocType:filterType];
    self.VOffice_subTitle = [self getSubString];
    [popoverController dismissPopoverAnimated:YES];
    //Call API Refresh data here
    [self.documentDetail reloadDataWhenFilter];
}
@end
