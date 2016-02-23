//
//  GAClipartPreviewView.m
//  GifsArt
//
//  Created by Hovhannes Safaryan on 8/7/15.
//  Copyright (c) 2015 PicsArt. All rights reserved.
//

#import "PicsiesPreviewView.h"

@interface PicsiesPreviewView ()

@end

@implementation PicsiesPreviewView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        self.backgroundColor = [UIColor colorWithWhite:0.6f alpha:0.7f];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect canvasFrame = self.bounds;
    canvasFrame.origin.y = 45;
    canvasFrame.size.height = self.bounds.size.width;
    _imageView.bounds = CGRectMake(0, 0, 200, 200);
    _imageView.center = CGPointMake(CGRectGetMidX(canvasFrame), CGRectGetMidY(canvasFrame)+40);
}

- (void)show:(BOOL)animated {
    self.hidden = NO;
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 1.0;
    }];
}

- (void)hide:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.5f animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }else {
        self.alpha = 0.0;
        self.hidden = YES;
    }
}

@end
