//
//  PMTC_SentInvoice.m
//  SmartOffice
//
//  Created by NguyenDucBien on 6/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "PMTC_SentInvoice.h"
#import "Constants.h"
#import "InformationInput.h"
#import "AttachFileCell.h"
#import "CollectionImageCell.h"
#import "ImageCollectionViewCell.h"

@interface PMTC_SentInvoice () <UITableViewDataSource, UITableViewDelegate, TTNS_BaseNavViewDelegate>

@end

@implementation PMTC_SentInvoice

//AVCaptureSession *session;
//AVCaptureStillImageOutput *StillImageOutput;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backTitle = @"Gửi hoá đơn";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    [self setupUI];
}

//- (void)viewWillAppear:(BOOL)animated {
//    session = [[AVCaptureSession alloc] init];
//    [session setSessionPreset:AVCaptureSessionPresetPhoto];
//    
//    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    NSError *error;
//    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
//    if ([session canAddInput:deviceInput]) {
//        [session addInput:deviceInput];
//    }
//    
//    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
//    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
//    CALayer *rootLayer = [[self view] layer];
//    [rootLayer setMasksToBounds:YES];
//    CGRect frame = _frameForCapture.frame;
//    [previewLayer setFrame:frame];
//    [rootLayer insertSublayer:previewLayer atIndex:0];
//    StillImageOutput = [[AVCaptureStillImageOutput alloc] init];
//    NSDictionary *outputSetting = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
//    [StillImageOutput setOutputSettings:outputSetting];
//    [session addOutput:StillImageOutput];
//    [session startRunning];
//}


- (void)setupUI {
    self.headerLB.text = @"THÔNG TIN HOÁ ĐƠN";
}


#pragma mark UITableView DataSource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == DetailSendInvoiceSectionType_Info) {
        return 2;
    } else if (section == DetailSendInvoiceSectionType_Attach) {
        return 1;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* IdentifierCell1 = @"InformationCell";
    static NSString* IdentifierCell2 = @"AttachFileCell";
    static NSString* IdentifierCell3 = @"ImageCollectionCell";
    
    if (indexPath.section == DetailSendInvoiceSectionType_Info) {
        InformationInput *infoCell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell1];
        if (!infoCell) {
            [tableView registerNib:[UINib nibWithNibName:@"InformationInput" bundle:nil] forCellReuseIdentifier:IdentifierCell1];
            infoCell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell1];
        }
        
        switch (indexPath.row) {
            case 0:
                infoCell.tittleLB.text = @"Số hoá đơn";
                infoCell.contentTF.placeholder = @"Nhập số hoá đơn";
                break;
            case 1:
                infoCell.tittleLB.text = @"Mã số thuế";
                infoCell.contentTF.placeholder = @"Nhập mã số thuế";
            default:
                break;
        }
        return infoCell;
    } else if (indexPath.section == DetailSendInvoiceSectionType_Attach) {
        AttachFileCell * attachCell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell2];
        
        if (!attachCell) {
            [tableView registerNib:[UINib nibWithNibName:@"AttachFileCell" bundle:nil] forCellReuseIdentifier:IdentifierCell2];
            attachCell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell2];
        }
        attachCell.tittleLB.text = @"File đính kèm ảnh chụp hoá đơn";
        return attachCell;
    } else {
        CollectionImageCell * imageCell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell3];
        
        if (!imageCell) {
            [tableView registerNib:[UINib nibWithNibName:@"CollectionImageCell" bundle:nil] forCellReuseIdentifier:IdentifierCell3];
            imageCell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell3];
        }
        return imageCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == DetailSendInvoiceSectionType_Info){
        return 96.0f;
    } else if(indexPath.section == DetailSendInvoiceSectionType_Attach){
        return 88.0f;
    } else {
        return 104.0f;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionCell" forIndexPath:indexPath];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 3;
}


@end
