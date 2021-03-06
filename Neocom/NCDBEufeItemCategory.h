//
//  NCDBEufeItemCategory.h
//  Neocom
//
//  Created by Артем Шиманский on 18.09.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NCDBChrRace, NCDBEufeItem, NCDBEufeItemGroup;

@interface NCDBEufeItemCategory : NSManagedObject

@property (nonatomic) int16_t category;
@property (nonatomic) int16_t subcategory;
@property (nonatomic, retain) NSSet *eufeItems;
@property (nonatomic, retain) NSSet *itemGroups;
@property (nonatomic, retain) NCDBChrRace *race;
@end

@interface NCDBEufeItemCategory (CoreDataGeneratedAccessors)

- (void)addEufeItemsObject:(NCDBEufeItem *)value;
- (void)removeEufeItemsObject:(NCDBEufeItem *)value;
- (void)addEufeItems:(NSSet *)values;
- (void)removeEufeItems:(NSSet *)values;

- (void)addItemGroupsObject:(NCDBEufeItemGroup *)value;
- (void)removeItemGroupsObject:(NCDBEufeItemGroup *)value;
- (void)addItemGroups:(NSSet *)values;
- (void)removeItemGroups:(NSSet *)values;

@end
