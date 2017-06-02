//
//  DetailViewController.m
//  PunkBeer
//
//  Created by Michel de Sousa Carvalho on 01/06/17.
//  Copyright © 2017 Michel de Sousa Carvalho. All rights reserved.
//

#import "DetailViewController.h"
#import "ImageCache.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageBeer;
@property (weak, nonatomic) IBOutlet UILabel *nameBeer;
@property (weak, nonatomic) IBOutlet UILabel *taglineBeer;
@property (weak, nonatomic) IBOutlet UILabel *abvBeer;
@property (weak, nonatomic) IBOutlet UILabel *ibuBeer;
@property (weak, nonatomic) IBOutlet UITextView *descriptionBeer;
@property (weak, nonatomic) IBOutlet UILabel *labelibu;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.beer.name;
    
    self.nameBeer.text = self.beer.name;
    self.taglineBeer.text = self.beer.tagline;
    if(self.beer.abv){
        self.abvBeer.text = [NSString stringWithFormat:@"%.2f", self.beer.abv];
    }
    if(self.beer.ibu){
        self.ibuBeer.text = [NSString stringWithFormat:@"%.2f", self.beer.ibu];
        self.labelibu.hidden = NO;
    } else {
        self.labelibu.hidden = YES;
        self.ibuBeer.hidden = YES;
    }
    
    self.descriptionBeer.text = self.beer.descriptionBeer;
    
    if(self.beer.imageUrl){
        ImageCache *imageCache = [ImageCache sharedInstance];
        [imageCache.imageRequest fetchImageWithUrl:self.beer.imageUrl andNameImage:self.beer.name withcompletionBlock:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageBeer.image = image;
            });
        }];
        
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
