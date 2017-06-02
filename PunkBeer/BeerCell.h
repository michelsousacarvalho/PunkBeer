//
//  BeerCell.h
//  PunkBeer
//
//  Created by Michel de Sousa Carvalho on 31/05/17.
//  Copyright © 2017 Michel de Sousa Carvalho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *nameBeer;
@property (weak, nonatomic) IBOutlet UILabel *abv;


@end
