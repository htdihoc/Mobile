//
//  QLTT_MasterView.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOSearchBarView.h"
#import "FullWidthSeperatorTableView.h"
#import "BaseSubView.h"
#import "QLTT_MasterTableView.h"
#import "QLTT_TreeView.h"
@protocol QLTT_MasterViewDelegate <NSObject>
@optional
- (void)didSelectFilter_QLTT_MasterView:(UIButton *)sender;
- (void)searchBarTextDidChange:(NSString *)searchText;
- (void)searchBarSearchButtonClicked:(NSString *)searchText;
- (void)searchBarCancelButtonClicked;
- (void)searchBarBeginEdit;
- (BOOL)isSearchView;
- (void)dismissVC;
- (void)clearContent;
- (void)setIsSearching:(BOOL)isSearch;
@end
@interface QLTT_MasterView : BaseSubView
@property (weak, nonatomic) IBOutlet SOSearchBarView *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *btn_Filter;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet QLTT_MasterTableView *masterTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_FilterWidth;


@property (weak, nonatomic) id<QLTT_MasterViewDelegate> delegate;
- (void)loadComponents;
-(void)reloadTableView;
-(BOOL)isActiveSearchBar;
-(void)selectFirstItem;
-(void)selectItem:(NSIndexPath *)index;
-(void)scrollToTop;
-(void)hiddenFilter;
@end
