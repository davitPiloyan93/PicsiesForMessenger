//
//  GAClipartPreviewView.h
//  GifsArt
//
//  Created by Hovhannes Safaryan on 8/7/15.
//  Copyright (c) 2015 PicsArt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicsiesPreviewView : UIView

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

@property (nonatomic) CGFloat bottomPadding;
@property (nonatomic) UIImageView *imageView;

@end
