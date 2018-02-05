//
//  NSString+StringToDate.h
//  SmartOffice
//
//  Created by NguyenVanTu on 6/7/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringToDate)
- (NSDate *)convertStringToDateWith:(NSString *)format;
@end
