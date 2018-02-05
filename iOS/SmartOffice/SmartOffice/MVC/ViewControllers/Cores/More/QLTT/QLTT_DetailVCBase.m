//
//  QLTT_DetailVCBase.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "QLTT_DetailVCBase.h"
#import "QLTT_InfoDetailController.h"
#import "Common.h"
#import "NSException+Custom.h"


@interface QLTT_DetailVCBase () <CAPSPageMenuDelegate, PassingMasterDocumentModel>
{
    QLTT_DetailInfoNormalVC *_detailInfoNormalVC;
    QLTT_InfoDetailVC *_detailVC;
    QLTT_CommentVC *_commentVC;
    QLTT_InfoDetailController *qltt_InfoDetailController;
    CGFloat _segmentHeight;
    CGFloat _margin;
    UIView *containerView;
    
@protected UISegmentedControl *_segmentedControl;
}
@property(strong, nonatomic) QLTTMasterDocumentModel *lastModel;
@end

@implementation QLTT_DetailVCBase


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setHidden:YES];
    //    self.backTitle = LocalizedString(@"QLTT_DetailVC_Chi_tiết_tài_liệu");
    //    [self addNavView];
    _segmentHeight = 36;
    _margin = 1;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isPushPreview = NO;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (!self.isPushPreview) {
        [_detailInfoNormalVC clearCategoryData];
        [_pageMenu moveToPage:0];
    }
    
}
- (QLTTMasterDocumentModel *)lastModel
{
    _lastModel = [self.delegate getMasterDocumentDetailModel];
    return _lastModel;
}
- (void)addContaintnerView:(CGFloat)spaceTop
{
    if (containerView) {
        return;
    }
    containerView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:containerView];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *top= [NSLayoutConstraint
                              constraintWithItem:containerView
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:spaceTop];
    NSLayoutConstraint *bottom = [NSLayoutConstraint
                                  constraintWithItem:containerView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual toItem:self.view
                                  attribute:NSLayoutAttributeBottom multiplier:1.0f
                                  constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint
                                constraintWithItem:containerView
                                attribute:NSLayoutAttributeLeft
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view attribute:
                                NSLayoutAttributeLeft multiplier:1.0
                                constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint
                                 constraintWithItem:containerView
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.view attribute:
                                 NSLayoutAttributeRight multiplier:1.0
                                 constant:0];
    
    /* 4. Add the constraints to button's superview*/
    [self.view addConstraints:@[top, left, bottom, right]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard:)];
    [containerView addGestureRecognizer:tap];
    
    
    
}
- (void)endEditCommentView
{
    [_commentVC endEditCommentView];
}
- (void)clearCategoryData
{
    [_detailInfoNormalVC clearCategoryData];
}
- (void)reloadData
{
    DLog(@"reloadData");
}
- (void)dismissKeyboard:(UIGestureRecognizer *)recognizer
{
    
    if ([self.delegate respondsToSelector:@selector(dismissVC:)])
    {
        [self.delegate dismissVC:recognizer];
    }
}
- (void)createUI:(CGFloat)spaceTop{
    [self addContaintnerView:spaceTop];
    [self setupPageMenu:spaceTop];
    
}
- (void)hiddenContent:(BOOL)isHidden
{
    if (IS_IPAD) {
        self.view.hidden = isHidden;
    }
    if (_pageMenu) {
        _pageMenu.view.hidden = isHidden;
    }
    else
    {
        if (isHidden == NO) {
            [_segmentedControl setSelectedSegmentIndex:0];
            [self setupWhenSelectingFirstStack];
        }
        _detailInfoNormalVC.view.hidden = isHidden;
        _detailVC.view.hidden = isHidden;
        _commentVC.view.hidden = isHidden;
    }
    
}
- (void)reloadDataDetail
{
    [_detailInfoNormalVC reloadData: NO];
    [_detailVC reloadData];
    [_commentVC reloadData: NO];
}
- (void)reloadIndexDetail
{
    [_detailInfoNormalVC reloadLastIndex];
}
- (void)setupPageMenu:(CGFloat)spaceTop{
    if (IS_IPAD) {
        if (_segmentedControl == nil) {
            [self setupPageMenu_iPad:spaceTop];
        }
        else
        {
            [self reloadViewWith:spaceTop];
        }
    } else {
        if (!_pageMenu) {
            [self setupPageMenu_iPhone:spaceTop];
        }
        else
        {
            [self reloadViewWith:spaceTop];
        }
    }
}

