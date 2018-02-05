//
//  SearchHandler_iPad.m
//  SmartOffice
//
//  Created by NguyenDucBien on 5/12/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SearchHandler_iPad.h"
#import "HandlerListCell.h"
#import "MZFormSheetController.h"



@interface SearchHandler_iPad () {
    NSArray *name;
    NSArray *position;

}

@end

@implementation SearchHandler_iPad
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.checkOutHandlerTableView.delegate = self;
    self.checkOutHandlerTableView.dataSource = self;
    name = [[NSArray alloc]initWithObjects:@"Nguyễn Hoàng Anh", @"Mai Ngọc Anh", @"Hoàng Văn Hưng", nil];
    position = [[NSArray alloc] initWithObjects:@"Trung tâm sảm phẩm mới", @"Trung tâm phần mềm", @"Trung tâm văn hoá", nil];
    _searchBarTool.placeholder = LocalizedString(@"PL_SEARCH_DOC_LABEL");
    
}

- (void)passDataBack {
    if (self.delegate) {
        NSString *itemToPassBack = [name objectAtIndex:indexString];
        [self.delegate passingString:self.delegate didFinishChooseItem:itemToPassBack];
    }
    
}

#pragma mark Tableview Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return name.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HandlerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HandlerCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"HandlerListCell" bundle:nil] forCellReuseIdentifier:@"HandlerCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"HandlerCell"];
        
    }
    cell.lbPersonName.text = [name objectAtIndex:indexPath.row];
    cell.lbPersonPosition.text = [position objectAtIndex:indexPath.row];

    return cell;

}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    indexString = indexPath.row;
    [tableView reloadData];
    [self passDataBack];
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController * _Nonnull formSheetController) {
    }];
}

- (IBAction)actionClose:(id)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController * _Nonnull formSheetController) {
    }];
}
@end
