//
//  UserInfoCell.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 7/28/29 H.
//  Copyright © 29 Heisei ITSOL. All rights reserved.
//

#import "UserInfoCell.h"
#import "UIImage+Resize.h"
@implementation UserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setDataForCell:(TTNS_EmployeeTimeKeeping *)model
{
    self.lbl_Name.text = model.fullName;
    self.lbl_Position.text = model.positionName;
    self.lbl_PhoneNumber.text = model.mobileNumber;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        if ([model.imagePath containsString:@"http"]) {
            NSData *resultData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.imagePath]];
            if (resultData == nil) {
                _img_Profile.image = [UIImage imageNamed:@"icon_avt_default"];
            }
            else
            {
                UIImage *image = [UIImage imageWithImageCache:[UIImage imageWithData:resultData] key:model.imagePath];
                if (image) {
                    dispatch_sync(dispatch_get_main_queue(), ^(void) {
                        _img_Profile.image = image;
                    });
                }
                else
                {
                    dispatch_sync(dispatch_get_main_queue(), ^(void) {
                        _img_Profile.image = [UIImage imageNamed:@"icon_avt_default"];
                    });
                }
            }
            
        }
    });
}

@end
