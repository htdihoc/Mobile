//
//  ListRegisterFormCell.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ListRegisterFormCell.h"

@implementation ListRegisterFormCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// MARK : - UI

-(void)setupUI{
    _stateView.layer.cornerRadius = _stateView.bounds.size.width/2;
    _stateView.layer.masksToBounds = YES;
    [_refuseLB setHidden:YES];
}


@end
