//
//  InfoEmployCheckOut.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "InfoEmployCheckOut.h"

@implementation InfoEmployCheckOut
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"";
        self.content = @"";
        self.time = @"";
    }
    return self;
}
- (instancetype)initWithImg:(UIImage *)img
                       name:(NSString *)name
                    content:(NSString *)content
                       time:(NSString *)time
{
    self = [super init];
    if (self) {
        self.img = img;
        self.name = name;
        self.content = content;
        self.time = time;
    }
    return self;
}
@end
