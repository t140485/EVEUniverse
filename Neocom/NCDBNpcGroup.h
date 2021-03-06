//
//  NCDBNpcGroup.h
//  Neocom
//
//  Created by Артем Шиманский on 18.09.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NCDBEveIcon, NCDBInvGroup, NCDBNpcGroup;

@interface NCDBNpcGroup : NSManagedObject

@property (nonatomic, retain) NSString * npcGroupName;
@property (nonatomic, retain) NCDBInvGroup *group;
@property (nonatomic, retain) NCDBEveIcon *icon;
@property (nonatomic, retain) NCDBNpcGroup *parentNpcGroup;
@property (nonatomic, retain) NSSet *supNpcGroups;
@end

@interface NCDBNpcGroup (CoreDataGeneratedAccessors)

- (void)addSupNpcGroupsObject:(NCDBNpcGroup *)value;
- (void)removeSupNpcGroupsObject:(NCDBNpcGroup *)value;
- (void)addSupNpcGroups:(NSSet *)values;
- (void)removeSupNpcGroups:(NSSet *)values;

@end
