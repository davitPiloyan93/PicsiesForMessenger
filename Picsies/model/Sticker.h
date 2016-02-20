//
//  ShopItem.h
//  Picsies
//
//  Created by DavitPiloyan on 2/19/16.
//  Copyright © 2016 Picsies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sticker : NSObject

@property(copy) NSString *type;
@property(copy) NSString *created;
@property(copy) NSString *item_id;
@property(nonatomic, copy) NSString *shop_item_uid;
@property(copy) NSString *shop_item_name;
@property(copy) NSString *shop_item_base_url;
@property(copy) NSString *shop_item_name_prefix;
@property(nonatomic) int shop_item_preview_count;
@property(nonatomic, copy) NSString *shopItemBannerUrl;
@property(nonatomic, copy) NSString *shopItemIconUrl;
@property(nonatomic) NSString *preview_size;
@property(nonatomic) NSArray *tags;

- (BOOL)hasTag:(NSString *)tag;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end
