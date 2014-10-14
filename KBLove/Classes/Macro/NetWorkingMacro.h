//
//  NetWorkingMacro.h
//  KBLove
//
//  Created by block on 14-10-13.
//  Copyright (c) 2014年 block. All rights reserved.
//

#ifndef KBLove_NetWorkingMacro_h
#define KBLove_NetWorkingMacro_h

#define  SERVER_URL @"http://118.194.192.104:8080"

#define SYSTEM_COLOR [UIColor colorWithRed:16/255.0 green:127/255.0 blue:136/255.0 alpha:1]
// wap服务器地址前缀
#define SERVER_URL @"http://118.194.192.104:8080"
//注册
#define REGRSTER_URL NSString stringWithFormat:@"%@/api/register.do?type=%d&name=%@&pwd=%@",SERVER_URL
//登陆
#define LOGIN_URL  NSString stringWithFormat:@"%@/api/logon.do?username=%@&pwd=%@&ts=%@&cmd=%d",SERVER_URL
//修改密码
#define ALTER_PASSWORD_URL  NSString stringWithFormat:@"%@/api/update.pwd.do?user_id=%@&password=%@&ts=%@&new_password=%@",SERVER_URL
//修改昵称
#define ALTER_NAME_URL  NSString stringWithFormat:@"%@/api/update.nick.do?user_id=%@&nick=%@",SERVER_URL
//忘记密码
#define FORGET_PASSWORD_URL  NSString stringWithFormat:@"%@api/forget.pwd.do?username=%@&cmd=%d",SERVER_URL
//设置用户模式
#define BACKENT_USER_MODE_URL NSString stringWithFormat:@"%@/api/backend.mode.do?user_id=%@&user_mode=%d",SERVER
//设置用户类型
#define BACKENT_USER_TYPE_URL NSString stringWithFormat:@"%@/api/backend.type.do?user_id=%@&user_type=%d",SERVER



//企业用户获取下属用户目录树
#define GET_USERTREE_URL NSString stringWithFormat:@"%@api/get.usertree.do?user_id=%@&app_name=%@",SERVER
//企业用户编辑下属用户(添加)
#define EDIT_USER_ADD_URL NSString stringWithFormat:@"%@/api/edit.user.do?operate=%@&user_id=%@&username=%@&pwd=%@&parent_id=%@&role=%@&nick=%@&type=%@",SERVER
//企业用户编辑下属用户(修改)
#define EDIT_USER_ALTER_URL NSString stringWithFormat:@"%@/api/edit.user.do?operate=%@&user_id=%@&target_id=%@&pwd=%@&nick=%@&ts=%@&app_name=%@",SERVER
//企业用户设置下级密码
#define SET_PASSWORD_URL NSString stringWithFormat:@"%@/api/set.pwd.do?user_id=%@&target_id=%@&pwd=%@&ts=%@&app_name=%@&target_pwd=%@",SERVER
/*轨迹回放接口*/
/*报警模块接口*/
/*所有警告接口*/

#endif