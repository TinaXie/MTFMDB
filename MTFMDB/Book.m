//
//  Book.m
//  MTFMDB_Example
//
//  Created by xiejc on 2018/12/17.
//  Copyright © 2018 xiejc. All rights reserved.
//

#import "Book.h"

@implementation Book

+ (instancetype)instanceWithDict:(NSDictionary<NSString *, NSString *> *)dict {
    Book *book = [[Book alloc] init];
    book.name = [dict objectForKey:@"name"];
    book.type = [[dict objectForKey:@"type"] integerValue];
    book.bookID = [[dict objectForKey:@"bookID"] integerValue];
    book.isDelete = [[dict objectForKey:@"isDelete"] integerValue];
    return book;
}

+ (NSArray<Book *> *)bookListFromDictList:(NSArray<NSDictionary<NSString *,NSString *> *> *)dictList {
    if (dictList.count == 0) {
        return nil;
    }

    NSMutableArray *resultList = [NSMutableArray arrayWithCapacity:dictList.count];
    for (NSDictionary<NSString *, NSString *> *dictInfo in dictList) {
        Book *book = [self instanceWithDict:dictInfo];
        [resultList addObject:book];
    }
    return resultList;
}

@end
