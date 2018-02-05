//
//  KTTS_DetailProperty_iPad.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTTS_DetailPropertyView_iPad.h"

@interface KTTS_DetailProperty_iPad : KTTS_DetailPropertyView_iPad <UITableViewDelegate, UITableViewDataSource>


@property (assign, nonatomic) NSInteger isStatus;

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





@end
