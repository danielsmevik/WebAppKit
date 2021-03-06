//
//  WASQLiteSessionManager.m
//  WebAppKit
//
//  Created by Tomas Franzén on 2011-01-04.
//  Copyright 2011 Lighthead Software. All rights reserved.
//

#import "WASessionGenerator.h"
#import "FMDatabase.h"
#import "WASession.h"
#import "WARequest.h"

@interface WASession (Private)
- (id)initWithDatabase:(FMDatabase*)db name:(NSString*)n request:(WARequest*)req response:(WAResponse*)resp;
- (id)initWithDatabase:(FMDatabase*)db name:(NSString*)n token:(NSString*)tokenString;
@end


@implementation WASessionGenerator

+ (id)sessionGenerator {
	return [[self alloc] init];	
}

+ (id)sessionGeneratorWithName:(NSString*)name {
	return [[self alloc] initWithName:name];	
}

- (id)initWithName:(NSString*)n {
	NSAssert(n != nil, @"name is nil");
	self = [super init];
	name = [n copy];
	
	NSString *filename = [name stringByAppendingPathExtension:@"db"];
	NSString *path = [WAApplicationSupportDirectory() stringByAppendingPathComponent:filename];
	
	database = [FMDatabase databaseWithPath:path];
	[database setLogsErrors:YES];
	
	if(![database open]) {
		[NSException raise:NSGenericException format:@"WASQLiteSessionGenerator: Failed to open session store SQLite database. Error %d (%@), path: %@", [database lastErrorCode], [database lastErrorMessage], path];
		return nil;
	}
	
	[database executeUpdate:@"CREATE TABLE IF NOT EXISTS tokens (token)"];
	[database executeUpdate:@"CREATE TABLE IF NOT EXISTS `values` (token, `key`, value)"];
	[database executeUpdate:@"CREATE UNIQUE INDEX IF NOT EXISTS tokens_index ON tokens (token)"];
	[database executeUpdate:@"CREATE UNIQUE INDEX IF NOT EXISTS values_index ON `values` (token, `key`)"];
	
	return self;
}

- (id)init {
	return [self initWithName:@"Session"];
}


- (void)invalidate {
	[database close];
	database = nil;
}

- (WASession*)sessionForRequest:(WARequest*)request response:(WAResponse*)response {
	NSAssert(request != nil && response != nil, @"sessionForRequest:response: needs non-nil request and response.");
	NSAssert(database != nil, @"can't create session from invalidated session generator");
	
	return [[WASession alloc] initWithDatabase:database name:name request:request response:response];
}

- (WASession*)sessionForToken:(NSString*)token {
	NSAssert(database != nil, @"can't create session from invalidated session generator");

	return [[WASession alloc] initWithDatabase:database name:name token:token];	
}


@end