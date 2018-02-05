//
//  DocModel.h
//  SmartOffice
//
//  Created by Kaka on 4/12/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOBaseModel.h"

@interface SumDocModel : SOBaseModel{
	
}
@property (assign, nonatomic) NSInteger countTextSigned;		//Hoả tốc
@property (assign, nonatomic) NSInteger countTextWaitingInitial;//Chờ ký nháy
@property (assign, nonatomic) NSInteger countTextWaitSign;		//Chờ ký duyệt

@property (assign, nonatomic) NSInteger countTextSecretaryWaitSign; //Số lượng văn bản đang chờ ký duyệt với user là văn thư - không sử dụng hiện giờ

@end
