//
//  CheckOutDetail.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/08/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLTT_RADataObject : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *children;

- (id)initWithName:(NSString *)name children:(NSArray *)array;

+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children;

- (void)addChild:(id)child;
- (void)removeChild:(id)child;

@end
