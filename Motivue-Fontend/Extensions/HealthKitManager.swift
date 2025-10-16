//
//  HealthKitManager.swift
//  SwiftUIstudy
//
//  Created by JangeJason on 2025/9/19.
//

import Combine
import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    let healthStore = HKHealthStore()
    @Published var isAuthorized: Bool = false
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("错误：此设备不支持 HealthKit。")
            return
        }
        
        let typesToShare = Self.shareableSampleTypes
        let typesToRead = Self.readableObjectTypes
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            if let error {
                print("HealthKit 授权请求失败: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.isAuthorized = success
            }
            
            if success {
                print("用户已成功授权所有可用的 HealthKit 数据类型！")
            } else {
                print("用户拒绝了 HealthKit 授权。")
            }
        }
    }
}

private extension HealthKitManager {
    static let shareableSampleTypes: Set<HKSampleType> = {
        var sampleTypes: Set<HKSampleType> = []
        
        for rawValue in HealthKitTypeCatalog.quantityTypeIdentifiers {
            let identifier = HKQuantityTypeIdentifier(rawValue: rawValue)
            if let quantityType = HKObjectType.quantityType(forIdentifier: identifier) {
                sampleTypes.insert(quantityType)
            }
        }
        
        for rawValue in HealthKitTypeCatalog.categoryTypeIdentifiers {
            let identifier = HKCategoryTypeIdentifier(rawValue: rawValue)
            if let categoryType = HKObjectType.categoryType(forIdentifier: identifier) {
                sampleTypes.insert(categoryType)
            }
        }
        
        for rawValue in HealthKitTypeCatalog.correlationTypeIdentifiers {
            let identifier = HKCorrelationTypeIdentifier(rawValue: rawValue)
            if let correlationType = HKObjectType.correlationType(forIdentifier: identifier) {
                sampleTypes.insert(correlationType)
            }
        }
        
        for rawValue in HealthKitTypeCatalog.documentTypeIdentifiers {
            let identifier = HKDocumentTypeIdentifier(rawValue: rawValue)
            if let documentType = HKObjectType.documentType(forIdentifier: identifier) {
                sampleTypes.insert(documentType)
            }
        }
        
        for rawValue in HealthKitTypeCatalog.clinicalTypeIdentifiers {
            let identifier = HKClinicalTypeIdentifier(rawValue: rawValue)
            if let clinicalType = HKObjectType.clinicalType(forIdentifier: identifier) {
                sampleTypes.insert(clinicalType)
            }
        }
        
        for rawValue in HealthKitTypeCatalog.seriesTypeIdentifiers {
            if let seriesType = HKObjectType.seriesType(forIdentifier: rawValue) {
                sampleTypes.insert(seriesType)
            }
        }
        
        sampleTypes.insert(HKObjectType.workoutType())
        
        if #available(iOS 13.0, *) {
            sampleTypes.insert(HKObjectType.audiogramSampleType())
        }
        
        if #available(iOS 14.0, *) {
            sampleTypes.insert(HKObjectType.electrocardiogramType())
        }
        
        if #available(iOS 16.0, *) {
            sampleTypes.insert(HKObjectType.visionPrescriptionType())
        }
        
        if #available(iOS 18.0, *) {
            sampleTypes.insert(HKObjectType.stateOfMindType())
        }
        
        return sampleTypes
    }()
    
    static let readableObjectTypes: Set<HKObjectType> = {
        var objectTypes: Set<HKObjectType> = []
        shareableSampleTypes.forEach { objectTypes.insert($0) }
        
        for rawValue in HealthKitTypeCatalog.characteristicTypeIdentifiers {
            let identifier = HKCharacteristicTypeIdentifier(rawValue: rawValue)
            if let characteristicType = HKObjectType.characteristicType(forIdentifier: identifier) {
                objectTypes.insert(characteristicType)
            }
        }
        
        if #available(iOS 9.3, *) {
            objectTypes.insert(HKObjectType.activitySummaryType())
        }
        
        return objectTypes
    }()
}

