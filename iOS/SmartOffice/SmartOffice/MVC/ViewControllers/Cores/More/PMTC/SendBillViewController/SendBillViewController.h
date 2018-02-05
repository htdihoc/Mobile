//
//  SendBillViewController.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 6/27/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_BaseVC.h"

@interface SendBillViewController : TTNS_BaseVC

@property (assign, nonatomic) NSInteger widthCollection;
@property (assign, nonatomic) NSInteger heightCollection;
@property (weak, nonatomic) IBOutlet UIButton *sendInvoiceButton;
- (IBAction)sendInvoiceAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cstButtonSendInvoice;

@property (strong, nonatomic) NSString *documentNumber;
@property (strong, nonatomic) NSString *taxCode;
@property (strong, nonatomic) NSString *fileAttach;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *vhrEmployeeCode;


@end
