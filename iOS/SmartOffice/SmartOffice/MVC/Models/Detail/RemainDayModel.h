//
//  RemainDayModel.h
//  SmartOffice
//
//  Created by Administrator on 5/16/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SOBaseModel.h"
#import <Foundation/Foundation.h>

@interface RemainDayModel : SOBaseModel{
    
}
@property (assign, nonatomic) NSInteger employeeId;
@property (assign, nonatomic) NSInteger totalSabaticalDays;
@property (assign, nonatomic) NSInteger totalNumOfDayLeave;
@property (assign, nonatomic) NSInteger remainingAnnualDay;


@end
