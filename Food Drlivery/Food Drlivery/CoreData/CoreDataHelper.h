//
//  CoreDataHelper.h
//  Food Drlivery
//
//  Created by Borislav Boyadzhiev on 11/8/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataHelper : NSObject

@property(nonatomic,strong) NSManagedObjectContext* context;
@property(nonatomic, strong) NSManagedObjectModel* model;
@property(nonatomic, strong) NSPersistentStoreCoordinator* coordinator;
@property(nonatomic, strong) NSPersistentStore* store;

+(CoreDataHelper*) coreDataStorageInastance;
- (void)saveContext;
- (void)setupCoreData;

@end
