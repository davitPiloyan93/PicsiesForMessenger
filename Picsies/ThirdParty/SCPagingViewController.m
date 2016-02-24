//
//  SCPagingViewController.m
//  picsart
//
//  Created by Arman Margaryan on 4/20/15.
//  Copyright (c) 2015 Socialin Inc. All rights reserved.
//

#import "UIViewController+SCAdditions.h"
#import "SCPagingViewController.h"
#import "SCScrollViewContainer.h"

@interface SCPagingViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView* scrollView;

@property (nonatomic) NSUInteger count;

@property (nonatomic) NSMutableDictionary* visibleViewControllers;

@property (nonatomic) BOOL ignoreOffsetChange;

@end

@implementation SCPagingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.visibleViewControllers = [NSMutableDictionary dictionary];
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectInset(self.view.bounds, -self.spacing, 0)];
    self.scrollView = scrollView;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    
    //enabling interactive pop gesture.
    UIGestureRecognizer* popRecognizer = self.navigationController.interactivePopGestureRecognizer;
    if (popRecognizer) {
        [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:popRecognizer];
    }
    [self.view addSubview:scrollView];
    
    self.visibleIndex = _visibleIndex;
   // [self reload];
}

- (UIPanGestureRecognizer*)scrollPanGestureRecogonizer {
    return self.scrollView.panGestureRecognizer;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //relayout in will appear for having correct frames of child view controllers in their will appear method
    [self relayout];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self relayout];
}

- (void)layoutVisibleControllers {
    NSArray* visibleIndexes = [self.visibleViewControllers allKeys];
    for (NSNumber* controllerIndex in visibleIndexes) {
        NSInteger idx = [controllerIndex integerValue];
        
        UIViewController* vc = self.visibleViewControllers[controllerIndex];
        
        float w = self.scrollView.bounds.size.width;
        float h = self.scrollView.bounds.size.height;
        
        vc.view.frame = CGRectMake(idx * w + self.spacing, 0, w - 2 * self.spacing, h);
    }
}
- (void)relayout {
    float offsetX = self.scrollView.contentOffset.x;
    float pageW = self.scrollView.bounds.size.width;
    
    int idx = floorf(offsetX / pageW);
    
    float pageOffsetDiff = offsetX - (idx * pageW);
    
    
    //ignoring offset change during setFrame:
    self.ignoreOffsetChange = YES;
    
    self.scrollView.frame = CGRectInset(self.view.bounds, -self.spacing, 0);
    
    self.scrollView.contentSize = CGSizeMake(self.count * self.scrollView.bounds.size.width,
                                             self.scrollView.bounds.size.height);
    
    float newPageW = self.scrollView.bounds.size.width;
    
    self.scrollView.contentOffset = CGPointMake(idx * newPageW + pageOffsetDiff, self.scrollView.contentOffset.y);
    
    [self layoutVisibleControllers];
    self.ignoreOffsetChange = NO;
}

- (void)reload {
    self.count = [self.dataSource pagingViewControllerViewControllersCount:self];
    self.scrollView.contentSize = CGSizeMake(self.count * self.scrollView.bounds.size.width,
                                             self.scrollView.bounds.size.height);
    _visibleIndex = (_visibleIndex > self.count - 1) ? self.count - 1 : _visibleIndex;
    
    float newOffsetX = _visibleIndex * self.scrollView.bounds.size.width;
    self.scrollView.contentOffset = CGPointMake(newOffsetX, self.scrollView.contentOffset.y);

    //removing current controllers
    [self.visibleViewControllers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self removeViewControllerForIndex:[key integerValue]];
    }];
    
    [self checkVisibleViewControllersForOffset];
    [self stoppedScrolling];
}

- (void)setVisibleIndex:(NSUInteger)visibleIndex {
    _visibleIndex = visibleIndex;
    if (self.isViewLoaded) {
        [self reload];
    }
}

