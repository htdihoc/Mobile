//
//  SO_TTNSHUBCustomView.h
//  SmartOffice
//
//  Created by Nguyen Van Tu on 9/27/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSubView.h"
@interface SO_TTNSHUBCustomView : BaseSubView
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UIImageView *imgIndicator;
@property BOOL stop;
+ (instancetype)sharedInstance;
- (void)startAnimation;
@end
