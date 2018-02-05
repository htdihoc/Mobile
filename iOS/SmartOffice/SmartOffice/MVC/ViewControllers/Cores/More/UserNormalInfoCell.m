//
//  UserNormalInfoCell.m
//  SmartOffice
//
//  Created by Nguyen Van Tu on 10/3/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "UserNormalInfoCell.h"
#import "UIImage+Resize.h"
@implementation UserNormalInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = AppColor_MainAppTintColor;
    self.lbl_Name.textColor = [UIColor whiteColor];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setDataForCell:(TTNS_EmployeeTimeKeeping *)model
{
    self.lbl_Name.text = model.fullName;
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
