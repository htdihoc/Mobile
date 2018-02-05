//
//  PersionaModel.h
//  SmartOffice
//
//  Created by Kaka on 4/12/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOBaseModel.h"
@class SumWorkModel;
@class SumDocModel;
@interface PersionaModel : SOBaseModel{
	
}

@property (strong, nonatomic) SumWorkModel *performWorkModel; //Công việc thực hiện
@property (strong, nonatomic) SumWorkModel *shippedWorkModel; //Công việc giao đi

@property (strong, nonatomic) NSMutableArray *listSchedule; //List Schedule model
@property (strong, nonatomic) SumDocModel *docModel;
@property (strong, nonatomic) NSMutableArray *listDoc;

- (instancetype)init;

//Update listDoc
- (void)updateDataForListDocFromSumDoc:(SumDocModel *)model;

@end
