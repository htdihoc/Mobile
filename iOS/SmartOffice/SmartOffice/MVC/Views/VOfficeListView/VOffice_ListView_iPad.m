//
//  VOfficeListView_iPad.m
//  SmartOffice
//
//  Created by Nguyen Van Tu on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_ListView_iPad.h"

#define WIDTH_FILTER_SHOW 44
#define WIDTH_FILTER_HIDEN 0

@interface VOffice_ListView_iPad()<SOSearchBarViewDelegate> {
    BOOL isHiddenFilter;
}
@end
@implementation VOffice_ListView_iPad
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tbl_ListContents.estimatedRowHeight = 80;
    self.tbl_ListContents.rowHeight = UITableViewAutomaticDimension;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}
    
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    if(CGRectIsEmpty(frame)) {
        self.bounds = self.view.bounds;
    }
    return self;
}
    
- (void)setup {
    self.view = [[[NSBundle mainBundle] loadNibNamed:@"VOffice_ListView_iPad" owner:self options:nil] firstObject];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
//    self.searchBar.placeholder = [NSString stringWithFormat:@"%@, %@",LocalizedString(@"PL_SEARCH_DOC_LABEL"), LocalizedString(@"PL_SEARCH_DOC_LABEL_More")];
    [self setTextForSegment];
    [self setupColor];
    self.searchBar.delegate = self;
//    [AppDelegateAccessor setPropertyItalic:self.searchBar fontsize:15];
    [AppDelegateAccessor setupSegment:_sgm_WorkType];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [self.tbl_ListContents addGestureRecognizer:tap];
}
- (void)setTextForSearchBar:(NSString *)searchString
{
    _searchBar.text = searchString;
}
- (void)didTapOnTableView:(UIGestureRecognizer*) recognizer
{
    CGPoint tapLocation = [recognizer locationInView:self.tbl_ListContents];
    NSIndexPath *indexPath = [self.tbl_ListContents indexPathForRowAtPoint:tapLocation];
    
    if (indexPath) { //we are in a tableview cell, let the gesture be handled by the view
        recognizer.cancelsTouchesInView = NO;
    }
    [self.delegate endEditView];
}
- (void)setupColor
{
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:AppFont_MainFontWithSize(13), NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} forState:UIControlStateNormal];
    self.sgm_WorkType.tintColor = AppColor_MainAppTintColor;
    self.view.backgroundColor = AppColor_MainAppBackgroundColor;
    self.sgm_WorkType.backgroundColor = RGB(227, 227, 232);
}
- (void)setTextForSegment
{
    self.lbl_Message.textColor = AppColor_MainTextColor;
    [self.sgm_WorkType setTitle:LocalizedString(@"VOffice_ListView_iPad_Thực_hiện") forSegmentAtIndex:0];
    [self.sgm_WorkType setTitle:LocalizedString(@"VOffice_ListView_iPad_Giao_đi") forSegmentAtIndex:1];
}
- (void)selectItemWithNoFocusCurrentItem:(NSIndexPath *)index
{
    [self.tbl_ListContents selectRowAtIndexPath:index animated:YES  scrollPosition:UITableViewScrollPositionNone];
}
- (void)selectItem:(NSIndexPath *)index
{
    [self.tbl_ListContents selectRowAtIndexPath:index animated:YES  scrollPosition:UITableViewScrollPositionMiddle];
}
- (void)setHiddenForFilterButton:(BOOL)isHidden
{
    isHiddenFilter = isHidden;
    [self layoutForHiddenFilter];
//    self.btn_Filter.hidden = isHidden;
}
#pragma mark action
- (IBAction)filter:(UIButton *)sender {
    [self.delegate buttonPressed:sender];
}
- (IBAction)switchSegment:(UISegmentedControl *)sender {
    if([sender selectedSegmentIndex] == ListWorkType_Shipped-1)
    {
        //hidden filter button
        self.btn_Filter.hidden = YES;
    }
    else
    {
        self.btn_Filter.hidden = NO;
    }
    [self.delegate switchSegment:sender];
    [self updateFrameSearchBarFrom:sender.selectedSegmentIndex == 1? ListWorkType_Shipped : ListWorkType_Perform];
}

- (void) setIndex:(NSInteger)sender {
    
//    [self updateFrameSearchBar:indexInt];
}
- (void)layoutForHiddenFilter
{
    self.constrain_width_filter.constant = WIDTH_FILTER_HIDEN;
    self.btn_Filter.hidden = YES;
}
- (void)layoutForShowingFilter
{
    self.btn_Filter.hidden = NO;
    self.constrain_width_filter.constant = WIDTH_FILTER_SHOW;
}
- (void) updateFrameSearchBarFrom:(ListWorkType)type {
    if (isHiddenFilter) {
        [self layoutForHiddenFilter];
    }
    else
    {
        if(type == ListWorkType_Perform)
        {
            [self layoutForShowingFilter];
        }
        else
        {
            [self layoutForHiddenFilter];
        }
    }
    
    [self layoutIfNeeded];
}

#pragma mark SOSearchBarViewDelegate
- (void)textField:(UITextField *)textField textDidChange:(NSString *)searchText
{
    if (self.delegate) {
        [self.delegate searchBar:textField textDidChange:searchText];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchBarReturn)])
    {
        [self.delegate searchBarReturn];
    }
    return YES;
}

@end
