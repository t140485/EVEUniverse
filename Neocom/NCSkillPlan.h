//
//  NCSkillPlan.h
//  Neocom
//
//  Created by Artem Shimanski on 17.12.13.
//  Copyright (c) 2013 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NCTrainingQueue.h"

@class NCAccount;
@interface NCSkillPlan : NSManagedObject

@property (nonatomic, assign) BOOL active;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSArray* skills;
@property (nonatomic, strong) NCAccount* account;

@property (nonatomic, strong) NCTrainingQueue* trainingQueue;

- (void) save;
- (void) mergeWithTrainingQueue:(NCTrainingQueue*) trainingQueue;
- (void) removeSkill:(NCSkillData*) skill;
- (void) clear;

- (void) updateSkillPoints;
- (void) reloadIfNeeded;

@end
