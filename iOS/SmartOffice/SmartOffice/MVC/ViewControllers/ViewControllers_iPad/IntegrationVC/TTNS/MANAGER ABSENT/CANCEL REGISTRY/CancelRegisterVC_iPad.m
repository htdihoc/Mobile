//
//  CancelRegisterVC_iPad.m
//  SmartOffice
//
//  Created by NguyenDucBien on 5/23/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "CancelRegisterVC_iPad.h"
#import "TTNSProcessor.h"
#import "CancelStatusCell.h"
#import "CancelHandOverCell.h"
#import "CancelReasonCell.h"
#import "Common.h"
#import "DetailLeaveModel.h"
#import "NSException+Custom.h"

@interface CancelRegisterVC_iPad () <UITableViewDelegate, UITableViewDataSource> {
}

@end

@implementation CancelRegisterVC_iPad {
    DetailLeaveModel *model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight            = UITableViewAutomaticDimension;
    self.tableView.separatorColor       = [UIColor clearColor];
    [self.tabBarController.tabBar setHidden:YES];
    [self.tableView reloadData];
    [self setupUI];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark UI

- (void)setupUI{
    self.mTitle.text = @"Chi tiết đăng ký";
    [self addTappGesture];
}

- (void)updateUI{
}

- (void)addTappGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark action

- (void)dismissKeyboard{
    //    [self.reasonTV resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark networking
- (void)loadingData:(NSInteger)personalFormId{
    if([Common checkNetworkAvaiable]){
        [[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
        [self loadDetailRegister:personalFormId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            [[Common shareInstance]dismissHUD];
            if(success){
                DLog(@"Get detail register success");
                NSDictionary *data = [resultDict valueForKey:@"data"];
                NSDictionary *entity = [data valueForKey:@"entity"][0];
                model = [[DetailLeaveModel alloc]initWithDictionary:entity error:nil];
                [self.tableView reloadData];
            } else {
                [self handleErrorFromResult:resultDict withException:exception inView:self.view];
            }
        }];
    } else {
        [self handleErrorFromResult:nil withException:[NSException initWithNoNetWork] inView:self.view];
    }
}

#pragma mark request Server
- (void)loadDetailRegister:(NSInteger)personalFormId callBack:(Callback)callBack{
    [TTNSProcessor getTTNS_CHI_TIET_DON_NGHI_PHEP:personalFormId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        callBack(success, resultDict, exception);
    }];
}

#pragma mark UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    } else if(section == 1){
        return 4;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* IdentifierCellStatus   = @"CancelStatusCell";
    static NSString* IdentifierCellReason   = @"CancelReasonCell";
    static NSString* IdentifierCellHandOver = @"CancelHandOverCell";
    
    if(indexPath.section == 0) {
        CancelStatusCell *statusCell          = [tableView dequeueReusableCellWithIdentifier:IdentifierCellStatus];
        if(statusCell == nil){
            
            [tableView registerNib:[UINib nibWithNibName:IdentifierCellStatus bundle:nil] forCellReuseIdentifier:IdentifierCellStatus];
            statusCell = [tableView dequeueReusableCellWithIdentifier:IdentifierCellStatus];
        }
        statusCell.statusLB.text        = @"Chưa xác nhận";
        return statusCell;
    } else if(indexPath.section == 1){
        CancelReasonCell *reasonCell                = [tableView dequeueReusableCellWithIdentifier:IdentifierCellReason];
        if(reasonCell == nil ){
            [tableView registerNib:[UINib nibWithNibName:IdentifierCellReason bundle:nil] forCellReuseIdentifier:IdentifierCellReason];
            reasonCell = [tableView dequeueReusableCellWithIdentifier:IdentifierCellReason];
        }
        NSString *timeString = [NSString stringWithFormat:@"%@ -> %@", [self                        convertTimeStampToDateStr:model.fromDate format:@"HH:mm - dd/MM/yyyy"], [self convertTimeStampToDateStr:model.toDate format:@"HH:mm - dd/MM/yyyy"]];
        switch (indexPath.row) {
            case 0:
                reasonCell.mTitle.text      = LocalizedString(@"TTNS_LY_DO_NGHI");
                reasonCell.mSubTitle.text   = model.reason;
                break;
            case 1:
                reasonCell.mTitle.text      = LocalizedString(@"TTNS_THOI_GIAN_NGHI");
                reasonCell.mSubTitle.text   = timeString;
                break;
            case 2:
                reasonCell.mTitle.text      = LocalizedString(@"TTNS_NOI_NGHI");
                reasonCell.mSubTitle.text   = model.currentAddress;
                break;
            case 3:
                reasonCell.mTitle.text      = LocalizedString(@"TTNS_SDT");
                reasonCell.mSubTitle.text   = [NSString stringWithFormat:@"%ld", (long)model.phoneNumber];
            default:
                break;
        }
        
        return reasonCell;
    } else {
        CancelHandOverCell *handoverCell      = [tableView dequeueReusableCellWithIdentifier:IdentifierCellHandOver];
        
        if(handoverCell == nil) {
            [tableView registerNib:[UINib nibWithNibName:IdentifierCellHandOver bundle:nil] forCellReuseIdentifier:IdentifierCellHandOver];
            handoverCell = [tableView dequeueReusableCellWithIdentifier:IdentifierCellHandOver];
        }
        switch (indexPath.row) {
            case 0:
                handoverCell.handOverTypeLB.text = LocalizedString(@"TTNS_NGUOI_DUOC_BAN_GIAO");
                break;
                
            case 1:
                handoverCell.handOverTypeLB.text = LocalizedString(@"TTNS_CHI_HUY_DON_VI");
                break;
            default:
                break;
        }
        return handoverCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return 50.0f;
    } else if(indexPath.section == 1){
        return 80.0f;
    } else {
        return 120.0f;
    }
}

#pragma mark IBAction

- (IBAction)cancelAction:(id)sender {
    UIAlertController* alertView= [UIAlertController alertControllerWithTitle:LocalizedString(@"TTNS_XAC_NHAN_BBBG") message:LocalizedString(@"TTNS_XAC_NHAN_BBBG_CONTENT") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* closeButton      = [UIAlertAction actionWithTitle:LocalizedString(@"TTNS_CheckOut_Đóng") style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction* cancleFormButton       = [UIAlertAction actionWithTitle:LocalizedString(@"TTNS_NormalRegisterDetail_Huỷ_trình_ký") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //Delete form
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
//    [cancleFormButton setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [alertView addAction:closeButton];
    [alertView addAction:cancleFormButton];
    alertView.view.tintColor = AppColor_MainTextColor;
    [self presentViewController:alertView animated:YES completion:nil];
}
@end
