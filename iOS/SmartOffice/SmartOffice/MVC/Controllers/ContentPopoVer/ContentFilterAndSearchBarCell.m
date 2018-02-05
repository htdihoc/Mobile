//
//  ContentFilterAndSearchBarCell.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ContentFilterAndSearchBarCell.h"

@implementation ContentFilterAndSearchBarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - SetData
- (void)setData:(NSString *)content showCheckmark:(BOOL)show{
    _lblContent.text = content;
    _imgCheckmark.hidden = !show;
}

@end
