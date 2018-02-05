//
//  SOTableViewRowAction.h
//  SmartOffice
//
//  Created by Kaka on 4/11/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOTableViewRowAction : UITableViewRowAction{
    
}
@property UIImage *icon;
@property UIFont *font;
@property UIColor *color;
@property NSString *customTitle;
+ (instancetype)rowActionWithStyle:(UITableViewRowActionStyle)style
                             title:(NSString *)title
                              icon:(UIImage*)icon
                             color:(UIColor *)color
                           handler:(void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))handler;

@end