- (void)setupPageMenu_iPhone:(CGFloat)spaceTop {
    NSMutableArray *controllerArray = [NSMutableArray array];
    
    _detailInfoNormalVC = NEW_VC_FROM_NIB(QLTT_DetailInfoNormalVC, @"QLTT_DetailInfoNormalVC");
    _detailInfoNormalVC.delegate = self;
    _detailInfoNormalVC.title = LocalizedString(@"QLTT_DetailVC_Thông_tin_chung");
    [controllerArray addObject:_detailInfoNormalVC];
    
    _detailVC = NEW_VC_FROM_NIB(QLTT_InfoDetailVC, @"QLTT_InfoDetailVC");
    _detailVC.delegate = self;
    _detailVC.title = LocalizedString(@"QLTT_DetailVC_Thông_tin_chi_tiết");
    [controllerArray addObject:_detailVC];
    
    _commentVC = NEW_VC_FROM_NIB(QLTT_CommentVC, @"QLTT_CommentVC");
    _commentVC.delegate = self;
    _commentVC.title = LocalizedString(@"QLTT_DetailVC_Ý_kiến_đọc");
    
    
    
    [controllerArray addObject:_commentVC];
    
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionUseMenuLikeSegmentedControl: @(YES),
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: AppColor_MainAppTintColor,
                                 CAPSPageMenuOptionMenuItemSeparatorRoundEdges:@(YES),CAPSPageMenuOptionMenuItemSeparatorPercentageHeight: @(0.5),
                                 CAPSPageMenuOptionMenuItemSeparatorWidth:@(1.0),
                                 CAPSPageMenuOptionAddBottomMenuHairline:@(YES),
                                 CAPSPageMenuOptionBottomMenuHairlineColor:AppColor_MainAppTintColor,
                                 CAPSPageMenuOptionMenuItemSeparatorColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor: [UIColor whiteColor]
                                 };
    // Initialize page menu with controller array, frame, and optional parameters
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, spaceTop, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - spaceTop) options:parameters];
    
    _pageMenu.view.backgroundColor = [UIColor clearColor];
    _pageMenu.delegate = self;
    _pageMenu.menuItemSeparatorRoundEdges = YES;
    _pageMenu.enableHorizontalBounce = YES;
    _pageMenu.controllerScrollView.scrollEnabled = YES;
    [self displayVC:_pageMenu container:containerView];
    //    [self.view addSubview:_pageMenu.view];
}
- (void)setupWhenSelectingFirstStack
{
    [_detailVC.view setHidden:YES];
    [_commentVC.view setHidden:YES];
}
- (void)setupPageMenu_iPad:(CGFloat)spaceTop {
    [self addSegmentControl:spaceTop];
    [self addComentVC:spaceTop];
    [self addDetailVC:spaceTop];
    [self addDetailInfoNormalVC:spaceTop];
    [self setupWhenSelectingFirstStack];
    
    
}
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    if (_pageMenu) {
//        [_pageMenu moveToPage:0];
//    }
//}
- (void)reloadViewWith:(CGFloat)spaceTop
{
    //_cts_Top.constant = spaceTop + _margin;
    //_detailInfoNormalVC.view.frame = CGRectMake(0, spaceTop + _segmentHeight + _margin, self.view.frame.size.width, self.view.frame.size.height - spaceTop - _segmentHeight - _margin);
    //_detailVC.view.frame = CGRectMake(0, spaceTop + _segmentHeight + 2*_margin, self.view.frame.size.width, self.view.frame.size.height - spaceTop - _segmentHeight - 2*_margin);
    //_commentVC.view.frame = CGRectMake(0, spaceTop + _segmentHeight + 2*_margin, self.view.frame.size.width, self.view.frame.size.height - spaceTop - _segmentHeight - 2*_margin);
    [self reloadDataDetail];
    
}
- (NSInteger)getSegmentNumber;
{
    return 3;
}
- (void)setSegment:(NSInteger)index
{
    [_segmentedControl setSelectedSegmentIndex:index];
}
- (void)addSegmentControl:(CGFloat)spaceTop {
    NSArray *itemsArray = [NSMutableArray arrayWithObjects:
                           LocalizedString(@"QLTT_DetailVC_Thông_tin_chung"),
                           LocalizedString(@"QLTT_DetailVC_Thông_tin_chi_tiết"),
                           LocalizedString(@"QLTT_DetailVC_Ý_kiến_đọc"), nil];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:itemsArray];
    _segmentedControl.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, _segmentHeight);
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    _segmentedControl.clipsToBounds = YES;
    _segmentedControl.layer.cornerRadius = 4;
    [_segmentedControl addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.selectedSegmentIndex = 0;
    [[UISegmentedControl appearance] setTintColor:AppColor_MainAppTintColor];
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:AppFont_MainFontWithSize(13), NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} forState:UIControlStateNormal];
    [self.view addSubview:_segmentedControl];
    
    _segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *left    = [NSLayoutConstraint constraintWithItem:_segmentedControl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *cts_Top  = [NSLayoutConstraint
                                    constraintWithItem:_segmentedControl
                                    attribute:NSLayoutAttributeTop
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                    attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                    constant:0.0];
    NSLayoutConstraint *height  = [NSLayoutConstraint constraintWithItem:_segmentedControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:_segmentHeight];
    NSLayoutConstraint *right  = [NSLayoutConstraint constraintWithItem:_segmentedControl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self.view addConstraints:@[left, cts_Top, height, right]];
    
}

