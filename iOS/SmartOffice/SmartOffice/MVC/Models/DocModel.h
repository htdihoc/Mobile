//
//  DocModel.h
//  SmartOffice
//
//  Created by Kaka on 4/12/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOBaseModel.h"

@interface DocModel : SOBaseModel{
	
}
@property (strong, nonatomic) NSString *documentId;
@property (assign, nonatomic) NSUInteger documentInStaffId;
@property (assign, nonatomic) NSInteger documentType;

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *promulgateDate;
@property (strong, nonatomic) NSString *receiveDate;
@property (strong, nonatomic) NSString *signer;

@property (assign, nonatomic) BOOL isArrive;
@property (assign, nonatomic) BOOL isRead;

@property (assign, nonatomic) NSUInteger priorityId;
@property (strong, nonatomic) NSString *priority;

@property (assign, nonatomic) NSUInteger typeId;
@property (strong, nonatomic) NSString *type;

@property (assign, nonatomic) NSUInteger stypeId;
@property (strong, nonatomic) NSString *stype;

@property (assign, nonatomic) NSUInteger areaId;
@property (strong, nonatomic) NSString *area;

@property (assign, nonatomic) NSInteger total;

@property (strong, nonatomic) NSArray *listAttachment;

@property (strong, nonatomic) NSString *sendDocType;
@property (assign, nonatomic) NSInteger sendType;
@property (strong, nonatomic) NSString *senderEmail;
@property (strong, nonatomic) NSString *senderName;

@property (assign, nonatomic) NSUInteger staffId;

@property (strong, nonatomic) NSString *searchName;

@property (strong, nonatomic) NSString *textId;

@property (strong, nonatomic) NSString *promulgatingDepart;
@end
