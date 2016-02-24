//
//  SCPagingTabController.h
//  picsart
//
//  Created by Arman Margaryan on 4/25/15.
//  Copyright (c) 2015 Socialin Inc. All rights reserved.
//

#import "SCTabBar.h"

@class SCPagingTabController;

@protocol SCPagingTabControllerDataSource <NSObject>

- (UIViewController*)pagingTabController:(SCPagingTabController*)pagingViewController
                    viewControllerAtIndex:(NSUInteger)index;

@end

@protocol SCPagingTabControllerDelegate <NSObject>

@optional

- (void)pagingTabController:(SCPagingTabController*)tabController
     willShowViewController:(UIViewController*)viewController
                    atIndex:(NSUInteger)index;

- (void)pagingTabController:(SCPagingTabController*)tabController
      didShowViewController:(UIViewController*)viewController
                    atIndex:(NSUInteger)index;

- (void)pagingTabSelectedAtIndex:(NSUInteger)index byUser:(BOOL)byUser;

- (void)pagingTabController:(SCPagingTabController *)pagingViewController didUpdateTransitionProgress:(float)progress;


@end

@interface SCPagingTabController : UIViewController

@property (nonatomic, weak) id<SCPagingTabControllerDelegate> delegate;

@property (nonatomic, weak) id<SCPagingTabControllerDataSource> dataSource;

@property (nonatomic, readonly) UIPanGestureRecognizer* scrollPanGestureRecogonizer;

@property (nonatomic, readonly) SCTabBar* tabBar;

@property (nonatomic) BOOL adjustsTabInsets;

@property (nonatomic) NSUInteger selectedTabIndex;

@property (nonatomic, weak) UIViewController* currentController;

- (void)setVisibleIndex:(NSUInteger)visibleIndex animated:(BOOL)animated;

- (id)initWithTabTitles:(NSArray*)titles;

- (void)reload;

@end