- (void)setVisibleIndex:(NSUInteger)visibleIndex animated:(BOOL)animated {
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.visibleIndex = visibleIndex;
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.ignoreOffsetChange) return;
  
    [self checkVisibleViewControllersForOffset];
    if ([self.delegate respondsToSelector:@selector(pagingViewController:didUpdateTransitionProgress:)]) {
        float offsetX = self.scrollView.contentOffset.x;
        float pageW = self.scrollView.bounds.size.width;
        float progress = offsetX / pageW;
        [self.delegate pagingViewController:self didUpdateTransitionProgress:progress];
    }
}

- (NSArray*)visibleViewControllerIndexesForOffset {
    NSMutableArray* indexes = [NSMutableArray array];
    
    float offsetX = self.scrollView.contentOffset.x;
    float pageW = self.scrollView.bounds.size.width;
    
    int idx = floorf(offsetX / pageW);
    
    if (idx >= 0 && idx < self.count) {
        [indexes addObject:@(idx)];
    }
    
    if (ABS(pageW * idx - offsetX) > 0.1) {
        int nextIdx = idx + 1;
          if (nextIdx >= 0 && nextIdx < self.count) {
              [indexes addObject:@(nextIdx)];
          }
        
    }
    return [indexes copy];
}

- (void)checkVisibleViewControllersForOffset {
    NSArray* visibleIndexes = [self visibleViewControllerIndexesForOffset];
    
    //remove not visible controllers.
    NSArray* prevVisibleIndexes = [self.visibleViewControllers allKeys];
    
    for (NSNumber* index in prevVisibleIndexes) {
        if (![visibleIndexes containsObject:index]) {
            [self removeViewControllerForIndex:[index integerValue]];
        }
    }
    
    //adding new visible view controllers.
    for (NSNumber* index in visibleIndexes) {
        if (![prevVisibleIndexes containsObject:index]) {
            [self addViewControllerForIndex:[index integerValue]];
        }
    }
}

- (void)removeViewControllerForIndex:(NSInteger)index {
    NSNumber* key = @(index);
    UIViewController* vc = self.visibleViewControllers[key];
    [vc removeViewControllerFromParent];
    [self.visibleViewControllers removeObjectForKey:key];
}

- (void)addViewControllerForIndex:(NSInteger)index {
    UIViewController* vc = [self.dataSource pagingViewController:self viewControllerAtIndex:index];
    [self addChildViewController:vc];
    
    float w = self.scrollView.bounds.size.width;
    float h = self.scrollView.bounds.size.height;
    
    vc.view.frame = CGRectMake(index * w + self.spacing, 0, w - 2 * self.spacing, h);
    [self.scrollView addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    
    if ([vc conformsToProtocol:@protocol(SCScrollViewContainer)] && self.adjustsScrollViewsInsets) {
        UIScrollView* scrollView = [(id)vc collectionView];
        
        UIEdgeInsets insets = scrollView.contentInset;
        
        insets.top = (insets.top < self.scrollViewInsetTop) ? self.scrollViewInsetTop : insets.top;
        scrollView.contentInset = insets;
        scrollView.scrollIndicatorInsets = insets;
        
        CGPoint contentOffset = scrollView.contentOffset;
        contentOffset.y = -insets.top;
        scrollView.contentOffset = contentOffset;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(pagingViewController:willShowViewController:atIndex:)]) {
        [self.delegate pagingViewController:self willShowViewController:vc atIndex:index];
    }
    self.visibleViewControllers[@(index)] = vc;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self stoppedScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self stoppedScrolling];
    }
}

- (void)stoppedScrolling {
    float offsetX = self.scrollView.contentOffset.x;
    float pageW = self.scrollView.bounds.size.width;
    
    _visibleIndex = MAX(MIN(self.count - 1, floorf(offsetX / pageW)), 0);
    
    _visibleViewController = self.visibleViewControllers[@(_visibleIndex)];
    if ([self.delegate respondsToSelector:@selector(pagingViewController:didShowViewController:atIndex:)]
        && self.count) {
        [self.delegate pagingViewController:self
                      didShowViewController:_visibleViewController
                                    atIndex:_visibleIndex];
    }
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

- (void)dealloc {
    self.scrollView.delegate = nil;
}

@end
