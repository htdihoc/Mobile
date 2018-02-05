//
//  VOffice_TaskController.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/15/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VOfficeProcessor.h"
#import "MissionModel.h"
#import "NSArray+LinqExtensions.h"
#import "NSDictionary+LinqExtensions.h"
#import "MissionGroupModel.h"
@interface VOffice_TaskController : NSObject
typedef void (^CallbackVOffice_Task)(BOOL success, NSArray *listGroupPerformedMission, NSArray *listGroupShippedMission, NSArray *exceptions, NSArray *exceptionCodes);

- (void)loadData:(CallbackVOffice_Task)completion;
@end
