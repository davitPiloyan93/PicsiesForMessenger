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

@interface BannerCell : UICollectionViewCell
@property (nonatomic) UIImageView *imageView;
@end

@implementation BannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
    }
    return self;
}

@end

@interface StickersSliderViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic)UICollectionView *collectionView;
@property (nonatomic) iCarousel* carousel;
@property (nonatomic) NSTimer *timer;

@end

@implementation StickersSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UICollectionViewFlowLayout *collectionLayout = (UICollectionViewFlowLayout *) _collectionView.collectionViewLayout;
    collectionLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *collectionLayout = [UICollectionViewFlowLayout new];
    collectionLayout.minimumLineSpacing = 0;
    collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
    _collectionView.contentInset = UIEdgeInsetsZero;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.scrollsToTop = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[BannerCell class] forCellWithReuseIdentifier:@"StickerCell"];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.banners.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StickerCell" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:self.banners[indexPath.row]];
    return cell;
}

- (void)scrollToOffset:(float)offset withIgnore:(BOOL)ignore {
    self.ignoreChanges = ignore;
    [self.collectionView setContentOffset:CGPointMake(offset*self.collectionView.bounds.size.width, self.collectionView.contentOffset.y)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.delegate stickerSliderVC:self contentOffset:scrollView.contentOffset];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    [self.delegate stickerSliderVC:self stoppedScrolling:YES];
}

@end
