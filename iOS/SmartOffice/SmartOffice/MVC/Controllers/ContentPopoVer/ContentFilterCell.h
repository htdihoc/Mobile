//
//  ContentFilterCell.h
//  SmartOffice
//
//  Created by Kaka on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentFilterCell : UITableViewCell{
	
}
@property (weak, nonatomic) IBOutlet UIImageView *imgCheckmark;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;

//InstanceType
+ (ContentFilterCell *)cellFromNibNamed:(NSString *)nibName;

- (void)setData:(NSString *)content showCheckmark:(BOOL)show;

@end
