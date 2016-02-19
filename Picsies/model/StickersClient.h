//
//  StickerManager.h
//  Picsies
//
//  Created by DavitPiloyan on 2/19/16.
//  Copyright © 2016 Picsies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StickersClient : NSObject

+ (StickersClient *)sharedInstance;

- (void)stickersWithComplitionBlock:(void (^)(NSArray *items))complitionBlock;

@end
