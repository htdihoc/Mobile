//
//  ListMissionVC.h
//  SmartOffice
//
//  Created by Kaka on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseVC.h"
#import "VOffice_ListMissionController.h"
@class MissionGroupModel;
@class SOSearchBarView;
@interface ListMissionVC : TTNS_BaseVC<UITableViewDelegate, UITableViewDataSource>{
	
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginTopLayout;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet SOSearchBarView *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *btnFilter;

@property (weak, nonatomic) IBOutlet UITableView *tblContent;

//Passing data
@property (assign, nonatomic) ListMissionType listType;

@property (strong, nonatomic) MissionGroupModel *groupModel;
@property (strong, nonatomic) VOffice_ListMissionController *listMisstionController;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrain_width_filter;
@end
