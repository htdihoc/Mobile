//
//  VOffice_DetailMissionCell_iPad.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_DetailMissionCell_iPad.h"
#import "Common.h"
#import "MissionModel.h"

@implementation VOffice_DetailMissionCell_iPad


typedef enum : NSUInteger {
    DetailWorkIndexType_TenCV = 0,
    DetailWorkIndexType_NgayGiao,
    DetailWorkIndexType_ThoiHan,
    DetailWorkIndexType_TrangThai,
    DetailWorkIndexType_TanSuatBaoCao,
    DetailWorkIndexType_MucDo,
    DetailWorkIndexType_MucTieu,
    DetailWorkIndexType_NguoiGiaoViec,
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

- (void)setupDataByModel:(DetailMissionModel *)model atIndex:(NSInteger)index{
    if (model) {
        switch (index) {
            case DetailWorkIndexType_TenCV:{
                _lbl_Title.text = LocalizedString(@"DM_NAME_MISSION_LABEL");
                _lbl_Content.text = model.missionName;
            }
                break;
            case DetailWorkIndexType_NgayGiao:{
                _lbl_Title.text = LocalizedString(@"DM_RELEASE_DATE_LABEL");
                
                //                NSString *startTime = [[Common shareInstance] fullNormalStringDateFromServerDate:model.dateStart serverFormatDate:@"dd/MM/yyyy HH:mm"];
                //                _lbl_Content.text = startTime;
                
                _lbl_Content.text = model.dateStart;
            }
                break;
            case DetailWorkIndexType_ThoiHan:{
                _lbl_Title.text = LocalizedString(@"DM_DEADLINE_DATE");
                NSString *deadline = [[Common shareInstance] fullNormalStringDateFromServerDate:model.dateComplete serverFormatDate:kFormatDateClientDetail];
                _lbl_Content.text = deadline;      
            }
                break;
            case DetailWorkIndexType_TrangThai:{
                _lbl_Title.text = LocalizedString(@"DM_STATE_LABEL");
                _lbl_Content.text = model.statusName;
            }
                break;
            case DetailWorkIndexType_TanSuatBaoCao:{
                _lbl_Title.text = LocalizedString(@"DM_FREQUENCY_UPDATE_LABEL");
                _lbl_Content.text = model.frequenceUpdateName;
            }
                break;
            case DetailWorkIndexType_MucDo:{
                _lbl_Title.text = LocalizedString(@"DM_IMPORTANT_LEVEL_LABEL");
                if (model.levelImportance == MissionLevelType_Normal) {
                    _lbl_Content.text = LocalizedString(@"DM_LEVEL_NORMAL_LABEL");
                }else{
                    _lbl_Content.text = LocalizedString(@"DM_LEVEL_IMPORTANT_LABEL");
                }
            }
                break;
            case DetailWorkIndexType_MucTieu:{
                _lbl_Title.text = LocalizedString(@"DM_OBJECTIVE_LABEL");
                _lbl_Content.text = model.target;
            }
                break;
            case DetailWorkIndexType_NguoiGiaoViec:{
                _lbl_Title.text = LocalizedString(@"DM_ASSIGNER_LABEL");
                _lbl_Content.text = model.assignName;
            }
                break;
                
            default:
                break;
        }
    }
}

@end
