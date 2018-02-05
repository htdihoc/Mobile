//
//  ContentFilterVC.h
//  SmartOffice
//
//  Created by Kaka on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentFilterVC;
@class FullWidthSeperatorTableView;
@protocol ContentFilterVCDelegate <NSObject>

- (void)didSelectedFilterVC:(ContentFilterVC *)filterVC withFilterType:(NSInteger)filterType;

@end

@interface ContentFilterVC : UIViewController<UITableViewDelegate, UITableViewDataSource>{
	
}

@property (weak, nonatomic) IBOutlet FullWidthSeperatorTableView *tblContent;

//Data
@property (assign, nonatomic) NSInteger filterType;
@property (strong, nonatomic) NSArray *listContent;
@property (weak, nonatomic) id <ContentFilterVCDelegate> delegate;

//Instance object
- (instancetype)initWithFilterSelected:(NSInteger)filterType content:(NSArray *)contents;

@end
