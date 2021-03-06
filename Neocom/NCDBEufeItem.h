//
//  NCDBEufeItem.h
//  Neocom
//
//  Created by Артем Шиманский on 18.09.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NCDBEufeItemCategory, NCDBEufeItemGroup, NCDBInvType;

@interface NCDBEufeItem : NSManagedObject

@property (nonatomic, retain) NCDBEufeItemCategory *charge;
@property (nonatomic, retain) NSSet *groups;
@property (nonatomic, retain) NCDBInvType *type;
@end

@interface NCDBEufeItem (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(NCDBEufeItemGroup *)value;
- (void)removeGroupsObject:(NCDBEufeItemGroup *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

@end
