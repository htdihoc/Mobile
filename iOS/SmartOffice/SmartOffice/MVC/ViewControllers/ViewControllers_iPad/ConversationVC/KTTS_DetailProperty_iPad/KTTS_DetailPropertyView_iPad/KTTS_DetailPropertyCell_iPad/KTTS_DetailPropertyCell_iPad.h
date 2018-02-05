//
//  KTTS_DetailPropertyCell_iPad.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTTS_DetailPropertyCell_iPad : UITableViewCell

@property(weak, nonatomic) IBOutlet UILabel *lbl_title;

@property(weak, nonatomic) IBOutlet UILabel *lbl_content;

- (void)setupDataAtIndex:(NSInteger)index;

@end
