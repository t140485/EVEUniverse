//
//  NCDBMapConstellation.h
//  NCDatabase
//
//  Created by Артем Шиманский on 17.09.14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NCDBMapDenormalize, NCDBMapRegion, NCDBMapSolarSystem;

@interface NCDBMapConstellation : NSManagedObject

@property (nonatomic) int32_t constellationID;
@property (nonatomic, retain) NSString * constellationName;
@property (nonatomic) int32_t factionID;
@property (nonatomic, retain) NSSet *denormalize;
@property (nonatomic, retain) NCDBMapRegion *region;
@property (nonatomic, retain) NSSet *solarSystems;
@end

@interface NCDBMapConstellation (CoreDataGeneratedAccessors)

- (void)addDenormalizeObject:(NCDBMapDenormalize *)value;
- (void)removeDenormalizeObject:(NCDBMapDenormalize *)value;
- (void)addDenormalize:(NSSet *)values;
- (void)removeDenormalize:(NSSet *)values;

- (void)addSolarSystemsObject:(NCDBMapSolarSystem *)value;
- (void)removeSolarSystemsObject:(NCDBMapSolarSystem *)value;
- (void)addSolarSystems:(NSSet *)values;
- (void)removeSolarSystems:(NSSet *)values;

@end
