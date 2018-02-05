//
//  KTTS_ContentAssetBBBG_VC_iPad.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "KTTS_ContentAssetBBBG_VC_iPad.h"
#import "MZFormSheetController.h"
#import "KTTS_DetailPropertyCell_iPad.h"

@interface KTTS_ContentAssetBBBG_VC_iPad () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation KTTS_ContentAssetBBBG_VC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tbl_Content.delegate = self;
    self.tbl_Content.dataSource = self;
    self.tbl_Content.rowHeight = 50;
    self.tbl_Content.estimatedRowHeight = UITableViewAutomaticDimension;
    
    _tbl_Content.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tbl_Content registerNib:[UINib nibWithNibName:@"KTTS_DetailPropertyCell_iPad" bundle:nil] forCellReuseIdentifier:@"KTTS_DetailPropertyCell_iPad"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)action_Done:(UIButton *)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController * _Nonnull formSheetController) {
        //
    }];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


#pragma mark UITableviewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID_CELL = @"KTTS_DetailPropertyCell_iPad";
    KTTS_DetailPropertyCell_iPad *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"PropertyDetailsCell" bundle:nil] forCellReuseIdentifier:ID_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    }
    
    [cell.lbl_title setFont:[UIFont systemFontOfSize:14]];
    [cell.lbl_content setFont:[UIFont systemFontOfSize:16]];
    
    // [cell setupDataAtIndex:indexPath.row];
    
    self.lbl_good_names.text = [NSString stringWithFormat:@"Mã BBBG: %@", self.goods_name];
    
    switch (indexPath.row) {
        case 0: {
            cell.lbl_title.text             = @"Tên tài sản:";
            cell.lbl_content.text           = self.value_commodity_name;
        } break;
        case 1: {
            cell.lbl_title.text             = @"Mã tài sản:";
            cell.lbl_content.text           = self.value_commodity_code;
        } break;
        case 2: {
            cell.lbl_title.text             = @"Đơn vị tính:";
            cell.lbl_content.text           = self.value_unit;
        } break;
        case 3: {
            cell.lbl_title.text             = @"Số lượng:";
            cell.lbl_content.text           = self.value_number;
        } break;
        case 4: {
            cell.lbl_title.text             = @"Serial:";
            cell.lbl_content.text           = self.value_serial;
        } break;
        case 5: {
            cell.lbl_title.text             = @"Hãng sản xuất:";
            cell.lbl_content.text           = self.value_manufacturer;
        } break;
        case 6: {
            cell.lbl_title.text             = @"Tình trạng:";
            cell.lbl_content.text           = self.value_aspect;
        } break;
        case 7: {
            cell.lbl_title.text             = @"Thời hạn sử dụng:";
            cell.lbl_content.text           = self.value_expiry_date;
        } break;
        case 8: {
            cell.lbl_title.text             = @"Loại tài sản:";
            cell.lbl_content.text           = self.value_asset_type;
        } break;
        case 9: {
            cell.lbl_title.text             = @"T.gian đưa vào sử dụng:";
            cell.lbl_content.text           = self.value_use_time;
        } break;
        case 10: {
            cell.lbl_title.text             = @"Nguyên giá bàn giao:";
            cell.lbl_content.text           = self.value_price;
        } break;
        case 11: {
            cell.lbl_title.text             = @"Trạng thái:";
            cell.lbl_content.text           = self.value_status;
            //  _lbl_content.textColor =
        } break;
        default:
            break;
    }
    
    return cell;
}

@end
