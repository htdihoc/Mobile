//
//  PropertyDetailsViewController.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseVC.h"
#import "PropertyDetailsCell.h"

@interface PropertyDetailsViewController : TTNS_BaseVC

@property (assign, nonatomic) NSInteger isStatus;
@property (assign, nonatomic) NSInteger isColorButton;

@property (strong, nonatomic) NSString *value_commodity_code;
@property (strong, nonatomic) NSString *value_commodity_name;
@property (strong, nonatomic) NSString *value_unit;
@property (strong, nonatomic) NSString *value_number;
@property (strong, nonatomic) NSString *value_serial;
@property (strong, nonatomic) NSString *value_manufacturer;
@property (strong, nonatomic) NSString *value_aspect;
@property (strong, nonatomic) NSString *value_expiry_date;
@property (strong, nonatomic) NSString *value_asset_type;
@property (strong, nonatomic) NSString *value_use_time;
@property (strong, nonatomic) NSString *value_price;
@property (strong, nonatomic) NSString *value_status;
@property (assign, nonatomic) NSInteger merEntityId;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) NSInteger typeKTTS;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hightBtnCancelOrConfirm;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hightBtnCancel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hightBtnConfirm;

@end
