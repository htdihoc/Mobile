//
//  VOffice_ListWork_iPad.h
//  SmartOffice
//
//  Created by Nguyen Van Tu on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOffice_ListView_iPad.h"
@interface VOffice_ListWork_iPad : VOffice_ListView_iPad
@property (assign, nonatomic) WorkType workType;
@property (strong, nonatomic) NSMutableArray *listWorks;
@end
