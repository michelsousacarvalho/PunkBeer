//
//  DataStore.m
//  PunkBeer
//
//  Created by Michel de Sousa Carvalho on 31/05/17.
//  Copyright © 2017 Michel de Sousa Carvalho. All rights reserved.
//

#import "DataStore.h"



@implementation DataStore

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


static DataStore *sharedDataConfig = nil;

+ (DataStore *) sharedManager
{
    
    if (!sharedDataConfig)
    {
        sharedDataConfig = [[super allocWithZone:nil] init];
    }
    
    return sharedDataConfig;
}

- (NSManagedObject*) createObjectWithEntityName:(NSString *)entityName
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *managedObject = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    return  managedObject;
}

- (NSManagedObject*) createObjectWithEntityName:(NSString *)entityName inContext:(NSManagedObjectContext *) context
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSManagedObject *managedObject = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    return  managedObject;
}

- (NSManagedObject*) getOrCreateObjectWithEntityName:(NSString *)entityName withUUID:(NSString *)uuid context:(NSManagedObjectContext *)context
{    
    NSManagedObject *object = [[self loadObjectsForEntity:entityName withValue:uuid forAttribute:@"uuid" inContext:context] firstObject];
    
    if (!object) {
        object = [self createObjectWithEntityName:entityName inContext:context];
        [object setValue:uuid forKey:@"uuid"];
//        [self updateManagedObject:object];
    }
    
    return  object;
}

- (NSManagedObject*) getOrCreateObjectWithEntityName:(NSString *)entityName withID:(NSString *)idEntity fieldID:(NSString*)field context:(NSManagedObjectContext *)context
{
    NSManagedObject *object = [[self loadObjectsForEntity:entityName withValue:idEntity forAttribute:field inContext:context] firstObject];
    
    if (!object) {
        object = [self createObjectWithEntityName:entityName inContext:context];
        [object setValue:idEntity forKey:field];
//        [self updateManagedObject:object];
    }
    
    return  object;
}


- (NSManagedObject*) getOrCreateObjectWithEntityName:(NSString *)entityName withIDNumber:(NSNumber *)idEntity fieldID:(NSString *)field context:(NSManagedObjectContext *)context
{
    NSManagedObject *object = [[self loadObjectsForEntity:entityName withValue:idEntity forAttribute:field inContext:context] firstObject];
    
    if (!object) {
        object = [self createObjectWithEntityName:entityName inContext:context];
        [object setValue:idEntity forKey:field];
//        [self updateManagedObject:object];
    }
    
    return  object;
}

- (NSUInteger) countObjectsForEntity:(NSString*) entityName {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName
                                   inManagedObjectContext:self.managedObjectContext]];
    [request setIncludesSubentities:NO];
    NSError *error;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];
    if(error != nil){
        return 0;
    }
    return count;
}


- (NSError *) saveAndInsertObject:(NSManagedObject *) managedObject
{
    if (!managedObject) return nil;
    
    if (!managedObject.isInserted)
        [self.managedObjectContext insertObject:managedObject];
    NSError *error;
    
    [self.managedObjectContext save:&error];
    return error;
}

- (NSMutableArray *) loadObjectsForEntity :(NSString *) entityName withValue : (id) attributeValue forAttribute : (NSString *) attribute
{
    //retrieve from Core Data
    
    NSMutableArray *array = [self loadObjectsForEntity:entityName withValue:attributeValue forAttribute:attribute inContext:self.managedObjectContext];
    
    return array;
}

- (NSMutableArray *) loadObjectsForEntity :(NSString *) entityName withValue : (id) attributeValue forAttribute : (NSString *) attribute inContext:(NSManagedObjectContext *) context
{
    return [self loadObjectsForEntity:entityName withValue:attributeValue forAttribute:attribute sortDescriptors:nil inContext:context];
}

