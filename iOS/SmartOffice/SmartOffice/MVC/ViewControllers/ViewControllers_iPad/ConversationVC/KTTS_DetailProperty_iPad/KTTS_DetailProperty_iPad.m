//
//  KTTS_DetailProperty_iPad.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "KTTS_DetailProperty_iPad.h"
#import "KTTS_DetailPropertyCell_iPad.h"
#import "PropertyDetailsCell.h"
@implementation KTTS_DetailProperty_iPad

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tbl_Detail.delegate = self;
    self.tbl_Detail.dataSource = self;
    self.btn_Confirm.hidden = YES;
    self.tbl_Detail.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.layer.borderWidth                 = 1;
    self.view.layer.borderColor                 = AppColor_BorderForView.CGColor;
    self.titleView.layer.borderWidth            = 1;
    self.titleView.layer.borderColor            = AppColor_BorderForView.CGColor;
    
    [self.tbl_Detail registerNib:[UINib nibWithNibName:@"KTTS_DetailPropertyCell_iPad" bundle:nil] forCellReuseIdentifier:@"KTTS_DetailPropertyCell_iPad"];
}

- (void)setButtonConfirm {
    self.btn_Confirm.hidden = NO;
    if (self.value_status.length == 0) {
        
        self.isConfirm = NO;
        
        [self.btn_Confirm setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        self.btn_Confirm.backgroundColor            = RGB(14, 133, 188);
        self.btn_Confirm.layer.borderWidth          = 1;
        self.btn_Confirm.layer.borderColor          = RGB(14, 133, 188).CGColor;
        self.btn_Confirm.layer.cornerRadius         = 3;
        [self.btn_Confirm setTitle:@"Xác nhận tài sản" forState:UIControlStateNormal];
    } else if (self.value_status.length > 0) {
        
        self.isConfirm = YES;
        
        [self.btn_Confirm setTitleColor: RGB(240, 82, 83) forState:UIControlStateNormal];
        self.btn_Confirm.backgroundColor            = [UIColor whiteColor];
        self.btn_Confirm.layer.borderWidth          = 1;
        self.btn_Confirm.layer.borderColor          = RGB(240, 82, 83).CGColor;
        self.btn_Confirm.layer.cornerRadius         = 3;
        [self.btn_Confirm setTitle:@"Huỷ thông báo" forState:UIControlStateNormal];
    } else {
        NSLog(@"else");
    }
}

#pragma Mark Table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12; // list count
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID_CELL = @"KTTS_DetailPropertyCell_iPad";
    KTTS_DetailPropertyCell_iPad *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KTTS_DetailPropertyCell_iPad" bundle:nil] forCellReuseIdentifier:ID_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    }
    
    switch (indexPath.row) {
        case 0: {
            cell.lbl_title.text             = @"Tên tài sản:";
            cell.lbl_content.text           = self.value_commodity_name;
            [self setButtonConfirm];
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
    
    // [cell setupDataAtIndex:indexPath.row];
    
    return cell;
}

#pragma Mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // return UITableViewAutomaticDimension;
    return indexPath.row == 0 ? 80.0 : 40.0;
}

@end
