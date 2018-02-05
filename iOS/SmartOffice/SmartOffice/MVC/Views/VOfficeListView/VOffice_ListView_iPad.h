//
//  VOfficeListView_iPad.h
//  SmartOffice
//
//  Created by Nguyen Van Tu on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOSearchBarView.h"
#import "FullWidthSeperatorTableView.h"

@protocol VOffice_ListView_iPadDelegate <NSObject>
- (void)buttonPressed:(UIButton *)sender;
- (void)switchSegment:(UISegmentedControl *)segment;
- (void)searchBar:(UITextField *)searchBar textDidChange:(NSString *)searchText;
- (void)beginSearch;
- (void)endEditView;
@optional
- (void)searchBarReturn;
@end
@interface VOffice_ListView_iPad : UIView
@property (weak, nonatomic) IBOutlet FullWidthSeperatorTableView *tbl_ListContents;
@property (nonatomic, strong) UIView *view;
@property (weak, nonatomic) IBOutlet SOSearchBarView *searchBar;
@property (weak, nonatomic) id<VOffice_ListView_iPadDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sgm_WorkType;
@property (weak, nonatomic) IBOutlet UIButton *btn_Filter;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Message;
- (void)setHiddenForFilterButton:(BOOL)isHidden;
- (void)selectItem:(NSIndexPath *)index;
- (void)selectItemWithNoFocusCurrentItem:(NSIndexPath *)index;

- (void) setIndex:(NSInteger)sender;
- (void) updateFrameSearchBarFrom:(ListWorkType)type;

- (void)setTextForSearchBar:(NSString *)searchString;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrain_width_filter;

@end
