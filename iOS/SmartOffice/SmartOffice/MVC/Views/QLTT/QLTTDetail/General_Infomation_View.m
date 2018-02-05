//
//  General_Infomation_View.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 7/17/29 H.
//  Copyright © 29 Heisei ITSOL. All rights reserved.
//

#import "General_Infomation_View.h"

@implementation General_Infomation_View

- (void) loadDataWith:(QLTTMasterDocumentModel *)model {
    self.value_creator.text = model.createdUser;
    self.value_numberofpage.text = [NSString stringWithFormat:@"%@ %@/%@",model.pageNumber, LocalizedString(@"Trang"), [AppDelegateAccessor transformedValue: model.fileSize]];
    self.value_approver.text = model.approvalName;
    self.value_language.text = model.language;
    self.value_author.text = model.authorName;
}

@end
