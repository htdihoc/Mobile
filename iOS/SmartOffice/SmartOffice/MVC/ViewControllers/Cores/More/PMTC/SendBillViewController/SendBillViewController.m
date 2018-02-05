//
//  SendBillViewController.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 6/27/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//


#import <Photos/Photos.h>
#import "SendBillViewController.h"
#import "HeaderPMTCCell.h"
#import "CodeSendBillCell.h"
#import "AttachFileCell.h"
#import "SendBillCollectionCell.h"
#import "ImageCollectionCell.h"
#import "Common.h"
#import "PMTCProcessor.h"
#import "UIImage+Resize.h"
#import <Foundation/Foundation.h>
#import "SendInvoiceModel.h"


@interface SendBillViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TTNS_BaseNavViewDelegate, AttachFileDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate> {
    SendBillCollectionCell *sendBillCollection;
    AttachFileCell *attachFileCell;
    ImageCollectionCell *imageCollectionCell;
    BOOL isCheck;
    NSData *imageData;
    NSURL *filePathFromCamera;
    NSURL *filePathFromLibrary;
    NSString *letters;
}
@property (strong, nonatomic) SendInvoiceModel *sendInvoiceModel;
@property (weak, nonatomic) IBOutlet UITableView *sendbillTableView;
@property (strong, nonatomic) UICollectionView *imageCollectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) NSMutableArray *array_image_Item;
@property (strong, nonatomic) UIImagePickerController *imgPicker;
@property (nonatomic, strong) UIPopoverController *popOver;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, assign) BOOL isSelectedImage;
@end

@implementation SendBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isCheck = NO;
    self.backTitle = LocalizedString(@"PMTC_SEND_INVOICE");
    [self.sendInvoiceButton setTitle:LocalizedString(@"PMTC_SEND_INVOICE") forState:UIControlStateNormal];
    self.heightCollection = 200;
    self.array_image_Item = [NSMutableArray new];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    
    self.layout = [UICollectionViewFlowLayout new];
    [self.layout setScrollDirection: UICollectionViewScrollDirectionVertical];
    self.layout.minimumLineSpacing = 15;
    
    self.imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.heightCollection) collectionViewLayout:self.layout];
    self.imageCollectionView.backgroundColor = [UIColor clearColor];
    self.imageCollectionView.showsVerticalScrollIndicator = NO;
    self.imageCollectionView.scrollEnabled = YES;
    self.imageCollectionView.delegate = self;
    self.imageCollectionView.dataSource = self;
    [self.imageCollectionView registerNib:[UINib nibWithNibName:@"ImageCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"imageCollectionCell"];
    if (IS_IPAD) {
        self.sendInvoiceButton.hidden = YES;
        _cstButtonSendInvoice.constant = 0;
    }
    [self disableButtonSendInvoice];
}

- (void)showCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imgPicker = [[UIImagePickerController alloc] init];
        self.imgPicker.sourceType = UIImagePickerControllerCameraDeviceFront;
        self.imgPicker.delegate = self;
        [self presentViewController:self.imgPicker animated:YES completion:nil];
    }
}

- (void) dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)showLibrary {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imgPicker = [[UIImagePickerController alloc] init];
        self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imgPicker.allowsEditing = YES;
        self.imgPicker.delegate = self;
        
        if (IS_IPAD) {
            self.popOver = [[UIPopoverController alloc] initWithContentViewController:self.imgPicker];
            [self.popOver presentPopoverFromRect:self.view.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        } else if (IS_IPHONE) {
            [self presentViewController:self.imgPicker animated:YES completion:nil];
        }
    }
}

