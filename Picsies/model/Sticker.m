//
//  ShopItem.m
//  Picsies
//
//  Created by DavitPiloyan on 2/19/16.
//  Copyright © 2016 Picsies. All rights reserved.
//

#import "Sticker.h"
#define SHOP_ITEM_BASE_URL @"http://static.picsart.com/shop/package_icon"


@implementation Sticker

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.type = [[dictionary objectForKey:@"type"] description];
    self.created = [[dictionary objectForKey:@"created"] description];
    self.shop_item_uid = [[[dictionary objectForKey:@"data"] objectForKey:@"shop_item_uid"] description];
    self.shop_item_name = [[[dictionary objectForKey:@"data"] objectForKey:@"name"] description];
    self.shop_item_price = [[[dictionary objectForKey:@"data"] objectForKey:@"price"] description];
    self.shop_item_base_url = [[[dictionary objectForKey:@"data"] objectForKey:@"base_url"] description];
    self.shop_item_description = [[[dictionary objectForKey:@"data"] objectForKey:@"description"] description];
    self.shop_item_props_json = [[[dictionary objectForKey:@"data"] objectForKey:@"props_json"] description];
    self.item_id = [[[dictionary objectForKey:@"data"] objectForKey:@"id"] description];
    self.brand = [[[dictionary objectForKey:@"data"] objectForKey:@"brand"] description];
    self.provider = [[[dictionary objectForKey:@"data"] objectForKey:@"provider"] description];
    self.content = [[[dictionary objectForKey:@"data"] objectForKey:@"content"] description];
    if ([dictionary valueForKey:@"hidden"]) {
        self.hidden = [[dictionary valueForKey:@"hidden"] boolValue];
    } else {
        self.hidden = NO;
    }
    if ([[dictionary objectForKey:@"data"] objectForKey:@"rule"]) {
        self.rule = [[[dictionary objectForKey:@"data"] objectForKey:@"rule"] description];
    }
    
    self.shop_item_name_prefix = [[[dictionary objectForKey:@"data"] objectForKey:@"name_prefix"] description];
    self.shop_item_color = [[[dictionary objectForKey:@"data"] objectForKey:@"color"] description];
    self.shop_item_mini_description = [[[dictionary objectForKey:@"data"] objectForKey:@"mini_description"] description];
    self.shop_item_preview_type = [[[dictionary objectForKey:@"data"] objectForKey:@"preview_type"] description];
    self.shop_item_preview_count = [[[dictionary objectForKey:@"data"] objectForKey:@"preview_count"] intValue];
    self.shop_item_banners_count = [[[dictionary objectForKey:@"data"] objectForKey:@"banners_count"] intValue];
    self.networkProvider = dictionary[@"data"][@"promotion"][@"network"];
    self.preview_size = dictionary[@"data"][@"preview_size"];
    self.tags = dictionary[@"tags"];
    
    if ([dictionary valueForKey:@"is_new"]) {
        self.is_new = [dictionary[@"is_new"] boolValue];
    } else {
        self.hidden = NO;
    }
    return self;
}

- (BOOL)hasTag:(NSString *)tag {
    for (NSString *cur in self.tags) {
        //        NSLog(@"aaaaaaa %@ : %@   ::: %@", cur, tag, @([cur isEqual:tag]));
        if ([cur isEqual:tag]) {
            return YES;
        }
    }
    return NO;
}

- (NSURL *)shopItemPreviewIconUrl {
    return [NSURL URLWithString: [NSString stringWithFormat:@"%@/%@_icons/mini/%@_", SHOP_ITEM_BASE_URL, self.shop_item_uid, self.shop_item_name_prefix]]; // + position.png
}

- (NSString *)shopItemIconUrl {
    if (self.preview_size.length == 0 || [self.preview_size isEqual:@"small"]) {
        return [NSString stringWithFormat:@"%@/%@_icons/%@_", SHOP_ITEM_BASE_URL, self.shop_item_uid, self.shop_item_name_prefix]; // + position.png
    }
    return [NSString stringWithFormat:@"%@_%@/%@_icons/%@_", SHOP_ITEM_BASE_URL, self.preview_size.lowercaseString, self.shop_item_uid, self.shop_item_name_prefix]; // + position.png
}

@end
