//  ReasonModel.h
//  SmartOffice
//
//  Created by Administrator on 5/18/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SOBaseModel.h"

@interface ReasonModel : SOBaseModel

@property (assign, nonatomic)NSInteger reasonOutId;

@property (strong, nonatomic)NSString *code;

@property (strong, nonatomic)NSString *name;

@property (assign, nonatomic)NSInteger workdayTypeId;

@property (assign, nonatomic)NSInteger timeHoursStart;

@property (assign, nonatomic)NSInteger timeMinuteStart;

@property (assign, nonatomic)NSInteger timeHoursEnd;

@property (assign, nonatomic)NSInteger timeMinuteEnd;

@property (assign, nonatomic)NSInteger workHours;

@property (assign, nonatomic)NSInteger createdTime;

@end
