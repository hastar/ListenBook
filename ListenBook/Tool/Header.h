//
//  Header.h
//  ListenBook
//
//  Created by lanou on 15/7/15.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#ifndef ListenBook_Header_h
#define ListenBook_Header_h

#define SW [[UIScreen mainScreen] bounds].size.width
#define SH [[UIScreen mainScreen] bounds].size.height
#define AppKey @"55b63cf8e0f55a08760035b7"
/*************************************** 接口总结 *****************************************/
//书的目录的总序（只需改变最后的type=1,拼接）
#define AllBooks @"http://api.mting.info/yyting/bookclient/ClientTypeResource.action?pageNum=0&pageSize=500&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=528&imei=ODY0NTg3MDI4MjYxNjY4"//&type=1"
//书的目录 （sort=2 推荐 sort=2 最新 sort=0 热门 只需改变最后的type=1,拼接）
#define BaseBooks @"http://api.mting.info/yyting/bookclient/ClientGetBookList.action?pageNum=1&pageSize=10&isSon=1&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1414&imei=ODY0NTg3MDI4MjYxNjY4&sort=2&type=3"
//书的简介（只需要知道最后面的id=3782，拼接）
#define BookInfo @"http://api.mting.info/yyting/bookclient/ClientGetBookDetail.action?token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1626&imei=ODY0NTg3MDI4MjYxNjY4&id=3782"
//具体书的列表（只需要知道最后面的bookId=3890，拼接）
#define BaseBook @"http://117.25.143.74/yyting/bookclient/ClientGetBookResource.action?pageNum=1&pageSize=50&sortType=0&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1448&imei=ODY0NTg3MDI4MjYxNjY4&bookId=3890"
//搜索书的列表（只需要知道最后面的keyWord=%E7%9B%98%E9%BE%99，拼接）
#define SearchBook @"http://api.mting.info/yyting/bookclient/BookSearch.action?keyWord=%E7%9B%98%E9%BE%99&pageNum=1&pageSize=25&type=0&token=J0xvhH9l1WfWwhUQagwAxVmP2UlvqlY6-zdukwv7lbY*&q=924&imei=ODY0NTg3MDI4MjYxNjY4"
/***************************************************************************************/

/*********************************  12个基础目录借口 *************************************/
//基本Url
#define BaseUrl @"http://api.mting.info/yyting/snsresource/getRecommendAblumns.action?token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&imei=ODY0NTg3MDI4MjYxNjY4"
//电台顶部
#define dttop @"http://api.mting.info/yyting/snsresource/getRecommendAblumns.action?opType=H&referId=0&size=6&type=1&needFlag=0&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1411&imei=ODY0NTg3MDI4MjYxNjY4"
//电台目录
#define dt @"http://api.mting.info/yyting/snsresource/getRecommendAblumns.action?opType=H&referId=0&size=10&type=2&needFlag=1&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1412&imei=ODY0NTg3MDI4MjYxNjY4"


