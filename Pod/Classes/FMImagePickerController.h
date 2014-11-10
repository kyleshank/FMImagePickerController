//
//  FMImagePickerController.h
//  Pods
//
//  Created by Kyle Shank on 7/5/14.
//
//

#import "FMAssetCollectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface FMImagePickerController : FMAssetCollectionViewController <UIActionSheetDelegate, FMAssetCollectionViewControllerDelegate>
@property (nonatomic, retain) ALAssetsGroup *assetGroup;
@property BOOL ascending;
@property ALAssetsFilter* assetsFilter;
@property (strong, retain) ALAssetsLibrary *library;
@end
