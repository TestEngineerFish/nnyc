//
//  YXAPI.h
//  YXEDU
//
//  Created by sunwu on 2019/9/10.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "YXEvnOC.h"

typedef void (^progressBlock)(NSProgress *progress);
typedef void (^finishBlock) (id obj, BOOL result);

typedef void (^ActionFinishBlock)(void);

#define STRCAT(A,B) [NSString stringWithFormat:@"%@%@",A,B]

#define RELEASE(V) {\
if (V) {\
[V removeFromSuperview];\
V = nil;\
}\
}




//#define HTTPS 0
//
//#define ENV 1 // 1:测试环境 2:开发环境 0:生产环境
//
//#if HTTPS
//#define SCHEME @"https://"
//#else
//#define SCHEME @"http://"
//#endif



//#if ENV == 1
//#define YX_IP @"test-app.xstudyedu.com"   // 122.152.217.186
//#elif ENV == 2
//#define YX_IP @"10.160.5.31:10011"
//#else
//#define YX_IP @"app.xstudyedu.com"
//#endif


#define SCHEME @""
#define YX_IP [YXEvnOC baseUrl]



#define YX_DOMAIN STRCAT(YX_IP, @"/v1")
#define YX_DOMAIN_V2 STRCAT(YX_IP, @"/v2")

/*
 * api: user/logout 退出登录
 */
#define DOMAIN_LOGOUT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/logout"))

/*
 * 本接口用于上报数据, 登录后可调用, 需包含公共参数
 * api/statistics
 */
#define DOMAIN_STATISTICS STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/api/statistics"))

/* 版本：v1.1
 * 获取词书配置
 */
#define DOMAIN_GETCONFIG3 STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/api/getconfig3"))

/*
 * 获取词书配置
 */
#define DOMAIN_GETCONFIG STRCAT(SCHEME,STRCAT(YX_DOMAIN_V2,@"/api/getconfig")) // ⭐️

///v2/book/setlearning

/*
 * 词书的基本信息获取
 */
#define DOMAIN_BOOKINFO STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/book/bookinfo"))

/*
 * 获取用户信息user/getinfo
 */
#define DOMAIN_GETUSERINFO STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/getinfo"))

/*
 * api: /v2/user/getinfo
 * method: get
 * version : 1.3版本
 * 备注：对比1.2版本 v1/user/getinfo 接口
 */
#define DOMAIN_GETINFO STRCAT(SCHEME,STRCAT(YX_DOMAIN_V2,@"/user/getinfo")) // ⭐️


/*
 * 获取用户信息user/sendsms
 */
#define DOMAIN_SENDSMS STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/api/sendsms")) // ⭐️

/* 版本：v1.1
 * 图形验证码接口/api/captcha
 */
#define DOMAIN_CAPTCHA STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/api/captcha")) // ⭐️

/*
 * 获取用户信息绑定手机号
 */
#define DOMAIN_BINDMOBILE STRCAT(YX_IP,@"/api/v1/user/bindmobile") // ⭐️

/*
 * 设定要学习的图书 book/setlearning
 */
#define DOMAIN_SETLEARNING STRCAT(SCHEME,STRCAT(YX_DOMAIN_V2,@"/book/setlearning"))


/*
 * 获取正在学习的图书 book/getlearning
 */
#define DOMAIN_GETLEARNING STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/book/getlearning"))

/*
 * 添加一本词书到书架中 book/addbook/
 */
#define DOMAIN_ADDBOOK STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/book/addbook"))

/*
 * 删除一本词书 book/delbook/ method: post
 */
#define DOMAIN_DELBOOK STRCAT(SCHEME,STRCAT(YX_DOMAIN_V2,@"/book/delbook"))

/*
 * 重置一本词书 book/delbook/ method: post
 */
#define DOMAIN_RESETBOOK STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/book/resetbookprogress"))

/*
 * 获取书籍列表 book/getbook/ method: post
 */
#define DOMAIN_GETBOOKLIST STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/book/getbooklist"))

/*
 * 获取单元题目 learning/getsubject ::method: get
 */
#define DOMAIN_BOOKUNIT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/bookunit"))

/*
 * 设定单词已选 learning/study ::method: post
 */
#define DOMAIN_STUDY STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/study"))

#define DOMAIN_AGREEMENT STRCAT(STRCAT(SCHEME,YX_IP),@"/agreement.html") // ⭐️ //STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/agreement.html"))

