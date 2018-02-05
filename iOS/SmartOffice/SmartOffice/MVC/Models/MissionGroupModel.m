//
//  MissionGroupModel.m
//  SmartOffice
//
//  Created by Kaka on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "MissionGroupModel.h"

@implementation MissionGroupModel

- (instancetype)initWithName:(NSString *)groupName delayProgressNumber:(NSInteger)delay unInprogress:(NSInteger)unInprogress groupId:(NSString *)groupId{
	self = [super init];
	if (self) {
		self.msGroupName = groupName;
		self.msDelayProgressNumber = delay;
		self.msUnProgressNumber = unInprogress;
		self.groupId = groupId;
	}
	return  self;
}
@end
