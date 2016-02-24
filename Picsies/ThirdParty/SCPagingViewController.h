//
//  SCPagingViewController.h
//  picsart
//
//  Created by Arman Margaryan on 4/20/15.
//  Copyright (c) 2015 Socialin Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCPagingViewController;

@protocol SCPagingViewControllerDataSoure <NSObject>

- (NSUInteger)pagingViewControllerViewControllersCount:(SCPagingViewController*)pagingViewController;

- (UIViewController*)pagingViewController:(SCPagingViewController*)pagingViewController
                    viewControllerAtIndex:(NSUInteger)index;

@end

@protocol SCPagingViewControllerDelegate <NSObject>

@optional
- (void)pagingViewController:(SCPagingViewController*)pagingViewController
      willShowViewController:(UIViewController*)viewController
                     atIndex:(NSUInteger)index;

- (void)pagingViewController:(SCPagingViewController*)pagingViewController
       didShowViewController:(UIViewController*)viewController
                     atIndex:(NSUInteger)index;

- (void)pagingViewController:(SCPagingViewController *)pagingViewController
 didUpdateTransitionProgress:(float)progress;

@end

@interface SCPagingViewController : UIViewController

@property (nonatomic) BOOL adjustsScrollViewsInsets;
@property (nonatomic) float scrollViewInsetTop;

@property (nonatomic) NSUInteger visibleIndex;
@property (nonatomic, readonly) UIViewController* visibleViewController;
@property (nonatomic, weak) id<SCPagingViewControllerDataSoure> dataSource;
@property (nonatomic, weak) id<SCPagingViewControllerDelegate> delegate;
@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) UIPanGestureRecognizer* scrollPanGestureRecogonizer;
@property (nonatomic) int spacing;

- (void)reload;

- (void)setVisibleIndex:(NSUInteger)visibleIndex animated:(BOOL)animated;


@end
