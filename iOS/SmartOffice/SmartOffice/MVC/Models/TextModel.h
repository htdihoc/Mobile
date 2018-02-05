//
//  TextModel.h
//  SmartOffice
//
//  Created by Kaka on 5/16/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SOBaseModel.h"
static NSString *PRIORITY_NORMAL_TEXT = @"Bình thường"; //Remove later
@interface TextModel : SOBaseModel

@property (assign, nonatomic) BOOL canEdit;
@property (strong, nonatomic) NSString *chiefName;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSArray *listFileSignMain;
@property (strong, nonatomic) NSArray *listFileSignOther;
@property (assign, nonatomic) NSInteger mainStatus;
@property (strong, nonatomic) NSNumber *numberHtime;
@property (strong, nonatomic) NSString *officeSender;
@property (strong, nonatomic) NSNumber *orderNumber;
@property (strong, nonatomic) NSNumber *orderNumberMax;
@property (strong, nonatomic) NSString *priorityName;
@property (assign, nonatomic) NSInteger priorityId;
@property (strong, nonatomic) NSString *receiveDate;
@property (assign, nonatomic) NSInteger sTypeId;
@property (assign, nonatomic) NSInteger state;
@property (strong, nonatomic) NSString *textId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *typeName;
@property (strong, nonatomic) NSString *searchName;
@property (strong, nonatomic) NSString *documentId;
@end
