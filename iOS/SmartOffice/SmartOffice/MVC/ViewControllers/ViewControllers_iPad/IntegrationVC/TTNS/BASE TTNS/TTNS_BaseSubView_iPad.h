//
//  TTNS_BaseSubView_iPad.h
//  SmartOffice
//
//  Created by Administrator on 5/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOInsectTextLabel.h"
#import "BaseVC.h"

@interface TTNS_BaseSubView_iPad : BaseVC

@property (strong, nonatomic) SOInsectTextLabel *mTitle;
@property (strong, nonatomic) UIView            *containerView;

@end
