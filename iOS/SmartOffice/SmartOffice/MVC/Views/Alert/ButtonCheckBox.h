//
//  ButtonCheckBox.h
//  Demo
//
//  Created by NguyenDucBien on 4/10/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonCheckBox : UIButton

@property (assign, nonatomic) BOOL isCheckboxSelected;
@property IBInspectable UIImage *imgCheck;
@property IBInspectable UIImage *imgUnCheck;

- (void)setSelected:(BOOL)selected;
- (void)refresh;


@end
