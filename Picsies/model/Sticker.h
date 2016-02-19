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
@property(nonatomic, copy) NSString *shop_item_price;
@property(copy) NSString *shop_item_base_url;
@property(copy) NSString *shop_item_description;
@property(copy) NSString *shop_item_props_json;
@property(copy) NSString *rule;
@property(nonatomic) BOOL hidden;
@property(nonatomic) BOOL is_new;

@property(nonatomic) NSString *localePrice;
@property(nonatomic) NSDecimalNumber *price;

@property(nonatomic, readonly) NSURL *categoryUrl;

@property(nonatomic, readonly) NSURL *downloadUrl;
@property(nonatomic, readonly) NSString *packagePath;

@property(copy) NSString *shop_item_name_prefix;
@property(copy) NSString *shop_item_color;
@property(copy) NSString *shop_item_mini_description;
@property(copy) NSString *shop_item_preview_type;
@property(nonatomic) int shop_item_preview_count;
@property(nonatomic) int shop_item_banners_count;

@property(copy) NSString *networkProvider;

@property(nonatomic, copy) NSURL *shopItemPreviewIconUrl;
@property(nonatomic, copy) NSURL *shopItemCategoryIconUrl;
@property(nonatomic, copy) NSString *shopItemBannerUrl;
@property(nonatomic, copy) NSString *shopItemIconUrl;
@property(nonatomic, copy) NSString *networkProviderIconUrl;

@property(nonatomic) BOOL isFreeItem;

@property(nonatomic) NSString *preview_size;
@property(nonatomic) NSArray *tags;
@property(nonatomic) NSString *currency;


- (BOOL)hasTag:(NSString *)tag;

@property(nonatomic) NSString *provider;
@property(nonatomic) NSString *content;
@property(nonatomic) NSString *brand;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end
