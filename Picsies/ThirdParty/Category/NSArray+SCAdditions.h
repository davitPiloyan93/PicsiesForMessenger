//
// Created by Hovhannes Safaryan on 5/28/14.
// Copyright (c) 2014 Socialin Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SCAdditions)

- (instancetype)arrayByRemovingObject:(id)object;

- (NSArray *)mapObjectsWithBlock:(id (^)(id obj, NSUInteger idx))block;

- (instancetype)arrayByRemovingObjectsFromArray:(NSArray *)array;

-(nullable NSString *)sc_toJSONString;

-(nullable NSString *)sc_toJSONStringPrittyPrinted:(BOOL)prittedPrinted;

@end