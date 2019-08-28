//
//  Book.h
//  MTFMDB_Example
//
//  Created by xiejc on 2018/12/17.
//  Copyright © 2018 xiejc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Book : NSObject

@property (nonatomic, assign) NSInteger bookID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL isDelete;

+ (instancetype)instanceWithDict:(NSDictionary<NSString *, NSString *> *)dict;

+ (NSArray<Book *> *)bookListFromDictList:(NSArray<NSDictionary<NSString *, NSString *> *> *)dictList;

@end

NS_ASSUME_NONNULL_END
