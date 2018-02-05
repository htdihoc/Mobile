//
//  InformationInput.m
//  SmartOffice
//
//  Created by NguyenDucBien on 6/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "InformationInput.h"

@implementation InformationInput

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentTF.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
