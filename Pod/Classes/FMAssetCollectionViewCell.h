//
//  FMAssetCollectionViewCell.h
//  Pods
//
//  Created by Kyle Shank on 7/5/14.
//
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface FMAssetCollectionViewCell : UICollectionViewCell
@property NSUInteger index;
@property (nonatomic, retain) ALAsset* asset;
@end
