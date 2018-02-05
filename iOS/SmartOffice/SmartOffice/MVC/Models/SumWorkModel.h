//
//  WorkModel.h
//  SmartOffice
//
//  Created by Kaka on 4/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOBaseModel.h"

@interface SumWorkModel : SOBaseModel{
    
}
@property (assign, nonatomic) WorkType typeTask; //(0- việc giao đi; 1 - việc thực hiện)

@property (assign, nonatomic) NSInteger newTask;
@property (assign, nonatomic) NSInteger inProgress;
@property (assign, nonatomic) NSInteger completed;

@property (assign, nonatomic) NSInteger overdue;
@property (assign, nonatomic) NSInteger approvalTask; //Số lượng phiếu giao việc
@property (assign, nonatomic) NSInteger approvalEvaluation; //số lượng phiếu đánh giá

@property (assign, nonatomic) BOOL isApprovalTask; //0 - ko có quyền ký PGV; 1 - có quyền ký phiếu giao việc
@property (assign, nonatomic) BOOL isApprovalEvalTask; //0 - ko có quyền ký đánh giá; 1 - có quyền đánh giá
@property (assign, nonatomic) NSInteger nDayUrgenTask; //số ngày cấu hình cảnh báo sắp đến hạn

@end