private enum HealthKitTypeCatalog {
    static let quantityTypeIdentifiers: [String] = [
        "HKQuantityTypeIdentifierAppleSleepingWristTemperature",
        "HKQuantityTypeIdentifierBodyFatPercentage",
        "HKQuantityTypeIdentifierBodyMass",
        "HKQuantityTypeIdentifierBodyMassIndex",
        "HKQuantityTypeIdentifierElectrodermalActivity",
        "HKQuantityTypeIdentifierHeight",
        "HKQuantityTypeIdentifierLeanBodyMass",
        "HKQuantityTypeIdentifierWaistCircumference",
        "HKQuantityTypeIdentifierActiveEnergyBurned",
        "HKQuantityTypeIdentifierAppleExerciseTime",
        "HKQuantityTypeIdentifierAppleMoveTime",
        "HKQuantityTypeIdentifierAppleStandTime",
        "HKQuantityTypeIdentifierBasalEnergyBurned",
        "HKQuantityTypeIdentifierCrossCountrySkiingSpeed",
        "HKQuantityTypeIdentifierCyclingCadence",
        "HKQuantityTypeIdentifierCyclingFunctionalThresholdPower",
        "HKQuantityTypeIdentifierCyclingPower",
        "HKQuantityTypeIdentifierCyclingSpeed",
        "HKQuantityTypeIdentifierDistanceCrossCountrySkiing",
        "HKQuantityTypeIdentifierDistanceCycling",
        "HKQuantityTypeIdentifierDistanceDownhillSnowSports",
        "HKQuantityTypeIdentifierDistancePaddleSports",
        "HKQuantityTypeIdentifierDistanceRowing",
        "HKQuantityTypeIdentifierDistanceSkatingSports",
        "HKQuantityTypeIdentifierDistanceSwimming",
        "HKQuantityTypeIdentifierDistanceWalkingRunning",
        "HKQuantityTypeIdentifierDistanceWheelchair",
        "HKQuantityTypeIdentifierEstimatedWorkoutEffortScore",
        "HKQuantityTypeIdentifierFlightsClimbed",
        "HKQuantityTypeIdentifierNikeFuel",
        "HKQuantityTypeIdentifierPaddleSportsSpeed",
        "HKQuantityTypeIdentifierPhysicalEffort",
        "HKQuantityTypeIdentifierPushCount",
        "HKQuantityTypeIdentifierRowingSpeed",
        "HKQuantityTypeIdentifierRunningPower",
        "HKQuantityTypeIdentifierRunningSpeed",
        "HKQuantityTypeIdentifierStepCount",
        "HKQuantityTypeIdentifierSwimmingStrokeCount",
        "HKQuantityTypeIdentifierUnderwaterDepth",
        "HKQuantityTypeIdentifierWorkoutEffortScore",
        "HKQuantityTypeIdentifierEnvironmentalAudioExposure",
        "HKQuantityTypeIdentifierEnvironmentalSoundReduction",
        "HKQuantityTypeIdentifierHeadphoneAudioExposure",
        "HKQuantityTypeIdentifierAtrialFibrillationBurden",
        "HKQuantityTypeIdentifierHeartRate",
        "HKQuantityTypeIdentifierHeartRateRecoveryOneMinute",
        "HKQuantityTypeIdentifierHeartRateVariabilitySDNN",
        "HKQuantityTypeIdentifierPeripheralPerfusionIndex",
        "HKQuantityTypeIdentifierRestingHeartRate",
        "HKQuantityTypeIdentifierVO2Max",
        "HKQuantityTypeIdentifierWalkingHeartRateAverage",
        "HKQuantityTypeIdentifierAppleWalkingSteadiness",
        "HKQuantityTypeIdentifierRunningGroundContactTime",
        "HKQuantityTypeIdentifierRunningStrideLength",
        "HKQuantityTypeIdentifierRunningVerticalOscillation",
        "HKQuantityTypeIdentifierSixMinuteWalkTestDistance",
        "HKQuantityTypeIdentifierStairAscentSpeed",
        "HKQuantityTypeIdentifierStairDescentSpeed",
        "HKQuantityTypeIdentifierWalkingAsymmetryPercentage",
        "HKQuantityTypeIdentifierWalkingDoubleSupportPercentage",
        "HKQuantityTypeIdentifierWalkingSpeed",
        "HKQuantityTypeIdentifierWalkingStepLength",
        "HKQuantityTypeIdentifierDietaryBiotin",
        "HKQuantityTypeIdentifierDietaryCaffeine",
        "HKQuantityTypeIdentifierDietaryCalcium",
        "HKQuantityTypeIdentifierDietaryCarbohydrates",
        "HKQuantityTypeIdentifierDietaryChloride",
        "HKQuantityTypeIdentifierDietaryCholesterol",
        "HKQuantityTypeIdentifierDietaryChromium",
        "HKQuantityTypeIdentifierDietaryCopper",
        "HKQuantityTypeIdentifierDietaryEnergyConsumed",
        "HKQuantityTypeIdentifierDietaryFatMonounsaturated",
        "HKQuantityTypeIdentifierDietaryFatPolyunsaturated",
        "HKQuantityTypeIdentifierDietaryFatSaturated",
        "HKQuantityTypeIdentifierDietaryFatTotal",
        "HKQuantityTypeIdentifierDietaryFiber",
        "HKQuantityTypeIdentifierDietaryFolate",
        "HKQuantityTypeIdentifierDietaryIodine",
        "HKQuantityTypeIdentifierDietaryIron",
        "HKQuantityTypeIdentifierDietaryMagnesium",
        "HKQuantityTypeIdentifierDietaryManganese",
        "HKQuantityTypeIdentifierDietaryMolybdenum",
        "HKQuantityTypeIdentifierDietaryNiacin",
        "HKQuantityTypeIdentifierDietaryPantothenicAcid",
        "HKQuantityTypeIdentifierDietaryPhosphorus",
        "HKQuantityTypeIdentifierDietaryPotassium",
        "HKQuantityTypeIdentifierDietaryProtein",
        "HKQuantityTypeIdentifierDietaryRiboflavin",
        "HKQuantityTypeIdentifierDietarySelenium",
        "HKQuantityTypeIdentifierDietarySodium",
        "HKQuantityTypeIdentifierDietarySugar",
        "HKQuantityTypeIdentifierDietaryThiamin",
        "HKQuantityTypeIdentifierDietaryVitaminA",
        "HKQuantityTypeIdentifierDietaryVitaminB12",
        "HKQuantityTypeIdentifierDietaryVitaminB6",
        "HKQuantityTypeIdentifierDietaryVitaminC",
        "HKQuantityTypeIdentifierDietaryVitaminD",
        "HKQuantityTypeIdentifierDietaryVitaminE",
        "HKQuantityTypeIdentifierDietaryVitaminK",
        "HKQuantityTypeIdentifierDietaryWater",
        "HKQuantityTypeIdentifierDietaryZinc",
        "HKQuantityTypeIdentifierBloodAlcoholContent",
        "HKQuantityTypeIdentifierBloodPressureDiastolic",
        "HKQuantityTypeIdentifierBloodPressureSystolic",
        "HKQuantityTypeIdentifierInsulinDelivery",
        "HKQuantityTypeIdentifierNumberOfAlcoholicBeverages",
        "HKQuantityTypeIdentifierNumberOfTimesFallen",
        "HKQuantityTypeIdentifierTimeInDaylight",
        "HKQuantityTypeIdentifierUVExposure",
        "HKQuantityTypeIdentifierWaterTemperature",
        "HKQuantityTypeIdentifierBasalBodyTemperature",
        "HKQuantityTypeIdentifierAppleSleepingBreathingDisturbances",
        "HKQuantityTypeIdentifierForcedExpiratoryVolume1",
        "HKQuantityTypeIdentifierForcedVitalCapacity",
        "HKQuantityTypeIdentifierInhalerUsage",
        "HKQuantityTypeIdentifierOxygenSaturation",
        "HKQuantityTypeIdentifierPeakExpiratoryFlowRate",
        "HKQuantityTypeIdentifierRespiratoryRate",
        "HKQuantityTypeIdentifierBloodGlucose",
        "HKQuantityTypeIdentifierBodyTemperature"
    ]
    
