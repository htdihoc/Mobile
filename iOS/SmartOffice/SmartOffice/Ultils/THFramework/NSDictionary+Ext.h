//
//  NSDictionary+Ext.h
//  mPOS_iOS
//
//  Created by Nguyen Thanh Huy on 11/8/16.
//  Copyright © 2016 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NSDictionary)

- (void)setValueString:(NSString *)strValue nullValue:(NSString *)nullValue forKey:(NSString *)key;
- (NSString *)getValueStringFromKey:(NSString *)key;

@end
