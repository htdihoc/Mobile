//
//  VoucherDetailViewController.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 6/27/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Photos/Photos.h>
#import "VoucherDetailViewController.h"
#import "HeaderPMTCCell.h"
#import "CodeSendBillDetailCell.h"
#import "AttachFileDetailCell.h"
#import "SendBillCollectionDetailCell.h"
#import "ImageCollectionDetailCell.h"
#import "Common.h"
#import "UIImage+Resize.h"
#import "PMTCProcessor.h"
#import "UpdateInvoiceModel.h"


@import AssetsLibrary;
@interface VoucherDetailViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TTNS_BaseNavViewDelegate, AttachFileDetailDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    SendBillCollectionDetailCell *sendBillCollection;
    AttachFileDetailCell *attachFileCell;
    NSString *letters;
    BOOL isCheck;
}
@property (strong, nonatomic) UpdateInvoiceModel *updateInvoiceModel;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIPopoverController *popOver;

@end

@implementation VoucherDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isCheck = NO;
    self.backTitle = LocalizedString(@"PMTC_VOUCHER_DETAIL");
    [self.updateInvoiceButton setTitle:LocalizedString(@"PMTC_UPDATE") forState:UIControlStateNormal];
    self.heightCollection = 200;
    self.array_image_Item = [NSMutableArray new];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    self.sendbilldetailTableView.estimatedRowHeight = 80;
    self.sendbilldetailTableView.rowHeight = UITableViewAutomaticDimension;
    self.layout = [UICollectionViewFlowLayout new];
    [self.layout setScrollDirection: UICollectionViewScrollDirectionVertical];
    self.layout.minimumLineSpacing = 15;
    
    self.imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.heightCollection) collectionViewLayout:self.layout];
    self.imageCollectionView.backgroundColor = [UIColor clearColor];
    self.imageCollectionView.showsVerticalScrollIndicator = YES;
    self.imageCollectionView.scrollEnabled = YES;
    self.imageCollectionView.delegate = self;
    self.imageCollectionView.dataSource = self;
    [self.imageCollectionView registerNib:[UINib nibWithNibName:@"ImageCollectionDetailCell" bundle:nil] forCellWithReuseIdentifier:@"imageCollectionDetailCell"];
}

- (void)showCameraUpdate {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imgPicker = [[UIImagePickerController alloc] init];
        self.imgPicker.sourceType = UIImagePickerControllerCameraDeviceFront;
        self.imgPicker.delegate = self;
        [self presentViewController:self.imgPicker animated:YES completion:nil];
    }
}

- (void)showLibraryUpdate {
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
    
    [self dismissViewControllerAnimated:YES completion:^ {
        //[self popToMoreRoot];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array_image_Item.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionDetailCell *imageCollectionCell = (ImageCollectionDetailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"imageCollectionDetailCell" forIndexPath:indexPath];
    if (imageCollectionCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ImageCollectionDetailCell" owner:self options:nil];
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

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)checkHaveImage {
    if (self.array_image_Item.count > 0) {
        isCheck = YES;
    } else {
        [self actionShowConfirm];
    }
}

- (void) actionShowConfirm{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Xác nhận" message:@"Bạn bắt buộc phải chọn ảnh đính kèm" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.delegate = self;
    [alert show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            static NSString *identifier = @"codeSendBillDetailCell";
            _codeSendBillDetailCell = (CodeSendBillDetailCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (_codeSendBillDetailCell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CodeSendBillDetailCell" owner:self options:nil];
                _codeSendBillDetailCell = [nib objectAtIndex:0];
            }
            _codeSendBillDetailCell.title_header.text = LocalizedString(@"PMTC_DETAIL_VOUCHER_NO");
            _codeSendBillDetailCell.contentLabel.text = self.contentSeriaString;
            _codeSendBillDetailCell.selectionStyle = UIAccessibilityTraitNone;
            return _codeSendBillDetailCell;
        }
            break;
        case 1:
        {
            static NSString *identifier = @"codeSendBillDetailCell";
            _codeSendBillDetailCell = (CodeSendBillDetailCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (_codeSendBillDetailCell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CodeSendBillDetailCell" owner:self options:nil];
                _codeSendBillDetailCell = [nib objectAtIndex:0];
            }
            _codeSendBillDetailCell.title_header.text = LocalizedString(@"PMTC_DETAIL_VOUCHER_DATE");
            _codeSendBillDetailCell.contentLabel.text = self.contentDateString;
            _codeSendBillDetailCell.selectionStyle = UIAccessibilityTraitNone;
            return _codeSendBillDetailCell;
        }
            break;
        case 2:
        {
            static NSString *identifier = @"codeSendBillDetailCell";
            _codeSendBillDetailCell = (CodeSendBillDetailCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (_codeSendBillDetailCell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CodeSendBillDetailCell" owner:self options:nil];
                _codeSendBillDetailCell = [nib objectAtIndex:0];
            }
            _codeSendBillDetailCell.title_header.text = LocalizedString(@"PMTC_DETAIL_CONTENT");
            _codeSendBillDetailCell.contentLabel.text = self.contentString;
            _codeSendBillDetailCell.selectionStyle = UIAccessibilityTraitNone;
            return _codeSendBillDetailCell;
        }
            break;
        case 3:
        {
            static NSString *identifier = @"attachFileDetailCell";
            attachFileCell = (AttachFileDetailCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (attachFileCell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AttachFileDetailCell" owner:self options:nil];
                attachFileCell = [nib objectAtIndex:0];
            }
            attachFileCell.attacgFileTittle.text = LocalizedString(@"PMTC_DETAIL_FILE_ATTACH");
            attachFileCell.delegate = self;
            attachFileCell.selectionStyle = UIAccessibilityTraitNone;
            return attachFileCell;
        }
        case 4:
        {
            static NSString *identifier = @"sendBillCollectionDetailCell";
            sendBillCollection = (SendBillCollectionDetailCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (sendBillCollection == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SendBillCollectionDetailCell" owner:self options:nil];
                sendBillCollection = [nib objectAtIndex:0];
            }
            [sendBillCollection addSubview:self.imageCollectionView];
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
            return 80;
        }
            break;
        case 1:
        {
            return 80;
        }
            break;
        case 2:
        {
            return 80;
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


- (void) updateIvoice {
    self.documentNumber = ((CodeSendBillDetailCell *)[self.sendbilldetailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).contentLabel.text;
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
        if ([Common checkNetworkAvaiable]) {
            NSDictionary *dict = result;
            self.updateInvoiceModel = [[UpdateInvoiceModel alloc] initWithDictionary:dict error:nil];
            [self showToastWithMessage:self.updateInvoiceModel.errorName];
            [self hideCustomHUB];
//            [self popToMoreRoot];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)didTapBackButton {
    [self popToMoreRoot];
}

- (IBAction)updateInvoiceAction:(id)sender {
    [self checkHaveImage];
    if (isCheck == YES) {
        [self updateIvoice];
    } else {
       return [self checkHaveImage];
    }
    
}
@end
