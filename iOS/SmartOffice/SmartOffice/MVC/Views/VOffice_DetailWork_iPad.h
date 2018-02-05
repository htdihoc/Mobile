//
//  VOffice_DetailWork_iPad.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VOffice_DetailView_iPad.h"
@class DetailWorkModel;
@protocol VOffice_DetailWork_iPadDelegate
-(DetailWorkModel *)getDetailWorkModel;
- (void)didSelectVOffice;
- (void)endEditView;
@end
@interface VOffice_DetailWork_iPad : VOffice_DetailView_iPad

@property (nonatomic) NSInteger setSegment;

@property (weak, nonatomic) id <VOffice_DetailWork_iPadDelegate>delegate;
@end
