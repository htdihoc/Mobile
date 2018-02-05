//
//  ButtonCheckBox.m
//  Demo
//
//  Created by NguyenDucBien on 4/10/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import "ButtonCheckBox.h"

@implementation ButtonCheckBox{
    
}

- (void)setImageWithName:(NSString *)name
{
    [self setImage:[UIImage imageNamed:name] forState:UIControlStateSelected];
}
- (void)setImageForSelectedButton
{
    
    if(_imgCheck == nil){
        [self setImageWithName:@"check_Button"];
    } else {
        [self setImage:_imgCheck forState:UIControlStateNormal];
    }
    
}

- (void)setImageForUnSelectedButton
{
    
    if(_imgUnCheck == nil){
        [self setImageWithName:@"uncheck_Button"];
    } else{
        [self setImage:_imgUnCheck forState:UIControlStateNormal];
    }
    
}
- (void)refresh {
    [self setSelected:NO];
    [self setImageForUnSelectedButton];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if(selected == true)
    {
        self.isCheckboxSelected = YES;
        [self setImageForSelectedButton];
    }
    else
    {
        self.isCheckboxSelected = NO;
        [self setImageForUnSelectedButton];
    }
    
}


@end
