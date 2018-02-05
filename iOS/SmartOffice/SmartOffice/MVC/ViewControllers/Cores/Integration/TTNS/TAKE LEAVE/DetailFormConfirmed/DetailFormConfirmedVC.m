//
//  DetailFormConfirmedVC.m
//  SmartOffice
//
//  Created by Administrator on 6/1/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "DetailFormConfirmedVC.h"
#import "InfoDetailCell_iPad.h"
#import "PersonDetail_iPad.h"
#import "DetailLeaveModel.h"
#import "Common.h"
#import "TTNSProcessor.h"
#import "NSException+Custom.h"


@interface DetailFormConfirmedVC ()<UITableViewDataSource, UITableViewDelegate>{
@protected DetailLeaveModel *model;
}

@end

@implementation DetailFormConfirmedVC

#pragma mark Lifecycler

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadingData];
    [self setupUI];
    [self.tableView reloadData];
}

#pragma mark UI

- (void)setupUI{
    [self setBackTitle];
    self.tableView.rowHeight   =   UITableViewAutomaticDimension;
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
    [self.view endEditing:YES];
}

#pragma mark Networking

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
                [self updateUI];
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

#pragma mark UITableViewDatasouce

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == DetailLeaveSectionType_Info) {
        return 4;
    } else if (section == DetailLeaveSectionType_Handler) {
        return 1;
    } else if (section == DetailLeaveSectionType_ContentHandler) {
        return 1;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* IdentifierCell1 = @"InfoDetailCell";
    static NSString* IdentifierCell2 = @"PersonDetaiCell";
    
    if (indexPath.section == DetailLeaveSectionType_Info) {
        InfoDetailCell_iPad *infoCell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell1];
        if (!infoCell) {
            [tableView registerNib:[UINib nibWithNibName:@"InfoDetailCell_iPad" bundle:nil] forCellReuseIdentifier:IdentifierCell1];
            infoCell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell1];
        }
        NSString *timeString                = [NSString stringWithFormat:@"%@ -> %@", [self convertTimeStampToDateStr:model.fromDate format:@"HH:mm - dd/MM/yyyy"], [self convertTimeStampToDateStr:model.toDate format:@"HH:mm - dd/MM/yyyy"]];
        switch (indexPath.row) {
            case 0:
                infoCell.titleLB.text = LocalizedString(@"TTNS_LY_DO_NGHI");
                infoCell.contentLB.text = model.reason;
                break;
            case 1:
                infoCell.titleLB.text = LocalizedString(@"TTNS_THOI_GIAN_NGHI");
                infoCell.contentLB.text = timeString;
                break;
            case 2:
                infoCell.titleLB.text      = LocalizedString(@"TTNS_NOI_NGHI");
                infoCell.contentLB.text   = model.currentAddress;
                break;
            case 3:
                infoCell.titleLB.text      = LocalizedString(@"TTNS_SDT");
                infoCell.contentLB.text   = [NSString stringWithFormat:@"%ld", (long)model.phoneNumber];
            default:
                break;
        }
        return infoCell;
    } else if (indexPath.section == DetailLeaveSectionType_Handler) {
        PersonDetail_iPad *personCell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell2];
        if (!personCell) {
            [tableView registerNib:[UINib nibWithNibName:@"PersonDetail_iPad" bundle:nil] forCellReuseIdentifier:IdentifierCell2];
            personCell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell2];
        }
        personCell.titleLB.text = LocalizedString(@"TTNS_NGUOI_DUOC_BAN_GIAO");
        [personCell.strarLB setHidden:YES];
        return personCell;
    } else if (indexPath.section == DetailLeaveSectionType_ContentHandler) {
        InfoDetailCell_iPad *infoCell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell1];
        if (!infoCell) {
            [tableView registerNib:[UINib nibWithNibName:@"InfoDetailCell_iPad" bundle:nil] forCellReuseIdentifier:IdentifierCell1];
            infoCell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell1];
        }
        infoCell.titleLB.text = LocalizedString(@"TTNS_NOI_DUNG_BAN_GIAO");
        [infoCell.starLB setHidden:YES];
        infoCell.contentLB.text = @"Đưa bố đi chữa bệnh";
        return infoCell;
    } else {
        PersonDetail_iPad *personCell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell2];
        if (!personCell) {
            [tableView registerNib:[UINib nibWithNibName:@"PersonDetail_iPad" bundle:nil] forCellReuseIdentifier:IdentifierCell2];
            personCell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell2];
        }
        personCell.titleLB.text = LocalizedString(@"TTNS_CHI_HUY_DON_VI");
        personCell.nameLB.text = @"Phạm Xuân Hoàng";
        personCell.positionLB.text = @"Trưởng BU SPM";
        return personCell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == DetailDocSectionType_Info){
        return 80.0f;
    } else if(indexPath.section == DetailLeaveSectionType_Handler){
        return 144.0f;
    } else if (indexPath.section == DetailLeaveSectionType_ContentHandler) {
        return 80.0f;
    } else {
        return 144.0f;
    }
}

#pragma mark UITableViewDelegate


@end
