//
//  NavButton_iPad.h
//  SmartOffice
//
//  Created by NguyenVanTu on 6/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavButton_iPad:NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *iconName;

- (instancetype)initWithTitleAndIconName:(NSString *)title iconName:(NSString *)iconName;
- (instancetype)initWithTitle:(NSString *)title;

@end
