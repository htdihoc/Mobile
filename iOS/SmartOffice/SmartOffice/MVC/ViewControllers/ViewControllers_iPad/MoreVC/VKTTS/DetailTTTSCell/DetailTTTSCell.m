//
//  DetailTTTSCell.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 9/15/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "DetailTTTSCell.h"

@implementation DetailTTTSCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setDataWithArray:(PropertyInfoModel *)array {
    self.value_asset_name.text = array.catMerName;
    self.value_code_asset.text = array.catMerCode;
    self.value_unit.text = array.unitName;
    self.value_number.text = IntToString(array.count);
    self.value_serial.text = array.serialNumber;
    self.value_publicsher.text = array.companyName;
    self.value_state.text = array.statusName;
//    self.value_expiry_date.text = array.usedDate;
//    self.value_asset_type.text = array.;
//    self.value_time_to_put_into_use.text = array.;
    self.value_original_price_handover.text = IntToString(array.assetPrice);
//    self.value_status.text = array.;
    
}

- (IBAction)confirmAction:(id)sender {
    [self.delegate sendRequestConfirm];
}

- (IBAction)cancelAction:(id)sender {
    [self.delegate sendRequestCancel];
}


@end
