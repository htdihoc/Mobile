//
//  DetailWorkCell.m
//  SmartOffice
//
//  Created by Kaka on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "DetailWorkCell.h"
#import "DetailWorkModel.h"
#import "WorkModel.h"
#import "Common.h"
#import "UILabel+FormattedText.h"

//DetailWorkIndexType_MucDo - unuse this now
typedef enum : NSUInteger {
    DetailWorkIndexType_TenCV = 0,
    DetailWorkIndexType_NoiDungCV,
    DetailWorkIndexType_LoaiCV,
    DetailWorkIndexType_NgayGiao,
    DetailWorkIndexType_ThoiHan,
    DetailWorkIndexType_TrangThai,
    DetailWorkIndexType_TanSuatBaoCao,
    DetailWorkIndexType_PhoiHop
} DetailWorkIndexType;


@implementation DetailWorkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // Initialization code
    _lblTitleCell.textColor = RGB(102, 102, 102);
    _lblContentCell.textColor = RGB(51, 51, 51);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - SetupData by Model
- (void)setupDataByModel:(DetailWorkModel *)model atIndex:(NSUInteger)index withSegment:(ListWorkType)segmsent {
    if (model) {
        switch (index) {
            case DetailWorkIndexType_TenCV:{
                _lblTitleCell.text = LocalizedString(@"DetailWorkCell_Tên_công_việc");
                _lblContentCell.text = model.taskName;
            }
                break;
            case DetailWorkIndexType_NoiDungCV:{
                _lblTitleCell.text = LocalizedString(@"DetailWorkCell_Nội_dung_công_việc");
                _lblContentCell.text = model.content;
            }
                break;
            case DetailWorkIndexType_LoaiCV:{
                _lblTitleCell.text = LocalizedString(@"DetailWorkCell_Loại_công_việc");
                _lblContentCell.text = model.taskTypeName2;
            }
                break;
            case DetailWorkIndexType_NgayGiao:{
                _lblTitleCell.text = LocalizedString(@"DetailWorkCell_Ngày_giao");
                _lblContentCell.text = [[Common shareInstance] fullNormalStringDateFromServerDate:model.startTime serverFormatDate:@"dd/MM/yyyy HH:mm"];
            }
                break;
            case DetailWorkIndexType_ThoiHan:{
                _lblTitleCell.text = LocalizedString(@"DetailWorkCell_Thời_hạn");
                _lblContentCell.text = [[Common shareInstance] fullNormalStringDateFromServerDate:model.endTime serverFormatDate:@"dd/MM/yyyy HH:mm"];
            }
                break;
            case DetailWorkIndexType_TrangThai:{
                _lblTitleCell.text = LocalizedString(@"DetailWorkCell_Trạng_thái");
                _lblContentCell.text = model.statusName;
                if (model.status == WorkStatus_InProgress) {
                    [_lblContentCell colorSubString:model.statusName withColor:AppColor_HightLightTextColor];
                }else{
                    _lblContentCell.textColor = AppColor_MainTextColor;
                }
            }
                break;
            case DetailWorkIndexType_TanSuatBaoCao:{
                _lblTitleCell.text = LocalizedString(@"DetailWorkCell_Tần_suất_báo_cáo");
                _lblContentCell.text = model.updateFrequencyName;
            }
                break;
            case DetailWorkIndexType_PhoiHop:{
                if (segmsent == ListWorkType_Perform) {
					if (model.commandType == CommandTypeWork_Combinated) {
						_lblTitleCell.text = LocalizedString(@"DetailWorkCell_Phối_hợp");
						_lblContentCell.text = model.enforcementName;
					}else{
						_lblTitleCell.text = LocalizedString(@"DetailWorkCell_Người_giao");
						_lblContentCell.text = model.commanderName;
					}
					
                } else {
                    _lblTitleCell.text = LocalizedString(@"DetailWorkCell_Giao_tới");
					_lblContentCell.text = model.enforcementName;
                }
            }
                break;
                
            default:
                break;
        }
    }else{
        _lblTitleCell.text = @"";
        _lblContentCell.text = @"";
    }
}

@end
