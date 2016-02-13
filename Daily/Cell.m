//
//  Cell.m
//  Daily
//
//  Created by qyt on 2/12/16.
//  Copyright © 2016 qyt. All rights reserved.
//

#import "Cell.h"
#import "ListData.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

@interface Cell()

@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) UIImageView *image;
@property (nonatomic, weak) UILabel *label;

@end

@implementation Cell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"daily";
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[Cell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self initFrame];
    
    return self;
}

- (void)initFrame {
    UIView *view = [[UIView alloc] init];
    CGRect screenBounds = [ [ UIScreen mainScreen ] bounds ];
    view.frame = CGRectMake(0, 10, screenBounds.size.width, 180);
    self.view = view;
    [self.contentView addSubview:view];
    
    UIImageView *image = [[UIImageView alloc] init];
    image.frame = CGRectMake(screenBounds.size.width - 95, 0, 75, 60);
//    image.image = [UIImage imageNamed:@"1.jpg"];
    self.image = image;
    [self.view addSubview:self.image];
    
    UILabel *label = [[UILabel alloc] init];
//    label.text = @"年度热门年度热门年度热门年度热门年度热门年度热门年度热门";
    label.frame = CGRectMake(15, 0, 240, 60);
    label.numberOfLines = 0;
    self.label = label;
    [self.view addSubview:self.label];
}

- (void)setData:(ListData *)data {
    self.label.text = data.title;
    [self.image sd_setImageWithURL:[NSURL URLWithString:data.images[0]]];
}

@end
