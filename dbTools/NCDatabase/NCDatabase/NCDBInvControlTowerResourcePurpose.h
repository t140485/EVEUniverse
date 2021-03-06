//
//  NCDBInvControlTowerResourcePurpose.h
//  NCDatabase
//
//  Created by Артем Шиманский on 17.09.14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NCDBInvControlTowerResource;

@interface NCDBInvControlTowerResourcePurpose : NSManagedObject

@property (nonatomic) int32_t purposeID;
@property (nonatomic, retain) NSString * purposeText;
@property (nonatomic, retain) NSSet *controlTowerResources;
@end

@interface NCDBInvControlTowerResourcePurpose (CoreDataGeneratedAccessors)

- (void)addControlTowerResourcesObject:(NCDBInvControlTowerResource *)value;
- (void)removeControlTowerResourcesObject:(NCDBInvControlTowerResource *)value;
- (void)addControlTowerResources:(NSSet *)values;
- (void)removeControlTowerResources:(NSSet *)values;

@end
