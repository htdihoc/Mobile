//
//  VOffice_DetailWorkCell_iPad.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_DetailWorkCell_iPad.h"
#import "DetailWorkModel.h"
#import "WorkModel.h"
#import "Common.h"
#import "UILabel+FormattedText.h"

@implementation VOffice_DetailWorkCell_iPad


typedef enum : NSUInteger {
    DetailWorkIndexType_TenCV,
    DetailWorkIndexType_NoiDungCV,
    DetailWorkIndexType_LoaiCV,
    DetailWorkIndexType_NgayGiao,
    DetailWorkIndexType_ThoiHan,
    DetailWorkIndexType_TrangThai,
    DetailWorkIndexType_TanSuatBaoCao,
    DetailWorkIndexType_PhoiHop
} DetailWorkIndexType;


- (void)awakeFromNib {
    [super awakeFromNib];
    
    _lbl_Title.textColor = RGB(102, 102, 102);
    _lbl_Content.textColor = RGB(51, 51, 51);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setupDataByModel:(DetailWorkModel *)model atIndex:(NSInteger)index segment:(NSInteger)segment {
    if (model)
    {
        switch (index) {
            case DetailWorkIndexType_TenCV:{
                _lbl_Title.text = LocalizedString(@"DetailWorkCell_Tên_công_việc");
                _lbl_Content.text = model.taskName;
            }
                break;
            case DetailWorkIndexType_NoiDungCV:{
                _lbl_Title.text = LocalizedString(@"DetailWorkCell_Nội_dung_công_việc");
                _lbl_Content.text = model.content;
            }
                break;
            case DetailWorkIndexType_LoaiCV:{
                _lbl_Title.text = LocalizedString(@"DetailWorkCell_Loại_công_việc");
                _lbl_Content.text = model.taskTypeName2;
            }
                break;
            case DetailWorkIndexType_NgayGiao:{
                _lbl_Title.text = LocalizedString(@"DetailWorkCell_Ngày_giao");
                _lbl_Content.text = [[Common shareInstance] fullNormalStringDateFromServerDate:model.startTime serverFormatDate:@"dd/MM/yyyy HH:mm"];
            }
                break;
            case DetailWorkIndexType_ThoiHan:{
                _lbl_Title.text = LocalizedString(@"DetailWorkCell_Thời_hạn");
                _lbl_Content.text = [[Common shareInstance] fullNormalStringDateFromServerDate:model.endTime serverFormatDate:@"dd/MM/yyyy HH:mm"];
            }
                break;
            case DetailWorkIndexType_TrangThai:{
                _lbl_Title.text = LocalizedString(@"DetailWorkCell_Trạng_thái");
                _lbl_Content.text = model.statusName;
                if (model.status == WorkStatus_InProgress) {
                    [_lbl_Content colorSubString:model.statusName withColor:AppColor_HightLightTextColor];
                }else{
                    _lbl_Content.textColor = AppColor_MainTextColor;
                }
            }
                break;
            case DetailWorkIndexType_TanSuatBaoCao:{
                _lbl_Title.text = LocalizedString(@"DetailWorkCell_Tần_suất_báo_cáo");
                _lbl_Content.text = model.updateFrequencyName;
            }
                break;
            case DetailWorkIndexType_PhoiHop:{
				if (segment == 0) {
					if (model.commandType == CommandTypeWork_Combinated) {
						_lbl_Title.text = LocalizedString(@"DetailWorkCell_Phối_hợp");
						_lbl_Content.text = model.enforcementName;

					}else{
						_lbl_Title.text = LocalizedString(@"DetailWorkCell_Người_giao");
						_lbl_Content.text = model.commanderName;
					}
					
				} else {
					_lbl_Title.text = LocalizedString(@"DetailWorkCell_Giao_tới");
					_lbl_Content.text = model.enforcementName;
				}				
            }
                break;
				
                
            default:
                break;
        }
    }
    else
    {
        _lbl_Title.text = @"";
        _lbl_Content.text = @"";
    }
    
}

@end
