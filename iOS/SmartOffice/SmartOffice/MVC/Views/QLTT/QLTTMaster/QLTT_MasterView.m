//
//  QLTT_MasterView.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "QLTT_MasterView.h"
#define hiddenWidth = 0
#define showWidth = 44
@interface QLTT_MasterView()<SOSearchBarViewDelegate>

@end
@implementation QLTT_MasterView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}
- (void)dismissKeyboard
{
    DLog(@"");
}
- (void)setupUI
{
    NSString *searchBarText = [NSString stringWithFormat:@"%@ %@, %@, %@", LocalizedString(@"QLTT_MasterView_Tìm_kiếm"), LocalizedString(@"QLTT_MasterView_tài_liệu"), LocalizedString(@"QLTT_MasterView_tác_giả"),LocalizedString(@"QLTT_MasterView_người_tạo")];
    self.searchBar.placeholder = searchBarText;
    self.searchBar.delegate = self;
//    [AppDelegateAccessor setPropertyItalic:self.searchBar fontsize:15];
    
}
-(void)hiddenFilter
{
    self.btn_Filter.hidden = YES;
    self.cst_FilterWidth.constant = 0;
}
- (void)loadComponents
{
    if (self.delegate) {
        if ([self.delegate isSearchView]) {
            [self.btn_Filter setImage:nil forState:UIControlStateNormal];
            [self.btn_Filter setTitle:LocalizedString(@"Huỷ") forState:UIControlStateNormal];
            [self.btn_Filter setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [self.btn_Filter setTitleColor:AppColor_MainAppTintColor forState:UIControlStateNormal];
        }
    }
}
- (void)scrollToTop
{
    [self.masterTableView.tb_QLTTList setContentOffset:CGPointMake(0, 0 - self.masterTableView.tb_QLTTList.contentInset.top) animated:YES];
}
- (void)reloadTableView
{
    [self.masterTableView.tb_QLTTList reloadData];
}
- (BOOL)isActiveSearchBar
{
    return self.searchBar.text.length > 0;
}
-(void)selectFirstItem
{
    [self selectItem:[NSIndexPath indexPathForRow:0 inSection:0]];
}
-(void)selectItem:(NSIndexPath *)index
{
    [self.masterTableView.tb_QLTTList selectRowAtIndexPath:index animated:YES  scrollPosition:UITableViewScrollPositionTop];
}
- (IBAction)filer:(UIButton *)sender {
    if(self.delegate)
    {
        [self.delegate didSelectFilter_QLTT_MasterView:sender];
    }
}

#pragma mark SOSearchBarViewDelegate
- (void)textField:(UITextField *)textField textDidChange:(NSString *)searchText
{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(setIsSearching:)]) {
            [self.delegate setIsSearching: NO];
        }
        if ([self.delegate respondsToSelector:@selector(clearContent)]) {
            [self.delegate clearContent];
        }
        if ([self.delegate respondsToSelector:@selector(searchBarTextDidChange:)]) {
            [self.delegate searchBarTextDidChange:searchText];
        }
        
    }
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked) ]) {
        [self.delegate searchBarCancelButtonClicked];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchBarSearchButtonClicked:) ]) {
        [self.delegate searchBarSearchButtonClicked:textField.text];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchBarBeginEdit) ]) {
        [self.delegate searchBarBeginEdit];
    }
}
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
//{
//    if (self.delegate) {
//        if ([self.delegate respondsToSelector:@selector(clearContent)]) {
//            [self.delegate clearContent];
//        }
//        if ([self.delegate respondsToSelector:@selector(searchBarTextDidChange:)]) {
//            [self.delegate searchBarTextDidChange:searchText];
//        }
//        
//    }
//}
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    if (self.delegate) {
//        [self.delegate searchBarCancelButtonClicked];
//    }
//    
//}
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    if (self.delegate) {
//        [self.delegate searchBarSearchButtonClicked:searchBar.text];
//    }
//}
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    
//}
@end
