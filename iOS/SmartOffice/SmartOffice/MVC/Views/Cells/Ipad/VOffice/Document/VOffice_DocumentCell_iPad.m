//
//  VOffice_DocumentCell_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_DocumentCell_iPad.h"
#import "SumDocModel.h"
#import "UILabel+FormattedText.h"

static NSString *WAITING_SIGN_DOC = @"VOffice_DocumentCell_iPad_Chờ_ký_duyệt";
static NSString *FLASH_DOC = @"VOffice_DocumentCell_iPad_Ký_nháy";
static NSString *EXPRESS_DOC = @"VOffice_DocumentCell_iPad_Hoả_tốc";
@interface VOffice_DocumentCell_iPad()
@property (weak, nonatomic) IBOutlet UIImageView *imgDocType;
@property (weak, nonatomic) IBOutlet UILabel *lblValue;

@end

@implementation VOffice_DocumentCell_iPad

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateValue:(SumDocModel *)model forType:(DocType)type{
    NSInteger numberDoc = 0;
    switch (type) {
        case DocType_Waiting:{
            numberDoc = model.countTextWaitSign;
            _imgDocType.image = [UIImage imageNamed:@"waiting_doc_icon"];
            _lblValue.text = [NSString stringWithFormat:@"%ld %@", (long)numberDoc, LocalizedString(WAITING_SIGN_DOC)];
        }
            
            break;
        case DocType_Flash:{
            numberDoc = model.countTextWaitingInitial;
            _imgDocType.image = [UIImage imageNamed:@"flash_doc_icon"];
            _lblValue.text = [NSString stringWithFormat:@"%ld %@", (long)numberDoc, LocalizedString(FLASH_DOC)];
        }
            break;
        case DocType_Express:{
            numberDoc = model.countTextSigned;
            _imgDocType.image = [UIImage imageNamed:@"express_doc_icon"];
            _lblValue.text = [NSString stringWithFormat:@"%ld %@", (long)numberDoc, LocalizedString(EXPRESS_DOC)];
        }
            break;
        default:
            break;
    }
    [_lblValue boldSubstring:[NSString stringWithFormat:@"%ld", (long)numberDoc]];
}

@end
