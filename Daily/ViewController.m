//
//  ViewController.m
//  Daily
//
//  Created by qyt on 2/12/16.
//  Copyright © 2016 qyt. All rights reserved.
//

#import "ViewController.h"
#import "Cell.h"
#import "AFNetworking.h"
#import "YYModel.h"
#import "ListData.h"
#import "MJRefresh.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *table;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSString *lastDate;

@property (nonatomic, weak) MJRefreshHeader *freshHeader;
@property (nonatomic, weak) MJRefreshFooter *freshFooter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGRect frame = self.view.frame;
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, frame.size.height - 20)];
    table.delegate = self;
    table.dataSource = self;
    self.table = table;
    [self.view addSubview:self.table];
    [self initForRefresh];
}

- (void)initForRefresh {
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getAsyncData:@"top"];
    }];
    
    [self.table.mj_header beginRefreshing];
    
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getAsyncData:@"bottom"];
    }];
}

- (void)getAsyncData:(NSString *)type {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL;
    if ([type isEqualToString:@"top"]) {
        URL = [NSURL URLWithString:@"http://news-at.zhihu.com/api/4/news/latest"];
    } else {
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://news.at.zhihu.com/api/4/news/before/%@", self.lastDate]];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSMutableArray *tempData = [NSMutableArray array];
            if ([type isEqualToString:@"top"]) {
                if (self.lastDate == nil) self.lastDate = responseObject[@"date"];
                long long first_id = 0;
                if (self.data.count != 0) {
                    ListData *d = self.data[0];
                    first_id = d.s_id;
                }
                for (NSDictionary *dict in responseObject[@"stories"]) {
                    ListData *data = [ListData yy_modelWithJSON:dict];
                    if (data.s_id > first_id) {
                        [tempData addObject:data];
                    } else {
                        break;
                    }
                }
                [self.data addObjectsFromArray:tempData];
            } else {
                self.lastDate = responseObject[@"date"];
                for (NSDictionary *dict in responseObject[@"stories"]) {
                    ListData *data = [ListData yy_modelWithJSON:dict];
                    [self.data addObject:data];
                }
            }
        }
        [self.table reloadData];
        [self.table.mj_header endRefreshing];
        [self.table.mj_footer endRefreshing];
        NSLog(@"%d", self.data.count);
    }];
    [dataTask resume];
}

- (NSMutableArray *)data {
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = [Cell cellWithTableView:tableView];
    cell.data = [self.data objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

@end
