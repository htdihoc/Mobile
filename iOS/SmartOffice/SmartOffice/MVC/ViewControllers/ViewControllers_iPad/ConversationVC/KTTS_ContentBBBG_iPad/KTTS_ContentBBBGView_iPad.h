
//
//  KTTS_ContentBBBGView_iPad.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullWidthSeperatorTableView.h"

@protocol KTTS_ContentBBBGView_Delegate_iPad <NSObject>


- (void)actionShowContentVC:(int)index array:(NSMutableArray *)array;

- (void)actionShowConfirmAlert;

- (void)actionShowRefuseAlert;

@end

@interface KTTS_ContentBBBGView_iPad : UIView

@property (nonatomic, strong) UIView *view;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightMiddleView;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *lbl_contentBBBG;

@property (weak, nonatomic) IBOutlet UILabel *lbl_statusBBBG;

@property (weak, nonatomic) IBOutlet UILabel *lbl_reason;

@property (weak, nonatomic) IBOutlet UIView *middleView;

@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet FullWidthSeperatorTableView *tbl_Content;

@property (weak, nonatomic) IBOutlet UIButton *btn_confirm;

@property (weak, nonatomic) IBOutlet UIButton *btn_refuse;


@property (weak, nonatomic) id<KTTS_ContentBBBGView_Delegate_iPad> delegate;




@end
