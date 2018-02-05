//
//  TTNS_Base_iPad.h
//  SmartOffice
//
//  Created by Administrator on 7/14/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNS_NavBase_iPad.h"

@interface TTNS_Base_iPad : BaseVC

@property(nonatomic,copy) NSString *TTNS_title;
@property (nonatomic, copy) NSArray *TTNS_buttonTitles;

@property (assign) NSInteger jumpVC;

@property(strong, nonatomic) TTNS_NavBase_iPad *nav_iPad;

- (void)didTapRightButton:(UIButton *)sender;
- (void)isTTNSVC:(BOOL)isTTNSVC;

@end
