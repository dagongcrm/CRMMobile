//
//  EntityHelper.h
//  使用前提条件是：字典的Key和实体对象属性的单词是一样的，大小可以忽略。
//
//  Created by lgj.
//  Copyright (c) 2013年 RL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntityHelper : NSObject


//字典对象转为实体对象
+ (void) dictionaryToEntity:(NSDictionary *)dict entity:(NSObject*)entity;

//实体对象转为字典对象
+ (NSDictionary *) entityToDictionary:(id)entity;

@end