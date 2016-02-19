//
//  ViewController.m
//  Picsies
//
//  Created by DavitPiloyan on 2/19/16.
//  Copyright © 2016 Picsies. All rights reserved.
//

#import "ViewController.h"
#import "SCPagingTabController.h"
#import "SCWrapperScrollView.h"
#import "ContentController.h"
#import "StickersSliderViewController.h"

@interface ViewController () < SCPagingTabControllerDataSource,
                                SCPagingTabControllerDelegate,
                                StickersSliderDelegate,
                                UIScrollViewDelegate>

@property (nonatomic,weak) SCWrapperScrollView *scrollViewWrapper;
@property (nonatomic,weak) SCPagingTabController *pagingTabController;
@property (nonatomic,weak) StickersSliderViewController *stickerSliderVC;
@property (nonatomic) BOOL tabSelected;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        [self initTabController];
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

- (void)initTabController {
    SCWrapperScrollView* scrollViewWrapper = [[SCWrapperScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollViewWrapper = scrollViewWrapper;
    self.scrollViewWrapper.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:self.scrollViewWrapper atIndex:0];
    
    StickersSliderViewController* stickerSliderVC = [[StickersSliderViewController alloc] init];
    self.stickerSliderVC = stickerSliderVC;
    self.stickerSliderVC.delegate = self;
    self.stickerSliderVC.view.frame = (CGRect){CGPointZero, (CGSize){CGRectGetWidth(self.view.bounds), 240}};
    [self addChildViewController:self.stickerSliderVC];
    [self.scrollViewWrapper addSubview:self.stickerSliderVC.view];
    [self.stickerSliderVC didMoveToParentViewController:self];
    
    SCPagingTabController* tabController = [[SCPagingTabController alloc] initWithTabTitles:self.tabTitles];
    
    self.pagingTabController = tabController;
    self.pagingTabController.dataSource = self;
    self.pagingTabController.delegate = self;
    [self addChildViewController:self.pagingTabController];
    [self.view addSubview:self.pagingTabController.view];
    self.pagingTabController.view.frame = self.view.bounds;
    self.pagingTabController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.pagingTabController didMoveToParentViewController:self];
    
    self.scrollViewWrapper.scrollContainerInsets = UIEdgeInsetsMake(self.stickerSliderVC.view.frame.size.height,
                                                                    0, 0, 0);
    self.scrollViewWrapper.scrollContainerView = self.pagingTabController.view;
    self.scrollViewWrapper.delegate = self;
}

- (NSArray *)tabTitles {
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        [titles addObject:[NSString stringWithFormat:@"Name%@",@(i)]];
    }

    return [titles copy];
}

- (UIViewController *)pagingTabController:(SCPagingTabController *)pagingViewController
                    viewControllerAtIndex:(NSUInteger)index {
    ContentController* collection = [[ContentController alloc] init];
    return collection;
}

- (void)pagingTabController:(SCPagingTabController *)tabController
      didShowViewController:(UIViewController *)viewController
                    atIndex:(NSUInteger)index {
    UICollectionView* collectionView = [(id)viewController collectionView];
    collectionView.scrollsToTop = NO;
    self.scrollViewWrapper.scrollView = collectionView;
    self.tabSelected = NO;
}

- (void)pagingTabSelectedAtIndex:(NSUInteger)index byUser:(BOOL)byUser{
    if (byUser) {
        self.tabSelected = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIView* cover = self.stickerSliderVC.view;
    float offset = scrollView.contentOffset.y;
    float coverH = cover.bounds.size.height;
    if (offset <= 0) {
        float s = (coverH - offset) / coverH;
        
        cover.transform = CGAffineTransformMakeScale(s, s);
        cover.center = CGPointMake(cover.center.x, cover.bounds.size.height / 2 + (cover.bounds.size.height - cover.frame.size.height) / 2);
    }
}

- (void)stickerSliderVC:(StickersSliderViewController *)stickerSliderVC selectedAtIndx:(NSUInteger)index {
    NSLog(@"index : %@", @(index));
    self.tabSelected = YES;
    [self.pagingTabController setVisibleIndex:index animated:NO];
}

- (void)dealloc {
    self.scrollViewWrapper.delegate = nil;
}

@end