- (void)switchView:(UISegmentedControl *)segment{
    [self didSelectSegmentAtIndex:segment.selectedSegmentIndex];
    [self endEditCurrentView];
    [self reloadDataWith:segment.selectedSegmentIndex];
}
- (void)didSelectSegmentAtIndex:(NSInteger)index
{
    _currentSegmentIndex = index;
}
-(void)swipeleft
{
    if (self.currentSegmentIndex == 0) {
        return;
    }
    self.currentSegmentIndex--;
    [self setSegment:self.currentSegmentIndex];
    [self reloadDataWith:self.currentSegmentIndex];
}
-(void)swiperight
{
    if (self.currentSegmentIndex == [self getSegmentNumber]) {
        return;
    }
    self.currentSegmentIndex++;
    [self setSegment:self.currentSegmentIndex];
    [self reloadDataWith:self.currentSegmentIndex];
}
- (void)reloadDataWith:(TypeInfo)type
{
    switch (type) {
        case InfoNormal:
            //            [_detailInfoNormalVC reloadData];
            [_detailInfoNormalVC.view setHidden:NO];
            [_detailVC.view setHidden:YES];
            [_commentVC.view setHidden:YES];
            break;
        case InfoDetail:
            [_detailVC reloadData];
            [_detailVC.view setHidden:NO];
            [_detailInfoNormalVC.view setHidden:YES];
            [_commentVC.view setHidden:YES];
            break;
        case InfoComent:
            //            [_commentVC reloadData];
            [_commentVC.view setHidden:NO];
            [_detailInfoNormalVC.view setHidden:YES];
            [_detailVC.view setHidden:YES];
            break;
        default:
            break;
    }
    
}
- (void)addDetailInfoNormalVC:(CGFloat)spaceTop{
    if(_detailInfoNormalVC == nil) {
        _detailInfoNormalVC = NEW_VC_FROM_NIB(QLTT_DetailInfoNormalVC, @"QLTT_DetailInfoNormalVC");
        _detailInfoNormalVC.isTreeVC = self.isTreeVC;
        _detailInfoNormalVC.delegate = self;
        [self addChildViewController:_detailInfoNormalVC];
        _detailInfoNormalVC.view.frame = CGRectMake(0, spaceTop + _segmentHeight +_margin, self.view.frame.size.width, self.view.frame.size.height - spaceTop - _segmentHeight - _margin);
        [self.view addSubview:_detailInfoNormalVC.view];
        [_detailInfoNormalVC didMoveToParentViewController:self];
    }
}

