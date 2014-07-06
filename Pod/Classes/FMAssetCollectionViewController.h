//
//  FMAssetCollectionViewController.h
//  Pods
//
//  Created by Kyle Shank on 7/4/14.
//
//

#import <UIKit/UIKit.h>

@interface FMAssetCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, retain) NSArray* assets;
@property BOOL selectionMode;
@property NSUInteger cellSize;
@property CGFloat cellSpacing;
-(NSArray*)selectedAssets;
@end
