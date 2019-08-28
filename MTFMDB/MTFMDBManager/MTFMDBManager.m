//
//  MTFMDBManager.m
//  FMDB
//
//  Created by xiejc on 2018/12/17.
//

#import "MTFMDBManager.h"


@interface MTFMDBManager ()


@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation MTFMDBManager

static MTFMDBManager *dataBaseManageObj;


+ (MTFMDBManager *)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataBaseManageObj = [[MTFMDBManager alloc] init];
    });

    return dataBaseManageObj;
}

- (instancetype)init {
    if (self = [super init]) {
        [self loadDataBase];
    }
    return self;
}


- (void)loadDataBase {
    NSString *dbPath = [self dbPath];
    
    //连接数据库
    self.db = [FMDatabase databaseWithPath:dbPath];
    [self.db setLogsErrors:YES];
    [self.db open];
    self.dbQueue =   [FMDatabaseQueue databaseQueueWithPath:dbPath];
}


- (NSString *)dbPath {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    //设备中数据库文件地址
    NSString *realPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.db", MTDBName]];
    
    NSString *realDBDir = [realPath stringByDeletingLastPathComponent];
    
    //设备不存在数据库目录进行创建
    if (![fileManager fileExistsAtPath:realDBDir])
    {
        [fileManager createDirectoryAtPath:realDBDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //设备内没有找到DataBase
    if (![fileManager fileExistsAtPath:realPath])
    {
        //App内的DataBase文件目录
        NSString *srcPath = [[NSBundle mainBundle] pathForResource:MTDBName ofType:@"db"];
        if (srcPath == nil) {
            NSLog(@"应用程序内没找到数据库：%@.db", MTDBName);
            return  nil;
        }
        
        NSError * error;
        if (![fileManager copyItemAtPath:srcPath toPath:realPath error:&error])
        {
            NSLog(@"Login basedata.s3db open error:%@", error.localizedDescription);
            return nil;
        }
    }
    
    NSLog(@"数据库地址dbPath:%@", realPath);
    return realPath;
}

- (BOOL)executeUpdateWithArray:(NSArray *)sqlArray isTransaction:(BOOL)isTransaction {
    __block BOOL result = NO;
    [self.dbQueue inTransaction:^(FMDatabase *adb, BOOL *rollback) {
        for (NSString *string in sqlArray) {
            result = [adb executeUpdate:string];
        }
        
        if (!result && isTransaction) {
            *rollback = YES;
            return;
        }
    }];
    
    return result;
}

- (BOOL)executeUpdateWithString:(NSString*)sqlNSString {
    __block BOOL result = NO;
    [self.dbQueue inDatabase:^(FMDatabase *adb) {
        result = [adb executeUpdate:sqlNSString];
    }];
    
    return result;
}

- (NSArray<NSDictionary<NSString *,NSString *> *> *)executeSelectWithSql:(NSString *)sqlString {
    NSMutableArray *resultList = [NSMutableArray array];
    [self.dbQueue inTransaction:^(FMDatabase *adb, BOOL *rollback) {
        FMResultSet *resultSet = [adb executeQuery:sqlString];
        NSArray *columnArray = [self getResultColumNameList:resultSet];
        NSString *columnName = nil;
        while ([resultSet next]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (int i = 0;i < columnArray.count;i++)
            {
                columnName = [columnArray objectAtIndex:i];
                NSString *columnValue = [resultSet stringForColumn:columnName];
                if (columnValue != nil) {
                    [dict setObject:columnValue forKey:columnName];
                }
            }
            [resultList addObject:dict];
        }
    }];
    
    return resultList;
}


/**
 *  获取结果集列名称
 */
- (NSArray *)getResultColumNameList:(FMResultSet *)resultSet {
    NSInteger columnCount = resultSet.columnCount;
    NSMutableArray *columnArray = [NSMutableArray arrayWithCapacity:columnCount];
    
    for (int columnIdx = 0; columnIdx < columnCount; columnIdx++) {
        NSString *columnName = [resultSet columnNameForIndex:columnIdx];
        [columnArray addObject:columnName];
    }
    return columnArray;
}


@end


