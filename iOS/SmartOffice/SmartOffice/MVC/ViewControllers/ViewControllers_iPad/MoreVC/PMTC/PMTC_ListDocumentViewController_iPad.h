//
//  PMTC_ListDocumentViewController_iPad.h
//  SmartOffice
//
//  Created by NguyenDucBien on 9/28/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNS_BaseVC.h"
#import "SOSearchBarView.h"
#import "QLTT_DetailVCBase.h"

@interface PMTC_ListDocumentViewController_iPad : BaseVC

@property (weak, nonatomic) IBOutlet SOSearchBarView *searchView;
@property (weak, nonatomic) IBOutlet UITableView *listDocumentTable;

@property (strong, nonatomic) QLTT_DetailVCBase *detailVC;
@property (strong, nonatomic) NSString *documentType;
@property (assign, nonatomic) NSInteger pageSize;
@property (assign, nonatomic) NSInteger pageNumber;

@end
