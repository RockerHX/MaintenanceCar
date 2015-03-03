//
//  SCDictionaryItem.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/25.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCDictionaryItem.h"

@implementation SCDictionaryItem

- (id)initWithItemName:(NSString *)itemName
                dictID:(NSString *)dictID
                  type:(NSString *)type
                 index:(NSString *)index;
{
    self = [super init];
    if (self) {
        _name    = itemName;
        _dict_id = dictID;
        _type    = type;
        _index   = index;
    }
    return self;
}

@end
