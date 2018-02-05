//
//  MissionGroupModel.h
//  SmartOffice
//
//  Created by Kaka on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOBaseModel.h"

@interface MissionGroupModel : SOBaseModel{
	
}
@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSString *msGroupName;
@property (assign, nonatomic) NSInteger msDelayProgressNumber;
@property (assign, nonatomic) NSInteger msUnProgressNumber;

- (instancetype)initWithName:(NSString *)groupName delayProgressNumber:(NSInteger)delay unInprogress:(NSInteger)unInprogress groupId:(NSString *)groupId;

@end
