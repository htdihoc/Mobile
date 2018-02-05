//
//  NSString+Util.m
//  SmartOffice
//
//  Created by NguyenVanTu on 6/12/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "NSString+Util.h"
#import <MobileCoreServices/MobileCoreServices.h>
#define MAXLENGHT 200
@implementation NSString (Util)
- (NSString *)noSpaceString
{
    return [self stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
-(NSString*) mimeTypeForFileAtPath {
    // Borrowed from https://stackoverflow.com/questions/5996797/determine-mime-type-of-nsdata-loaded-from-a-file
    // itself, derived from  https://stackoverflow.com/questions/2439020/wheres-the-iphone-mime-type-database
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)self, NULL);
    CFStringRef mimeType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    if (!mimeType) {
        return @"application/octet-stream";
    }
    return (__bridge NSString *)mimeType;
}
- (BOOL)isImageType
{
    if ([self isEqualToString:@"jpeg"] ||
        [self isEqualToString:@"png"] ||
        [self isEqualToString:@"gif"] ||
        [self isEqualToString:@"tiff"] ||
        [self isEqualToString:@"jpg"]) {
        return YES;
    }
    return NO;
    
}
- (NSString *)checkValid
{
    if (self == nil || [self isEqualToString:@""]) {
        return LocalizedString(@"N/A");
    }
    return self;
}
- (BOOL)isVideo
{
    if ([self.lowercaseString isEqualToString:@"flv"] ||
        [self.lowercaseString isEqualToString:@"mp4"] ||
        [self.lowercaseString isEqualToString:@"m3u8"] ||
        [self.lowercaseString isEqualToString:@"ts"] ||
        [self.lowercaseString isEqualToString:@"3gp"] ||
        [self.lowercaseString isEqualToString:@"mov"] ||
        [self.lowercaseString isEqualToString:@"avi"] ||
        [self.lowercaseString isEqualToString:@"wmv"]) {
        return YES;
    }
    return NO;
    
}

- (NSString *)stringToShow
{
	if (self.length > MAXLENGHT) {
		return [NSString stringWithFormat:@"%@...", [self substringToIndex:MAXLENGHT - 4]];
	}
	return self;
}
- (BOOL)checkValidString
{
    if ([self isEqualToString:@""] || self == nil) {
        return NO;
    }
    return YES;
}
- (BOOL)checkSpace
{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if ([self isEqualToString:@""] || [[self stringByTrimmingCharactersInSet: set] length] == 0)
    {
        return YES;
    }
    return NO;
}
- (NSString *)convertLatinCharacters
{
    if (![self checkValidString]) {
        return @"";
    }
//    NSData *temp = [self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    NSString *dst = [[NSString alloc] initWithData:temp encoding:NSASCIIStringEncoding];
    return self;
}
@end
