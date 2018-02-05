//
//  ListWorkVC.h
//  SmartOffice
//
//  Created by Kaka on 4/13/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOfficeBaseSwipeTableView.h"
#import "SOSearchBarView.h"

@class SOSearchBarView;
@interface ListWorkVC : VOfficeBaseSwipeTableView<UITableViewDataSource, UITabBarDelegate, UISearchDisplayDelegate, SOSearchBarViewDelegate>{
	
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginTop;
//@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIButton *btlFilter;
@property (weak, nonatomic) IBOutlet UITableView *tblContent;

//Data
@property (assign, nonatomic) ListWorkType listWorkType;
@property (weak, nonatomic) IBOutlet SOSearchBarView *search_view;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrain_filter_width;

@end