/*
 * v1.1
 * 批量学习上报 /api/feedback ::method: post
 */
#define DOMAIN_FEEDBACK STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/api/feedback")) // ⭐️

/*
 * v1.1
 * 用户反馈 learning/batch ::method: post
 */
#define DOMAIN_BATCH STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/batch"))

/*
 * v1.1
 * 检查版本更新 api/chkver ::method: Get
 */
#define DOMAIN_CHKVER STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/api/chkver")) // ⭐️

/*
 * v1.1
 * 绑定社交网络 user/bind ::method: POST
 */
#define DOMAIN_BINDSO STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/bind")) // ⭐️

/*
 * v1.1
 * 解绑定社交网络 user/unbind ::method: POST
 */
#define DOMAIN_UNBINDSO STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/unbind")) // ⭐️

/*
 * v1.3
 * 设置词书的学习计划
 * api: v1/book/setplan
 * method: post
 * version: 1.3版本
 */
#define DOMAIN_STUDYPLAN STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/book/setplan"))

/*
 * v1.3
 * 首页进入时的用户基础学习数据的获取
 * api: /v1/learning/indexinfo
 * method: get
 * version: 1.3版本
 */
#define DOMAIN_INDEXINFO STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/indexinfo"))


/*
 * v1.3
 * 获取10道题
 * api: /v1/learning/question
 * method: get
 * version: 1.3版本
 */
#define DOMAIN_QUESTION STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/question"))

/*
 * v1.3
 * 学习答题上报
 * api: /v1/learning/studyreport
 * method: get
 * version: 1.3版本
 */
#define DOMAIN_STUDYREPORT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/studyreport"))


/*
 * v1.3
 * 待复习单词资源数据获取
 * api: /v1/learning/reviewdata
 * method: get
 * version: 1.3版本
 */
#define DOMAIN_REVIEWDATA STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/reviewdata"))

/*
 * v1.3
 * 复习单词的上报
 * api: /v1/learning/reviewreport
 * method: get
 * version: 1.3版本
 */
#define DOMAIN_REVIEWREPORT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/reviewreport"))

/*
 * v1.3
 * 今日待学习单词的获取
 * api: /v1/learning/question
 * method: get
 * version: 1.3版本
 */
#define DOMAIN_STUDYDATA STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/studydata"))

/*
 * v1.3
 * 口语题的判断评分
 * api: /v1/learning/speaking
 * method: get
 * version: 1.3版本
 */
#define DOMAIN_SPEAKING STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/speaking"))

/* 跳过口语 */
#define DOMAIN_CANCLESPEAKING STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/cancelspeak"))

/*
 * v1.3
 * 学习结束后的列表数据
 * api: /v1/learning/result
 * method: get
 * version: 1.3版本
 */
#define DOMAIN_RESULT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/result"))

/*
 * v1.3
 * 首页点击再来一组
 * api: /v1/learning/onegroup
 * method: get
 * version: 1.3版本
 * 备注：直接进入学习流程
 */
#define DOMAIN_ONEGROUP STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/onegroup"))


/*
 * v1.3
 * 获取分享数据
 * api: /v1/learning/getsharedata
 * method: get
 * version: 1.3版本
 */
#define DOMAIN_GETSHAREDATA STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/getsharedata"))


/*
 * v1.3
 * 收藏单词 & 取消收藏
 * api: /v1/learning/favorite
 * method: get
 * version: 1.3版本
 */
#define DOMAIN_FAVORITE STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/favorite"))

#define DOMAIN_WORDFAVORITE STRCAT(SCHEME,STRCAT(YX_DOMAIN_V2,@"/book/favorite")) // ⭐️

/*
 * v1.3
 * 获得已学单词列表
 * api: /v1/learning/notelearned
 * method: get
 * version: 1.3版本
 * 备注：参考1.2版本 v1/learning/notelearned
 */
#define DOMAIN_NOTELEARNED STRCAT(SCHEME,STRCAT(YX_DOMAIN_V2,@"/learning/notelearned"))


/*
 * v1.3
 * 获取收藏夹单词列表
 * api: /v1/learning/notefav
 * method: get
 * version: 1.3版本
 */
#define DOMAIN_NOTEFAV STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/notefav"))

/*
 * v1.3
 * 获取错词本单词列表
 * api: /v1/learning/notewrong
 * method: get
 * version: 1.3版本
 */
