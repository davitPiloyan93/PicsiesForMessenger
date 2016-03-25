//
//  StickerManager.m
//  Picsies
//
//  Created by DavitPiloyan on 2/19/16.
//  Copyright © 2016 Picsies. All rights reserved.
//

#import "StickersClient.h"
#import "Sticker.h"

@implementation StickersClient

- (void)stickersWithComplitionBlock:(void (^)(NSArray * items))complitionBlock {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"picsies" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *itemsInfoFromJson = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                      options:0
                                                                        error:nil];

    for (NSDictionary *item in itemsInfoFromJson) {
        Sticker *sticker = [[Sticker alloc] initWithDictionary:item];
        [items addObject:sticker];
    }
    complitionBlock(items);
    
}

@end
