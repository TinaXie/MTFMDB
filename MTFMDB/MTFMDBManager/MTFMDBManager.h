//
//  MTFMDBManager.h
//  FMDB
//
//  Created by xiejc on 2018/12/17.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

#define MTDBName @"MTTest"

NS_ASSUME_NONNULL_BEGIN

@interface MTFMDBManager : NSObject

/**
 *  获取单例实体
 *
 *  @return 操作数据库实体
 */
+ (MTFMDBManager *)instance;

/**
 *  执行多条数据库更新语句
 *
 *  @param sqlArray      更新语句列表
 *  @param isTransaction 是否使用事务
 *
 *  @return 成功yes，失败no
 */
- (BOOL)executeUpdateWithArray:(NSArray *)sqlArray isTransaction:(BOOL)isTransaction;

/**
 *  执行单条sql更新语句
 *
 *  @param sqlString sql更新语句
 *
 *  @return 成功yes，失败no
 */
- (BOOL)executeUpdateWithString:(NSString*)sqlString;

/**
 *  根据sql查询语句返回结果列表
 *
 *  @param sqlString sql查询语句
 *
 *  @return 返回集合
 */
- (NSArray<NSDictionary<NSString *, NSString *> *> *)executeSelectWithSql:(NSString *)sqlString;


@end

NS_ASSUME_NONNULL_END