-(NSString *) randomStringWithLength: (int) len {
    letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((uint32_t)[letters length])]];
    }
    
    return randomString;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.picker = picker;
    UIImage *photoTaken = (UIImage *)[info valueForKey:UIImagePickerControllerOriginalImage];
    if (photoTaken) {
        imageCollectionCell.image_attach.image = photoTaken;
        UIImageWriteToSavedPhotosAlbum(photoTaken, nil, nil, nil);
        [self.array_image_Item addObject:photoTaken];
        NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        self.fileName = [imagePath lastPathComponent];
        if (imagePath == nil) {
            self.fileName = [NSString stringWithFormat:@"%@%@", [self randomStringWithLength:8], @".png"];
        }
        [self.imageCollectionView reloadData];
    } else{
        NSLog(@"Selected photo is NULL");
    }
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (void)checkHaveImage {
    if (self.array_image_Item.count > 0) {
        isCheck = YES;
    } else {
        [self actionShowConfirm];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (((CodeSendBillCell *)[self.sendbillTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).input_code.text.length > 0 & ((CodeSendBillCell *)[self.sendbillTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]).input_code.text.length > 0) {
        return [self enableButtonSendInvoice];
    } else{
        return [self disableButtonSendInvoice];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array_image_Item.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    imageCollectionCell = (ImageCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"imageCollectionCell" forIndexPath:indexPath];
    if (imageCollectionCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ImageCollectionCell" owner:self options:nil];
        imageCollectionCell = [nib objectAtIndex:0];
    }
    imageCollectionCell.image_attach.image = self.array_image_Item[indexPath.row];
    imageCollectionCell.button_close.tag = indexPath.row;
    [imageCollectionCell.button_close addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    return imageCollectionCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((collectionView.bounds.size.width-60)/3, (collectionView.bounds.size.width-60)/3);
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (void) deleteImage:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    [self.array_image_Item removeObjectAtIndex:button.tag];
    [self.imageCollectionView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            static NSString *identifier = @"headerPMTC";
            HeaderPMTCCell *headerPMTCCell = (HeaderPMTCCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (headerPMTCCell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HeaderPMTCCell" owner:self options:nil];
                headerPMTCCell = [nib objectAtIndex:0];
            }
            headerPMTCCell.title_header.text = LocalizedString(@"PMTC_DEBT_INFORMATION");
            headerPMTCCell.currencyUnit.hidden = YES;
            headerPMTCCell.selectionStyle = UIAccessibilityTraitNone;
            return headerPMTCCell;
        }
            break;
        case 1:
        {
            static NSString *identifier = @"codeSendBillCell";
            CodeSendBillCell *codeSendBillCell = (CodeSendBillCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (codeSendBillCell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CodeSendBillCell" owner:self options:nil];
                codeSendBillCell = [nib objectAtIndex:0];
            }
            codeSendBillCell.title_header.text = LocalizedString(@"PMTC_SENDINVOICE_BILLNO");
            codeSendBillCell.input_code.placeholder = LocalizedString(@"PMTC_SENDINVOICE_CREAT_BILLNO");
            codeSendBillCell.input_code.delegate = self;
            codeSendBillCell.input_code.text = self.documentNumber;
            codeSendBillCell.selectionStyle = UIAccessibilityTraitNone;
            return codeSendBillCell;
        }
            break;
        case 2:
        {
            static NSString *identifier = @"codeSendBillCell";
            CodeSendBillCell *codeSendBillCell = (CodeSendBillCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (codeSendBillCell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CodeSendBillCell" owner:self options:nil];
                codeSendBillCell = [nib objectAtIndex:0];
            }
            codeSendBillCell.title_header.text = LocalizedString(@"PMTC_SENDINVOICE_TAXCODE");
            codeSendBillCell.input_code.placeholder = LocalizedString(@"PMTC_SENDINVOICE_TAXCODE_CREAT");
            codeSendBillCell.input_code.delegate = self;
            codeSendBillCell.input_code.text = self.taxCode;
            codeSendBillCell.selectionStyle = UIAccessibilityTraitNone;
            return codeSendBillCell;
        }
            break;
        case 3:
        {
            static NSString *identifier = @"attachFileCell";
            attachFileCell = (AttachFileCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (attachFileCell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AttachFileCell" owner:self options:nil];
                attachFileCell = [nib objectAtIndex:0];
            }
            attachFileCell.attacgFileTittle.text = LocalizedString(@"PMTC_SENDINVOICE_FILEATTACH_AN_INVOICE_PHOTO");
            attachFileCell.delegate = self;
            attachFileCell.selectionStyle = UIAccessibilityTraitNone;
            return attachFileCell;
        }
        case 4:
        {
            static NSString *identifier = @"sendBillCollectionCell";
            sendBillCollection = (SendBillCollectionCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (sendBillCollection == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SendBillCollectionCell" owner:self options:nil];
                sendBillCollection = [nib objectAtIndex:0];
            }
            [sendBillCollection addSubview: self.imageCollectionView];
            sendBillCollection.selectionStyle = UIAccessibilityTraitNone;
            return sendBillCollection;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            return 50;
        }
            break;
        case 1:
        {
            return 90;
        }
            break;
        case 2:
        {
            return 90;
        }
            break;
        case 3:
        {
            return 110;
        }
            break;
        case 4:
        {
            return self.heightCollection;
        }
            break;
        default:
            return 0;
            break;
    }
}
- (void) actionShowConfirm{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Xác nhận" message:@"Bạn bắt buộc phải chọn ảnh đính kèm" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.delegate = self;
    [alert show];
}

- (void) actionShowConfirmSendInvoice {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Xác nhận" message:@"Bạn chắc chắn muốn gửi hóa đơn này?" delegate:self cancelButtonTitle:@"Không" otherButtonTitles:@"Có", nil];
    alert.delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            [self sendInvoiceConfirm];
            break;
        default:
            break;
    }
}


#pragma mark - Util Image
- (void) sendInvoiceConfirm {
    self.documentNumber = ((CodeSendBillCell *)[self.sendbillTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).input_code.text;
    self.taxCode = ((CodeSendBillCell *)[self.sendbillTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]).input_code.text;
    [[Common shareInstance] showCustomHudInView:self.view];
    UIImage *image = [self resizeImageByWidth:self.array_image_Item[0] scaledToWidth:100];
    image = [self resizeImageByHeight:image scaledHeight:100];
    NSData *data = UIImageJPEGRepresentation(image, 0.1);

    NSDictionary *parameter = @{
                                @"arg0": self.documentNumber,
                                @"arg1": self.taxCode,
                                @"arg2": [data base64EncodedStringWithOptions:0],
                                @"arg3": self.fileName,
                                @"arg4": @"111999"
                                };
    [PMTCProcessor postPMTC_sendInvoice:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        if ([Common checkNetworkAvaiable]) {
            NSDictionary *dict = result;
            self.sendInvoiceModel = [[SendInvoiceModel alloc] initWithDictionary:dict error:nil];
            [self showToastWithMessage:self.sendInvoiceModel.errorName];
            [self hideCustomHUB];
            [self popToMoreRoot];
        }
        
    } onError:^(NSString *Error) {
        [self showToastWithMessage:@"Mất kết nối tới hệ thống"];
        [self hideCustomHUB];
    } onException:^(NSString *Exception) {
        [self showToastWithMessage:@"Mất kết nối Internet"];
        [self hideCustomHUB];
    }];
}

- (UIImage *)resizeImageByWidth:(UIImage *)sourceImage scaledToWidth:(float)i_width {
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)resizeImageByHeight:(UIImage *)sourceImage scaledHeight:(float)i_height {
    float oldHeight = sourceImage.size.height;
    float scaleFactor = i_height / oldHeight;
    
    float newWidth = sourceImage.size.width * scaleFactor;
    float newHeight = oldHeight * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) hideCustomHUB {
    [[Common shareInstance] dismissCustomHUD];
}

- (void)disableButtonSendInvoice {
    [self.sendInvoiceButton setEnabled:NO];
    self.sendInvoiceButton.backgroundColor = [UIColor colorWithRed:0.36 green:0.74 blue:0.82 alpha:1.0];
}

- (void)enableButtonSendInvoice {
    [self.sendInvoiceButton setEnabled:YES];
    self.sendInvoiceButton.backgroundColor = AppColor_MainAppTintColor;
}

- (void)didTapBackButton {
    [self popToMoreRoot];
}

- (IBAction)sendInvoiceAction:(id)sender {
    [self checkHaveImage];
    if (isCheck == NO) {
        return;
    } else {
        return [self actionShowConfirmSendInvoice];
    }
}
@end
