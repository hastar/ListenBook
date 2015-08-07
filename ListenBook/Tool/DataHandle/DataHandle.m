//
//  DataHandle.m
//  HomeCooking
//
//  Created by lanou on 15/6/19.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import "DataHandle.h"
#import <UIKit/UIKit.h>
@implementation DataHandle
/**
 *  用于请求各个菜单目录二进制信息
 *  @param UrlStr 各个不同的菜单字符串 如：鱼类菜单：FishURl（在URLHeader.h中查找）
 *  @return NSData (得到data后，需要通过JSON解析得到需要的NSArray或者NSDictionary)
 */

+(NSData*)DataWithURLStr:(NSString*)UrlStr
{
    NSURL *url = [NSURL URLWithString:UrlStr];
    NSData *data = nil;
    data = [self DataWithURL:url];
    return data;
}
/**
 *  1，用于请求各个菜单目录中各个不同菜的二进制信息
 *  2，DataWithURLStr函数中也会用到
 *  @param url
 *  @return NSData (得到data后，需要通过JSON解析得到需要的NSArray或者NSDictionary)
 */

+(NSData*)DataWithURL:(NSURL *)url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setValue:@"Android4.3/yyting/ONEPLUS/A0001/ch_oppo_nearme/109/Android Paros/3.2.13" forHTTPHeaderField:@"User-Agent"];
   
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (!error) {
        return data;
    }
    return nil;
}
+(NSData*)DataWithURLNOHTTPHeader:(NSURL *)url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

/**
 *  请求到的各个菜单目录通过JSON解析后，是一个字典，字典中有一个菜单信息数组
 *  @param data 通过网络请求得到的二进制数据
 *  @return 需要的数组
 */

+(NSMutableArray*)ArrayWithData:(NSData*)data
{
    NSDictionary *dic = [self DictionaryWithData:data];
    NSMutableArray *array = [dic objectForKey:@"data"];
    return array;
}

/**
 *  1，请求到的各个菜单目录中各个不同菜的信息，通过JSON解析后，是一个字典
 *  2，ArrayWithData函数中会用到
 *  @param data 通过网络请求得到的二进制数据
 *  @return 需要的字典
 */

+(NSDictionary*)DictionaryWithData:(NSData *)data
{
    if (data == nil){
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败，网路链接异常" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        return nil;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return dic;
}

/**
 *  URL的拼接，将从菜单目标数组中，得到的各个菜的信息中的code值，拼接在固定的DetialURL上，得到完整的URL
 *  @param code 各个菜的信息中的code(菜本身是一个字典，@"code"是一个Key,这里的code,是指@"code"对应的字典中的值)
 *  @return url，用于请求菜的详细信息，菜的详细信息是一个字典
 */

//+(NSURL*)UrlWithCode:(NSNumber*)code
//{
//    NSString *CodeStr = [code stringValue];
//    NSString *urlStr = [DetialURL stringByAppendingString:CodeStr];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    return url;
//}
/**
 *  Url S=？部分的拼接
 *  @param str 要拼接的
 *  @return 完整的URL
 */
//+(NSURL*)UrlWithStr:(NSString*)str
//{
//    NSString *UrlStr = [self UrlStrWithStr:str];
//    return [NSURL URLWithString:UrlStr];
//}
//+(NSString*)UrlStrWithStr:(NSString*)str
//{
//    NSString *UrlStr =  [MeatURL stringByReplacingOccurrencesOfString:@"%25E8%2582%2589%25E7%25B1%25BB" withString:str];
//    return UrlStr;
//}
@end
