//
//  PMTC_SendInvoiceViewController_iPad.m
//  SmartOffice
//
//  Created by NguyenDucBien on 9/29/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMTC_SendInvoiceViewController_iPad.h"
#import "InputText_TableViewCell.h"
#import "AttachImageTableViewCell.h"
#import "SendInvoiceCollectionCell.h"
#import "ImageCollectionViewCell.h"
#import "Common.h"
#import "PMTCProcessor.h"
#import "UIImage+Resize.h"
#import "SendInvoiceModel.h"
#import "AttachViewController_iPad.h"

@interface PMTC_SendInvoiceViewController_iPad () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TTNS_BaseNavViewDelegate, AttachFileDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate> {
    InputText_TableViewCell *inputText;
    AttachImageTableViewCell *attachFile;
    ImageCollectionViewCell *imageCollect;
    SendInvoiceCollectionCell *invoiceImage;
    NSString *letters;
    BOOL isCheck;
    @protected BOOL isChanged;
}

@property (strong, nonatomic) SendInvoiceModel *sendInvoiceModel;
@property (strong, nonatomic) UICollectionView *imageCollectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) NSMutableArray *array_image_Item;
@property (strong, nonatomic) UIImagePickerController *imgPicker;
@property (nonatomic, strong) UIPopoverController *popOver;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, assign) BOOL isSelectedImage;
@property (strong, nonatomic) AttachViewController_iPad *attachView;
@end

@implementation PMTC_SendInvoiceViewController_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    isCheck = NO;
    self.titleLabel.text = LocalizedString(@"PMTC_SEND_INVOICE");
    [self.btnSendInvoiceButton setTitle:LocalizedString(@"PMTC_SEND_INVOICE") forState:UIControlStateNormal];
    [self.cancelSendInvoiceButton setTitle:@"Huỷ" forState:UIControlStateNormal];
    [self setUp];
    self.sendInvoiceTableView.delegate = self;
    self.sendInvoiceTableView.dataSource = self;
}

- (void)setUp {
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
    [self.imageCollectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    self.btnSendInvoiceButton.backgroundColor = AppColor_MainAppTintColor;
}

- (void)showCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imgPicker = [[UIImagePickerController alloc] init];
        self.imgPicker.sourceType = UIImagePickerControllerCameraDeviceFront;
        self.imgPicker.delegate = self;
        [self presentViewController:self.imgPicker animated:YES completion:nil];
    }
}


