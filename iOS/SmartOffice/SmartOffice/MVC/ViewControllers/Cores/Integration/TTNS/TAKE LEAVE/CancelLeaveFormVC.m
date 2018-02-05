//
//  CancelLeaveFormVC.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/13/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "CancelLeaveFormVC.h"
#import "TTNSProcessor.h"
#import "StatusCell.h"
#import "handOverCell.h"
#import "ReasonCell.h"
#import "Common.h"
#import "DetailLeaveModel.h"
#import "NSException+Custom.h"

@interface CancelLeaveFormVC ()<UITableViewDelegate, UITableViewDataSource>{
    
}

@end

@implementation CancelLeaveFormVC{
    DetailLeaveModel *model;
}

#pragma mark lifecycler

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadingData];
    [self setupUI];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark UI

- (void)setupUI{
    [self setBackTitle];
    self.tableView.rowHeight            = UITableViewAutomaticDimension;
    self.tableView.separatorColor       = [UIColor clearColor];
    [self.tabBarController.tabBar setHidden:YES];
     [self addTappGesture];
}

- (void)updateUI{
}

- (void)addTappGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)setBackTitle{
    switch (_typeOfForm) {
        case TTNS_Type_NghiPhep:
            self.backTitle  = LocalizedString(@"KLIST_REGISTER_FORM_TYPE_1");
            break;
            
        case TTNS_Type_NghiViecRieng:
            self.backTitle  = LocalizedString(@"KLIST_REGISTER_FORM_TYPE_2");
            break;
            
        case TTNS_Type_NghiOm:
            self.backTitle  = LocalizedString(@"KLIST_REGISTER_FORM_TYPE_3");
            break;
            
        case TTNS_Type_NghiConOm:
            self.backTitle  = LocalizedString(@"KLIST_REGISTER_FORM_TYPE_4");
            break;
            
        default:
            break;
    }
}

#pragma mark action
- (void)dismissKeyboard{
    //    [self.reasonTV resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark networking
- (void)loadingData{
    if([Common checkNetworkAvaiable]){
        [[Common shareInstance]showHUDWithTitle:@"Loading..." inView:self.view];
        [self loadDetailRegister:self.personalFormId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
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
    [TTNSProcessor getTTNS_CHI_TIET_DON_NGHI_PHEP:self.personalFormId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
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
    static NSString* IdentifierCell1 = @"StatusCell";
    static NSString* IdentifierCell2 = @"ReasonCell";
    static NSString* IdentifierCell3 = @"HandOverCell";
    
    if(indexPath.section == 0) {
        StatusCell *statusCell          = [tableView dequeueReusableCellWithIdentifier:IdentifierCell1];
        if(statusCell == nil){
            statusCell                  = [[StatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IdentifierCell1 ];
        }
        statusCell.statusLB.text        = @"Chưa xác nhận";
        return statusCell;
    } else if(indexPath.section == 1){
        ReasonCell *reasonCell                = [tableView dequeueReusableCellWithIdentifier:IdentifierCell2];
        if(reasonCell == nil ){
            reasonCell                  = [[ReasonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IdentifierCell2];
        }
        
        NSString *timeString                = [NSString stringWithFormat:@"%@ -> %@", [self convertTimeStampToDateStr:model.fromDate format:@"HH:mm - dd/MM/yyyy"], [self convertTimeStampToDateStr:model.toDate format:@"HH:mm - dd/MM/yyyy"]];
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
        handOverCell *handoverCell      = [tableView dequeueReusableCellWithIdentifier:IdentifierCell3];
        
        if(handoverCell == nil) {
            handoverCell                = [[handOverCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IdentifierCell3];
        }
        switch (indexPath.row) {
            case 0:
                handoverCell.handOverTypeLB.text   = LocalizedString(@"TTNS_NGUOI_DUOC_BAN_GIAO");
                break;
                
            case 1:
                handoverCell.handOverTypeLB.text    = LocalizedString(@"TTNS_CHI_HUY_DON_VI");
                break;
            default:
                break;
        }
        return handoverCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 50.0f;
    } else if(indexPath.section == 1){
        return 80.0f;
    } else {
        return 120;
    }
}

#pragma mark IBAction
- (IBAction)backAction:(id)sender {
    [AppDelegateAccessor.navIntegrationVC popViewControllerAnimated:YES];
}

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
