//
//  CheckBoxButton.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/18/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "CheckBoxButton.h"

@implementation CheckBoxButton{
    UILabel *label;
    BOOL    textIsSet;
}

@synthesize text = _text;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self != nil){
        // initInternals;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self != nil){
        // initInternals
    }
    return self;
}

- (void) initInternals{
    _boxFillColor           = [UIColor colorWithRed:0 green:0.478 blue:1 alpha:1];
    _boxBorderColor         = [UIColor colorWithRed:0 green:0.478 blue:1 alpha:1];
    _checkColor             = [UIColor whiteColor];
    _isChecked              = YES;
    _isChecked              = YES;
    _showTextLabel          = NO;
    textIsSet               = NO;
    self.backgroundColor    = [UIColor clearColor];
}

- (CGSize)intrinsicContentSize{
    if(_showTextLabel){
        return CGSizeMake(160, 40);
    } else {
        return CGSizeMake(40, 40);
    }
}

@end
