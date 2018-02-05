//
//  ChoiseUserVC.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/20/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ChoiseUserVC.h"
#import "ChoiseUserCell.h"



@interface ChoiseUserVC ()<UITableViewDataSource, UITableViewDelegate>{
}

@end

@implementation ChoiseUserVC

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    // Do any additional setup after loading the view.
}

- (void)setupNav{
    self.backTitle      = LocalizedString(@"TTNS_TIM_KIEM");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* Identifier     = @"ChoiseUserCell";
    
    ChoiseUserCell *cell        = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if(cell == nil){
        cell        = [[ChoiseUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        cell.selectionStyle         = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(delegate != nil){
        // Do something here
    }
}

@end
