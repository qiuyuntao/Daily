//
//  Cell.h
//  Daily
//
//  Created by qyt on 2/12/16.
//  Copyright © 2016 qyt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ListData;

@interface Cell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) ListData *data;
- (void)setData:(ListData *)data;

@end
