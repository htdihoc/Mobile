//
//  CheckList.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "CheckList.h"
#import "DestinationListTableViewCell.h"
#import "WorkPlaceModel.h"


@interface CheckList ()<UITableViewDelegate, UITableViewDataSource>{

}

@end

@implementation CheckList

@synthesize delegate = delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCellWith:@"DestinationListTableViewCell"];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    
}

- (void)putBackData{
    if(self.delegate){
        WorkPlaceModel *model = self.array[self.indexSelect];
        NSString *address = [NSString stringWithFormat:@"%@ %@", model.dataSource, model.name];
        [self.delegate didFinishChoiseWorkPlace:self workPlaceId:model.workPlaceId address:address];
    }
}

- (void) didFinishChoiseWorkPlace:(CheckList*)vc workPlaceId:(NSInteger)workPlaceId address:(NSString*)address
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    DestinationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DestinationListTableViewCell class]) forIndexPath:indexPath];
    
    cell.lbl_Address.text = [self.array objectAtIndex:indexPath.row];
    
    if([_lastIndex isEqual:indexPath])
    {
        cell.img_Check.hidden = NO;
    }
    else
    {
        cell.img_Check.hidden = YES;
    }
    
    if (cell.img_Check.hidden == NO) {
        DLog(@"%ld: NO", (long)indexPath.row);
    }
    
    return cell;
}


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.lastIndex != indexPath) {
        self.lastIndex = indexPath;
        self.indexSelect = indexPath.row;
    } else if (self.lastIndex == indexPath) {
        self.lastIndex = nil;
        self.indexSelect = (long)nil;
    }
//    [self passingString];
    [self putBackData];
    [self dismissViewControllerAnimated:YES completion:nil];
    [tableView reloadData];
    
}

@end
