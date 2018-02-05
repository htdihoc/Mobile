//
//  MyPieElement.m
//  MagicPie
//
//  Created by Alexander on 31.12.13.
//  Copyright (c) 2013 Alexandr Corporation. All rights reserved.
//

#import "SOPieElement.h"

@implementation SOPieElement

- (id)copyWithZone:(NSZone *)zone
{
    SOPieElement *copyElem = [super copyWithZone:zone];
    copyElem.title = self.title;
    
    return copyElem;
}

@end
