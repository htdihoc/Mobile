//
//  VOffice_MiddelVC.h
//  SmartOffice
//
//  Created by NguyenVanTu on 8/2/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOffice_MainController.h"

@interface VOffice_MiddelVC : BaseVC
@property (nonatomic, strong) VOffice_MainController *mainController;
- (void)reloadData;
@end
