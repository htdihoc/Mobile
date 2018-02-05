//
//  TTNSRoot.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTNSRoot : BaseVC

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTopConstraint;
- (void)reloadData;
@end
