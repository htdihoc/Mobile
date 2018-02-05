//
//  TTNS_CheckPointModel.h
//  SmartOffice
//
//  Created by Nguyen Van Tu on 9/23/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOBaseModel.h"
@interface TTNS_CheckPointModel : SOBaseModel
@property (assign, nonatomic) double totalEmp; //Tông nhân viên
@property (assign, nonatomic) double totalLeave; //Tổng nhân viên nghỉ
@property (assign, nonatomic) double totalLeaveLong;// Tổng nv nghỉ dài hạn
@property (assign, nonatomic) double totalLeaveP;// Tổng nv nghỉ phép
@property (assign, nonatomic) double totalLeaveRv;// Tổng nv nghỉ việc riêng
@property (assign, nonatomic) double totalLeaveRo;// Tổng nv nghỉ k lương
@property (assign, nonatomic) double totalLeaveOther; // Tổng nv nghỉ khác

- (double)getLeaveTotal;
@end