- (void)showLibrary {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imgPicker = [[UIImagePickerController alloc] init];
        self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imgPicker.allowsEditing = YES;
        self.imgPicker.delegate = self;
        self.popOver = [[UIPopoverController alloc] initWithContentViewController:self.imgPicker];
        [self.popOver presentPopoverFromRect:self.view.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void) dismissKeyboard {
    [self.view endEditing:YES];
}

-(NSString *) randomStringWithLength: (int) len {
    letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex:8]];
    }
    
    return randomString;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.picker = picker;
    UIImage *photoTaken = (UIImage *)[info valueForKey:UIImagePickerControllerOriginalImage];
    if (photoTaken) {
        imageCollect.imageCollection.image = photoTaken;
        UIImageWriteToSavedPhotosAlbum(photoTaken, nil, nil, nil);
        [self.array_image_Item addObject:photoTaken];
        NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        self.fileName = [imagePath lastPathComponent];
        if (imagePath == nil) {
            self.fileName = [NSString stringWithFormat:@"%@%@", [self randomStringWithLength:arc4random_uniform((uint32_t)[letters length])], @".png"];
        }
        [self.imageCollectionView reloadData];
    } else{
        NSLog(@"Selected photo is NULL");
    }
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array_image_Item.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    imageCollect = (ImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    if (imageCollect == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ImageCollectionViewCell" owner:self options:nil];
        imageCollect = [nib objectAtIndex:0];
    }
    imageCollect.imageCollection.image = self.array_image_Item[indexPath.row];
    imageCollect.deleteImageButton.tag = indexPath.row;
    [imageCollect.deleteImageButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    return imageCollect;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.bounds.size.width-60)/3, (self.view.bounds.size.width-60)/3);
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (void)deleteImage:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    [self.array_image_Item removeObjectAtIndex:button.tag];
    [self.imageCollectionView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            static NSString *identifier = @"InputText_TableViewCell";
            InputText_TableViewCell *inputTextCell = (InputText_TableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (inputTextCell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InputText_TableViewCell" owner:self options:nil];
                inputTextCell = [nib objectAtIndex:0];
            }
            inputTextCell.docNumberTittle.text = LocalizedString(@"PMTC_SENDINVOICE_BILLNO");
            inputTextCell.codeTaxTittle.text = LocalizedString(@"PMTC_SENDINVOICE_TAXCODE");
            inputTextCell.docNumberTextfile.placeholder = LocalizedString(@"PMTC_SENDINVOICE_CREAT_BILLNO");
            inputTextCell.codeTaxTextfile.placeholder = LocalizedString(@"PMTC_SENDINVOICE_TAXCODE_CREAT");
            inputTextCell.docNumberTextfile.text = self.documentNumber;
            inputTextCell.docNumberTextfile.text = self.taxCode;
            
            inputTextCell.selectionStyle = UIAccessibilityTraitNone;
            return inputTextCell;
        }
            break;
        case 1:
                {
            static NSString *identifier = @"AttachImageTableViewCell_iPad";
            attachFile = (AttachImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (attachFile == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AttachImageTableViewCell" owner:self options:nil];
                attachFile = [nib objectAtIndex:0];
            }
                    attachFile.attachTittle.text = @"Đính kèm";
            attachFile.delegate = self;
            attachFile.selectionStyle = UIAccessibilityTraitNone;
            return attachFile;
        }
        case 2:
        {
            static NSString *identifier = @"SendInvoiceCollectionCell";
            invoiceImage = (SendInvoiceCollectionCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (invoiceImage == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SendBillCollectionCell" owner:self options:nil];
                invoiceImage = [nib objectAtIndex:0];
            }
            [invoiceImage addSubview: self.imageCollectionView];
            invoiceImage.selectionStyle = UIAccessibilityTraitNone;
            return invoiceImage;
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
            return 200;
        }
            break;
        case 1:
        {
            return 100;
        }
            break;
        case 2:
        {
            return self.heightCollection;
        }
            break;
        default:
            return 0;
            break;
    }
}
- (void)checkHaveImage {
    if (self.array_image_Item.count > 0) {
        isCheck = YES;
    } else {
        [self actionShowConfirm];
    }
}

- (void) actionShowConfirmSendInvoice {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Xác nhận" message:@"Bạn chắc chắn muốn xác nhận gửi hoá đơn này?" delegate:self cancelButtonTitle:@"Đóng" otherButtonTitles:@"Xác nhận", nil];
    alert.delegate = self;
    [alert show];
}

- (void) actionShowConfirm{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Xác nhận" message:@"Bạn bắt buộc phải chọn ảnh đính kèm" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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


#pragma mark - TextFielđelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (((InputText_TableViewCell *)[self.sendInvoiceTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).docNumberTextfile.text.length > 0 & ((InputText_TableViewCell *)[self.sendInvoiceTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).codeTaxTextfile.text.length > 0) {
        isChanged = YES;
    } else{
        isChanged = NO;
    }
}

#pragma mark - Validate TextFile!

- (BOOL)isValidate {
    if (((InputText_TableViewCell *)[self.sendInvoiceTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).docNumberTittle != nil && [[((InputText_TableViewCell *)[self.sendInvoiceTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).docNumberTittle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
            if (((InputText_TableViewCell *)[self.sendInvoiceTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).codeTaxTittle != nil && [[((InputText_TableViewCell *)[self.sendInvoiceTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).codeTaxTittle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                isChanged = YES;
                return YES;
            } else {
                [[Common shareInstance]showErrorHUDWithMessage:[NSString stringWithFormat:@"%@ %@", LocalizedString(@"Bạn chưa nhập"), LocalizedString(@"PMTC_SENDINVOICE_BILLNO")] inView:self.view];
            }
    } else {
        [[Common shareInstance]showErrorHUDWithMessage:[NSString stringWithFormat:@"%@ %@", LocalizedString(@"Bạn chưa nhập"), LocalizedString(@"PMTC_SENDINVOICE_TAXCODE")] inView:self.view];
    }
    return NO;
}


#pragma mark - Util Image
- (void) sendInvoiceConfirm {
    self.documentNumber = ((InputText_TableViewCell *)[self.sendInvoiceTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).docNumberTextfile.text;
    self.taxCode = ((InputText_TableViewCell *)[self.sendInvoiceTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).codeTaxTextfile.text;
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

- (void)didTapBackButton {
    [self popToIntegrationRoot];
}

@end
