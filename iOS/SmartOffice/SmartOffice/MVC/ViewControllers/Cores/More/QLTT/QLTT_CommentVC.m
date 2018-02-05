//
//  QLTT_CommentVC.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "QLTT_CommentVC.h"
#import "QLTT_CommentController.h"
#import "QLTTCommentingPerson.h"
#import "NSException+Custom.h"
#import "QLTT_CommentViewCell.h"
#import "Common.h"
#import "NSString+StringToDate.h"
#import "SVPullToRefresh.h"
@interface QLTT_CommentVC () <UITableViewDelegate, UITableViewDataSource, QLTT_CommentViewDelegate, QLTT_CommentViewCellDelegate>
{
    NSMutableArray *_listComment;
    NSInteger _numComment;
    NSInteger _increaseComment;
    NSMutableArray<NSIndexPath *> *_activeIndex;
    __weak QLTT_CommentVC *weakSelf;
}
@property (strong, nonatomic) QLTT_CommentController *commentController;
@end

@implementation QLTT_CommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initValues];
    [self reloadData: NO];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateModel:)
                                                 name:@"updateQLTTMasterDocumentModel"
                                               object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"updateQLTTMasterDocumentModel"
                                                  object:nil];
}
- (void) updateModel:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"updateQLTTMasterDocumentModel"])
    {
        [self reloadData:YES];
    }
}
- (void)dismissVC:(UIGestureRecognizer *)recognizer
{
    [self endEditCommentView];
    [self.delegate dismissVC:recognizer];
}
- (void)endEditCommentView
{
    [self didFinishHiddenKeyBorad];
    [self.view endEditing:YES];
}
- (void)setDefaultValues
{
    _increaseComment = 20;
    _numComment = _increaseComment;
}
- (void)initValues
{
    [self setDefaultValues];
    _activeIndex = [[NSMutableArray alloc] init];
    _commentController = [[QLTT_CommentController alloc] init];
    self.qltt_CommentView.delegate = self;
    self.qltt_CommentView.tbl_Comments.delegate = self;
    self.qltt_CommentView.tbl_Comments.dataSource = self;
    [self.qltt_CommentView.tbl_Comments registerNib:[UINib nibWithNibName:@"QLTT_CommentViewCell" bundle:nil] forCellReuseIdentifier:@"QLTT_CommentViewCell"];
    
    weakSelf = self;
    
    self.qltt_CommentView.tbl_Comments.showsPullToRefresh = NO;
    [self.qltt_CommentView.tbl_Comments addPullToRefreshWithActionHandler:^{
        DLog(@"Refresh data here");
        
        if ([Common checkNetworkAvaiable]) {
            [self hiddenPullRefreshView:NO];
            [self reloadData:YES];
        }else
        {
            [self hiddenPullRefreshView:YES];
            [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view isInstant:NO];
        }
        
        
        //Refresh data here
        // prepend data to dataSource, insert cells at top of table view
        // call [tableView.pullToRefreshView stopAnimating] when done
    } position:SVPullToRefreshPositionTop];
}
- (void)hiddenPullRefreshView:(BOOL)hidden{
    if (hidden) {
        [weakSelf.qltt_CommentView.tbl_Comments.pullToRefreshView stopAnimating];
        [weakSelf.qltt_CommentView.tbl_Comments.pullToRefreshView hiddenPullToRefresh:YES];
        
    }else{
        [weakSelf.qltt_CommentView.tbl_Comments.pullToRefreshView startAnimating];
        [weakSelf.qltt_CommentView.tbl_Comments.pullToRefreshView hiddenPullToRefresh:NO];
    }
}
- (void)didFinishHiddenKeyBorad
{
    self.qltt_CommentView.cst_BottomView.constant = 0;
}
- (void)reloadData:(BOOL)isRefresh
{
    [self setDefaultValues];
    [self endEditCommentView];
    [self loadComments: isRefresh];
}
- (void)clearData
{
    [_listComment removeAllObjects];
}

