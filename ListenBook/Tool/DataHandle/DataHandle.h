//
//  DataHandle.h
//  HomeCooking
//
//  Created by lanou on 15/6/19.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHandle : NSObject
+(NSData*)DataWithURL:(NSURL *)Url;
+(NSData*)DataWithURLStr:(NSString*)UrlStr;
+(NSMutableArray*)ArrayWithData:(NSData*)data;
+(NSDictionary*)DictionaryWithData:(NSData *)data;
+(NSData*)DataWithURLNOHTTPHeader:(NSURL *)url;
//+(NSURL*)UrlWithCode:(NSNumber*)code;
//+(NSURL*)UrlWithStr:(NSString*)str;
//+(NSString*)UrlStrWithStr:(NSString*)str;
@end
