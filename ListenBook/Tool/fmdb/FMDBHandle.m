//
//  FoodHandle.m
//  HomeCooking
//
//  Created by lanou on 15/6/29.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import "FMDBHandle.h"
#import "FMDB.h"
@implementation FMDBHandle
static FMDatabase *_db;

+ (void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CollectData.sqlite"];
    //NSLog(@"%@",path);
    if (!_db)
        _db = [FMDatabase databaseWithPath:path];
    
    [_db open];
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS collects (id integer PRIMARY KEY, name text NOT NULL, idStr text);"];
}
+ (void)deleteAllDatas
{
    [_db executeUpdate:@"DELETE FROM collects"];
}
+ (void)deleteData:(NSString *)data
{
    [_db executeUpdateWithFormat:@"DELETE FROM collects WHERE name = %@;",data];
}
+ (void)addData:(CollectData *)collect
{
    [_db executeUpdateWithFormat:@"INSERT INTO collects(name,idStr) VALUES (%@,%@);", collect.name,collect.idStr];
}

//图片  UIImageJPEGRepresentation(cuisine.picture, 1.0)
//对象  [NSKeyedArchiver archivedDataWithRootObject:cuisine.makes]

+ (NSArray *)AllDatas;
{// 得到结果集
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM collects;"];
    
    // 不断往下取数据
    NSMutableArray *collects = [NSMutableArray array];
    while (set.next) {
        // 获得当前所指向的数据
        CollectData *collect= [[CollectData alloc]init];
        collect.name = [set stringForColumn:@"name"];
        collect.idStr = [set stringForColumn:@"idStr"];
    
        //NSData *dataM = [set dataForColumn:@"makes"];
        //cuisine.makes = [NSKeyedUnarchiver unarchiveObjectWithData:dataM];
        
        //NSData *dataP = [set dataForColumn:@"picture"];
        //collect.picture = [UIImage imageWithData:dataP];
        [collects addObject:collect];
    }
    return collects;
}

+ (BOOL)isHaveData:(NSString *)name
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM collects WHERE name = %@;",name];
    while (set.next)
        return YES;
    
    return NO;
}
+ (CollectData*)collectData:(NSString *)name
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM collects WHERE name = %@;",name];
    
    while (set.next){
        CollectData *collect= [[CollectData alloc]init];
        collect.name = [set stringForColumn:@"name"];
        collect.idStr = [set stringForColumn:@"idStr"];
        
        //NSData *dataP = [set dataForColumn:@"picture"];
        //collect.picture = [UIImage imageWithData:dataP];
        return collect;
    }
    return nil;
}
@end
