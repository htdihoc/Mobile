//
//  WorkNotDataCell.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/18/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkNotDataCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *img;

@property (strong, nonatomic) IBOutlet UILabel *contentLB;

- (void)setupUIWithContent:(NSString *)content;

@end
