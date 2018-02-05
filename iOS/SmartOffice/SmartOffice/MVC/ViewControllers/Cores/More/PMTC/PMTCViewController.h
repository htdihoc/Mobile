//
//  PMTCViewController.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 6/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_BaseVC.h"

@interface PMTCViewController : TTNS_BaseVC

@property (weak, nonatomic) IBOutlet UIView *view_segment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmented_view;
@property (weak, nonatomic) IBOutlet UITableView *pmtcTableView;
@property (strong, nonatomic) NSMutableArray *image_attach_pmtc;
@property (strong, nonatomic) NSMutableArray *title_attach_pmtc;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrain_height_segment;
@property (assign, nonatomic)

NSInteger switchScreen;
@property (strong, nonatomic) NSString *currencyCodeValue;
@property (assign, nonatomic) NSString *debtAmountValue;
@property (weak, nonatomic) IBOutlet UIView *HeaderView;

@property (weak, nonatomic) IBOutlet UILabel *HeaderTHCNtitle;

@property (weak, nonatomic) IBOutlet UILabel *currentUinitLabel;

@property (weak, nonatomic) IBOutlet UILabel *CNHTtitle;

@property (weak, nonatomic) IBOutlet UILabel *currentCodeLabel;

@property (weak, nonatomic) IBOutlet UILabel *HistoryLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_headerView;





@end
