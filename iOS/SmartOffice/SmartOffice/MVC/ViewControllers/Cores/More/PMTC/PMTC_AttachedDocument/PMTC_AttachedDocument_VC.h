//
//  PMTC_AttachedDocument_VC.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 6/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNS_BaseVC.h"
#import "SOSearchBarView.h"
@interface PMTC_AttachedDocument_VC : TTNS_BaseVC

@property (weak, nonatomic) IBOutlet UILabel *lbl_Header;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SOSearchBarView *search_view;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_NaviIphone;
@property (assign, nonatomic) NSString *typeOfDocument;
@property (nonatomic) BOOL isFiltered;

@end
