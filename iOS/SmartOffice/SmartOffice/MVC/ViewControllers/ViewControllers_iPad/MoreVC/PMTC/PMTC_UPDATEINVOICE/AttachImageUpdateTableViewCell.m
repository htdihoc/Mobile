//
//  AttachImageUpdateTableViewCell.m
//  SmartOffice
//
//  Created by NguyenDucBien on 9/29/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "AttachImageUpdateTableViewCell.h"

@implementation AttachImageUpdateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cameraButton.layer.cornerRadius = 5;
    self.cameraButton.layer.masksToBounds = YES;
    self.libraryButton.layer.cornerRadius = 5;
    self.libraryButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (IBAction)cameraButtonAction:(id)sender {
}

- (IBAction)libraryButtonAction:(id)sender {
}
@end