- (void)addDetailVC:(CGFloat)spaceTop {
    if(_detailVC == nil) {
        _detailVC = NEW_VC_FROM_NIB(QLTT_InfoDetailVC, @"QLTT_InfoDetailVC");
        _detailVC.delegate = self;
        [self addChildViewController:_detailVC];
        _detailVC.view.frame = CGRectMake(0, spaceTop + _segmentHeight + _margin, self.view.frame.size.width, self.view.frame.size.height - spaceTop - _segmentHeight - _margin);
        [self.view addSubview:_detailVC.view];
        [_detailVC didMoveToParentViewController:self];
    }
}

- (void)addComentVC:(CGFloat)spaceTop {
    if(_commentVC == nil) {
        _commentVC = NEW_VC_FROM_NIB(QLTT_CommentVC, @"QLTT_CommentVC");
        _commentVC.delegate = self;
        [self.view addSubview:_commentVC.view];

            _commentVC.view.translatesAutoresizingMaskIntoConstraints = NO;
            
            NSLayoutConstraint *left    = [NSLayoutConstraint constraintWithItem:_commentVC.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_segmentedControl attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
            NSLayoutConstraint *cts_Top  = [NSLayoutConstraint
                                            constraintWithItem:_commentVC.view
                                            attribute:NSLayoutAttributeTop
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:_segmentedControl
                                            attribute:NSLayoutAttributeBottom
                                            multiplier:1.0
                                            constant:_margin];
        NSLayoutConstraint *height  = [NSLayoutConstraint
                                       constraintWithItem:_commentVC.view
                                       attribute:NSLayoutAttributeBottom
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:self.view
                                       attribute:NSLayoutAttributeBottom
                                       multiplier:1.0
                                       constant:0.0];
            NSLayoutConstraint *right  = [NSLayoutConstraint constraintWithItem:_commentVC.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_segmentedControl attribute:NSLayoutAttributeRight multiplier:1 constant:0];
            [self.view addConstraints:@[left, cts_Top, right, height]];

        
    }
}

#pragma mark action
- (void)btnAddRowTapped:(UIButton *)sender
{
    DLog(@"tapped");
}

#pragma mark - CAPSPageMenuDelegate
- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)willMoveToPage:(UIViewController *)controller index:(NSInteger)index {
    [self endEditCurrentView];
    switch (index) {
        case 0: {
            DLog(@"VOffice");
        }
            break;
        case 1: {
            DLog(@"TTNS");
        }
            break;
        case 2: {
            DLog(@"TTNS");
        }
        default:
            break;
    }
}

- (void)didMoveToPage:(UIViewController *)controller index:(NSInteger)index {
    //    [self reloadDataWith:index];
}

#pragma mark - PassingMasterDocumentModel
- (QLTTMasterDocumentModel *)getMasterDocumentModel
{
    return self.lastModel;
}

- (QLTTFileAttachmentModel *)getAttachmentModel:(NSInteger)index
{
    return self.lastModel.fileAttachment[index];
}

- (NSInteger)numberOfFileAttachment
{
    return self.lastModel.fileAttachment.count;
}

- (NSNumber *)getDocumentId
{
    return self.lastModel.documentId;
}

