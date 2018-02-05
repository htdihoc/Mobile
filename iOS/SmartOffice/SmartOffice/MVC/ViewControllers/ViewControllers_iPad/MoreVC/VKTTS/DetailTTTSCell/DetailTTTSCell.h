//
//  DetailTTTSCell.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 9/15/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyInfoModel.h"

@protocol SendRequestDelegate <NSObject>

- (void) sendRequestConfirm;
- (void) sendRequestCancel;

@end

@interface DetailTTTSCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *value_asset_name;
@property (weak, nonatomic) IBOutlet UILabel *value_code_asset;
@property (weak, nonatomic) IBOutlet UILabel *value_unit;
@property (weak, nonatomic) IBOutlet UILabel *value_number;
@property (weak, nonatomic) IBOutlet UILabel *value_serial;
@property (weak, nonatomic) IBOutlet UILabel *value_publicsher;
@property (weak, nonatomic) IBOutlet UILabel *value_state;
@property (weak, nonatomic) IBOutlet UILabel *value_expiry_date;
@property (weak, nonatomic) IBOutlet UILabel *value_asset_type;
@property (weak, nonatomic) IBOutlet UILabel *value_time_to_put_into_use;
@property (weak, nonatomic) IBOutlet UILabel *value_original_price_handover;
@property (weak, nonatomic) IBOutlet UILabel *value_status;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) id<SendRequestDelegate> delegate;

- (void) setDataWithArray:(PropertyInfoModel *)array;

@end