- (NSMutableArray *) loadObjectsForEntity: (NSString *) entityName
                                withValue: (id) attributeValue
                              forAttribute: (NSString *) attribute
                           sortDescriptors: (NSArray *)sortDescriptors
                                 inContext: (NSManagedObjectContext *) context
{
    //retrieve from Core Data
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:entityName
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    request.fetchBatchSize = 20;
    
    if (attribute && attributeValue) {
        NSPredicate *pred =
        [NSPredicate predicateWithFormat:@"(%K = %@)", attribute, attributeValue];
        [request setPredicate:pred];
    }
    
    if (sortDescriptors) {
        request.sortDescriptors = sortDescriptors;
    }
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    if (error) NSLog(@"%@", error);
    
    return [NSMutableArray arrayWithArray:objects];
}


- (NSMutableArray *) loadObjectsForEntity:(NSString *)entityName withParameterDictionary:(NSDictionary *)parameters {
    return [self loadObjectsForEntity:entityName withParameterDictionary:parameters inContext:self.managedObjectContext];
}


- (NSMutableArray *) loadObjectsForEntity: (NSString *) entityName withParameterDictionary: (NSDictionary *) parameters  inContext: (NSManagedObjectContext *) context {
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:entityName
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSPredicate *pred;
        if (obj == [NSNull null]) {
            pred = [NSPredicate predicateWithFormat:@"(%K = nil)", key];
        } else {
            pred = [NSPredicate predicateWithFormat:@"(%K = %@)", key, obj];
            
        }
    
        [predicates addObject:pred];
    }];

    NSPredicate *compoundPred = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    
    [request setPredicate:compoundPred];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    return [NSMutableArray arrayWithArray:objects];
}
- (NSMutableArray *) loadObjectsForEntity :(NSString *) entityName withValuesArray : (NSArray *) attributeValues forAttribute : (NSString *) attribute {
    NSMutableArray *array = [self loadObjectsForEntity:entityName withValuesArray:attributeValues forAttribute:attribute inContext:self.managedObjectContext];
    return array;
}
- (NSMutableArray *) loadObjectsForEntity :(NSString *) entityName withValuesArray : (NSArray *) attributeValues forAttribute : (NSString *) attribute inContext: (NSManagedObjectContext *) context
{
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:entityName
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    if (attribute && attributeValues) {
        NSPredicate *pred =
        [NSPredicate predicateWithFormat:@"(%K in %@)", attribute, attributeValues];
        [request setPredicate:pred];
    }
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                                  error:&error];
    return [NSMutableArray arrayWithArray:objects];
}


-(NSMutableArray *) loadObjectsForEntityUsingContains:(NSString*) entityName withValue:(id)attributeValue forAttribute : (NSString *) attribute
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    request.fetchBatchSize = 20;

    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:attribute ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    request.sortDescriptors = sortDescriptors;
    
    if (attribute && attributeValue) {
        //http://stackoverflow.com/questions/14578513/nspredicate-core-data
        //http://stackoverflow.com/questions/2036094/case-insensitive-core-data-contains-or-beginswith-contraint
        NSPredicate *pred =
        [NSPredicate predicateWithFormat:@"(%K CONTAINS[cd] %@)", attribute, attributeValue];
        [request setPredicate:pred];
    }
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    if (error) NSLog(@"%@", error);
    
    return [NSMutableArray arrayWithArray:objects];

}

-(NSMutableArray *) loadObjectsForEntityUsingContainsWithDistinct:(NSString*) entityName withValue:(id)attributeValue forAttribute : (NSString *) attribute
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    request.fetchBatchSize = 20;
        request.resultType = NSDictionaryResultType;
    request.propertiesToFetch = [NSArray arrayWithObject:[[entityDesc propertiesByName] objectForKey:attribute]];
    request.returnsDistinctResults = YES;
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:attribute ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    request.sortDescriptors = sortDescriptors;
    
    if (attribute && attributeValue) {
        //http://stackoverflow.com/questions/14578513/nspredicate-core-data
        //http://stackoverflow.com/questions/2036094/case-insensitive-core-data-contains-or-beginswith-contraint
        NSPredicate *pred =
        [NSPredicate predicateWithFormat:@"(%K CONTAINS[cd] %@)", attribute, attributeValue];
        [request setPredicate:pred];
    }
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    if (error) NSLog(@"%@", error);
    
    return [NSMutableArray arrayWithArray:objects];
}



