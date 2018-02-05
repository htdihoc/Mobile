//
//  KTTS_PersonalInforVC_iPad.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/10/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTTS_ListPropertyView_iPad.h"
#import "KTTS_DetailProperty_iPad.h"
#import "KTTS_ContentBBBG_iPad.h"
#import "KTTS_ListPropertyCell_iPad.h"

#import "VOffice_Base_iPad.h"

@interface KTTS_PersonalInforVC_iPad : VOffice_Base_iPad

@property (weak, nonatomic) IBOutlet KTTS_ListPropertyView_iPad *listProperty;
@property (weak, nonatomic) IBOutlet KTTS_DetailProperty_iPad *propertyDetail;
@property (weak, nonatomic) IBOutlet KTTS_ContentBBBG_iPad *contentBBBG;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic) int switchScreen;

@end
