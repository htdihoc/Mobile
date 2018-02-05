//
//  SOBaseModel.m
//  SmartOffice
//
//  Created by Kaka on 4/12/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOBaseModel.h"

@implementation SOBaseModel
- (void)printDescription {
    DLog(@"%@", [self toJSONString]);
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end
