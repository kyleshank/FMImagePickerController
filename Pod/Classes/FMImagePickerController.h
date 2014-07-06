//
//  FMImagePickerController.h
//  Pods
//
//  Created by Kyle Shank on 7/5/14.
//
//

#import "FMAssetCollectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface FMImagePickerController : FMAssetCollectionViewController <UIActionSheetDelegate>
@property (nonatomic, retain) ALAssetsGroup *assetGroup;
@property BOOL ascending;
@end
