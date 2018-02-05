//
//  DetailNormalDocCell.m
//  SmartOffice
//
//  Created by Kaka on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "DetailNormalDocCell.h"
#import "DocDetailModel.h"
#import "TextDetailModel.h"
#import "Common.h"

@implementation DetailNormalDocCell

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
		//Apply for Express Doc
		if ([model isKindOfClass:[DocDetailModel class]]) {
			DocDetailModel *docDetail = (DocDetailModel *)model;
			switch (index) {
				case DetailTitleCellType_EXTRAC_WEAK_CONTENT:{
					_lblTitleCell.text = LocalizedString(@"Trích yếu nội dung");
                    _lblContentCell.text = docDetail.content;
				}
					break;
					
				case DetailTitleCellType_UNIT_RAISE_SIGN:{
					_lblTitleCell.text = LocalizedString(@"Đơn vị ban hành");
					_lblContentCell.text = docDetail.promulgatingDepart;

				}
					break;
                case DetailTitleCellType_SIGNED_DATE:
                {
                    _lblTitleCell.text = LocalizedString(@"Ngày ban hành");
					NSString *dateSigned = [[Common shareInstance] normalDateFromServerDate:docDetail.toDate serverFormatDate:kServerFormatDate toClientFormat:kAppNormalFormatDate];
                    _lblContentCell.text = dateSigned;
                }
                    break;
				case DetailTitleCellType_SIGNED_RAISER:{
					_lblTitleCell.text = LocalizedString(@"Người ký ban hành");
					_lblContentCell.text = docDetail.signer;
				}
					break;
				case DetailTitleCellType_LEVEL_SECURITY:{
					_lblTitleCell.text = LocalizedString(@"Độ mật");
					_lblContentCell.text = docDetail.stype;

				}
					break;
				case DetailTitleCellType_LEVEL_URGENT:{
					_lblTitleCell.text = LocalizedString(@"Độ khẩn");
					_lblContentCell.text = [Common getPriorityDoc:docDetail.priorityId];
					if (docDetail.priorityId == UrgentDocStatus_Normal) {
						//Bình thường
						_lblContentCell.textColor = RGB(51, 51, 51);
					}else{
						_lblContentCell.textColor = [UIColor redColor];
					}
				}
					break;
				default:
					break;
			}
		}else{
			TextDetailModel *textDetail = (TextDetailModel *)model;
			switch (index) {
				case DetailTitleCellType_EXTRAC_WEAK_CONTENT:{
					_lblTitleCell.text = LocalizedString(@"Trích yếu nội dung");
                    _lblContentCell.text = textDetail.content;
				}
					break;
					
				case DetailTitleCellType_UNIT_RAISE_SIGN:{
					_lblTitleCell.text = LocalizedString(@"Đơn vị trình ký");
					_lblContentCell.text = textDetail.departSentSign;
					
				}
					break;
				case DetailTitleCellType_SIGNED_RAISER:{
					_lblTitleCell.text = LocalizedString(@"Người trình ký");
					_lblContentCell.text = textDetail.creator;
					//_lblContentCell.text = LocalizedString(@"N/A");
				}
					break;
                case DetailTitleCellType_SIGNED_DATE:
                {
                    _lblTitleCell.text = LocalizedString(@"VOffice_DocumentTypicalDetailCell_iPad_Thời_gian_trình_ký");
                    
                    _lblContentCell.text = [[Common shareInstance] fullNormalStringDateFromServerDate:textDetail.createDate serverFormatDate:kServerFormatDate];
//                    ? textDetail.createDate : LocalizedString(@"N/A");
                }
                    break;
				case DetailTitleCellType_LEVEL_SECURITY:{
					_lblTitleCell.text = LocalizedString(@"Độ mật");
					_lblContentCell.text = textDetail.securityName;
					
				}
					break;
				case DetailTitleCellType_LEVEL_URGENT:{
					_lblTitleCell.text = LocalizedString(@"Độ khẩn");
					_lblContentCell.text = textDetail.urgencyName;
					//Check urgentCode
					if (textDetail.urgencyCode == UrgentTextStatus_Normal) {
						//Bình thường
						_lblContentCell.textColor = RGB(51, 51, 51);
					}else{
						_lblContentCell.textColor = [UIColor redColor];
					}
				}
					break;
				default:
					break;
			}
		}
	}
}

@end