//有声小说
#define ysxs @"http://api.mting.info/yyting/bookclient/ClientGetBookList.action?type=1&sort=2&pageNum=1&pageSize=10&isSon=1&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1414&imei=ODY0NTg3MDI4MjYxNjY4"
//有声小说顶部
#define ysxstop @"http://api.mting.info/yyting/bookclient/ClientTypeResource.action?pageNum=0&pageSize=500&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=528&imei=ODY0NTg3MDI4MjYxNjY4&type=1"
//相声评书顶部
#define xspstop @"@http://api.mting.info/yyting/bookclient/ClientTypeResource.action?type=3&pageNum=0&pageSize=500&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1413&imei=ODY0NTg3MDI4MjYxNjY4"
//相声评书
#define xsps @"http://api.mting.info/yyting/bookclient/ClientGetBookList.action?type=3&sort=2&pageNum=1&pageSize=10&isSon=1&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1414&imei=ODY0NTg3MDI4MjYxNjY4"
//曲艺戏曲顶部
#define qyxqtop @"http://api.mting.info/yyting/bookclient/ClientTypeResource.action?type=4&pageNum=0&pageSize=500&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1415&imei=ODY0NTg3MDI4MjYxNjY4"
//曲艺戏曲
#define qyxq @"http://api.mting.info/yyting/bookclient/ClientGetBookList.action?type=4&sort=2&pageNum=1&pageSize=10&isSon=1&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1416&imei=ODY0NTg3MDI4MjYxNjY4"
//文学名著顶部
#define wxmztop @"http://api.mting.info/yyting/bookclient/ClientTypeResource.action?type=78&pageNum=0&pageSize=500&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1415&imei=ODY0NTg3MDI4MjYxNjY4"
//文学名著
#define wxmz @"http://api.mting.info/yyting/bookclient/ClientGetBookList.action?type=78&sort=2&pageNum=1&pageSize=10&isSon=1&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1416&imei=ODY0NTg3MDI4MjYxNjY4"
//少儿天地顶部
#define setdtop @"http://api.mting.info/yyting/bookclient/ClientTypeResource.action?type=6&pageNum=0&pageSize=500&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1415&imei=ODY0NTg3MDI4MjYxNjY4"
//少儿天地
#define setd @"http://api.mting.info/yyting/bookclient/ClientGetBookList.action?type=6&sort=2&pageNum=1&pageSize=10&isSon=1&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1416&imei=ODY0NTg3MDI4MjYxNjY4"
//外语学习顶部
#define wyxxtop @"http://api.mting.info/yyting/bookclient/ClientTypeResource.action?type=7&pageNum=0&pageSize=500&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1417&imei=ODY0NTg3MDI4MjYxNjY4"
//外语学习
#define wyxx @"http://api.mting.info/yyting/bookclient/ClientGetBookList.action?type=7&sort=2&pageNum=1&pageSize=10&isSon=1&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1418&imei=ODY0NTg3MDI4MjYxNjY4"
//综艺娱乐顶部
#define zyyltop @"http://api.mting.info/yyting/bookclient/ClientTypeResource.action?type=54&pageNum=0&pageSize=500&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1417&imei=ODY0NTg3MDI4MjYxNjY4"
//综艺娱乐
#define zyyl @"http://api.mting.info/yyting/bookclient/ClientGetBookList.action?type=54&sort=2&pageNum=1&pageSize=10&isSon=1&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1418&imei=ODY0NTg3MDI4MjYxNjY4"
//人文社科顶部
#define rwsktop @"http://api.mting.info/yyting/bookclient/ClientTypeResource.action?type=80&pageNum=0&pageSize=500&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1417&imei=ODY0NTg3MDI4MjYxNjY4"
//人文社科
#define rwsk @"http://api.mting.info/yyting/bookclient/ClientGetBookList.action?type=80&sort=2&pageNum=1&pageSize=10&isSon=1&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1418&imei=ODY0NTg3MDI4MjYxNjY4"
//时事热点顶部
#define ssrdtop @"http://api.mting.info/yyting/bookclient/ClientTypeResource.action?type=1015&pageNum=0&pageSize=500&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1417&imei=ODY0NTg3MDI4MjYxNjY4"
//时事热点
#define ssrd @"http://api.mting.info/yyting/bookclient/ClientGetBookList.action?type=1015&sort=2&pageNum=1&pageSize=10&isSon=1&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1418&imei=ODY0NTg3MDI4MjYxNjY4"
//商业财经顶部
#define sycjtop @"http://api.mting.info/yyting/bookclient/ClientTypeResource.action?type=3085&pageNum=0&pageSize=500&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1419&imei=ODY0NTg3MDI4MjYxNjY4"
//商业财经
#define sycj @"http://api.mting.info/yyting/bookclient/ClientGetBookList.action?type=3086&sort=2&pageNum=1&pageSize=10&isSon=1&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1420&imei=ODY0NTg3MDI4MjYxNjY4"
//健康养生顶部
#define jkystop @"http://api.mting.info/yyting/bookclient/ClientTypeResource.action?type=3086&pageNum=0&pageSize=500&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1419&imei=ODY0NTg3MDI4MjYxNjY4"
//健康养生
#define jkys @"http://api.mting.info/yyting/bookclient/ClientGetBookList.action?type=3085&sort=2&pageNum=1&pageSize=10&isSon=1&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1420&imei=ODY0NTg3MDI4MjYxNjY4"
//时尚生活顶部
#define ssshtop @"http://api.mting.info/yyting/bookclient/ClientTypeResource.action?type=1019&pageNum=0&pageSize=500&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1422&imei=ODY0NTg3MDI4MjYxNjY4"
//时尚生活
#define sssh @"http://api.mting.info/yyting/bookclient/ClientGetBookList.action?type=1019&sort=2&pageNum=1&pageSize=10&isSon=1&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1423&imei=ODY0NTg3MDI4MjYxNjY4"
//职业技能顶部
#define zyjntop @"http://api.mting.info/yyting/bookclient/ClientTypeResource.action?type=79&pageNum=0&pageSize=500&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1425&imei=ODY0NTg3MDI4MjYxNjY4"
//职业技能
#define zyjn @"http://api.mting.info/yyting/bookclient/ClientGetBookList.action?type=79&sort=2&pageNum=1&pageSize=10&isSon=1&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1426&imei=ODY0NTg3MDI4MjYxNjY4"
//静雅思听顶部
#define jysttop @"http://api.mting.info/yyting/bookclient/ClientTypeResource.action?type=104&pageNum=0&pageSize=500&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1427&imei=ODY0NTg3MDI4MjYxNjY4"
//静雅思听
#define jyst @"http://api.mting.info/yyting/bookclient/ClientGetBookList.action?type=104&sort=2&pageNum=1&pageSize=10&isSon=1&token=J0xvhH9l1WfWwhUQagwAxQ_fIQkwx2Cb-zdukwv7lbY*&q=1428&imei=ODY0NTg3MDI4MjYxNjY4"
/*********************************  6 topId *************************************/
#define MSid @"5728";
#define HMid @"6222";
#define HHid @"27662";
#define JDid @"1370";
#define QGid @"7399";
#define TSid @"161";
#endif
