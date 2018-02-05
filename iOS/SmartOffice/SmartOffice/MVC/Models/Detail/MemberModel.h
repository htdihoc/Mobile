//
//  MemberModel.h
//  SmartOffice
//
//  Created by Kaka on 5/16/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SOBaseModel.h"

@protocol MemberModel
@end

@interface MemberModel : SOBaseModel{
	
}
@property (assign, nonatomic) NSInteger status;
@property (strong, nonatomic) NSString *aliasName;
@property (strong, nonatomic) NSString *signer;
@property (strong, nonatomic) NSString *departSentSignFullPathVof2; // use this
@property (strong, nonatomic) NSString *departmentName;
@property (strong, nonatomic) NSString *departmentSignId;

@property (strong, nonatomic) NSString *empVhrId;
@property (strong, nonatomic) NSString *empVhrName;

//For DOC
@property (strong, nonatomic) NSString *receiverName;
@property (strong, nonatomic) NSString *email;

@end
