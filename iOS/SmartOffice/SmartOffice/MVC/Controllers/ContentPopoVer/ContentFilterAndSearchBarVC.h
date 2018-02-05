//
//  ContentFilterAndSearchBarVC.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullWidthSeperatorTableView.h"
@protocol ContentFilterAndSearchBarVCDelegate <NSObject>
- (void)didSelectedFilterVC:(NSInteger)index;
@end
@interface ContentFilterAndSearchBarVC : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    
}

@property (weak, nonatomic) IBOutlet FullWidthSeperatorTableView *tblContent;

//Data
@property (assign, nonatomic) NSInteger filterType;
@property (strong, nonatomic) NSArray *listContent;
@property (strong, nonatomic) NSArray *listFilteredContent;
@property (weak, nonatomic) id <ContentFilterAndSearchBarVCDelegate> delegate;
@property (strong, nonatomic) NSString *placeHolder;
//Instance object
- (instancetype)initWithFilterSelected:(NSInteger)filterType content:(NSArray *)contents withoutSearchBar:(BOOL)isHiddenSearchBar;

@end
