//
//  PersonalAssetInfoCell.m
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 4/13/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "PersonalAssetInfoCell.h"

@implementation PersonalAssetInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)cellIdentifier {
    return @"AssetInfoCellIdentifier";
}

@end
