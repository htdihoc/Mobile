//
//  KTTS_ContentBBBG_iPad.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/25/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "KTTS_ContentBBBG_iPad.h"
#import "KTTS_ContentBBBG_CELL_iPad.h"
#import "KTTS_ContentAssetBBBG_VC_iPad.h"
#import "BBBGAssetModel.h"
#import "KTTSProcessor.h"
#import "DetailBBBGModel.h"

@interface KTTS_ContentBBBG_iPad () <UITableViewDelegate, UITableViewDataSource, SOSearchBarViewDelegate, UITextFieldDelegate> {
@protected KTTS_ContentAssetBBBG_VC_iPad *contentVC;
}

@property (nonatomic) BOOL isFiltered;

@end

@implementation KTTS_ContentBBBG_iPad

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.start = 0;
    self.limit = 100;
    self.id_BBBG_detail = @"0";
    self.data_BBBG = [NSMutableArray new];
    self.data_FilterBBBG = [NSArray new];
    
    self.searchview.delegate = self;
    
    self.tbl_Content.delegate = self;
    self.tbl_Content.dataSource = self;
    self.tbl_Content.estimatedRowHeight = 150;
    self.tbl_Content.rowHeight = UITableViewAutomaticDimension;
    self.tbl_Content.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tbl_Content registerNib:[UINib nibWithNibName:@"KTTS_ContentBBBG_CELL_iPad" bundle:nil] forCellReuseIdentifier:@"KTTS_ContentBBBG_CELL_iPad"];
}

- (void) getData {
    NSDictionary *parameter = @{
                                @"idBBBGTSCN": self.id_BBBG_detail,
                                @"start": IntToString(self.start),
                                @"keyword": self.searchview.searchBar.text,
                                @"limit": IntToString(self.limit)
                                };
    [KTTSProcessor postDetailBBBG:parameter handle:^(id result, NSString *error) {
        NSArray *array = result[@"listMerEntity"];
        self.BBBG_data_array_detail = [NSMutableArray new];
        self.BBBG_data_array_detail = (NSMutableArray *)[self.BBBG_data_array_detail arrayByAddingObjectsFromArray:array];
        [self.tbl_Content reloadData];
        [self setupUI];
    } onError:^(NSString *Error) {
        //
    } onException:^(NSString *Exception) {
        //
    }];
}

- (void)setupUI {
    
    self.lbl_contentBBBG.text = [NSString stringWithFormat:@"Chi tiết %@", self.goods_name];
    
    switch (self.isStatus) {
        case 0:
        {
            self.heightMiddleView.constant = 80;
            self.btn_confirm.hidden = NO;
            self.btn_refuse.hidden = NO;
        }
            break;
        case 1:{
            self.heightMiddleView.constant = 0;
            self.btn_confirm.hidden = YES;
            self.btn_refuse.hidden = YES;
        }
            break;
        case 2:{
            self.heightMiddleView.constant = 80;
            self.btn_confirm.hidden = YES;
            self.btn_refuse.hidden = YES;
        }
            break;
        default:
            break;
    }
    [self layoutIfNeeded];
    
}

- (void) dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark SOSearchBarViewDelegate
-(BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self dismissKeyboard];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self getData];
    return YES;
}

- (void)textField:(UITextField *)textField textDidChange:(NSString *)searchText {
    [self searchlocalwith:searchText];
}

- (void) searchlocalwith:(NSString *)searchText {
    if (searchText.length == 0) {
        _isFiltered = NO;
        [self.tbl_Content reloadData];
    } else {
        _isFiltered = YES;
        NSPredicate *p = [NSPredicate predicateWithFormat:@"catMerName CONTAINS[cd] %@ or serialNumber CONTAINS[cd] %@", searchText, searchText];
        self.data_FilterBBBG = [self.BBBG_data_array_detail filteredArrayUsingPredicate:p];
        [self.tbl_Content reloadData];
    }
}

#pragma mark TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isFiltered) {
        return self.data_FilterBBBG.count;
    } else {
        return self.BBBG_data_array_detail.count;
    }
}

#pragma mark TableView Datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_isFiltered) {
        self.data_BBBG = [DetailBBBGModel arrayOfModelsFromDictionaries: self.BBBG_data_array_detail error:nil];
    } else {
        self.data_BBBG = [DetailBBBGModel arrayOfModelsFromDictionaries: self.data_FilterBBBG error:nil];
    }
    
    static NSString *ID_CELL = @"KTTS_ContentBBBG_CELL_iPad";
    KTTS_ContentBBBG_CELL_iPad *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KTTS_ContentBBBG_CELL_iPad" bundle:nil] forCellReuseIdentifier:ID_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    }
    
    cell.lbl_cellNumber.text = IntToString(indexPath.row + 1);
    DetailBBBGModel *detailBBBGModel = self.data_BBBG[indexPath.row];
    cell.lbl_assetName.text = detailBBBGModel.catMerName;
    cell.lbl_assetCount.text = IntToString(detailBBBGModel.count);
    cell.lbl_assetSerial.text = detailBBBGModel.catMerCode;
    
    switch (detailBBBGModel.stt) {
        case 0:
        {
            //            cell.lbl_assetSerial.text = @"Đã bàn giao";
            //            cell.lb_status.textColor = RGB(254, 94, 8);
        }
            break;
        case 1:
        {
            //            cell.lb_status.text = @"Đã xác nhận";
            //            cell.lb_status.textColor = RGB(2, 127, 185);
        }
            break;
        case 2:
        {
            //            cell.lb_status.text = @"Đã từ chối";
            //            cell.lb_status.textColor = RGB(254, 8, 8);
        }
            break;
        default:
            //            personalAccInfoCell.lb_status.text = @"Không xác định";
            break;
    }
    
    cell.selectionStyle = UIAccessibilityTraitNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_isFiltered) {
        [self.delegate actionShowContentVC:(int)indexPath.row array: self.BBBG_data_array_detail];
    } else {
        [self.delegate actionShowContentVC:(int)indexPath.row array: (NSMutableArray *)self.data_FilterBBBG];
    }
}
@end
