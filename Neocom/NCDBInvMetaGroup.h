//
//  NCDBInvMetaGroup.h
//  Neocom
//
//  Created by Артем Шиманский on 18.09.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NCDBEveIcon, NCDBInvType;

@interface NCDBInvMetaGroup : NSManagedObject

@property (nonatomic) int32_t metaGroupID;
@property (nonatomic, retain) NSString * metaGroupName;
@property (nonatomic, retain) NCDBEveIcon *icon;
@property (nonatomic, retain) NSSet *types;
@end

@interface NCDBInvMetaGroup (CoreDataGeneratedAccessors)

- (void)addTypesObject:(NCDBInvType *)value;
- (void)removeTypesObject:(NCDBInvType *)value;
- (void)addTypes:(NSSet *)values;
- (void)removeTypes:(NSSet *)values;

@end
