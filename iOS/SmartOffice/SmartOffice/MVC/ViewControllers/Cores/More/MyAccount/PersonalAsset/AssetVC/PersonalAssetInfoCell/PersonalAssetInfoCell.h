//
//  PersonalAssetInfoCell.h
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 4/13/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalAssetInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnIndex;
@property (weak, nonatomic) IBOutlet UIButton *btnViewDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbAssetName;
@property (weak, nonatomic) IBOutlet UILabel *lbQuantity;
@property (weak, nonatomic) IBOutlet UILabel *lbSerial;
@property (weak, nonatomic) IBOutlet UILabel *lbState;


+ (NSString *)cellIdentifier;

@end
