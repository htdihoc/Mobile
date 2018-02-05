//
//  KTTSTableViewCell.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 9/13/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "KTTSTableViewCell.h"

@implementation KTTSTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.value_cell_number.layer.cornerRadius = 4;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