#define DOMAIN_NOTEWRONG STRCAT(SCHEME,STRCAT(YX_DOMAIN_V2,@"/learning/notewrong"))


#define DOMAIN_MYBOOKS STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/book/indexinfo"))


#define DOMAIN_LEARNBOOKS STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/notebooklist"))


#define DOMAIN_BOOKLISTWORDS STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/notewordlist"))

#define DOMAIN_WORDFAVSTATE STRCAT(SCHEME,STRCAT(YX_DOMAIN_V2,@"/api/word/favinfo"))

/* 错词本抽查复习题目生成 */
#define DOMAIN_SPOTCHECK STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wrong/spotcheck"))

/* 抽查复习题上报 */
#define DOMAIN_SPOTCHECKREPORT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wrong/spotcheck/report"))

/* 错词本抽查复习结果页 */
#define DOMAIN_SPOTCHECKRESULT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wrong/spotcheck/result"))



/** V1.4.0
 *  词书列表
 */
#define DOMAIN_BOOKLIST STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/book/booklist"))

#define DOMAIN_LEARNREPORT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/learnreport"))

#define DOMAIN_DETAILLEARNREPORT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/detailedlearnreport")) // ⭐️


/** 1.4.0语音上报接口 */
#define DOMAIN_ASYNCSPEAKING STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/asyncspeaking"))


#define DIMAIN_CHECKSPEECHX STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/checkspeechx"))



#pragma mark --- V2.0 -----
/** 发现页聚合接口 */
#define DIMAIN_DESCOVERINDEX STRCAT(SCHEME,STRCAT(YX_DOMAIN_V2,@"/game/index")) // ⭐️

/** 上一期排行榜接口 */
#define DIMAIN_PREVIOUSRANKING STRCAT(SCHEME,STRCAT(YX_DOMAIN_V2,@"/game/preranking")) // ⭐️

/** 用户的签到信息接口 */
#define DOMAIN_SIGNININFO STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/signininfo")) // ⭐️

/** 手动触发签到操作 */
#define DOMAIN_SIGNIN STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/signin")) // ⭐️

/** 获取积分是否充足接口 */
#define DIMAIN_GAMEAVAIABLE STRCAT(SCHEME,STRCAT(YX_DOMAIN_V2,@"/game/credits")) // ⭐️

/** 游戏开始接口 */
#define DIMAIN_GAMESTART STRCAT(SCHEME,STRCAT(YX_DOMAIN_V2,@"/game/start")) // ⭐️

/** 游戏结束接口，上报数据 */
#define DIMAIN_GAMEREPORT STRCAT(SCHEME,STRCAT(YX_DOMAIN_V2,@"/game/reviewreport")) // ⭐️

/** 获取游戏结果接口 */
#define DIMAIN_GAMERESULT STRCAT(SCHEME,STRCAT(YX_DOMAIN_V2,@"/game/result")) // ⭐️

/** 用户领取任务积分 */
#define DOMAIN_GETNEWTASK STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/receivetaskreward")) // ⭐️

/** 查询用户当前积分的接口 */
#define DOMAIN_CREDITS STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/credits")) // ⭐️

/** 特殊数据上报接口 */
#define DOMAIN_SEEDSREPORT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/api/seedsreport"))


#pragma mark --- V2.1.1 -----
/** 我的词单首页接口 */
#define DOMAIN_MYWORDLIST STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/mywordlist")) // ⭐️

/** 批量删除用户词单 */
#define DOMAIN_DELETEMYWORDLIST STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/deletewordlist")) // ⭐️

/** 词单详情接口 */
#define DOMAIN_WORDLISTDETAILS STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/details"))

/** 获取词单单词列表数据 */
#define DOMAIN_WORDLISTBOOKWORDS STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/bookwords")) // ⭐️


/** 根据词书ID获取本词书下哪些单词已经被选为词单 */
#define DOMAIN_WORDLISTGETUSEDWORD STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/getusedword"))

/** 创建词单接口 */
#define DOMAIN_CREATEWORDLIST STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/createwordlist"))

/** 获取用户词单的基础信息 */
#define DOMAIN_WORDLISTBASEINFO STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/baseinfo")) // ⭐️

// >>>>词单学习相关
/** 刷新学习流程，重新学习 */
#define DOMAIN_WORDLISTREFRESHPROGRESS STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/refreshprogress")) // ⭐️

