//
//  AttachFileDetailCell.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 6/28/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "AttachFileDetailCell.h"

@implementation AttachFileDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.camera_button addTarget:self action:@selector(cameraActionUpdate) forControlEvents:UIControlEventTouchUpInside];
    [self.image_button addTarget:self action:@selector(imageAcionUpdate) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) cameraActionUpdate {
    [self.delegate showCameraUpdate];
}

- (void) imageAcionUpdate {
    [self.delegate showLibraryUpdate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
