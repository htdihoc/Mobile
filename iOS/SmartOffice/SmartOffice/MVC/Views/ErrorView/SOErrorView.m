//
//  SOErrorView.m
//  SmartOffice
//
//  Created by Kaka on 4/12/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOErrorView.h"
#import "SONoteButton.h"

@implementation SOErrorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame inforError:(NSString *)errorInfo{
    self =  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.frame = frame;
        if (errorInfo != nil || errorInfo.length > 0) {
            self.lblErrorInfo.text = errorInfo;
        }
        //self.backgroundColor = [UIColor clearColor];
		self.backgroundColor = AppColor_MainAppBackgroundColor;
    }
    return self;
}

- (void)setErrorInfo:(NSString *)error{
	if (error == nil || error.length == 0) {
		error = @"";
	}
	_lblErrorInfo.text = error;
}

- (IBAction)onTryAgainButtonClicked:(id)sender {
    if (_delegate) {
        [_delegate didRefreshOnErrorView:self];
    }
}

@end
