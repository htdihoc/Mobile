//
//  ChoiseLocationVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 5/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ChoiseLocationVC_iPad.h"

@interface ChoiseLocationVC_iPad ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *locationArr;
}

@end

@implementation ChoiseLocationVC_iPad

@synthesize delegate = delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    locationArr = [[NSArray alloc]initWithObjects:@"Diem 1", @"Diem 2", @"Diem 3", @"Diem 4", @"Diem 5", @"Diem 6", nil];
    self.tableView.layer.cornerRadius = 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return locationArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"myCell";
    ReasonContentCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if(cell == nil){
        [tableView registerNib:[UINib nibWithNibName:@"ReasonContentCell" bundle:nil] forCellReuseIdentifier:Identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    }
    
    cell.lbReason.text = [locationArr objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(delegate != nil){
        NSString *stringPassBack = [locationArr objectAtIndex:indexPath.row];
        [self.delegate passingLocation:self didFinishSelectItem:stringPassBack];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

























