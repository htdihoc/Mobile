//
//  QLTTFileAttachment.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOBaseModel.h"
@interface QLTTFileAttachmentModel : SOBaseModel
@property (strong, nonatomic) NSNumber *fileAttachmentId;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSNumber *fileSize;
@property (strong, nonatomic) NSString *fileType;
@end
