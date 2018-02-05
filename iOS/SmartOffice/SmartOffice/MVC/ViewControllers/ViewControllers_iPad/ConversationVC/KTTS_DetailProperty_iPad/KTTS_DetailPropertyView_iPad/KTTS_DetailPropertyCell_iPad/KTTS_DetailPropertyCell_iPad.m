//
//  KTTS_DetailPropertyCell_iPad.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "KTTS_DetailPropertyCell_iPad.h"

@implementation KTTS_DetailPropertyCell_iPad

typedef enum: NSUInteger {
    DetailPropertyIndexType_TenTaiSan,
    DetailPropertyIndexType_MaTaiSan,
    DetailPropertyIndexType_DonViTinh,
    DetailPropertyIndexType_SoLuong,
    DetailPropertyIndexType_Serial,
    DetailPropertyIndexType_HangSanXuat,
    DetailPropertyIndexType_TinhTrang,
    DetailPropertyIndexType_ThoiHanSuDung,
    DetailPropertyIndexType_LoaiTaiSan,
    DetailPropertyIndexType_ThoiGianDuaVaoSuDung,
    DetailPropertyIndexType_NguyenGiaBanGiao,
    DetailPropertyIndexType_TrangThai
} DetailPropertyIndexType;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setupDataAtIndex:(NSInteger)index {
    
    switch (index) {
        case DetailPropertyIndexType_TenTaiSan: {
            _lbl_title.text = @"Tên tai sản:";
            _lbl_content.text = @"Màn hình máy tính LCD HP Comqap led R191, 19inch";
        } break;
        case DetailPropertyIndexType_MaTaiSan: {
            _lbl_title.text = @"Mã tài sản:";
            _lbl_content.text = @"PCDESKTOP";
        } break;
        case DetailPropertyIndexType_DonViTinh: {
            _lbl_title.text = @"Đơn vị tính:";
            _lbl_content.text = @"Bộ";
        } break;
        case DetailPropertyIndexType_SoLuong: {
            _lbl_title.text = @"Số lượng:";
            _lbl_content.text = @"1";
        } break;
        case DetailPropertyIndexType_Serial: {
            _lbl_title.text = @"Serial:";
            _lbl_content.text = @"VT9000274036";
        } break;
        case DetailPropertyIndexType_HangSanXuat: {
            _lbl_title.text = @"Hãng sản xuất:";
            _lbl_content.text = @"HTPC";
        } break;
        case DetailPropertyIndexType_TinhTrang: {
            _lbl_title.text = @"Tình trạng:";
            _lbl_content.text = @"Đang sử dụng";
        } break;
        case DetailPropertyIndexType_ThoiHanSuDung: {
            _lbl_title.text = @"Thời hạn sử dụng:";
            _lbl_content.text = @"20 tháng";
        } break;
        case DetailPropertyIndexType_LoaiTaiSan: {
            _lbl_title.text = @"Loại tài sản:";
            _lbl_content.text = @"TBVP";
        } break;
        case DetailPropertyIndexType_ThoiGianDuaVaoSuDung: {
            _lbl_title.text = @"T.gian đưa vào sử dụng:";
            _lbl_content.text = @"20 tháng";
        } break;
        case DetailPropertyIndexType_NguyenGiaBanGiao: {
            _lbl_title.text = @"Nguyên giá bàn giao:";
            _lbl_content.text = @"15.000.000.000.000";
        } break;
        case DetailPropertyIndexType_TrangThai: {
            _lbl_title.text = @"Trạng thái:";
            _lbl_content.text = @"Đã Hỏng";
            //  _lbl_content.textColor =
        } break;
            
        default:
            break;
    }
}
@end
