//
//  ListDocVC.h
//  SmartOffice
//
//  Created by Kaka on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseVC.h"
#import "VOfficeBaseSwipeTableView.h"
@class SOSearchBarView;

@interface ListDocVC : VOfficeBaseSwipeTableView<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
	
}
@property (assign, nonatomic) DocType docType;

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet SOSearchBarView *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *btnFilter;
@property (weak, nonatomic) IBOutlet UITableView *tblContent;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrain_width_filter;

@end
