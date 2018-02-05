//
//  ContentFilterAndSearchBarVC.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ContentFilterAndSearchBarVC.h"
#import "ContentFilterAndSearchBarCell.h"
#import "SOSearchBarView.h"
@interface ContentFilterAndSearchBarVC () <SOSearchBarViewDelegate>
{
    BOOL _isHiddenSearchBar;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

    
@property (weak, nonatomic) IBOutlet SOSearchBarView *searchBar;


@end

static NSString *CELL_ID = @"ContentFilterAndSearchBarCell";
@implementation ContentFilterAndSearchBarVC

- (instancetype)initWithFilterSelected:(NSInteger)filterType content:(NSArray *)contents withoutSearchBar:(BOOL)isHiddenSearchBar{
    self = [[ContentFilterAndSearchBarVC alloc] initWithNibName:@"ContentFilterAndSearchBarVC" bundle:nil];
    if (self) {
        _isHiddenSearchBar = isHiddenSearchBar;
        self.filterType = filterType;
        self.listContent = contents;
        self.view.frame = CGRectMake(0, 0, 350, 44 * self.listContent.count);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tblContent registerNib:[UINib nibWithNibName:@"ContentFilterAndSearchBarCell" bundle:nil] forCellReuseIdentifier:CELL_ID];
    if (_isHiddenSearchBar == YES) {
        self.topLayout.constant = -44;
        self.searchBar.hidden = YES;
    }
    else
    {
        self.searchBar.delegate = self;
    }
    self.tblContent.delegate = self;
    self.tblContent.dataSource = self;
    
}
- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    self.searchBar.placeholder = self.placeHolder;
}

- (NSInteger)convertFilterIndex
{
    for (int index = 0; index < _listContent.count; index++) {
        if ([_listFilteredContent[_filterType] isEqualToString:_listContent[index]]){
            return index;
        }
    }
    return 0;
}
- (void)filterContent:(NSString *)keyWord
{
    NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", keyWord];
    _listFilteredContent = [_listContent filteredArrayUsingPredicate:p];
}

- (BOOL)checkSearchBarIsActive
{
    if (![self.searchBar.text isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

#pragma mark - UITableView DataSource
//Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self checkSearchBarIsActive] == YES ? _listFilteredContent.count : _listContent.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContentFilterAndSearchBarCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (cell == nil) {
        cell = [[ContentFilterAndSearchBarCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_ID];
    }
    BOOL checkCheckMark = NO;
    if ([self checkSearchBarIsActive]) {
        if ([_listFilteredContent[indexPath.row] isEqualToString:_listContent[_filterType]]) {
            checkCheckMark = YES;
        }
        [cell setData: _listFilteredContent[indexPath.row] showCheckmark:checkCheckMark];
    }
    else
    {
        if (_filterType == indexPath.row) {
            checkCheckMark = YES;
        }
        [cell setData: _listContent[indexPath.row] showCheckmark:checkCheckMark];
    }
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContentFilterAndSearchBarCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.imgCheckmark.hidden = NO;
    _filterType = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
    if (_delegate) {
        NSInteger index = indexPath.row;
        if ([self checkSearchBarIsActive]) {
            index = [self convertFilterIndex];
        }
        [_delegate didSelectedFilterVC:index];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContentFilterAndSearchBarCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.imgCheckmark.hidden = YES;
}

#pragma mark UISearchBarDelegate
- (void)textField:(UITextField *)textField textDidChange:(NSString *)searchText
{
    [self filterContent:searchText];
    [self.tblContent reloadData];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
