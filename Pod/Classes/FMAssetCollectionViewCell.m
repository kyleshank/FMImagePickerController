//
//  FMAssetCollectionViewCell.m
//  Pods
//
//  Created by Kyle Shank on 7/5/14.
//
//

#import "FMAssetCollectionViewCell.h"

@interface FMAssetCollectionViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIImageView *selection;
@property (strong, nonatomic) IBOutlet UIView *movie;
@property (strong, nonatomic) IBOutlet UILabel *duration;
@end

@implementation FMAssetCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        [self.image setContentMode:UIViewContentModeScaleAspectFill];
        self.image.clipsToBounds=YES;
        [self addSubview:self.image];
        
        CGFloat movieHeight = 17.0;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            movieHeight = 34.0;
        }
        
        self.movie = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height-movieHeight, self.frame.size.width, movieHeight)];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0.0,0.0,self.movie.frame.size.width,self.movie.frame.size.height);
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
        [self.movie.layer insertSublayer:gradient atIndex:0];
        
        self.duration = [[UILabel alloc] initWithFrame:CGRectMake(2*movieHeight, 0.0, self.frame.size.width-(2*movieHeight)-2.0, movieHeight)];
        [self.duration setTextColor:[UIColor whiteColor]];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            [self.duration setFont:[UIFont boldSystemFontOfSize:21.0]];
        }else{
            [self.duration setFont:[UIFont boldSystemFontOfSize:13.0]];
        }
        [self.duration setTextAlignment: NSTextAlignmentRight];
        [self.duration setText:@"00:00"];
        [self.movie addSubview:self.duration];
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            UIImageView* videoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(2.0, 0.0, 34.0, 34.0)];
            [videoIcon setImage:[UIImage imageNamed:@"FMPickerVideoIconPad"]];
            [self.movie addSubview:videoIcon];
        }else{
            UIImageView* videoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(2.0, 4.0, 15.0, 9.0)];
            [videoIcon setImage:[UIImage imageNamed:@"FMPickerVideoIcon"]];
            [self.movie addSubview:videoIcon];
        }
        
        [self addSubview:self.movie];
        
        self.selection = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            [self.selection setImage:[UIImage imageNamed:@"FMPickerOverlayPad"]];
        }else{
            [self.selection setImage:[UIImage imageNamed:@"FMPickerOverlay"]];
        }
        self.selection.hidden=YES;
        [self addSubview:self.selection];
    }
    
    return self;
}

-(void)setAsset:(ALAsset *)asset{
    _asset = asset;
    if( self.image.frame.size.width > 75.0){
        [self.image setImage: [UIImage imageWithCGImage:asset.aspectRatioThumbnail]];
    }else{
        [self.image setImage: [UIImage imageWithCGImage:asset.thumbnail]];
    }
    
    if([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]){
        NSNumber *durationNumber = [NSNumber numberWithDouble: ([[asset valueForProperty:ALAssetPropertyDuration] doubleValue] * 1000.0)];
        int seconds = [durationNumber intValue] / 1000;
        int durationTotalMinutes = (seconds / 60);
        int durationTotalSeconds = seconds % 60;
        NSString* durationString = [NSString stringWithFormat:@"%02d:%02d", durationTotalMinutes, durationTotalSeconds];
        [self.duration setText:durationString];
        self.movie.hidden = NO;
    }else{
        self.movie.hidden = YES;
    }
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if(selected){
        self.selection.hidden=NO;
    }else{
        self.selection.hidden=YES;
    }
}

@end
