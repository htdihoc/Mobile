//
//  AttachFileCell.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 6/28/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "AttachFileCell.h"

@implementation AttachFileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.camera_button addTarget:self action:@selector(cameraAction) forControlEvents:UIControlEventTouchUpInside];
    [self.image_button addTarget:self action:@selector(imageAcion) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) cameraAction {
    [self.delegate showCamera];
}

- (void) imageAcion {
    [self.delegate showLibrary];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
