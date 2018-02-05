//
//  NSString+Util.h
//  SmartOffice
//
//  Created by NguyenVanTu on 6/12/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)
- (BOOL)checkSpace;
- (NSString *)noSpaceString;
- (NSString *)convertLatinCharacters;
- (BOOL)checkValidString;
- (NSString *)stringToShow;
- (BOOL)isImageType;
- (BOOL)isVideo;
-(NSString*) mimeTypeForFileAtPath;
- (NSString *)checkValid;
@end
