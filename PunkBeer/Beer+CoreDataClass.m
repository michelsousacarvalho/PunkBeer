//
//  Beer+CoreDataClass.m
//  PunkBeer
//
//  Created by Michel de Sousa Carvalho on 31/05/17.
//  Copyright © 2017 Michel de Sousa Carvalho. All rights reserved.
//

#import "Beer+CoreDataClass.h"
#import "DataStore.h"

@implementation Beer


+(NSUInteger)countBeers {
    return [[DataStore sharedManager] countObjectsForEntity:EntityBeer];
}

+(Beer *) createBeer {
    Beer *beer = (Beer *) [[DataStore sharedManager] createObjectWithEntityName:EntityBeer];
    return beer;
}

+(BOOL) verifyExistBeerWithName:(NSString *) name {
    if( [[DataStore sharedManager] loadObjectsForEntity:EntityBeer withValue:name forAttribute:@"name"].count > 0 ){
        return true;
    } else {
        return false;
    }
}



+(void) saveBeer:(Beer*) beer {
    NSError *error;
    [[[DataStore sharedManager] managedObjectContext] save:&error];
}

+(NSArray *) getAllBeers {
    NSMutableArray *allBeers = [[DataStore sharedManager] loadObjectsForEntity:EntityBeer withParameterDictionary:nil];
    return allBeers;
}

+(NSArray *) getAllBeersOrdered {
    
    NSManagedObjectContext *context = [[DataStore sharedManager] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:EntityBeer
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
    
}


@end
