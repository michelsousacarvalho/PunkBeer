
//
//  DataStore.h
//  PunkBeer
//
//  Created by Michel de Sousa Carvalho on 31/05/17.
//  Copyright © 2017 Michel de Sousa Carvalho. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly, copy) NSURL *applicationDocumentsDirectory;

+ (DataStore *) sharedManager;

- (void)saveContext;

- (NSUInteger) countObjectsForEntity:(NSString*) entityName;

- (NSManagedObjectContext *) newTemporaryContext;

- (NSManagedObject*) getOrCreateObjectWithEntityName:(NSString *)entityName withUUID:(NSString *)uuid context:(NSManagedObjectContext *)context;

- (NSManagedObject*) getOrCreateObjectWithEntityName:(NSString *)entityName withID:(NSString *)idEntity fieldID:(NSString*)field context:(NSManagedObjectContext *)context;

- (NSManagedObject*) getOrCreateObjectWithEntityName:(NSString *)entityName withIDNumber:(NSNumber *)idEntity fieldID:(NSString*)field context:(NSManagedObjectContext *)context;

- (NSManagedObject *) createObjectWithEntityName:(NSString*) entityName;
- (NSManagedObject*) createObjectWithEntityName:(NSString *)entityName inContext:(NSManagedObjectContext *) context;

- (NSError *) saveAndInsertObject:(NSManagedObject *) managedObject;

- (NSMutableArray *) loadObjectsForEntity :(NSString *) entityName withValue : (id) attributeValue forAttribute : (NSString *) attribute;
- (NSMutableArray *) loadObjectsForEntity :(NSString *) entityName withValuesArray : (NSArray *) attributeValues forAttribute : (NSString *) attribute;

- (NSMutableArray *) loadObjectsForEntity :(NSString *) entityName withValue : (id) attributeValue forAttribute : (NSString *) attribute inContext:(NSManagedObjectContext *) context;
- (NSMutableArray *) loadObjectsForEntity :(NSString *) entityName withValuesArray : (NSArray *) attributeValues forAttribute : (NSString *) attribute inContext: (NSManagedObjectContext *) context;

- (NSMutableArray *) loadObjectsForEntity: (NSString *) entityName
                                withValue: (id) attributeValue
                             forAttribute: (NSString *) attribute
                          sortDescriptors: (NSArray *)sortDescriptors
                                inContext: (NSManagedObjectContext *) context;
/**
 * Loads objects creating an AND between the parameters
 * @param entityName the class name in core data
 * @param parameters NSDictionary with keys as parameters and values arguments for the query
 * @param context the NSManagedObjectContext to execute the fetch on
 */

- (NSMutableArray *) loadObjectsForEntity: (NSString *) entityName withParameterDictionary: (NSDictionary *) parameters  inContext: (NSManagedObjectContext *) context;

/**
 * Loads objects creating an AND between the parameters
 * @param entityName the class name in core data
 * @param parameters NSDictionary with keys as parameters and values arguments for the query
 */
- (NSMutableArray *) loadObjectsForEntity: (NSString *) entityName withParameterDictionary: (NSDictionary *) parameters;

-(NSMutableArray *) loadObjectsForEntityUsingContains:(NSString*) entityName withValue:(id)attributeValue forAttribute : (NSString *) attribute;

-(NSMutableArray *) loadObjectsForEntityUsingContainsWithDistinct:(NSString*) entityName withValue:(id)attributeValue forAttribute : (NSString *) attribute;

-(NSMutableArray *) loadObjectsForEntityUsingContains:(NSString *) entityName withSubQuery:(NSString*)subQuery withValue:(id)attributeValue;

-(NSMutableArray *) loadObjectsForEntityWithSort:(NSString*) entityName withValue:(id)attributeValue forAttribute : (NSString *) attribute orderBy:(NSString*)orderBy;

-(NSUInteger) verifyExistObject:(NSString *) entityName withValue:(id) atributeValue forAttribute:(NSString *) attribute;

- (void) updateManagedObject : (NSManagedObject *) object ;

-(BOOL) checkIfUUIDWasDeleted:(NSString *) uuid;

@property (nonatomic, readonly, strong) NSManagedObjectContext *newTemporaryContext;
- (void) saveTemporaryContext: (NSManagedObjectContext *)context;

-(void) deleteManagedObject:(NSManagedObject *) object;

@end
