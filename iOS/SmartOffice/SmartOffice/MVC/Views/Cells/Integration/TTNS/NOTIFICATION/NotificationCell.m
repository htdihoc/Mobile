//
//  NotificationCell.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell{

}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
    [_btnCheck setHidden:YES];
}

- (void)setupUI{
    [_btnCheck setImage:[UIImage imageNamed:@"check_button_on"] forState:UIControlStateSelected];
    
    [_btnCheck setImage:[UIImage imageNamed:@"check_button_off"] forState:UIControlStateNormal];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)btnCheckAction:(id)sender {
    _btnCheck.selected = !_btnCheck.selected;
}
@end
