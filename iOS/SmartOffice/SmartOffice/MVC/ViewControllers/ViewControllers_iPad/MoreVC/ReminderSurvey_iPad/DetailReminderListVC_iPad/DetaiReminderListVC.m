//
//  DetaiReminderListVC.m
//  SmartOffice
//
//  Created by NguyenDucBien on 5/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "DetaiReminderListVC.h"
#import "CellReminder.h"

@interface DetaiReminderListVC ()

@end

@implementation DetaiReminderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.mTitle.text = @"Danh sách nhắc nhở";
    
}

#pragma mark Tableview Datasource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID_CELL = @"reminderCell";
    
    CellReminder *cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:@"CellReminder" bundle:nil] forCellReuseIdentifier:ID_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:ID_CELL];
    }
    return cell;
}

#pragma mark Tableview Delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (IBAction)creatReminderNewAction:(id)sender {
    [self.delegate pressButton:sender];
}
@end
