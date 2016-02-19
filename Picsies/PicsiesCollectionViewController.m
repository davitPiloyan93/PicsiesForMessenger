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

#define offset 4
#define itemsPerRow 2
#define padding 16

@interface PicsiesCollectionViewController ()

@property (nonatomic) NSMutableArray *itemsIconsUrls;

@end

@implementation PicsiesCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupShopItemIconsUrls];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PicsiesCell class]) bundle:nil] forCellWithReuseIdentifier:@"picsiesCellIdentifier"];
}


-(void)setupShopItemIconsUrls {
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
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemSide = ([UIScreen mainScreen].bounds.size.width - (itemsPerRow + 1) * (padding - offset)) / itemsPerRow;
    return CGSizeMake(itemSide, itemSide);
}


@end
