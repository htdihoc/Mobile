//
//  TextModel.m
//  SmartOffice
//
//  Created by Kaka on 5/16/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TextModel.h"

@implementation TextModel
+ (JSONKeyMapper *)keyMapper
{
	return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
																  @"desc": @"description"
																  }];
}

- (void)setChiefName:(NSString *)chiefName
{
    _chiefName = chiefName;
    _searchName = _chiefName;
}
- (NSString *)documentId
{
    return _textId;
}
@end
