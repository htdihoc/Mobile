//
//  QLTT_InfoDetailDocumentCell.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "QLTT_InfoDetailDocumentCell.h"
#import "NSString+Util.h"
@implementation QLTT_InfoDetailDocumentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.lbl_State.text = LocalizedString(@"Không có tài liệu đính kèm");
    self.lbl_State.font = [UIFont systemFontOfSize:14];
    self.lbl_State.backgroundColor = AppColor_MainAppBackgroundColor;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                          action:@selector(dismissKeyboard:)];
//    [self.contentView addGestureRecognizer:tap];
}

//- (void)dismissKeyboard:(UIGestureRecognizer*) recognizer
//{
//    if ([self.delegate respondsToSelector:@selector(dismissVC:)])
//    {
//        [self.delegate dismissVC:recognizer];
//    }
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setupdataForView:(QLTTFileAttachmentModel *)model
{
    if (model.fileName == nil) {
        self.lbl_State.hidden = NO;
        self.lbl_DocumentName.text = @"";
        self.lbl_DocumentSize.text = @"";
        self.img_Document.hidden = YES;
    } else {
        self.lbl_State.hidden = YES;
    self.lbl_DocumentName.text = model.fileName;
    [self setImageType:[_lbl_DocumentName.text pathExtension]];
    self.lbl_DocumentSize.text = [AppDelegateAccessor transformedValue: model.fileSize];
    }
}

- (void)setImageType:(NSString *)fileType
{
    if (fileType == nil) {
        fileType = @"";
    }
    fileType = fileType.lowercaseString;
    if([fileType containsString:@"xls"])
    {
        fileType = @"xlsFile";
    }
    else if([fileType containsString:@"ppt"])
    {
        fileType = @"pptFile";
    }
        
    else if([fileType isImageType])
    {
        fileType = @"imageFile";
    }
    else if([fileType isVideo])
    {
        fileType = @"videoFile";
    }
    else
    {
        fileType = [fileType isEqualToString:@""] ? @"otherFile" : [NSString stringWithFormat:@"%@File", [fileType lowercaseString]];
    }
    UIImage *imgType = [UIImage imageNamed:fileType];
    if (!imgType) {
        imgType = [UIImage imageNamed:@"otherFile"];
    }
    self.img_Document.image = imgType;
}
@end
