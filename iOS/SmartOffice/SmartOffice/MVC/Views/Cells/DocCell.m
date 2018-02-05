//
//  DocCell.m
//  SmartOffice
//
//  Created by Kaka on 4/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "DocCell.h"
#import "UILabel+FormattedText.h"
#import "SumDocModel.h"


static NSString *WAITING_SIGN_DOC = @"Chờ ký duyệt";
static NSString *FLASH_DOC = @"Chờ ký nháy";
static NSString *EXPRESS_DOC = @"Hoả tốc";

@implementation DocCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Update Data

- (void)updateValue:(SumDocModel *)model forType:(DocType)type{
	NSInteger numberDoc = 0;
    switch (type) {
        case DocType_Waiting:{
			numberDoc = model.countTextWaitSign;
            _imgDocType.image = [UIImage imageNamed:@"waiting_doc_icon"];
            _lblValue.text = [NSString stringWithFormat:@"%ld %@", (long)numberDoc, WAITING_SIGN_DOC];
        }
       
        break;
        case DocType_Flash:{
			numberDoc = model.countTextWaitingInitial;
            _imgDocType.image = [UIImage imageNamed:@"flash_doc_icon"];
            _lblValue.text = [NSString stringWithFormat:@"%ld %@", (long)numberDoc, LocalizedString(@"VOffice_DocumentCell_iPad_Ký_nháy")];
        }
        break;
        case DocType_Express:{
			numberDoc = model.countTextSigned;
            _imgDocType.image = [UIImage imageNamed:@"express_doc_icon"];
            _lblValue.text = [NSString stringWithFormat:@"%ld %@", (long)numberDoc, EXPRESS_DOC];
        }
        break;
        default:
        break;
    }
    [_lblValue boldSubstring:[NSString stringWithFormat:@"%ld", (long)numberDoc]];
}
@end
