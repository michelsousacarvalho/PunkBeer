//
//  Beer+CoreDataProperties.h
//  PunkBeer
//
//  Created by Michel de Sousa Carvalho on 31/05/17.
//  Copyright © 2017 Michel de Sousa Carvalho. All rights reserved.
//

#import "Beer+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Beer (CoreDataProperties)

+ (NSFetchRequest<Beer *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *imageUrl;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *tagline;
@property (nonatomic) float abv;
@property (nonatomic) float ibu;
@property (nullable, nonatomic, copy) NSString *descriptionBeer;

@end

NS_ASSUME_NONNULL_END
