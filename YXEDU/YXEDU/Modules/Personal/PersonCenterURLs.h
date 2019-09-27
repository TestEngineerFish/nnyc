//
//  PersonCenterURLs.h
//  YXEDU
//
//  Created by Jake To on 10/22/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#ifndef PersonCenterURLs_h
#define PersonCenterURLs_h

// 用户基础数据设置
#define DOMAIN_SETUP STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/setup"))
// 头像
#define DOMAIN_SETAVATAR STRCAT(SCHEME,STRCAT(YX_DOMAIN_V2,@"/user/setavatar"))
// 社交绑定
#define DOMAIN_BIND STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/bind"))
// 解除社交绑定
#define DOMAIN_UNBIND STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/unbind"))
// 徽章
#define DOMAIN_BADGES STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/badgesinfo"))
// 分享徽章
#define DOMAIN_BADGESHARE STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/share/badge"))
// 分享打卡
#define DOMAIN_SHARE STRCAT(SCHEME,STRCAT(YX_DOMAIN_V2,@"/user/share"))

// 分享打卡
#define DOMAIN_PUNCH STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/getpunch"))


#endif /* PersonCenterURLs_h */
