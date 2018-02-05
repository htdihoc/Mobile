//
//  BaseVC.h
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 3/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseVC : UIViewController

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *button;

- (void)logout;

@end
