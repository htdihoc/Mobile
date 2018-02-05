//
//  KTTS_ListPropertyCell_iPad.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/10/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "KTTS_ListPropertyCell_iPad.h"

@implementation KTTS_ListPropertyCell_iPad

- (void)awakeFromNib {
    [super awakeFromNib];

    self.counterView.layer.cornerRadius = 5;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setHighlighted:(BOOL)highlighted {
    if (highlighted) {
        self.bottomView.backgroundColor = [UIColor redColor];
        self.headerView.backgroundColor = [UIColor blueColor];
    }
}

@end
