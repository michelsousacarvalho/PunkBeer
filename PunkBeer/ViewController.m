//
//  ViewController.m
//  PunkBeer
//
//  Created by Michel de Sousa Carvalho on 31/05/17.
//  Copyright © 2017 Michel de Sousa Carvalho. All rights reserved.
//

#import "ViewController.h"
#import "BeerRequest.h"
#import "Beer+CoreDataClass.h"
#import "BeerCell.h"
#import "ImageCache.h"
#import "DetailViewController.h"
#import "AppDelegate.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *allBeers;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    [appDelegate checkInternet];
    
    self.activity.hidden = FALSE;
    [self.activity startAnimating];
    [BeerRequest requestBeerAndSaveCoreDataWithCompletion:^{
        self.allBeers = [Beer getAllBeersOrdered];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.activity stopAnimating];
            self.activity.hidden = YES;
        });
    }];
    
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"PunkBeer";
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
}



#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allBeers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Beer *beer = [self.allBeers objectAtIndex:indexPath.row];
    BeerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BeerCellIdentifier];
    cell.nameBeer.text = beer.name;
    if(beer.abv){
        cell.abv.text = [NSString stringWithFormat:@"ABV: %.2f", beer.abv];
    }
    if(beer.imageUrl){
        ImageCache *imageCache = [ImageCache sharedInstance];
        [imageCache.imageRequest fetchImageWithUrl:beer.imageUrl andNameImage:beer.name withcompletionBlock:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.image.image = image;
            });
        }];
        
    }
    return cell;
    
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Beer *beer = [self.allBeers objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:SegueShowDetail sender:beer];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SegueShowDetail]){
        DetailViewController *detailVC = segue.destinationViewController;
        detailVC.beer = sender;
    }
}
 


@end
