//
//  SOInsectTextLabel.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOInsectTextLabel : UILabel
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
- (id)initWithFrame:(CGRect)frame isSubLabel:(BOOL)isSubLabel;
@end
