//
//  BarberModel.h
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/9.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "ZBaseModel.h"

@interface BarberModel : ZBaseModel

@property (strong, nonatomic) NSString *barberId;   //发型师id
@property (strong, nonatomic) NSString *nickName;   //发型师昵称
@property (strong, nonatomic) NSString *name;       //发型师真实姓名
@property (strong, nonatomic) NSString *gender;     //性别:1-男;2-女
@property (strong, nonatomic) NSString *orderNum;   //订单数目
@property (strong, nonatomic) NSString *fansNum;    //关注数
@property (strong, nonatomic) NSString *imgPath;    //头像路径
@property (strong, nonatomic) NSString *motto;      //个性答名
@property (strong, nonatomic) NSString *profile;    //个人简介

//下一期
@property (strong, nonatomic) NSString *award;       //获奖
@property (strong, nonatomic) NSString *creditNum;  // 信用值
@end
