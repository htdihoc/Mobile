//
//  ContentFilterAndSearchBarCell.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentFilterAndSearchBarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgCheckmark;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;

- (void)setData:(NSString *)content showCheckmark:(BOOL)show;

@end
