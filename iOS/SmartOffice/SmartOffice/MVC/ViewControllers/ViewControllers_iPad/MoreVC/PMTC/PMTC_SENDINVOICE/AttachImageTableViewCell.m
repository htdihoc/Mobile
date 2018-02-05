//
//  AttachImageTableViewCell.m
//  SmartOffice
//
//  Created by NguyenDucBien on 9/29/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "AttachImageTableViewCell.h"

@implementation AttachImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.cameraButton addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.libraryButton addTarget:self action:@selector(libraryAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)cameraAction:(id)sender {
    [self.delegate showCamera];
}

- (IBAction)libraryAction:(id)sender {
    [self.delegate showLibrary];
}
@end
