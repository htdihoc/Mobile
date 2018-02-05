//
//  NotEnoughHoliday.m
//  SmartOffice
//
//  Created by NguyenDucBien on 5/12/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "NotEnoughHoliday.h"

@implementation NotEnoughHoliday

- (instancetype)initWithFrame:(CGRect)frame contentData:(NSString *)contentData{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]objectAtIndex:0];
    
    if(self){
        self.frame                  = frame;
        if(contentData != nil || contentData.length > 0){
            self.lbStatus.text      = contentData;
        }
        
        self.lbStatus.textColor     = AppColor_MainTextColor;
    }
    return self;
}




@end
