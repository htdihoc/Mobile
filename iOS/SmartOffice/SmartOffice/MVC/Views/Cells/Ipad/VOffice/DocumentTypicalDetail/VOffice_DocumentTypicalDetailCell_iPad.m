//
//  VOffice_DocumentTypicalDetailCell_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_DocumentTypicalDetailCell_iPad.h"
#import "DocDetailModel.h"
#import "TextDetailModel.h"
#import "Common.h"
@implementation VOffice_DocumentTypicalDetailCell_iPad

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark - Setup Data
- (void)setupData:(id)model atIndex:(NSInteger)index{
    if (model) {
        BOOL isDocDetailModel = NO;
        if ([model isKindOfClass:[DocDetailModel class]]) {
            isDocDetailModel = YES;
        }
        switch (index) {
            case DetailTitleCellType_EXTRAC_WEAK_CONTENT:{
                _lblTitleCell.text = LocalizedString(@"VOffice_DocumentTypicalDetailCell_iPad_Trích_yếu_nội_dung");
                _lblContentCell.text = isDocDetailModel == YES ? ((DocDetailModel *)model).content : ((TextDetailModel *)model).content;
				_lblContentCell.textColor = RGB(51, 51, 51);
            }
                break;
                
            case DetailTitleCellType_UNIT_RAISE_SIGN:{
                _lblTitleCell.text = isDocDetailModel == YES ? LocalizedString(@"Đơn vị ban hành") : LocalizedString(@"Đơn vị trình ký");
                _lblContentCell.text = isDocDetailModel == YES ? ((DocDetailModel *)model).promulgatingDepart : ((TextDetailModel *)model).departSentSign;
				_lblContentCell.textColor = RGB(51, 51, 51);
            }
                break;
            case DetailTitleCellType_SIGNED_RAISER:{
                _lblTitleCell.text = isDocDetailModel == YES ? LocalizedString(@"Người ký ban hành") : LocalizedString(@"Người trình ký");
                _lblContentCell.text = isDocDetailModel == YES ? ((DocDetailModel *)model).signer : ((TextDetailModel *)model).creator;
				_lblContentCell.textColor = RGB(51, 51, 51);
            }
                break;
            case DetailTitleCellType_SIGNED_DATE:
            {
                _lblTitleCell.text = isDocDetailModel == YES ? LocalizedString(@"Ngày ban hành") : LocalizedString(@"VOffice_DocumentTypicalDetailCell_iPad_Thời_gian_trình_ký");

                NSString *dateFromServer = isDocDetailModel == YES ? ((DocDetailModel *)model).toDate : ((TextDetailModel *)model).createDate;
                _lblContentCell.text = [[Common shareInstance] normalDateFromServerDate:dateFromServer serverFormatDate:kServerFormatDate toClientFormat:kAppNormalFormatDate];
				_lblContentCell.textColor = RGB(51, 51, 51);
            }
                break;
            case DetailTitleCellType_LEVEL_SECURITY:{
                _lblTitleCell.text = LocalizedString(@"VOffice_DocumentTypicalDetailCell_iPad_Độ_mật");
                _lblContentCell.text = isDocDetailModel == YES ? ((DocDetailModel *)model).stype : ((TextDetailModel *)model).securityName;
                _lblContentCell.textColor = RGB(51, 51, 51);
            }
                break;
            case DetailTitleCellType_LEVEL_URGENT:{
                _lblTitleCell.text = LocalizedString(@"VOffice_DocumentTypicalDetailCell_iPad_Độ_khẩn");
                _lblContentCell.text = isDocDetailModel == YES ? ((DocDetailModel *)model).priority : ((TextDetailModel *)model).urgencyName;
                
                //Check urgentCode
                if (isDocDetailModel) {
                    if(((DocDetailModel *)model).priorityId == UrgentDocStatus_Normal) {
                        //Bình thường
                        _lblContentCell.textColor = RGB(51, 51, 51);
                    }else{
                        _lblContentCell.textColor = [UIColor redColor];
                    }
                    
                }else{
                    if(((TextDetailModel *)model).urgencyCode == UrgentTextStatus_Normal) {
                        //Bình thường
                        _lblContentCell.textColor = RGB(51, 51, 51);
                    }else{
                        _lblContentCell.textColor = [UIColor redColor];
                    }
                }
                //[self addBottomBorderWithColor];
            }
                break;
            default:
                break;
        }
        _lblContentCell.text = _lblContentCell.text ? _lblContentCell.text : LocalizedString(@"N/A");
    }
}

- (void)addBottomBorderWithColor{
    [_bottomBorder setHidden:NO];
}
@end