    static let categoryTypeIdentifiers: [String] = [
        "HKCategoryTypeIdentifierAppleStandHour",
        "HKCategoryTypeIdentifierEnvironmentalAudioExposureEvent",
        "HKCategoryTypeIdentifierHeadphoneAudioExposureEvent",
        "HKCategoryTypeIdentifierHighHeartRateEvent",
        "HKCategoryTypeIdentifierIrregularHeartRhythmEvent",
        "HKCategoryTypeIdentifierLowCardioFitnessEvent",
        "HKCategoryTypeIdentifierLowHeartRateEvent",
        "HKCategoryTypeIdentifierMindfulSession",
        "HKCategoryTypeIdentifierAppleWalkingSteadinessEvent",
        "HKCategoryTypeIdentifierHandwashingEvent",
        "HKCategoryTypeIdentifierToothbrushingEvent",
        "HKCategoryTypeIdentifierBleedingAfterPregnancy",
        "HKCategoryTypeIdentifierBleedingDuringPregnancy",
        "HKCategoryTypeIdentifierCervicalMucusQuality",
        "HKCategoryTypeIdentifierContraceptive",
        "HKCategoryTypeIdentifierInfrequentMenstrualCycles",
        "HKCategoryTypeIdentifierIntermenstrualBleeding",
        "HKCategoryTypeIdentifierIrregularMenstrualCycles",
        "HKCategoryTypeIdentifierLactation",
        "HKCategoryTypeIdentifierMenstrualFlow",
        "HKCategoryTypeIdentifierOvulationTestResult",
        "HKCategoryTypeIdentifierPersistentIntermenstrualBleeding",
        "HKCategoryTypeIdentifierPregnancy",
        "HKCategoryTypeIdentifierPregnancyTestResult",
        "HKCategoryTypeIdentifierProgesteroneTestResult",
        "HKCategoryTypeIdentifierProlongedMenstrualPeriods",
        "HKCategoryTypeIdentifierSexualActivity",
        "HKCategoryTypeIdentifierSleepApneaEvent",
        "HKCategoryTypeIdentifierSleepAnalysis",
        "HKCategoryTypeIdentifierAbdominalCramps",
        "HKCategoryTypeIdentifierAcne",
        "HKCategoryTypeIdentifierAppetiteChanges",
        "HKCategoryTypeIdentifierBladderIncontinence",
        "HKCategoryTypeIdentifierBloating",
        "HKCategoryTypeIdentifierBreastPain",
        "HKCategoryTypeIdentifierChestTightnessOrPain",
        "HKCategoryTypeIdentifierChills",
        "HKCategoryTypeIdentifierConstipation",
        "HKCategoryTypeIdentifierCoughing",
        "HKCategoryTypeIdentifierDiarrhea",
        "HKCategoryTypeIdentifierDizziness",
        "HKCategoryTypeIdentifierDrySkin",
        "HKCategoryTypeIdentifierFainting",
        "HKCategoryTypeIdentifierFatigue",
        "HKCategoryTypeIdentifierFever",
        "HKCategoryTypeIdentifierGeneralizedBodyAche",
        "HKCategoryTypeIdentifierHairLoss",
        "HKCategoryTypeIdentifierHeadache",
        "HKCategoryTypeIdentifierHeartburn",
        "HKCategoryTypeIdentifierHotFlashes",
        "HKCategoryTypeIdentifierLossOfSmell",
        "HKCategoryTypeIdentifierLossOfTaste",
        "HKCategoryTypeIdentifierLowerBackPain",
        "HKCategoryTypeIdentifierMemoryLapse",
        "HKCategoryTypeIdentifierMoodChanges",
        "HKCategoryTypeIdentifierNausea",
        "HKCategoryTypeIdentifierNightSweats",
        "HKCategoryTypeIdentifierPelvicPain",
        "HKCategoryTypeIdentifierRapidPoundingOrFlutteringHeartbeat",
        "HKCategoryTypeIdentifierRunnyNose",
        "HKCategoryTypeIdentifierShortnessOfBreath",
        "HKCategoryTypeIdentifierSinusCongestion",
        "HKCategoryTypeIdentifierSkippedHeartbeat",
        "HKCategoryTypeIdentifierSleepChanges",
        "HKCategoryTypeIdentifierSoreThroat",
        "HKCategoryTypeIdentifierVaginalDryness",
        "HKCategoryTypeIdentifierVomiting",
        "HKCategoryTypeIdentifierWheezing",
        "HKCategoryTypeIdentifierAudioExposureEvent"
    ]
    
