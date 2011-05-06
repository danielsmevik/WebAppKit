//
//  WSCoreDataExtras.h
//  WebTest
//
//  Created by Tomas Franzén on 2010-12-15.
//  Copyright 2010 Lighthead Software. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (WAExtras)
+ (id)managedObjectContextWithModel:(NSManagedObjectModel*)model store:(NSURL*)storeURL type:(NSString*)storeType;
+ (id)managedObjectContextFromModelNamed:(NSString*)modelName storeName:(NSString*)storeName type:(NSString*)storeType;
+ (id)managedObjectContextWithStoreName:(NSString*)storeName type:(NSString*)storeType;

- (void)deleteObjectsUsingFetchRequest:(NSFetchRequest*)request;
- (id)firstMatchForFetchRequest:(NSFetchRequest*)request;
- (void)saveOrRaise;
@end


@interface NSManagedObject (WAExtras)
- (id)initInsertingIntoManagedObjectContext:(NSManagedObjectContext*)moc;

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc;
+ (NSArray*)objectsMatchingFetchRequest:(NSFetchRequest*)req managedObjectContext:(NSManagedObjectContext*)moc;
+ (NSArray*)objectsInManagedObjectContext:(NSManagedObjectContext*)moc sortedBy:(NSString*)keyPath ascending:(BOOL)asc matchingPredicateFormat:(NSString*)format, ...;
+ (NSArray*)objectsInManagedObjectContext:(NSManagedObjectContext*)moc sorting:(NSArray*)sortDescriptors matchingPredicateFormat:(NSString*)format, ...;
+ (NSArray*)objectsInManagedObjectContext:(NSManagedObjectContext*)moc matchingPredicateFormat:(NSString*)format, ...;
+ (NSArray*)allObjectsInManagedObjectContext:(NSManagedObjectContext*)moc;

- (id)initWithRandomUUIDInsertingIntoManagedObjectContext:(NSManagedObjectContext*)moc;
+ (id)objectWithUUID:(NSString*)UUID inManagedObjectContext:(NSManagedObjectContext*)moc;
@end