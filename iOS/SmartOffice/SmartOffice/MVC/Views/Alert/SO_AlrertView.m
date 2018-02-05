//
//  SO_AlrertView.m
//  Alert
//
//  Created by NguyenVanTu on 4/12/17.
//  Copyright © 2017 NguyenVanTu. All rights reserved.
//

#import "SO_AlrertView.h"

@implementation SO_AlrertView
-(void)setViewContent:(UIViewController *)vc
{
    [self setValue:vc forKey:@"contentViewController"];
}
-(void)addButton:(NSString *)title
       textColor:(UIColor *)textColor
          hander:(void (^)(void))hander
{
    UIAlertAction* button = [UIAlertAction
                             actionWithTitle:title
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 if(hander)
                                     hander();
                             }];
    [button setValue:textColor forKey:@"titleTextColor"];
    [self addAction:button];
    
}
- (BOOL)canBecomeFirstResponder{
    return NO;
}
@end
