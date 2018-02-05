//
//  PMTC_DetailAttached_Cell.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 6/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "PMTC_DetailAttached_Cell.h"
#import "NSDate+Utilities.h"
#import "NSString+StringToDate.h"

@implementation PMTC_DetailAttached_Cell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

//- (void)setupDataForView:(DocumentCategoryModel *)model index:(NSInteger)index {
//    self.lbl_Title.text = model.content;
//    self.lbl_Serial.text = model.documentNo;
//    self.lbl_Date.text = [self dateStringToShow:model.documentDate];
//}
//
//- (NSString *)dateStringToShow:(NSString *)dateString
//{
//    NSDate *date = [self convertStringToDate:dateString];
//    NSString *dateToShow = [date stringWithFormat:DATE_COMMENT_FORMAT_DISPLAY];
//    dateToShow = [NSString stringWithFormat:@"%@", dateToShow];
//    return dateToShow;
//}
//- (NSDate *)convertStringToDate:(NSString *)dateString
//{
//    return [dateString convertStringToDateWith:DATE_DOCUMENT_FROM_SERVER];
//}

@end
