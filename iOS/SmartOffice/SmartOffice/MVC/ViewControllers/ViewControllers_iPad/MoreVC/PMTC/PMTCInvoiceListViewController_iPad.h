//
//  PMTCInvoiceListViewController_iPad.h
//  SmartOffice
//
//  Created by NguyenDucBien on 9/27/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//




#import "TTNS_Base_iPad.h"
#import "PMTC_BaseViewController.h"
#import "DocumentTypeListModel.h"


@interface PMTCInvoiceListViewController_iPad : TTNS_Base_iPad
@property (weak, nonatomic) IBOutlet UIView *PMTC_ListDocumentTypeView;
@property (weak, nonatomic) IBOutlet UIView *PMTC_HeaderListView;
@property (weak, nonatomic) IBOutlet UILabel *headerTittleLabel;
@property (weak, nonatomic) IBOutlet UIView *PMTC_ContentListView;
@property (weak, nonatomic) IBOutlet UIView *PMTC_ListDocumentView;
@property (weak, nonatomic) IBOutlet UIView *PMTC_HeaderDetailView;
@property (weak, nonatomic) IBOutlet UILabel *headerTittleDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *PMTC_ContentDetailView;


@end
