//
//  QLTTMasterDocumentModel.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/9/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOBaseModel.h"
#import "QLTTFileAttachmentModel.h"
@interface QLTTMasterDocumentModel : SOBaseModel
@property (strong, nonatomic) NSNumber *documentId;
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) NSString *approvalName;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSArray<QLTTFileAttachmentModel*> *avatar;
@property (strong, nonatomic) NSString *authorName;
@property (strong, nonatomic) NSString *expiredDate;
@property (strong, nonatomic) NSString *effectiveDate;
@property (strong, nonatomic) NSString *fileType;
@property (strong, nonatomic) NSArray *documentCategoryIds;
@property (strong, nonatomic) NSString *documentCategoryId;
@property (strong, nonatomic) NSString *docCategoryName;
@property (strong, nonatomic) NSString *approvalStatus;
@property (strong, nonatomic) NSString *createdUser;
@property (assign, nonatomic) NSString *statusName;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSNumber *type;
@property (strong, nonatomic) NSNumber *numLike;
@property (strong, nonatomic) NSNumber *numRead;
@property (strong, nonatomic) NSNumber *numDownload;
@property (strong, nonatomic) NSString *pageNumber;
@property (strong, nonatomic) NSString *fileSize;
@property (strong, nonatomic) NSString *effectStatusString;
@property (assign) BOOL secretLevel;
@property (assign) BOOL isLike;

@property (strong, nonatomic) NSString *shortName;
@property (strong, nonatomic) NSString *parentId;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSString *createdDate;
@property (strong, nonatomic) NSString *modifiedDate;
@property (strong, nonatomic) NSString *modifiedUser;
@property (strong, nonatomic) NSNumber *sortOrder;
@property (strong, nonatomic) NSString *generatedSortOrder;
@property (strong, nonatomic) NSString *pathName;
@property (strong, nonatomic) NSNumber *numDocApproved;
@property (strong, nonatomic) NSNumber *numDocDisapproved;


@property (assign, nonatomic) NSInteger level;
@property (strong, nonatomic) NSArray *levelPath;
@property (strong, nonatomic) NSMutableArray* children;

@property (nonatomic, assign) BOOL isSelectedModel;
@property (strong, nonatomic) NSArray<QLTTFileAttachmentModel*> *fileAttachment;

- (void)setFileAttachment:(NSArray<QLTTFileAttachmentModel*> *)fileAttachment andAvatar:(NSArray<QLTTFileAttachmentModel*> *)avatar;
@end
