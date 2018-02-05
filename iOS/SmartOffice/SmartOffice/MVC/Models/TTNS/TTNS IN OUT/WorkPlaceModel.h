//
//  WorkPlaceModel.h
//  SmartOffice
//
//  Created by Administrator on 5/18/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SOBaseModel.h"

@interface WorkPlaceModel : SOBaseModel

@property (assign, nonatomic)NSInteger stt;
@property (strong, nonatomic)NSString *dataSource;
@property (assign, nonatomic)NSInteger originId;
@property (assign, nonatomic)NSInteger workPlaceId;
@property (strong, nonatomic)NSString *code;
@property (strong, nonatomic)NSString *name;
@property (assign, nonatomic)NSInteger parentId;
@property (assign, nonatomic)NSInteger address;
@property (assign, nonatomic)NSInteger createUser;
@property (assign, nonatomic)NSInteger createDate;
@property (assign, nonatomic)NSInteger modifyUser;
@property (assign, nonatomic)NSInteger modifyDate;

@end
