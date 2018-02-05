//
//  KTTS_ContentBBBG_iPad.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/25/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTTS_ContentBBBGView_iPad.h"

@interface KTTS_ContentBBBG_iPad : KTTS_ContentBBBGView_iPad 

@property (strong, nonatomic) NSMutableArray *BBBG_data_array_detail;
@property (strong, nonatomic) NSArray *data_BBBG;
@property (strong, nonatomic) NSArray *data_FilterBBBG;

@property (strong, nonatomic) NSString *goods_name;
@property (strong, nonatomic) NSString *id_BBBG_detail;
@property (assign, nonatomic) NSInteger isStatus;
@property (assign, nonatomic) NSInteger start;
@property (assign, nonatomic) NSInteger limit;

- (void) getData;

@end
