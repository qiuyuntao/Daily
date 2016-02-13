//
//  ListData.h
//  Daily
//
//  Created by qyt on 2/13/16.
//  Copyright © 2016 qyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListData : NSObject

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) long long s_id;
@property (nonatomic, copy) NSString *ga_prefix;
@property (nonatomic, copy) NSString *title;

@end
