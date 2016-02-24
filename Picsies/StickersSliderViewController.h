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

- (void)stickerSliderVC:(StickersSliderViewController *)stickerSliderVC contentOffset:(CGPoint)offset;

- (void)stickerSliderVC:(StickersSliderViewController *)stickerSliderVC stoppedScrolling:(BOOL)stoppedScrolling;

@end


@interface StickersSliderViewController : UIViewController

@property (nonatomic, weak) id<StickersSliderDelegate> delegate;
@property (nonatomic) NSArray *banners;


- (void)scrollToOffset:(float)offset withIgnore:(BOOL)ignore;

@end
