//
//  QLTT_CommentVC.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLTT_CommentView.h"
#import "QLTT_CommentViewCell.h"
@interface QLTT_CommentVC : BaseVC
@property (weak, nonatomic) IBOutlet QLTT_CommentView *qltt_CommentView;
@property (weak, nonatomic) IBOutlet UILabel *notificationLB;
@property (weak, nonatomic) IBOutlet UIView *nofiView;

@property (weak, nonatomic) id<PassingMasterDocumentModel> delegate;
- (void)reloadData:(BOOL)isRefresh;
@end
