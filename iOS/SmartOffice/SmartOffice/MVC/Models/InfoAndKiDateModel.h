//
//  InfoAndKiDateModel.h
//  SmartOffice
//
//  Created by NguyenVanTu on 6/15/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoAndKiDateModel : NSObject
@property (assign) NSInteger currentMonth;
@property (assign) NSInteger monthTotal;
@property (assign) NSInteger currentYear;

- (id)initWith:(NSInteger)currentMonth monthTotal:(NSInteger)monthToal currentYear:(NSInteger)currentYear;
@end
