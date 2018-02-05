//
//  MyAccountViewController.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/24/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "MyAccountViewController.h"

@interface MyAccountViewController ()

@property (weak, nonatomic) IBOutlet UITableView *myAccountTableView;

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backTitle = @"My Account";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
