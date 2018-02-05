//
//  CheckOutDetail.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/08/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "QLTT_RADataObject.h"

@implementation QLTT_RADataObject


- (id)initWithName:(NSString *)name children:(NSArray *)children
{
  self = [super init];
  if (self) {
    self.children = [NSArray arrayWithArray:children];
    self.name = name;
  }
  return self;
}

+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children
{
  return [[self alloc] initWithName:name children:children];
}

- (void)addChild:(id)child
{
  NSMutableArray *children = [self.children mutableCopy];
  [children insertObject:child atIndex:0];
  self.children = [children copy];
}

- (void)removeChild:(id)child
{
  NSMutableArray *children = [self.children mutableCopy];
  [children removeObject:child];
  self.children = [children copy];
}

@end