#pragma mark PassingMasterDocumentModelDelegate
- (void)isPushPreview:(BOOL)isPushPreview
{
    self.isPushPreview = isPushPreview;
}
- (QLTT_InfoDetailController *)getQLTT_InfoDetailController
{
    if ([self.delegate respondsToSelector:@selector(getQLTT_InfoDetailController)]) {
        return [self.delegate getQLTT_InfoDetailController];
    }
    return nil;
}
- (void)setTile:(NSString *)title subTitle:(NSString *)subTitle
{
    if ([self.delegate respondsToSelector:@selector(setTile:subTitle:)]) {
        [self.delegate setTile:title subTitle:subTitle];
    }
}
- (void)dismissVC:(UIGestureRecognizer *)recognizer
{
    if ([self.delegate respondsToSelector:@selector(dismissVC:)]) {
        [self.delegate dismissVC:recognizer];
    }
}
- (void)pushVC:(UIViewController *)vc
{
    if ([self.delegate respondsToSelector:@selector(pushVC:)]) {
        [self.delegate pushVC:vc];
    }
}
- (void)didSelectRowAt:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectRowAt:)]) {
        [self.delegate didSelectRowAt:indexPath];
    }
}
- (void)didSelect:(id)item
{
    if ([self.delegate respondsToSelector:@selector(didSelect:)]) {
        [self.delegate didSelect:item];
    }
}
- (void)didSelectRow:(QLTTMasterDocumentModel *)item
{
    if ([self.delegate respondsToSelector:@selector(didSelectRow:)]) {
        [self.delegate didSelectRow:item];
    }
}
- (NSArray *)getMasterTreeDocumentModel
{
    if ([self.delegate respondsToSelector:@selector(getMasterTreeDocumentModel)]) {
        return [self.delegate getMasterTreeDocumentModel];
    }
    return nil;
}
- (QLTTMasterDocumentModel *)getMasterDocumentDetailModel
{
    if ([self.delegate respondsToSelector:@selector(getMasterDocumentDetailModel)]) {
        return [self.delegate getMasterDocumentDetailModel];
    }
    return nil;
}

- (void)clearContent
{
    if ([self.delegate respondsToSelector:@selector(clearContent)]) {
        [self.delegate clearContent];
    }
}
//DetailInfo
- (void)getDocumentWithSameCategory:(NSInteger)page isLoadMore:(BOOL)isLoadMore isRefresh:(BOOL)isRefresh completion:(CallbackQLTT_DetailInfoNormal)completion
{
    if ([self.delegate respondsToSelector:@selector(getDocumentWithSameCategory:isLoadMore:isRefresh:completion:)]) {
        [self.delegate getDocumentWithSameCategory:page isLoadMore:isLoadMore isRefresh:isRefresh completion:completion];
    }
    
}
- (void)didCheckLike
{
    if ([self.delegate respondsToSelector:@selector(didCheckLike)]) {
        [self.delegate didCheckLike];
    }
}

- (void)loadDetailDocumentWith:(NSNumber *)documentID isRefresh:(BOOL)isRefresh
{
    if ([self.delegate respondsToSelector:@selector(loadDetailDocumentWith:isRefresh:)]) {
        if (documentID == nil) {
            documentID = self.lastModel.documentId;
        }
        [self.delegate loadDetailDocumentWith:documentID isRefresh:isRefresh];
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
//Comment
- (QLTTCommentingPerson *)commentAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(commentAtIndex:)]) {
        return [self.delegate commentAtIndex:index];
    }
    return nil;
}
- (NSInteger)numberOfComment
{
    if ([self.delegate respondsToSelector:@selector(numberOfComment)]) {
        return [self.delegate numberOfComment];
    }
    return 0;
}
- (void)setMasterDocumentDetailModel:(QLTTMasterDocumentModel *)model
{
    if ([self.delegate respondsToSelector:@selector(setMasterDocumentDetailModel:)]) {
        [self.delegate setMasterDocumentDetailModel:model];
    }
}



@end
