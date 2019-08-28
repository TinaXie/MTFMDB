//
//  MTViewController.m
//  MTFMDB
//
//  Created by xiejc on 11/29/2018.
//  Copyright (c) 2018 xiejc. All rights reserved.
//

#import "MTViewController.h"
#import "MTFMDBManager.h"
#import "Book.h"

@interface MTViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
}

- (void)loadData {
    NSString *searchSql = @"select * from Book";
    NSArray<NSDictionary<NSString *, NSString *> *> *result = [[MTFMDBManager instance] executeSelectWithSql:searchSql];
    self.dataList = [Book bookListFromDictList:result];
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"bookCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Book *book = [self.dataList objectAtIndex:indexPath.row];
    cell.textLabel.text = book.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