-(NSMutableArray *) loadObjectsForEntityUsingContains:(NSString *) entityName withSubQuery:(NSString*)subQuery withValue:(id)attributeValue
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    request.fetchBatchSize = 20;

    NSPredicate *pred = [NSPredicate predicateWithFormat:subQuery, attributeValue];
    [request setPredicate:pred];
    
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    if (error) NSLog(@"%@", error);
    
    return [NSMutableArray arrayWithArray:objects];

}

-(NSMutableArray *) loadObjectsForEntityWithSort:(NSString*) entityName withValue:(id)attributeValue forAttribute : (NSString *) attribute orderBy:(NSString*)orderBy
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    request.fetchBatchSize = 20;
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:orderBy ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    request.sortDescriptors = sortDescriptors;
    
    if (attribute && attributeValue) {
        NSPredicate *pred =
        [NSPredicate predicateWithFormat:@"(%K = %@)", attribute, attributeValue];
        [request setPredicate:pred];
    }
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    if (error) NSLog(@"%@", error);
    
    return [NSMutableArray arrayWithArray:objects];
    
}





-(NSUInteger) verifyExistObject:(NSString *) entityName withValue:(id) attributeValue forAttribute:(NSString *) attribute
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entityDescription;
    
    if(attributeValue && attribute){
        NSPredicate *predicate =
        [NSPredicate predicateWithFormat:@"(%K = %@)", attribute, attributeValue];
        [request setPredicate:predicate];
    }
    
    NSError *error;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];
    if (!error) {
        return count;
    } else {
        return 0;
    }
}

- (void) updateManagedObject : (NSManagedObject *) object {
    NSManagedObjectContext *context = object.managedObjectContext;
    NSManagedObjectContext *parentContext = context.parentContext;
    
    if (!context.hasChanges) return;
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSError *error;
//        [context save: &error];
//    });
    [context performBlockAndWait:^{
        NSError *error;
        [context save: &error];
        
        if (error) {
//            [error printDetailedError];
        }
        else {
            if (parentContext) {
                [parentContext performBlockAndWait:^{
                    NSError *error;
                    [parentContext save:&error];
                    
                    if (error) {
//                        [error printDetailedError];
                    }
                }];
                [parentContext processPendingChanges];
            }
        }
        [context processPendingChanges];
    }];
}


- (void) saveTemporaryContext: (NSManagedObjectContext *)context
{
    [context performBlock:^{
        NSError *contextError = nil;
        [context save:&contextError];
        
        if (contextError) {
//            [contextError printDetailedError];
        } else if (context.parentContext) {
            [context.parentContext performBlock:^{
                NSError *mainError = nil;
                [context.parentContext save:&mainError];
                
                if (mainError) {
//                    [mainError printDetailedError];
                }
            }];
        }
    }];
}
- (NSManagedObjectContext *) newTemporaryContext
{
    NSManagedObjectContext *temp = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temp.parentContext = [self managedObjectContext];
    return temp;
}

-(void)deleteManagedObject:(NSManagedObject *)object
{
    NSManagedObjectContext *context = object.managedObjectContext;
    [context deleteObject:object];
    NSError * error = nil;
    if (![context save:&error])
    {
        NSLog(@"Error ! %@", error);
    }
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

/**
 * Returns the managed object model for the application.
 * If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PunkBeer" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

/**
 * Returns the persistent store coordinator for the application.
 * If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PunkBeer.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    //options for auto migration
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES,
                             NSInferMappingModelAutomaticallyOption: @YES};
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = _managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


-(void) setUUIDDeleted:(NSString *) uuid {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:uuid];
}

-(BOOL) checkIfUUIDWasDeleted:(NSString *) uuid {
    return [[NSUserDefaults standardUserDefaults] boolForKey:uuid];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
