//
//  StickersSliderViewController.h
//  Picsies
//
//  Created by Varuzhan Khachatryan on 2/19/16.
//  Copyright © 2016 Picsies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StickersSliderViewController;

@protocol StickersSliderDelegate <NSObject>

- (void)stickerSliderVC:(StickersSliderViewController *)stickerSliderVC selectedAtIndx:(NSUInteger)index;

- (void)stickerSliderVC:(StickersSliderViewController *)stickerSliderVC contentOffset:(CGPoint)offset;


@end


@interface StickersSliderViewController : UIViewController

@property (nonatomic, weak) id<StickersSliderDelegate> delegate;
@property (nonatomic) NSArray *banners;

@property (nonatomic) BOOL ignoreChanges;


- (void)scrollToOffset:(float)offset withIgnore:(BOOL)ignore;

@end
