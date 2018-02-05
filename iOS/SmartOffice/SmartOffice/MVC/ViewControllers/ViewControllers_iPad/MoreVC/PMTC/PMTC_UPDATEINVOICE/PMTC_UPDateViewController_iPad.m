//
//  PMTC_UPDateViewController_iPad.m
//  SmartOffice
//
//  Created by NguyenDucBien on 9/29/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Photos/Photos.h>
#import "PMTC_UPDateViewController_iPad.h"
#import "InfomationDocumentTableViewCell.h"
#import "AttachImageUpdateTableViewCell.h"
#import "UpdateInvoiceCollectionCell.h"
#import "ImageUpdateCollectionViewCell.h"
#import "Common.h"
#import "PMTCProcessor.h"
#import "UIImage+Resize.h"

@interface PMTC_UPDateViewController_iPad () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TTNS_BaseNavViewDelegate, AttachFileDelegateUpdate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate> {
    
    InfomationDocumentTableViewCell *infomationDocument;
    AttachImageUpdateTableViewCell *attachImageUpdate;
    UpdateInvoiceCollectionCell *updateInvoice;
    ImageUpdateCollectionViewCell *imageCollecttion;
    NSString *letters;
    
}

@property (strong, nonatomic) UICollectionView *imageCollectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) NSMutableArray *array_image_Item;
@property (strong, nonatomic) UIImagePickerController *imgPicker;
@property (nonatomic, strong) UIPopoverController *popOver;
@property (nonatomic, strong) UIImagePickerController *picker;

@end

@implementation PMTC_UPDateViewController_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tittleLabel.text = LocalizedString(@"PMTC_VOUCHER_DETAIL");
    [self.updateButton setTitle:LocalizedString(@"PMTC_UPDATE") forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"Huỷ" forState:UIControlStateNormal];
    [self setUp];
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
    [self.imageCollectionView registerNib:[UINib nibWithNibName:@"ImageUpdateCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageUpdateCollectionViewCell"];
    self.btnAction.backgroundColor = AppColor_MainAppTintColor;
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
        imageCollecttion.collectionImage.image = photoTaken;
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

- (void) dismissKeyboard {
    [self.view endEditing:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array_image_Item.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    imageCollecttion = (ImageUpdateCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageUpdateCollectionViewCell" forIndexPath:indexPath];
    if (imageCollecttion == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ImageUpdateCollectionViewCell" owner:self options:nil];
        imageCollecttion = [nib objectAtIndex:0];
    }
    imageCollecttion.collectionImage.image = self.array_image_Item[indexPath.row];
    imageCollecttion.buttonDeleteImage.tag = indexPath.row;
    [imageCollecttion.buttonDeleteImage addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    return imageCollecttion;
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

- (void) deleteImage:(UIButton *)sender {
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
            static NSString *identifier = @"InfomationDocumentTableViewCell";
            infomationDocument = (InfomationDocumentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (infomationDocument == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InfomationDocumentTableViewCell" owner:self options:nil];
                infomationDocument = [nib objectAtIndex:0];
            }
            infomationDocument.docNumberTittleLabel.text = LocalizedString(@"PMTC_DETAIL_VOUCHER_NO");
            infomationDocument.docNumberContent.text = self.contentSeriaString;
            infomationDocument.docDateTittleLabel.text = LocalizedString(@"PMTC_DETAIL_VOUCHER_DATE");
            infomationDocument.docDateContent.text = self.contentDateString;
            infomationDocument.contentLabel.text = LocalizedString(@"PMTC_DETAIL_CONTENT");
            infomationDocument.contentDocument.text = self.contentString;
            infomationDocument.selectionStyle = UIAccessibilityTraitNone;
            return infomationDocument;
        }
            break;
        case 1:
        {
            static NSString *identifier = @"AttachImageUpdateTableViewCell";
            attachImageUpdate = (AttachImageUpdateTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (attachImageUpdate == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AttachImageUpdateTableViewCell" owner:self options:nil];
                attachImageUpdate = [nib objectAtIndex:0];
            }
            attachImageUpdate.attachFileLabel.text = @"Đính kèm";
            attachImageUpdate.delegate = self;
            attachImageUpdate.selectionStyle = UIAccessibilityTraitNone;
            return attachImageUpdate;
        }
        case 2:
        {
            static NSString *identifier = @"UpdateInvoiceCollectionCell";
            updateInvoice = (UpdateInvoiceCollectionCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (updateInvoice == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UpdateInvoiceCollectionCell" owner:self options:nil];
                updateInvoice = [nib objectAtIndex:0];
            }
            [updateInvoice addSubview: self.imageCollectionView];
            updateInvoice.selectionStyle = UIAccessibilityTraitNone;
            return updateInvoice;
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
            return 220;
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

- (void) actionShowConfirmUpdateInvoice {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Xác nhận" message:@"Bạn chắc chắn muốn xác nhận cập nhật hoá đơn này?" delegate:self cancelButtonTitle:@"Đóng" otherButtonTitles:@"Xác nhận", nil];
    alert.delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            [self updateInvoice];
            break;
        default:
            break;
    }
}

- (void) updateInvoice {
    self.documentNumber = ((InfomationDocumentTableViewCell *)[self.updateInvoiceTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).contentLabel.text;
    [[Common shareInstance] showCustomHudInView:self.view];
    UIImage *image = [self resizeImageByWidth:self.array_image_Item[0] scaledToWidth:100];
    image = [self resizeImageByHeight:image scaledHeight:100];
    NSData *data = UIImageJPEGRepresentation(image, 0.1);
    NSDictionary *parameter = @{
                                @"arg0": self.documentType,
                                @"arg1": self.documentNumber,
                                @"arg2": [data base64EncodedStringWithOptions:0],
                                @"arg3": self.fileName,
                                };
    [PMTCProcessor postPMTC_updateDocument:parameter handle:^(id result, NSString *error) {
        [self hideCustomHUB];
        [self popToMoreRoot];
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
    [self popToMoreRoot];
}




- (IBAction)cancelButtonAction:(id)sender {
    
}

- (IBAction)updateButtonAction:(id)sender {
    [self actionShowConfirmUpdateInvoice];
}
@end
