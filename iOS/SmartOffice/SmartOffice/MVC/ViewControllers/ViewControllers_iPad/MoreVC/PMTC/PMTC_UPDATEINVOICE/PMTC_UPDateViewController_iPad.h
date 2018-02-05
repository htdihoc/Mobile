//
//  PMTC_UPDateViewController_iPad.h
//  SmartOffice
//
//  Created by NguyenDucBien on 9/29/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_Base_iPad.h"

@interface PMTC_UPDateViewController_iPad : TTNS_Base_iPad

@property (assign, nonatomic) NSInteger widthCollection;
@property (assign, nonatomic) NSInteger heightCollection;
@property (weak, nonatomic) IBOutlet UILabel *tittleLabel;
@property (weak, nonatomic) IBOutlet UITableView *updateInvoiceTableview;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (strong, nonatomic) NSString *documentType;
@property (strong, nonatomic) NSString *documentNumber;
@property (strong, nonatomic) NSString *fileAttach;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *contentSeriaString;
@property (strong, nonatomic) NSString *contentDateString;
@property (strong, nonatomic) NSString *contentString;
- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)updateButtonAction:(id)sender;

@end
