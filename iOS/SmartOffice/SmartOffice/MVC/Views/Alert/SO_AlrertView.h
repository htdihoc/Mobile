//
//  SO_AlrertView.h
//  Alert
//
//  Created by NguyenVanTu on 4/12/17.
//  Copyright © 2017 NguyenVanTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SO_AlrertView : UIAlertController

-(void)setViewContent:(UIViewController *)vc;
-(void)addButton:(NSString *)title
       textColor:(UIColor *)textColor
          hander:(void (^)(void))hander;
@end
