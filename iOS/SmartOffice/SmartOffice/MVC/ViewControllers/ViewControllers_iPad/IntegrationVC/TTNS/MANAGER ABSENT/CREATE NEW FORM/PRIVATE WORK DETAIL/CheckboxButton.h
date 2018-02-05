//
//  CheckboxButton.h
//  TTNS_ListOff_iPad
//
//  Created by NguyenDucBien on 5/8/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckboxButton : UIButton
@property (assign, nonatomic)BOOL isCheckboxSelected;

- (void)setSelected:(BOOL)selected;
- (void)refresh;

@end
