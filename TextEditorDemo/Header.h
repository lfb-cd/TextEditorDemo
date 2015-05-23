//
//  Header.h
//  MyTest
//
//  Created by lifubing on 15/5/21.
//  Copyright (c) 2015年 lifubing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Header : NSManagedObject
@property (nonatomic,retain) NSAttributedString *attributedText;//使得数据库可以直接存储NSAttributedString格式数据

@end