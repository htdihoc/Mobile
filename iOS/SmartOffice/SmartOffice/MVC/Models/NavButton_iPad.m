//
//  NavButton_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 6/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "NavButton_iPad.h"


@implementation NavButton_iPad

- (instancetype)initWithTitleAndIconName:(NSString *)title iconName:(NSString *)iconName
{
    self = [super init];
    if (self) {
        self.title = title;
        self.iconName = iconName;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
{
    return [self initWithTitleAndIconName:title iconName:@"nav_bulkHead"];
}

@end
