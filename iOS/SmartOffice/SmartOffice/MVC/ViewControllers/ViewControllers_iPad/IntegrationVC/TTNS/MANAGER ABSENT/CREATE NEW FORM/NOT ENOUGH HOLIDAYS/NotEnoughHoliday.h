//
//  NotEnoughHoliday.h
//  SmartOffice
//
//  Created by NguyenDucBien on 5/12/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotEnoughHoliday : UIView
@property (strong, nonatomic) UIView *customView;
@property (weak, nonatomic) IBOutlet UIImageView *imgNotthing;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;

- (instancetype)initWithFrame:(CGRect)frame contentData:(NSString *)contentData;

@end
