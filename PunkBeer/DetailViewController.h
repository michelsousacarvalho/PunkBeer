//
//  DetailViewController.h
//  PunkBeer
//
//  Created by Michel de Sousa Carvalho on 01/06/17.
//  Copyright © 2017 Michel de Sousa Carvalho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Beer+CoreDataClass.h"

@interface DetailViewController : UIViewController

@property(nonatomic, strong) Beer *beer;

@end
