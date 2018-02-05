//
//  TTNS_AttachDocModel.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 6/13/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOBaseModel.h"

@interface TTNS_AttachDocModel : SOBaseModel
@property (strong, nonatomic) NSString  *fileName;
@property (strong, nonatomic) NSString  *categorProfileName;
@property (strong, nonatomic) NSString  *uploadDate;

@end
