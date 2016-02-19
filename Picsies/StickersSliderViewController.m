//
//  StickersSliderViewController.m
//  Picsies
//
//  Created by Varuzhan Khachatryan on 2/19/16.
//  Copyright © 2016 Picsies. All rights reserved.
//

#import "StickersSliderViewController.h"
#import "iCarousel.h"
#import "UIImageView+WebCache.h"

@interface StickersSliderViewController ()<iCarouselDelegate, iCarouselDataSource>
@property (nonatomic) iCarousel* carousel;
@property (nonatomic) NSTimer *timer;
@end

@implementation StickersSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configCarousel];
}

- (void)configCarousel {
    self.carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [self.view addSubview:self.carousel];
    self.carousel.pagingEnabled = YES;
    self.carousel.type = iCarouselTypeLinear;
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    [self startTimer];
}

#pragma mark - iCarousel

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.banners.count;
}

- (UIView *)carousel:(iCarousel *)_carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView* image = nil;
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        CGRect frame = (CGRect){0, 0, self.carousel.bounds.size.width, self.carousel.bounds.size.height};
        view = [[UIView alloc] initWithFrame:frame];
        image = [[UIImageView alloc] initWithFrame:frame];
        image.tag = 1;
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        [view addSubview:image];
        
    }else {
        CGRect frame = (CGRect){0, 0, self.carousel.bounds.size.width, self.carousel.bounds.size.height};
        view.frame = frame;
        
        image = (UIImageView*)[view viewWithTag:1];
        image.frame = frame;
    }
    
    [image sd_setImageWithURL:self.banners[index]];
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            return value;
        }
        case iCarouselOptionShowBackfaces:
        {
            return YES;
        }
        default:
        {
            return value;
        }
    }
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {

}

- (void)carouselWillBeginDragging:(iCarousel *)carousel {
    [self stopTimer];
}

- (void)startTimer {
    [self stopTimer];
    [self performSelector:@selector(timerCompleted) withObject:nil afterDelay:6];
}

- (void)stopTimer {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)timerCompleted {
    [self scrollToIndex:self.carousel.currentItemIndex + 1];
}

- (void)scrollToIndex:(NSInteger)index {
    [self.carousel scrollToItemAtIndex:index animated:YES];
    [self performSelector:@selector(timerCompleted) withObject:nil afterDelay:6];
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    [self.delegate stickerSliderVC:self selectedAtIndx:index];
}

@end
