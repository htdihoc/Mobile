//
//  WorkModel.h
//  SmartOffice
//
//  Created by Kaka on 4/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOBaseModel.h"

typedef enum : NSUInteger {
	StatusWorkType_Unknow = 0,
	StatusWorkType_DuocGiao,
	StatusWorkType_ToiGiao,
	StatusWorkType_PhoiHop,
	StatusWorkType_CaNhanKhac,
	StatusWorkType_CaNhanRieng,
	StatusWorkType_DaChuyen,
	StatusWorkType_TongHop123
} StatusWorkType;
//4 - Chưa thực hiện; 5 - Đang thực hiện; 6 - Đă hoàn thành;  7 - đă quá hạn; Status

@interface WorkModel : SOBaseModel{
    
}

@property (assign, nonatomic) NSUInteger taskId;
@property (strong, nonatomic) NSString *taskName;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;

@property (assign, nonatomic) NSInteger taskType;
@property (assign, nonatomic) NSInteger taskType2;

@property (assign, nonatomic) NSUInteger commanderId;
@property (strong, nonatomic) NSString *commanderName;
@property (strong, nonatomic) NSString *commanderMobilePhone;
@property (strong, nonatomic) NSString *commanderEmail;

@property (assign, nonatomic) NSUInteger enforcementId;
@property (strong, nonatomic) NSString *enforcementName;
@property (strong, nonatomic) NSString *enforcementEmail;
@property (strong, nonatomic) NSString *enforcementMobilePhone;

@property (assign, nonatomic) StatusWorkType commandType; //The loai cong viec
@property (assign, nonatomic) NSInteger completedPercent;

@property (assign, nonatomic) WorkStatus status; //Status work ??
@property (assign, nonatomic) BOOL isMajor;
@property (strong, nonatomic) NSString *delayTime;
@property (assign, nonatomic) BOOL isCompleted;

@end