- (NSArray *)sortArray:(NSArray *)data
{
    NSArray *sortedArray;
    sortedArray = [data sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [[(QLTTCommentingPerson*)a createdDate] convertStringToDateWith:DATE_COMMENT_FORMAT_FROM_SERVER];
        NSDate *second = [[(QLTTCommentingPerson*)b createdDate] convertStringToDateWith:DATE_COMMENT_FORMAT_FROM_SERVER];
        return [second compare:first];
    }];
    return sortedArray;
}
- (void)loadComments:(BOOL)isRefresh
{
    [_activeIndex removeAllObjects];
    
    [_commentController loadComment:[self.delegate getDocumentId] completion:^(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error) {
        [self hiddenPullRefreshView:YES];
        [self clearData];
        [self.qltt_CommentView.tbl_Comments reloadData];
        if (exception) {
            [self handleErrorFromResult:nil withException:exception inView:self.view];
            return;
        }
        if (success) {
            [_listComment removeAllObjects];
            NSArray *commentPeople = [QLTTCommentingPerson arrayOfModelsFromDictionaries:resultArray error:nil];
            _listComment = [NSMutableArray arrayWithArray:[self sortArray:commentPeople]];
            [self removeContentLabel];
            if (_listComment.count == 0) {
                //                [self handleErrorFromResult:nil withException:[NSException initWithString:LocalizedString(@"QLTT_CommentVC_hãy_là_người_đầu_tiên_đóng_góp_ý_kiến_về_tài_liệu_này!")] inView:self.view];
                [self addContentLabel:LocalizedString(@"QLTT_CommentVC_hãy_là_người_đầu_tiên_đóng_góp_ý_kiến_về_tài_liệu_này!") forView:self.nofiView];

            }
            [self.qltt_CommentView.tbl_Comments reloadData];
        }
        else
        {
            [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
        }
        
        
    }];
}
#pragma mark QLTT_CommentViewDelegate
- (void)showError:(NSString *)errorContent
{
    [self handleErrorFromResult:nil withException:[NSException initWithString:errorContent] inView:self.view];
}
- (void)sendComment:(NSString *)Comment
{
    
    [self endEditCommentView];
    DLog(@"send Comment");
    [_commentController sendComment:[self.delegate getDocumentId] content:Comment createdUser:[GlobalObj getInstance].qltt_commentEmployID completion:^(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error) {
        
        if (exception) {
            [self handleErrorFromResult:nil withException:exception inView:self.view];
            return;
        }
        if (success) {
            [self loadComments: NO];
        }
        else
        {
            [self handleErrorFromResult:[error valueForKey:@"resultCode"] withException:nil inView:self.view];
            
        }
    }];
}
#pragma mark action
- (void)btnAddRowTapped:(UIButton *)sender
{
    if ([Common checkNetworkAvaiable]) {
        _numComment = _numComment + _increaseComment;
        if (_numComment >= _listComment.count) {
            [sender setHidden:YES];
        }
        [self.qltt_CommentView.tbl_Comments reloadData];
    }
    else
    {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
    
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_numComment >= _listComment.count) {
        return _listComment.count + 1;
    }
    return _listComment.count > _numComment ? _numComment+1 : _listComment.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //commentView
    NSInteger index = indexPath.row ;
    static NSString *lastCellIdentifier = @"LastCellIdentifier";
    if(index == (_numComment)){ //This is last cell so create normal cell
        UITableViewCell *lastcell = [tableView dequeueReusableCellWithIdentifier:lastCellIdentifier];
        if(!lastcell){
            lastcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lastCellIdentifier];
        }
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        aButton.center = lastcell.center;
        [aButton setTitle:LocalizedString(@"QLTT_DetailVC_Xem_thêm_các_bình_luận") forState:UIControlStateNormal];
        [aButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        [aButton setTitleColor:CommonColor_Blue forState:UIControlStateNormal];
        [aButton addTarget:self action:@selector(btnAddRowTapped:) forControlEvents:UIControlEventTouchUpInside];
        aButton.frame = frame;
        [lastcell addSubview:aButton];
        
        return lastcell;
    } else { //This is normal cells so create your worktouttablecell
        
        static NSString *ID_CELL = @"QLTT_CommentViewCell";
        QLTT_CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
        self.qltt_CommentView.tbl_Comments.separatorColor = [CommonColor_LineSeparatorColor colorWithAlphaComponent:0.7];
        if (_numComment >= _listComment.count  && index == _listComment.count) {
            [cell setHidden:YES];
            return cell;
        }
        cell.delegate = self;
        [cell setupDataForView:_listComment[index] index:index isViewMore:[_activeIndex containsObject:indexPath]];
        //Configure your cell
        return cell;
    }
}
#pragma mark QLTT_CommentViewCellDelegate
- (void)viewMore:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    if (![_activeIndex containsObject:indexPath]) {
        [_activeIndex addObject:indexPath];
    }
    else
    {
        [_activeIndex removeObject:indexPath];
    }
    [self.qltt_CommentView.tbl_Comments reloadData];
}
@end
