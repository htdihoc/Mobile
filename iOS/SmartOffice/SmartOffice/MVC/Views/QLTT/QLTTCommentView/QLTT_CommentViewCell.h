//
//  QLTTCommentViewCell.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLTTCommentingPerson.h"
#define DATE_COMMENT_FORMAT_FROM_SERVER @"MM dd, yyyy hh:mm:ss a"
#define DATE_COMMENT_FORMAT_DISPLAY     @"HH:mm - dd/MM/yyyy"
@protocol QLTT_CommentViewCellDelegate <NSObject>
- (void)viewMore:(NSInteger)index;
@end
@interface QLTT_CommentViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn_ViewMore;

- (void)setupDataForView:(QLTTCommentingPerson *)model index:(NSInteger)index isViewMore:(BOOL)isViewMore;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Content;

@property (weak, nonatomic) id<QLTT_CommentViewCellDelegate> delegate;
@end
