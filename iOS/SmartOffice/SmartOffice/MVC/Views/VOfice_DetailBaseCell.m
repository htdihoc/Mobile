//
//  VOfice_DetailBaseCell.m
//  SmartOffice
//
//  Created by NguyenVanTu on 7/31/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "VOfice_DetailBaseCell.h"

@implementation VOfice_DetailBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsMake(0, 30, 0, 0)];
    }
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
