//
//  PMTCViewController_iPad.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 7/6/29 H.
//  Copyright © 29 Heisei ITSOL. All rights reserved.
//

#import "VOffice_Base_iPad.h"
#import "PMTC_BaseViewController.h"

@interface PMTCViewController_iPad : VOffice_Base_iPad

@property (strong, nonatomic) NSMutableArray *image_attach_pmtc;
@property (strong, nonatomic) NSMutableArray *title_attach_pmtc;
@property (weak, nonatomic) IBOutlet UIView *view_credit_info;
@property (weak, nonatomic) IBOutlet UIView *view_attach;
@property (weak, nonatomic) IBOutlet UITableView *attach_tableview;

@end
