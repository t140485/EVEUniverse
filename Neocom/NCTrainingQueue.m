//
//  NCTrainingQueue.m
//  Neocom
//
//  Created by Артем Шиманский on 15.01.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "NCTrainingQueue.h"
#import "EVEOnlineAPI.h"
#import "NCAccount.h"
//#import "NCCharacterAttributes.h"

@interface NCTrainingQueue()<NSXMLParserDelegate> {
	NSMutableArray* _skills;
	NSString* _skillPlanName;
}
@property (nonatomic, strong) NSDictionary* characterSkills;
@property (nonatomic, strong) NCCharacterAttributes* characterAttributes;

@end

@implementation NCTrainingQueue
@synthesize trainingTime = _trainingTime;

- (id) init {
	if (self = [super init]) {
		self.characterAttributes = [NCCharacterAttributes defaultCharacterAttributes];
		_skills = [NSMutableArray new];
	}
	return self;
}

- (id) initWithAccount:(NCAccount*) account {
	if (self = [super init]) {
		if (account) {
			self.characterSkills = account.characterSheet.skillsMap;
			self.characterAttributes = account.characterAttributes;
		}
		if (!self.characterAttributes)
			self.characterAttributes = [NCCharacterAttributes defaultCharacterAttributes];
		_skills = [NSMutableArray new];
	}
	return self;
}

- (id) initWithAccount:(NCAccount*) account xmlData:(NSData*) data skillPlanName:(NSString**) skillPlanName {
	if (self = [self initWithAccount:account]) {
		NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
		parser.delegate = self;
		[parser parse];
		if (skillPlanName)
			*skillPlanName = _skillPlanName;
	}
	return self;
}

- (void) setSkills:(NSArray *)skills {
	_skills = [[NSMutableArray alloc] initWithArray:skills];
	_trainingTime = -1;
}

- (void) addRequiredSkillsForType:(NCDBInvType*) type {
	for (NCDBInvTypeRequiredSkill* skill in type.requiredSkills)
		[self addSkill:skill.skillType withLevel:skill.skillLevel];
}

- (void) addSkill:(NCDBInvType*) skill withLevel:(int32_t) level {
	EVECharacterSheetSkill *characterSkill = self.characterSkills[@(skill.typeID)];
	if (characterSkill.level >= level)
		return;
	
	BOOL addedDependence = NO;
	for (int32_t skillLevel = characterSkill.level + 1; skillLevel <= level; skillLevel++) {
		BOOL isExist = NO;
		for (NCSkillData *item in self.skills) {
			if (item.type.typeID == skill.typeID && item.targetLevel == skillLevel) {
				isExist = YES;
				break;
			}
		}
		if (!isExist) {
			if (!addedDependence) {
				[self addRequiredSkillsForType:skill];
				addedDependence = YES;
			}
			NCSkillData* skillData = [[NCSkillData alloc] initWithInvType:skill];
			skillData.targetLevel = skillLevel;
			skillData.currentLevel = skillLevel - 1;
			skillData.trainedLevel = characterSkill.level;
			skillData.characterAttributes = self.characterAttributes;
			
			skillData.skillPoints = characterSkill.skillpoints;
			[_skills addObject:skillData];
		}
	}
	_trainingTime = -1;
}

- (void) removeSkill:(NCSkillData*) skill {
	NSInteger typeID = skill.type.typeID;
	NSInteger level = skill.targetLevel;
	NSInteger index = 0;
	NSMutableIndexSet* indexes = [NSMutableIndexSet indexSet];
	for (NCSkillData* skillData in self.skills) {
		if (skillData.type.typeID == typeID && skillData.targetLevel >= level) {
			_trainingTime -= skillData.trainingTimeToLevelUp;
			[indexes addIndex:index];
		}
		index++;
	}
	[_skills removeObjectsAtIndexes:indexes];
}

- (void) addMastery:(NCDBCertMastery*) mastery {
	for (NCDBCertSkill* skill in mastery.skills) {
		[self addSkill:skill.type withLevel:skill.skillLevel];
	}
}

- (void) updateSkillPointsFromAccount:(NCAccount*) account {
	EVESkillQueueItem* firstSkill = account.skillQueue.skillQueue.count > 0 ? account.skillQueue.skillQueue[0] : nil;
	for (NCSkillData* skillData in self.skills) {
		EVECharacterSheetSkill* characterSkill = account.characterSheet.skillsMap[@(skillData.type.typeID)];
		if (characterSkill)
			skillData.skillPoints = characterSkill.skillpoints;
		if (firstSkill)
			skillData.active = skillData.type.typeID == firstSkill.typeID && skillData.targetLevel == firstSkill.level && skillData.currentLevel == skillData.targetLevel - 1;
	}
	_trainingTime = -1.0;
}

- (NSTimeInterval) trainingTime {
	if (_trainingTime < 0) {
		/*_trainingTime = 0;
		
		for (NCSkillData *skill in self.skills) {
			if (skill.currentLevel < skill.targetLevel)
				_trainingTime += skill.trainingTimeToLevelUp;
		}*/
		_trainingTime = [self trainingTimeWithCharacterAttributes:self.characterAttributes];
	}
	return _trainingTime;
}

- (NSString*) xmlRepresentationWithSkillPlanName:(NSString*) skillPlanName {
	NSMutableString* xml = [NSMutableString new];
	[xml appendString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"];
	[xml appendFormat:@"<plan xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" name=\"%@\" revision=\"2798\">\n", skillPlanName];
	for (NCSkillData* skill in self.skills) {
		[xml appendFormat:@"<entry skillID=\"%d\" skill=\"%@\" level=\"%d\" priority=\"1\" type=\"Planned\"/>\n", skill.type.typeID, skill.type.typeName, skill.targetLevel];
	}
	[xml appendString:@"</plan>\n<!-- Generated by Neocom https://itunes.apple.com/us/app/neocom/id418895101?mt=8 -->"];
	return xml;
}

- (NSTimeInterval) trainingTimeWithCharacterAttributes:(NCCharacterAttributes*) characterAttributes {
	NSTimeInterval trainingTime = 0;
	
	for (NCSkillData *skill in self.skills) {
		if (skill.currentLevel < skill.targetLevel)
			trainingTime += [skill trainingTimeToLevelUpWithCharacterAttributes:characterAttributes];
	}
	return trainingTime;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	NCTrainingQueue* trainingQueue = [[self.class allocWithZone:zone] init];
	trainingQueue.characterSkills = self.characterSkills;
	trainingQueue.characterAttributes = self.characterAttributes;
	
	trainingQueue.skills = self.skills;
	return trainingQueue;
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"entry"]) {
		int32_t typeID = [attributeDict[@"skillID"] intValue];
		int32_t level = [attributeDict[@"level"] intValue];
		NCDBInvType* skill = [NCDBInvType invTypeWithTypeID:typeID];
		if (skill)
			[self addSkill:skill withLevel:level];
	}
	else if ([elementName isEqualToString:@"plan"]) {
		_skillPlanName = [attributeDict valueForKey:@"name"];
	}
}

@end
