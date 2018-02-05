//
//  PMTC_SendInvoiceViewController_iPad.h
//  SmartOffice
//
//  Created by NguyenDucBien on 9/29/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_BaseVC.h"


@interface PMTC_SendInvoiceViewController_iPad : TTNS_BaseVC

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *sendInvoiceTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnSendInvoiceButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelSendInvoiceButton;
@property (assign, nonatomic) NSInteger widthCollection;
@property (assign, nonatomic) NSInteger heightCollection;
@property (strong, nonatomic) NSString *documentNumber;
@property (strong, nonatomic) NSString *taxCode;
@property (strong, nonatomic) NSString *fileAttach;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *vhrEmployeeCode;
- (IBAction)sendInvoiceAction:(id)sender;
- (IBAction)cancelAction:(id)sender;


@end
