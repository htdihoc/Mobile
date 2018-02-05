//
//  BBBGTableViewCell.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 9/15/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "BBBGTableViewCell.h"

@implementation BBBGTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setDataDetailBBBGWithArray:(DetailBBBGModel *)array {
    self.value_asset_name.text = array.catMerName;
    self.value_number.text = IntToString(array.count);
    self.value_serial.text = array.serialNumber;
}

@end
