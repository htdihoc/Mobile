//
//  PMTC_DetailAttached_VC.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 6/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNS_BaseVC.h"
#import "SOSearchBarView.h"

@interface PMTC_DetailAttached_VC : TTNS_BaseVC

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SOSearchBarView *search_view;
@property (strong, nonatomic) NSString *main_title;
@property (strong, nonatomic) NSString *documentType;
@property (assign, nonatomic) NSInteger pageSize;
@property (assign, nonatomic) NSInteger pageNumber;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_searchViewToTop;


@end
