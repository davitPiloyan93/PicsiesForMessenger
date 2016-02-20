//
//  ContentController.m
//  Picsies
//
//  Created by DavitPiloyan on 2/19/16.
//  Copyright © 2016 Picsies. All rights reserved.
//

#import "PicsiesCollectionViewController.h"
#import "PicsiesCell.h"
#import "StickersClient.h"
#import "Sticker.h"
#import "PicsiesPreviewView.h"
#import "UIImageView+WebCache.h"
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>

#define offset 4

#define padding 16

@interface PicsiesCollectionViewController ()

@property (nonatomic) NSMutableArray *itemsIconsUrls;

@property (nonatomic) PicsiesPreviewView *stickerPreviewView;

@property (nonatomic) NSIndexPath *currentIndexPath;

@end

@implementation PicsiesCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupShopItemIconsUrls];

    self.currentIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
 
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PicsiesCell class]) bundle:nil] forCellWithReuseIdentifier:@"picsiesCellIdentifier"];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupStickerPreviewView];

}

- (void)setupStickerPreviewView {
    if (self.stickerPreviewView) {
        return;
    }
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];;
    self.stickerPreviewView = [[PicsiesPreviewView alloc] initWithFrame:window.bounds];
    [window addSubview:self.stickerPreviewView];
    self.stickerPreviewView.hidden = YES;
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPressHandler:)];
    [self.collectionView addGestureRecognizer:longPressGesture];
}

- (void)setupShopItemIconsUrls {
    self.itemsIconsUrls = [[NSMutableArray alloc] initWithCapacity:10];
    if (self.sticker.shop_item_preview_count > 0) {
        int itemIconsCount = self.sticker.shop_item_preview_count;
        NSString* itemIconBaseUrl = self.sticker.shopItemIconUrl;
        for (int i = 1; i < itemIconsCount+1; i++) {
            NSString* itemIconUrl = [NSString stringWithFormat:@"%@%d.png", itemIconBaseUrl, i];
            [self.itemsIconsUrls addObject:itemIconUrl];
        }
    }
}


#pragma mark UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemsIconsUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    PicsiesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picsiesCellIdentifier" forIndexPath:indexPath];
    [cell setData:self.itemsIconsUrls[indexPath.row]];
    
    if (self.currentIndexPath == indexPath) {
        [cell hideViews:NO];
    } else {
        [cell hideViews:YES];
    }
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    int itemsPerRow = 2;
    if ([UIScreen mainScreen].bounds.size.height>600.f) {
        itemsPerRow = 3;
    }
    CGFloat itemSide = ([UIScreen mainScreen].bounds.size.width - (itemsPerRow + 1) * (padding - offset)) / itemsPerRow;
    return CGSizeMake(itemSide, itemSide);
}

- (void)cellLongPressHandler:(UIGestureRecognizer *)gr {
    static NSInteger position = -1;
    if (gr.state == UIGestureRecognizerStateChanged || gr.state == UIGestureRecognizerStateBegan) {
        [self.stickerPreviewView show:YES];
        CGPoint p = [gr locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
        if (indexPath != nil) {
            NSInteger idx = indexPath.item;
            if (idx != position) {
                position = idx;
                id detailItem = self.itemsIconsUrls[idx];
                
                [self.stickerPreviewView.imageView sd_setImageWithURL:detailItem];
            }
        }
    } else {
        position = -1;
        self.stickerPreviewView.imageView.image = nil;
        [self.stickerPreviewView hide:YES];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentIndexPath == indexPath) {
        PicsiesCell *currentSelectedCell = (PicsiesCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [currentSelectedCell hideViews:NO];
        return YES;
    }
    self.currentIndexPath = indexPath;
    PicsiesCell *currentSelectedCell = (PicsiesCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    for ( PicsiesCell *cell in  collectionView.visibleCells) {
        [cell hideViews:YES];
    }
    [currentSelectedCell hideViews:NO];
    return YES;
}

@end
