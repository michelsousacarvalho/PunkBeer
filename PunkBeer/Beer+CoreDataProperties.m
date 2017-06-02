//
//  Beer+CoreDataProperties.m
//  PunkBeer
//
//  Created by Michel de Sousa Carvalho on 31/05/17.
//  Copyright © 2017 Michel de Sousa Carvalho. All rights reserved.
//

#import "Beer+CoreDataProperties.h"

@implementation Beer (CoreDataProperties)

+ (NSFetchRequest<Beer *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Beer"];
}

@dynamic imageUrl;
@dynamic name;
@dynamic tagline;
@dynamic abv;
@dynamic ibu;
@dynamic descriptionBeer;

@end
