//
//  DocumentCategoryModel.h
//  SmartOffice
//
//  Created by Nguyen Duc Bien on 9/19/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SOBaseModel.h"

@interface DocumentCategoryModel : SOBaseModel {
    
}

@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *documentDate;
@property (strong, nonatomic) NSString *documentNo;
@property (strong, nonatomic) NSString *documentType;

@end