    static let characteristicTypeIdentifiers: [String] = [
        "HKCharacteristicTypeIdentifierActivityMoveMode",
        "HKCharacteristicTypeIdentifierBiologicalSex",
        "HKCharacteristicTypeIdentifierBloodType",
        "HKCharacteristicTypeIdentifierDateOfBirth",
        "HKCharacteristicTypeIdentifierFitzpatrickSkinType",
        "HKCharacteristicTypeIdentifierWheelchairUse"
    ]
    
    static let correlationTypeIdentifiers: [String] = [
        "HKCorrelationTypeIdentifierBloodPressure",
        "HKCorrelationTypeIdentifierFood"
    ]
    
    static let documentTypeIdentifiers: [String] = [
        "HKDocumentTypeIdentifierCDA"
    ]
    
    static let clinicalTypeIdentifiers: [String] = [
        "HKClinicalTypeIdentifierAllergyRecord",
        "HKClinicalTypeIdentifierClinicalNoteRecord",
        "HKClinicalTypeIdentifierConditionRecord",
        "HKClinicalTypeIdentifierImmunizationRecord",
        "HKClinicalTypeIdentifierLabResultRecord",
        "HKClinicalTypeIdentifierMedicationRecord",
        "HKClinicalTypeIdentifierProcedureRecord",
        "HKClinicalTypeIdentifierVitalSignRecord",
        "HKClinicalTypeIdentifierCoverageRecord"
    ]
    
    static let seriesTypeIdentifiers: [String] = [
        "HKWorkoutRouteTypeIdentifier",
        "HKDataTypeIdentifierHeartbeatSeries",
        "HKDataTypeIdentifierStateOfMind",
        "HKDataTypeIdentifierUserAnnotatedMedicationConcept"
    ]
}
