//
// Created by Hovhannes Safaryan on 5/28/14.
// Copyright (c) 2014 Socialin Inc. All rights reserved.
//

#import "NSArray+SCAdditions.h"


@implementation NSArray (SCAdditions)

- (instancetype)arrayByRemovingObject:(id)object {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != %@", object]];
}

- (instancetype)arrayByRemovingObjectsFromArray:(NSArray *)array {
    return [array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id item, NSDictionary *bindings) {
        for (id compItem in array) {
            if([compItem isEqual:item]){
                return NO;
            }
        }
        return YES;
    }]];
}

- (NSArray *)mapObjectsWithBlock:(id (^)(id obj, NSUInteger idx))block {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id mappedObj = block(obj, idx);
        if (mappedObj) {
            [result addObject:mappedObj];
        }
    }];
    return result;
}

-(NSString *)sc_toJSONString {
    return [self sc_toJSONStringPrittyPrinted:YES];
}

-(NSString *)sc_toJSONStringPrittyPrinted:(BOOL)prittedPrinted {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization  dataWithJSONObject:self options:prittedPrinted ? NSJSONWritingPrettyPrinted : 0 error:&error];
    if (error) {
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end