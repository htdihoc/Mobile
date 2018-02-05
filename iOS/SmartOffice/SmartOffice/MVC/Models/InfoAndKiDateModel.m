//
//  InfoAndKiDateModel.m
//  SmartOffice
//
//  Created by NguyenVanTu on 6/15/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "InfoAndKiDateModel.h"

@implementation InfoAndKiDateModel
- (id)initWith:(NSInteger)currentMonth monthTotal:(NSInteger)monthToal currentYear:(NSInteger)currentYear
{
    self = [super init];
    if (self) {
        self.currentMonth = currentMonth;
        self.monthTotal = monthToal;
        self.currentYear = currentYear;
    }
    return self;
}
@end
