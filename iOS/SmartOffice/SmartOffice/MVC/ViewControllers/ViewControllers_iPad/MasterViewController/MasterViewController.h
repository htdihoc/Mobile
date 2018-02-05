//
//  MasterViewController.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 6/12/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectTabDelegate <NSObject>

- (void) selectFuntioninTab:(NSInteger)indexPath;

@end

@interface MasterViewController : UIViewController

@property (weak, nonatomic) id<SelectTabDelegate> delegate;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil controllers:(NSMutableArray *)controllers;

@end
