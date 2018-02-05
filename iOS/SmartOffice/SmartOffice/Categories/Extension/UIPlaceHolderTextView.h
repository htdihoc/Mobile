//
//  UIPlaceHolderTextView.h
//  SmartOffice
//
//  Created by Administrator on 6/7/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

IB_DESIGNABLE
@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;
@property (nonatomic, retain) IBInspectable UIFont *placeholderFont;
-(void)textChanged:(NSNotification*)notification;

@end