/** 获取听写10道题 */
#define DOMAIN_WORDLISTSTARTLISTEN STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/startlisten"))

/** 听写学习的上报 */
#define DOMAIN_WORDLISTLISTENREPORT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/listenreport"))

/** 听写结果页接口 */
#define DOMAIN_WORDLISTLISTENRESULT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/listenresult"))

/** 获取学习流程10道题 */
#define DOMAIN_WORDLISTSTARTLEARN STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/startlearn"))

/** 学习流程题目上报 */
#define DOMAIN_WORDLISTLEARNREPORT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/learnreport"))

/** 学习结果页接口 */
#define DOMAIN_WORDLISTLEARNRESULT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/learnresult"))

/** 学习流程中跳过口语题 */
#define DOMAIN_WORDLISTSKIPSPEAK STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/skipspeak"))

/** 学习流程中口语题的上报 */
#define DOMAIN_WORDLISTSPEAKREPORT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/speakreport"))

/** 学习流程中口语题的分值获取 */
#define DOMAIN_WORDLISTSPEAKRESULT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/speakresult"))

/** 词单学习报告页 */
#define DOMAIN_WORDLISTREPORTPAGE STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/reportpage"))

/** 修改词单名称 */
#define DOMAIN_UPDATEWORDLIST STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/updatewordlist"))

/** 根据词单分享码获得对应的词单详情 */
#define DOMAIN_SHARECODEWORDLIST STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/simplifieddetails")) // ⭐️

/** 保存到我的词单接口 */
#define DOMAIN_SAVEWORDLIST STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/wordlist/savewordlist"))

/** 词书列表 */
#define DOMAIN_NOTEBOOKLIST STRCAT(SCHEME,STRCAT(YX_DOMAIN_V2,@"/learning/notebooklist")) // ⭐️

/** 词书单词列表 */
#define DOMAIN_NOTELISTWORDS STRCAT(SCHEME,STRCAT(YX_DOMAIN_V2,@"/learning/notewordlist")) // ⭐️

/** 分享页配置接口 */
#define DOMAIN_CONFIGSHARE STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/config/share"))

/** 分享页积分领取接口 */
#define DOMAIN_USERSHARECREDIT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/sharecredit"))

/*
 * api: /v1/user/wordtoolkitinfo
 * method: get
 * version : 2.3.0
 * 备注：获得用户词汇包的基础信息
 */
#define DOMAIN_USERWORDTOOLKITINFO STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/wordtoolkitinfo"))

/*
 * api: /v1/user/handlewordtoolkit
 * method: post
 * version : 2.3.0
 * 备注：用户开通词汇工具包功能
 */
#define DOMAIN_USERWORDHANDLEWORDTOOLKIT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/handlewordtoolkit"))

/** 日历-月汇总数据 */
#define DOMAIN_CALENDARMONTHLYDATA STRCAT(SCHEME,STRCAT(YX_IP,@"/api/v1/daily/getmonthly")) // ⭐️

/** 日历-日汇总数据 */
#define DOMAIN_CALENDARDAILYDATA STRCAT(SCHEME,STRCAT(YX_IP,@"/api/v1/daily/getdayinfo")) // ⭐️

/** 日历-每月分享图 */
#define DOMAIN_CALENDARSHAREIMAGE STRCAT(SCHEME,STRCAT(YX_DOMAIN_V2,@"/punch/share")) // ⭐️


/*
 * api: /v1/text/choice
 * method: get
 * version : 3.0.0
 * 备注：进入选择课文页
 */

#define DOMAIN_TEXTCHOICE STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/text/choice"))


/*
 * api: /v1/text/textlearnhistory
 * method: get
 * version : 3.0.0
 * 备注：获得用户的课文学习历史列表数据
 */

#define DOMAIN_TEXTLEARNHISTORY STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/text/textlearnhistory"))


/*
 * api: /v1/text/booklearnrank
 * method: get
 * version : 3.0.0
 * 备注：查询用户对一本词书的的学习进度情况
 * bookId 查询的词书Id
 */

#define DOMAIN_TEXTBOOKLEARNRANK STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/text/booklearnrank"))

/*
 * api: /v2/study/sharepicture
 * method: get
 * version : 2.4.0
 * 备注：学习打卡分享背景图
 */

#define DEMAIN_STUDYSHAREPICTURE STRCAT(SCHEME,STRCAT(YX_DOMAIN_V2,@"/study/sharepicture"))
