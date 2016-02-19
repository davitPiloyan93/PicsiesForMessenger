//
//  ContentController.h
//  Picsies
//
//  Created by DavitPiloyan on 2/19/16.
//  Copyright © 2016 Picsies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sticker.h"

@interface PicsiesCollectionViewController : UIViewController <UICollectionViewDataSource,                                                                                                                                                                                                                                         UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic) Sticker* sticker;


@end
