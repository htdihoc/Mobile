//
//  PropertyDetailsCell.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/27/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyDetailsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *value_commodity_code;
@property (weak, nonatomic) IBOutlet UILabel *value_commodity_name;
@property (weak, nonatomic) IBOutlet UILabel *value_unit;
@property (weak, nonatomic) IBOutlet UILabel *value_number;
@property (weak, nonatomic) IBOutlet UILabel *value_serial;
@property (weak, nonatomic) IBOutlet UILabel *value_manufacturer;
@property (weak, nonatomic) IBOutlet UILabel *value_aspect;
@property (weak, nonatomic) IBOutlet UILabel *value_expiry_date;
@property (weak, nonatomic) IBOutlet UILabel *value_asset_type;
@property (weak, nonatomic) IBOutlet UILabel *value_use_time;
@property (weak, nonatomic) IBOutlet UILabel *value_price;
@property (weak, nonatomic) IBOutlet UILabel *value_status;

@end
