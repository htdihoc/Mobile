//
//  ManageIO.h
//  QuanLyRaVao
//
//  Created by NguyenDucBien on 4/12/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalCheckOutCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbReason;
@property (weak, nonatomic) IBOutlet UILabel *lbContentDeny;
@property (weak, nonatomic) IBOutlet UIImageView *iconStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Content;



@end
