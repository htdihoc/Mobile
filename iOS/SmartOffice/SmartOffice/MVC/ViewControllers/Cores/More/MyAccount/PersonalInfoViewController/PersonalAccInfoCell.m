//
//  PersonalAccInfoCell.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/25/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "PersonalAccInfoCell.h"

@implementation PersonalAccInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.view_number_cell.layer.cornerRadius = 4;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
