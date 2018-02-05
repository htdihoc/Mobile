//
//  DocumentTypeListViewController_iPad.h
//  SmartOffice
//
//  Created by NguyenDucBien on 9/28/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOSearchBarView.h"
#import "TTNS_BaseVC.h"
#import "PMTCInvoiceListViewController_iPad.h"

@interface DocumentTypeListViewController_iPad : TTNS_BaseVC

@property (weak, nonatomic) IBOutlet UITableView *typeDocumentListTable;

@property (weak, nonatomic) IBOutlet SOSearchBarView *searchView;
@property (strong, nonatomic) NSIndexPath *lastIndex;
@property (strong, nonatomic) NSString *docType;
@property (assign, nonatomic) NSInteger sizePage;
@property (assign, nonatomic) NSInteger numberPage;



@end
