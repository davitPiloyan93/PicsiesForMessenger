//
//  ContentController.m
//  Picsies
//
//  Created by DavitPiloyan on 2/19/16.
//  Copyright © 2016 Picsies. All rights reserved.
//

#import "ContentController.h"
#import "PicsiesCell.h"

@interface ContentController ()

@property (nonatomic) NSMutableArray *items;

@end

@implementation ContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = [[NSMutableArray alloc] init];
    for (int i = 0 ; i<20; i++) {
        [self.items addObject:@(i)];
    }
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PicsiesCell class]) bundle:nil] forCellWithReuseIdentifier:@"picsiesCellIdentifier"];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    PicsiesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picsiesCellIdentifier" forIndexPath:indexPath];
    return cell;
    
    
}

@end
