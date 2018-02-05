//
//  SONoteLabel.h
//  SmartOffice
//
//  Created by Kaka on 4/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface SONoteButton : UIButton{
    
}

@property (assign, nonatomic) IBInspectable NSInteger borderWidth;
@property (assign, nonatomic) IBInspectable CGFloat cornerRadious;
@property (assign, nonatomic) IBInspectable UIColor *borderColor;

@end
