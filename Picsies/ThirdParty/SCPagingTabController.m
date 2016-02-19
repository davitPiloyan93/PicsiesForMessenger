//
//  SCPagingTabController.m
//  picsart
//
//  Created by Arman Margaryan on 4/25/15.
//  Copyright (c) 2015 Socialin Inc. All rights reserved.
//

#import "SCPagingViewController.h"
#import "SCPagingTabController.h"
#import "UIViewController+SCAdditions.h"
#import "SCScrollViewContainer.h"
#import "NSArray+SCAdditions.h"

@interface SCPagingTabController () <SCTabBarDelegateNew,
                                     SCPagingViewControllerDelegate,
                                     SCPagingViewControllerDataSoure>

@property (nonatomic) SCPagingViewController* pagingViewController;

@property (nonatomic) NSArray* titles;

@property (nonatomic, readwrite) SCTabBar* tabBar;

@end

@implementation SCPagingTabController

-(void)setTitles:(NSArray *)titles {
    _titles = [titles mapObjectsWithBlock:^id(NSString *obj, NSUInteger idx) {
        return [obj uppercaseString];
    }];
}

- (id)initWithTabTitles:(NSArray*)titles {
    self = [super init];
    if (self) {
        self.titles = titles;
        self.adjustsTabInsets = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float tabBarH = (NO) ? 44 : 36;
    
    tabBarH = (self.titles.count <= 1) ? 0 : tabBarH;
    
    CGRect tabBarFrame = CGRectMake(0, 64, self.view.bounds.size.width, tabBarH);
    
    SCTabBar* tabBar = [[SCTabBar alloc] initWithFrame:tabBarFrame tabTitles:self.titles];
                           
                           
    self.tabBar = tabBar;
    self.tabBar.delegate = self;
    self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.tabBar];
//    self.navigationBarScrollingDataSource.bottomViews = @[self.tabBar];
    
    SCPagingViewController *pagingViewController = [SCPagingViewController new];
    self.pagingViewController = pagingViewController;
    self.pagingViewController.delegate = self;
    self.pagingViewController.dataSource = self;
    self.pagingViewController.adjustsScrollViewsInsets = YES;
    self.pagingViewController.scrollViewInsetTop = CGRectGetMaxY(self.tabBar.frame);
    
    [self addChildViewController:pagingViewController];
    [self.view insertSubview:pagingViewController.view atIndex:0];
    self.pagingViewController.view.frame = self.view.bounds;
    self.pagingViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [pagingViewController didMoveToParentViewController:self];
}

- (UIPanGestureRecognizer*)scrollPanGestureRecogonizer {
    return self.pagingViewController.scrollPanGestureRecogonizer;
}

- (void)reload {
    [self.pagingViewController reload];
}

- (void)setSelectedTabIndex:(NSUInteger)selectedTabIndex {
    self.pagingViewController.visibleIndex = selectedTabIndex;
}

- (UIViewController*)currentController {
    return self.pagingViewController.visibleViewController;
}

- (NSUInteger)selectedTabIndex {
    return self.pagingViewController.visibleIndex;
}

- (NSUInteger)pagingViewControllerViewControllersCount:(SCPagingViewController*)pagingViewController {
    return self.titles.count;
}

- (UIViewController*)pagingViewController:(SCPagingViewController*)pagingViewController
                    viewControllerAtIndex:(NSUInteger)index {
    return [self.dataSource pagingTabController:self viewControllerAtIndex:index];
}

- (void)pagingViewController:(SCPagingViewController*)pagingViewController
      willShowViewController:(UIViewController*)viewController
                     atIndex:(NSUInteger)index {
//    [self.navigationBarScrollingDataSource.navBarScrollManager setOpened:YES animated:YES];
    if ([self.delegate respondsToSelector:@selector(pagingTabController:willShowViewController:atIndex:)]) {
        [self.delegate pagingTabController:self willShowViewController:viewController atIndex:index];
    }
}

- (void)pagingViewController:(SCPagingViewController*)pagingViewController
      didShowViewController:(UIViewController*)viewController
                     atIndex:(NSUInteger)index {
    self.tabBar.selectedTabIndex = index;
    if ([viewController conformsToProtocol:@protocol(SCScrollViewContainer)]) {
//        self.navigationBarScrollingDataSource.scrollView = [(id)viewController collectionView];
    }
    if ([self.delegate respondsToSelector:@selector(pagingTabController:didShowViewController:atIndex:)]) {
        [self.delegate pagingTabController:self didShowViewController:viewController atIndex:index];
    }
}

- (void)pagingViewController:(SCPagingViewController *)pagingViewController didUpdateTransitionProgress:(float)progress {
    [self.tabBar setProgress:progress];
}

- (void)tabBar:(SCTabBar *)tabBar didSelectTabAtIndex:(NSUInteger)index byUser:(BOOL)byUser {
    if ([self.delegate respondsToSelector:@selector(pagingTabSelectedAtIndex:byUser:)]) {
        [self.delegate pagingTabSelectedAtIndex:index byUser:byUser];
    }
    if (byUser) {
        self.pagingViewController.visibleIndex = index;
    }
}

@end
