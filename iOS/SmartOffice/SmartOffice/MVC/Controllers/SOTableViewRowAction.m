//
//  SOTableViewRowAction.m
//  SmartOffice
//
//  Created by Kaka on 4/11/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOTableViewRowAction.h"
@implementation SOTableViewRowAction


+ (instancetype)rowActionWithStyle:(UITableViewRowActionStyle)style
                             title:(NSString *)title
                              icon:(UIImage*)icon color:(UIColor *)color
                           handler:(void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))handler
{
//    if (iOS9AndLater) {
//        SOTableViewRowAction *action = [super rowActionWithStyle:style title:@"          " handler:handler];
////        action.customTitle = title;
//        action.icon = icon;
//        action.color = color;
//        return action;
//    }
//    else
//    {
        SOTableViewRowAction *action = [super rowActionWithStyle:style title:@"          " handler:handler];
        [action setBackgroundColor:[UIColor colorWithPatternImage:icon]];
        return action;
//    }
    
}

- (void)_setButton:(UIButton*)button
{
    if(self.icon != nil && button.titleLabel != nil)
    {
        button.backgroundColor = self.color;
        [button setImage:self.icon forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [button.titleLabel removeFromSuperview];
        
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        subLabel.text = self.customTitle;
        subLabel.numberOfLines = 1;
        subLabel.textAlignment = NSTextAlignmentCenter;
        subLabel.textColor = [UIColor whiteColor];
        [button addSubview:subLabel];
        
        subLabel.translatesAutoresizingMaskIntoConstraints = NO;

        /* Top space to superview Y*/
        NSLayoutConstraint *leftButtonYConstraint = [NSLayoutConstraint
                                                     constraintWithItem:subLabel
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual toItem:button
                                                     attribute:NSLayoutAttributeBottom multiplier:1.0f
                                                     constant:-4];
        
        /* Leading space to superview */
        NSLayoutConstraint *leftButtonXConstraint = [NSLayoutConstraint
                                                     constraintWithItem:subLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                     toItem:button attribute:
                                                     NSLayoutAttributeLeft multiplier:1.0
                                                     constant:4];
        NSLayoutConstraint *rightButtonXConstraint = [NSLayoutConstraint
                                                     constraintWithItem:subLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                     toItem:button attribute:
                                                     NSLayoutAttributeRight multiplier:1.0
                                                     constant:-8];
        
        /* Fixed Height */
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint
                                                constraintWithItem:subLabel
                                                attribute:NSLayoutAttributeHeight
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:button
                                                attribute:NSLayoutAttributeHeight
                                                multiplier:0.3
                                                constant:0];
        /* 4. Add the constraints to button's superview*/
        [button addConstraints:@[leftButtonXConstraint, leftButtonYConstraint, heightConstraint, rightButtonXConstraint]];
        
        
        button.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        /* Top space to superview Y*/
        leftButtonYConstraint = [NSLayoutConstraint
                                                     constraintWithItem:button.imageView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual toItem:subLabel
                                                     attribute:NSLayoutAttributeTop multiplier:1.0f
                                                     constant:-8];
        
        /* Leading space to superview */
        leftButtonXConstraint = [NSLayoutConstraint
                                                     constraintWithItem:button.imageView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                     toItem:button attribute:
                                                     NSLayoutAttributeLeft multiplier:1.0
                                                     constant:0];
        rightButtonXConstraint = [NSLayoutConstraint
                                                      constraintWithItem:button.imageView
                                                      attribute:NSLayoutAttributeRight
                                                      relatedBy:NSLayoutRelationEqual
                                                      toItem:button attribute:
                                                      NSLayoutAttributeRight multiplier:1.0
                                                      constant:0];
        
        /* Fixed Height */
        heightConstraint = [NSLayoutConstraint
                            constraintWithItem:button.imageView
                            attribute:NSLayoutAttributeTop
                            relatedBy:NSLayoutRelationEqual
                            toItem:button attribute:
                            NSLayoutAttributeTop multiplier:1.0
                            constant:24];
        /* 4. Add the constraints to button's superview*/
        [button addConstraints:@[leftButtonXConstraint, leftButtonYConstraint, heightConstraint, rightButtonXConstraint]];
        [button layoutIfNeeded];
        
		
		/*
		CGSize buttonImageSize = button.imageView.image.size;
        
        CGFloat topImageOffset = (buttonSize.height - (titleSize.height + buttonImageSize.height + offset)) / 2;
        CGFloat leftImageOffset = (buttonSize.width - buttonImageSize.width) / 2;
        self.imageEdgeInsets = UIEdgeInsetsMake(topImageOffset + offset,
                                                leftImageOffset,
                                                topImageOffset + 3*offset,0);
        CGFloat titleTopOffset = buttonSize.height - titleSize.height;
        CGFloat leftTitleOffset = (buttonSize.width - titleSize.width) / 2 - self.imageView.image.size.width;
        
        self.titleEdgeInsets = UIEdgeInsetsMake(titleTopOffset,
                                                leftTitleOffset,
                                                0,0);
		 */
    }
}
@end
