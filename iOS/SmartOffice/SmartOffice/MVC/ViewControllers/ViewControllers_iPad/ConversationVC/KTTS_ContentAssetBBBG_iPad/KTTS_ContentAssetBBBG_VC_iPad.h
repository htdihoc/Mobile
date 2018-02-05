//
//  KTTS_ContentAssetBBBG_VC_iPad.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTTS_ContentAssetBBBG_VC_iPad : UIViewController 


@property (weak, nonatomic) IBOutlet UIView *middleView;

@property (weak, nonatomic) IBOutlet UITableView *tbl_Content;

@property (weak, nonatomic) IBOutlet UIButton *btn_Done;

@property (weak, nonatomic) IBOutlet UILabel *lbl_good_names;

- (IBAction)action_Done:(UIButton *)sender;


@property (assign, nonatomic) NSInteger isStatus;
@property (assign, nonatomic) NSInteger isColorButton;

@property (strong, nonatomic) NSString *goods_name;
@property (strong, nonatomic) NSString *minuteHandOverId;
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
