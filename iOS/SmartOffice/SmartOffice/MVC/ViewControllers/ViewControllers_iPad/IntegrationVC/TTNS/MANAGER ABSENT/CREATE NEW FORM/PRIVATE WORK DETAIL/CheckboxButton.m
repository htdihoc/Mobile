//
//  CheckboxButton.m
//  TTNS_ListOff_iPad
//
//  Created by NguyenDucBien on 5/8/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import "CheckboxButton.h"

@implementation CheckboxButton

- (void)setImageWithName:(NSString *)name {
    [self setImage: [UIImage imageNamed:name] forState:UIControlStateSelected];
}

- (void)setImageForSelectedButton {
    [self setImageWithName:@"check_Button"];
}

- (void)setImageForUnSelectButton {
    [self setImageWithName:@"uncheck_Button"];
}

- (void)refresh {
    [self setSelected:NO];
    [self setImageForUnSelectButton];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected == true) {
        [self setImageForSelectedButton];
    } else {
        [self setImageForUnSelectButton];
    }
}

@end
