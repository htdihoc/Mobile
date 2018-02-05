//
//  QLTT_MasterViewCell.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "QLTT_MasterViewCell.h"
#import "QLTT_InfoDetailController.h"
#import "QLTTFileAttachmentModel.h"
#import "UIImage+Resize.h"
@interface QLTT_MasterViewCell()
{
    QLTT_InfoDetailController *_qltt_InfoDetailController;
}

@end
@implementation QLTT_MasterViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lbl_AuthorTitle.text = [NSString stringWithFormat:@"%@:", LocalizedString(@"QLTT_MasterViewCell_Tác_giả")];
    _qltt_InfoDetailController = [[QLTT_InfoDetailController alloc] init];
    _iconSecurityImg.layer.cornerRadius = 3;
    _iconSecurityImg.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)enterDataToCell:(QLTTMasterDocumentModel *)model
{
    //    img_Book;
    _img_Book.image = [UIImage imageNamed:@"QLTTDemo"];
    [self.iconSecurityImg setHidden:!model.secretLevel];
    _lbl_Version.text = [NSString stringWithFormat:@"(%@ %@)",LocalizedString(@"QLTT_MasterViewCell_Phiên_bản"), model.version];
    _lbl_Name.text = model.name;
    _lbl_Author.text = model.authorName;
    _lbl_State.text = model.effectStatusString;
    [self imageForStatus:_lbl_State.text];
    if ([model.name isEqualToString:@"test2"]) {
        NSLog(@"");
    }
    [self loadImage:model.avatar.firstObject];
}
- (void)imageForStatus:(NSString *)status
{
    if ([status isEqualToString:@"Còn hiệu lực"]) {
        self.img_Status.image = [UIImage imageNamed:@"state1"];
        _lbl_State.textColor = COLOR_FROM_HEX(0x00a651);
    }
    else if ([status isEqualToString:@"Sắp hết hiệu lực"])
    {
        self.img_Status.image = [UIImage imageNamed:@"state2"];
        _lbl_State.textColor = COLOR_FROM_HEX(0xe66b29);
    }
    else if ([status isEqualToString:@"Đã hết hiệu lực"])
    {
        self.img_Status.image = [UIImage imageNamed:@"state3"];
        _lbl_State.textColor = COLOR_FROM_HEX(0xff3a3a);
    }
    else
    {
        self.img_Status.image = [UIImage imageNamed:@"timer_icon"];
        _lbl_State.textColor = AppColor_MainTextColor;
    }
}
- (void)loadImage:(QLTTFileAttachmentModel *)avatar
{
    if (avatar) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *cacheImg = [UIImage imageCache:avatar.filePath];
            if (cacheImg) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    self.img_Book.image = cacheImg;
                });
            }
            else
            {
                [QLTT_InfoDetailController loadData:avatar.filePath completion:^(BOOL success, NSData *resultData, NSException *exception, NSDictionary *error) {
                    if (resultData) {
                        if([self.delegate isVisible:self])
                        {
                            self.img_Book.image = [UIImage imageWithImageCache:[UIImage imageWithData:resultData] key:avatar.filePath];
                        }
                    }
                }];
            }
            
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            _img_Book.image = [UIImage imageNamed:@"QLTTDemo"];
        });
    }
}
@end
