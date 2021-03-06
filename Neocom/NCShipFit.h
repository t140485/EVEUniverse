//
//  NCShipFit.h
//  Neocom
//
//  Created by Артем Шиманский on 31.01.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCLoadout.h"
#import "eufe.h"
#import "NCFitCharacter.h"

@interface NCLoadoutDataShip : NSObject<NSCoding>
@property (nonatomic, strong) NSArray* hiSlots;
@property (nonatomic, strong) NSArray* medSlots;
@property (nonatomic, strong) NSArray* lowSlots;
@property (nonatomic, strong) NSArray* rigSlots;
@property (nonatomic, strong) NSArray* subsystems;
@property (nonatomic, strong) NSArray* drones;
@property (nonatomic, strong) NSArray* cargo;
@property (nonatomic, strong) NSArray* implants;
@property (nonatomic, strong) NSArray* boosters;
@property (nonatomic, assign) eufe::TypeID mode;
@end

@interface NCLoadoutDataShipModule : NSObject<NSCoding>
@property (nonatomic, assign) eufe::TypeID typeID;
@property (nonatomic, assign) eufe::TypeID chargeID;
@property (nonatomic, assign) eufe::Module::State state;
@end

@interface NCLoadoutDataShipDrone : NSObject<NSCoding>
@property (nonatomic, assign) eufe::TypeID typeID;
@property (nonatomic, assign) int32_t count;
@property (nonatomic, assign) bool active;
@end

@interface NCLoadoutDataShipImplant : NSObject<NSCoding>
@property (nonatomic, assign) eufe::TypeID typeID;
@end

@interface NCLoadoutDataShipBooster : NSObject<NSCoding>
@property (nonatomic, assign) eufe::TypeID typeID;
@end

@interface NCLoadoutDataShipCargoItem : NSObject<NSCoding>
@property (nonatomic, assign) eufe::TypeID typeID;
@property (nonatomic, assign) int32_t count;
@end

@class BCEveLoadout;
@class NAPISearchItem;
@class EVEAssetListItem;
@class NCKillMail;
@class NCDBInvType;
@interface NCShipFit : NSObject
@property (nonatomic, strong) NCLoadout* loadout;
@property (nonatomic, strong) NSString* loadoutName;
@property (nonatomic, assign) eufe::Character* pilot;
@property (nonatomic, strong) NCFitCharacter* character;
@property (nonatomic, strong) NCDBInvType* type;
@property (nonatomic, readonly) NSString* canonicalName;
@property (nonatomic, readonly) NSString* dnaRepresentation;
@property (nonatomic, readonly) NSString* eveXMLRepresentation;
@property (nonatomic, readonly) NSString* eveXMLRecordRepresentation;
@property (nonatomic, readonly) NSString* eftRepresentation;
@property (nonatomic, readonly) NSString* hyperlinkTag;

- (id) initWithLoadout:(NCLoadout*) loadout;
- (id) initWithType:(NCDBInvType*) type;
- (id) initWithBattleClinicLoadout:(BCEveLoadout*) bcLoadout;
- (id) initWithAPILoadout:(NAPISearchItem*) apiLoadout;
- (id) initWithAsset:(EVEAssetListItem*) asset;
- (id) initWithKillMail:(NCKillMail*) killMail;
- (id) initWithDNA:(NSString*) dna;

- (void) flush;
- (void) save;
- (void) load;

@end
