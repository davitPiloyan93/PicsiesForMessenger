//
//  StickerManager.m
//  Picsies
//
//  Created by DavitPiloyan on 2/19/16.
//  Copyright © 2016 Picsies. All rights reserved.
//

#import "StickersClient.h"
#import "Sticker.h"

#define STICKERS_URL @"http://api.picsart.com/apps.json?app=com.picsart.studio&market=apple&type=apps&offet=0&limit=-1"


@interface StickersClient ()


@end

@implementation StickersClient

+ (StickersClient *)sharedInstance {
    static StickersClient *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[StickersClient alloc] init];
    });
    return __sharedInstance;
}

- (void)stickersWithComplitionBlock:(void (^)(NSArray * items))complitionBlock {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"stickers"]) {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (NSDictionary *item in [[NSUserDefaults standardUserDefaults] objectForKey:@"stickers"]) {
            Sticker *sticker = [[Sticker alloc] initWithDictionary:item];
            if ([sticker.shop_item_name_prefix isEqual:@"i_clipart"]) {
                [items addObject:sticker];
                
            }
        }
        complitionBlock(items);
    } else {
        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:STICKERS_URL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    complitionBlock(nil);
                } else {
                    NSError *jsonError;
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:0 error:&jsonError];
                    if (jsonError) {
                        complitionBlock(nil);
                        return;
                    }
                    
                    NSMutableArray *arrayOfDictinaries = [[NSMutableArray alloc] init];
                    NSMutableArray *items = [[NSMutableArray alloc] init];
                    for (NSDictionary *item in dictionary[@"response"]) {
                        Sticker *sticker = [[Sticker alloc] initWithDictionary:item];
                        if ([sticker hasTag:@"Picsies"] && [sticker.shop_item_name_prefix isEqual:@"i_clipart"]) {
                        
                            [arrayOfDictinaries addObject:item];
                            [items addObject:sticker];
                        }
                    }
                    complitionBlock(items);
                    
                    [[NSUserDefaults standardUserDefaults] setObject:arrayOfDictinaries forKey:@"stickers"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            });
        }] resume];
    }
}


@end
