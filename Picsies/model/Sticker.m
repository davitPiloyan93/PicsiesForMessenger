//
//  ShopItem.m
//  Picsies
//
//  Created by DavitPiloyan on 2/19/16.
//  Copyright © 2016 Picsies. All rights reserved.
//

#import "Sticker.h"
#define SHOP_ITEM_BASE_URL @"http://static.picsart.com/shop/package_icon"
#define BASE_URL @"http://static.picsart.com/"

@implementation Sticker

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.type = [[dictionary objectForKey:@"type"] description];
    self.created = [[dictionary objectForKey:@"created"] description];
    self.shop_item_uid = [[[dictionary objectForKey:@"data"] objectForKey:@"shop_item_uid"] description];
    self.shop_item_name = [[[dictionary objectForKey:@"data"] objectForKey:@"name"] description];

    self.shop_item_base_url = [[[dictionary objectForKey:@"data"] objectForKey:@"base_url"] description];
    self.shop_item_name_prefix = [[[dictionary objectForKey:@"data"] objectForKey:@"name_prefix"] description];
    self.shop_item_preview_count = [[[dictionary objectForKey:@"data"] objectForKey:@"preview_count"] intValue];
    self.preview_size = dictionary[@"data"][@"preview_size"];
    self.tags = dictionary[@"tags"];
    
    return self;
}

- (BOOL)hasTag:(NSString *)tag {
    for (NSString *cur in self.tags) {
        if ([cur isEqual:tag]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)shopItemBannerUrl {

    NSString *iconsStr = [self.shop_item_uid stringByAppendingString:@"_icons"];
    return [NSString pathWithComponents:@[BASE_URL,@"shop",@"package_icon",iconsStr,@"banner_"]];
}

- (NSString *)shopItemIconUrl {
    if (self.preview_size.length == 0 || [self.preview_size isEqual:@"small"]) {
        return [NSString stringWithFormat:@"%@/%@_icons/%@_", SHOP_ITEM_BASE_URL, self.shop_item_uid, self.shop_item_name_prefix]; // + position.png
    }
    return [NSString stringWithFormat:@"%@_%@/%@_icons/%@_", SHOP_ITEM_BASE_URL, self.preview_size.lowercaseString, self.shop_item_uid, self.shop_item_name_prefix]; // + position.png
}

@end
