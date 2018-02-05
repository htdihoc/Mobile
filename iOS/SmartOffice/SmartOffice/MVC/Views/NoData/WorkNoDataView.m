//
//  WorkNoDataView.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/18/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "WorkNoDataView.h"

@implementation WorkNoDataView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame contentData:(NSString *)contentData{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]objectAtIndex:0];
    
    if(self){
        self.frame                  = frame;
        if(contentData != nil || contentData.length > 0){
            self.contenLB.text      = contentData;
        }
        self.backgroundColor        = AppColor_MainTextColor;
        self.contenLB.textColor     = AppColor_MainTextColor;
    }
    return self;
}

@end
