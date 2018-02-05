//
//  KTTSViewController.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 9/13/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

//#import "PMTC_BaseViewController.h"
#import "VOffice_Base_iPad.h"
#import "SOSearchBarView.h"
#import "AssetConfirmViewController.h"

@interface KTTSViewController : VOffice_Base_iPad<AssetConfirmViewControllerDelegate> //PMTC_BaseViewController

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UILabel *recordTotal;
@property (weak, nonatomic) IBOutlet SOSearchBarView *search_view;
@property (weak, nonatomic) IBOutlet UITableView *kttsTableView;
@property (weak, nonatomic) IBOutlet UIView *kttsView;
@property (weak, nonatomic) IBOutlet UITableView *detailKTTSTableView;
@property (weak, nonatomic) IBOutlet SOSearchBarView *detailSearchView;

@property (weak, nonatomic) IBOutlet UIView *detailKTTSView;
@property (weak, nonatomic) IBOutlet UILabel *detailAssetName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reason_height_constraint;
@property (weak, nonatomic) IBOutlet UIView *reasonView;

@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;

@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchview_detail_constraint;

@property (weak, nonatomic) IBOutlet UILabel *noDataKTTSLabel;
@property (weak, nonatomic) IBOutlet UILabel *noDataBBBGLabel;

@end
