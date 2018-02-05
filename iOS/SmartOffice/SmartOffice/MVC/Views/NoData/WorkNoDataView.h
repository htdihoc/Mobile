//
//  WorkNoDataView.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/18/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkNoDataView : UIView
@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) IBOutlet UIImageView *img;

@property (strong, nonatomic) IBOutlet UILabel *contenLB;

- (instancetype)initWithFrame:(CGRect)frame contentData:(NSString*)contentData;

@end
