//
//  RegisterFormCell.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "RegisterFormCell.h"

@implementation RegisterFormCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCell {
    [self.overDateLB setHidden:YES];
    self.typeRegLBCenterY = 0;
}


@end
