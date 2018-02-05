//
//  MainVC.h
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 3/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BaseVC.h"
#import "MagicPieLayer.h"
#import "CAPSPageMenu.h"

@interface MainVC : BaseVC <CAPSPageMenuDelegate>

@property (nonatomic, strong) CAPSPageMenu *pageMenu;

- (IBAction)btnLogoutPressed:(id)sender;

@end
