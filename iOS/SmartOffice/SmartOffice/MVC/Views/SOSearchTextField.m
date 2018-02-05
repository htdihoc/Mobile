//
//  SOSearchTextField.m
//  SmartOffice
//
//  Created by Kaka on 4/13/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOSearchTextField.h"

@implementation SOSearchTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
	[super awakeFromNib];
	[self setLeftViewMode:UITextFieldViewModeAlways];
	self.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_glass_icon"]];
}
@end
