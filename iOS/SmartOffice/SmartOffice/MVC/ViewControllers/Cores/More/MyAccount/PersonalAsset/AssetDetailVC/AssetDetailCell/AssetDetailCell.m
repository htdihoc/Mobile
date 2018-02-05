//
//  AssetDetailCell.m
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 4/16/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "AssetDetailCell.h"

@implementation AssetDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)cellIdentifier {
    return @"AssetDetailIdentifier";
}

@end
