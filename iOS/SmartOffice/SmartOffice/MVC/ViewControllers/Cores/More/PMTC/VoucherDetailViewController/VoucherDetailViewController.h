//
//  VoucherDetailViewController.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 6/27/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_BaseVC.h"
#import "CodeSendBillDetailCell.h"

@interface VoucherDetailViewController : TTNS_BaseVC

@property (assign, nonatomic) NSInteger widthCollection;
@property (assign, nonatomic) NSInteger heightCollection;
@property (weak, nonatomic) IBOutlet UIButton *updateInvoiceButton;
- (IBAction)updateInvoiceAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *sendbilldetailTableView;
@property (strong, nonatomic) UICollectionView *imageCollectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) NSMutableArray *array_image_Item;
@property (strong, nonatomic) UIImagePickerController *imgPicker;
@property (strong, nonatomic) CodeSendBillDetailCell *codeSendBillDetailCell;
@property (strong, nonatomic) NSString *contentSeriaString;
@property (strong, nonatomic) NSString *contentDateString;
@property (strong, nonatomic) NSString *contentString;
@property (strong, nonatomic) NSString *documentType;
@property (strong, nonatomic) NSString *documentNumber;
@property (strong, nonatomic) NSString *fileAttach;
@property (strong, nonatomic) NSString *fileName;

@end
