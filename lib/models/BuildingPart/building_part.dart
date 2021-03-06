// ignore_for_file: unnecessary_this
import 'package:enum_to_string/enum_to_string.dart';

import 'package:msg/models/BuildingPart/construction_class.dart';
import 'package:msg/models/BuildingPart/fire_protection.dart';
import 'package:msg/models/BuildingPart/insured_type.dart';
import 'package:msg/models/Measurement/measurement.dart';
import 'package:msg/models/BuildingPart/risk_class.dart';

const String tableBuildingPart = 'buildingPart';

class BuildingPartFields {
  static final List<String> values = [
    id,
    description,
    buildingYear,
    fireProtection,
    constructionClass,
    riskClass,
    unitPrice,
    insuredType,
    devaluationPercentage,
    cubature,
    value,
    sumInsured,
    buildingAssesment,
    validated
  ];

  static const String id = 'buildingPartId';
  static const String description = 'description';
  static const String buildingYear = 'buildingYear';
  static const String fireProtection = 'fireProtection';
  static const String constructionClass = 'constructionClass';
  static const String riskClass = 'riskClass';
  static const String unitPrice = 'unitPrice';
  static const String insuredType = 'insuredType';
  static const String devaluationPercentage = 'devaluationPercentage';
  static const String cubature = 'cubature';
  static const String value = 'value';
  static const String sumInsured = 'sumInsured';
  static const String buildingAssesment = 'fk_buildingAssessmentId';
  static const String measurements = 'measurements';
  static const String validated = 'validated';
}

class BuildingPart {
  int? id;
  String? description;
  int? buildingYear;
  FireProtection? fireProtection;
  ConstructionClass? constructionClass;
  RiskClass? riskClass;
  double? unitPrice;
  InsuredType? insuredType;
  double? devaluationPercentage;
  double? cubature = 0.0;
  double? value;
  double? sumInsured;
  int? fk_buildingAssesmentId;
  bool? validated;
  List<Measurement> measurements;

  BuildingPart(
      {this.id,
      this.description,
      this.buildingYear,
      this.fireProtection,
      this.constructionClass,
      this.riskClass,
      this.unitPrice,
      this.insuredType,
      this.devaluationPercentage,
      this.cubature,
      this.value,
      this.sumInsured,
      this.validated,
      this.fk_buildingAssesmentId,
      List<Measurement>? measurements})
      : measurements = measurements ?? [];

  Map<String, dynamic> toJson() {
    return {
      BuildingPartFields.id: id,
      BuildingPartFields.description: description,
      BuildingPartFields.buildingYear: buildingYear,
      BuildingPartFields.fireProtection: fireProtection != null
          ? EnumToString.convertToString(fireProtection)
          : null,
      BuildingPartFields.constructionClass: constructionClass != null
          ? EnumToString.convertToString(constructionClass)
          : null,
      BuildingPartFields.riskClass:
          riskClass != null ? EnumToString.convertToString(riskClass) : null,
      BuildingPartFields.unitPrice: unitPrice,
      BuildingPartFields.insuredType: insuredType != null
          ? EnumToString.convertToString(insuredType)
          : null,
      BuildingPartFields.devaluationPercentage: devaluationPercentage,
      BuildingPartFields.cubature: cubature,
      BuildingPartFields.sumInsured: sumInsured,
      BuildingPartFields.value: value,
      BuildingPartFields.validated: validated == true ? 1 : 0,
      BuildingPartFields.buildingAssesment: fk_buildingAssesmentId
    };
  }

  Map<String, dynamic> toMessage() {
    List measurementsJson = [];
    measurements.forEach((measurement) {
      measurementsJson.add(measurement.toMessage());
    });
    return {
      BuildingPartFields.description: '"${description}"',
      BuildingPartFields.buildingYear: '"${buildingYear}"',
      BuildingPartFields.fireProtection: fireProtection != null
          ? '"${EnumToString.convertToString(fireProtection)}"'
          : "null",
      BuildingPartFields.constructionClass: constructionClass != null
          ? '"${EnumToString.convertToString(constructionClass)}"'
          : "null",
      BuildingPartFields.riskClass:
          riskClass != null 
          ? '"${EnumToString.convertToString(riskClass)}"'
          : "null",
      BuildingPartFields.unitPrice: unitPrice,
      BuildingPartFields.insuredType: insuredType != null
          ? '"${EnumToString.convertToString(insuredType)}"'
          : "null",
      BuildingPartFields.devaluationPercentage: '"${devaluationPercentage}"',
      BuildingPartFields.cubature: '"${cubature}"',
      BuildingPartFields.sumInsured: '"${sumInsured}"',
      BuildingPartFields.value: '"${value}"',
      BuildingPartFields.measurements: measurementsJson,
    };
  }

  static BuildingPart fromJson(Map<String, dynamic> json) {
    bool validatedBool =
        int.tryParse(json[BuildingPartFields.validated].toString()) == 1
            ? true
            : false;
    return BuildingPart(
      id: int.tryParse(json[BuildingPartFields.id].toString()),
      description: json[BuildingPartFields.description] as String?,
      buildingYear:
          int.tryParse(json[BuildingPartFields.buildingYear].toString()),
      fireProtection: json[BuildingPartFields.fireProtection] != null
          ? EnumToString.fromString(
              FireProtection.values, json[BuildingPartFields.fireProtection])
          : null,
      constructionClass: json[BuildingPartFields.constructionClass] != null
          ? EnumToString.fromString(ConstructionClass.values,
              json[BuildingPartFields.constructionClass])
          : null,
      riskClass: json[BuildingPartFields.riskClass] != null
          ? EnumToString.fromString(
              RiskClass.values, json[BuildingPartFields.riskClass])
          : null,
      unitPrice: double.tryParse(json[BuildingPartFields.unitPrice].toString()),
      insuredType: json[BuildingPartFields.insuredType] != null
          ? EnumToString.fromString(
              InsuredType.values, json[BuildingPartFields.insuredType])
          : null,
      cubature: double.tryParse(json[BuildingPartFields.cubature].toString()),
      devaluationPercentage: double.tryParse(
          json[BuildingPartFields.devaluationPercentage].toString()),
      value: double.tryParse(json[BuildingPartFields.value].toString()),
      sumInsured:
          double.tryParse(json[BuildingPartFields.sumInsured].toString()),
      validated: validatedBool,
      fk_buildingAssesmentId: int.tryParse(json[BuildingPartFields.buildingAssesment].toString())
    );
  }

  BuildingPart copy({
    int? id,
    String? description,
    int? buildingYear,
    FireProtection? fireProtection,
    ConstructionClass? constructionClass,
    RiskClass? riskClass,
    double? unitPrice,
    InsuredType? insuredType,
    double? devaluationPercentage,
    double? cubature,
    double? value,
    double? sumInsured,
    int? fk_buildingAssesmentId,
    bool? validated,
  }) =>
      BuildingPart(
          id: id ?? this.id,
          description: description ?? this.description,
          buildingYear: buildingYear ?? this.buildingYear,
          fireProtection: fireProtection ?? this.fireProtection,
          constructionClass: constructionClass ?? this.constructionClass,
          riskClass: riskClass ?? this.riskClass,
          unitPrice: unitPrice ?? this.unitPrice,
          insuredType: insuredType ?? this.insuredType,
          devaluationPercentage:
              devaluationPercentage ?? this.devaluationPercentage,
          cubature: cubature ?? this.cubature,
          value: value ?? this.value,
          sumInsured: sumInsured ?? this.sumInsured,
          fk_buildingAssesmentId:
              fk_buildingAssesmentId ?? this.fk_buildingAssesmentId,
          validated: validated ?? this.validated
        );

  get getId => this.id;

  set setId(id) => this.id = id;

  get getBuildingYear => this.buildingYear;

  set setBuildingYear(buildingYear) => this.buildingYear = buildingYear;

  get getFireProtection => this.fireProtection;

  set setFireProtection(fireProtection) => this.fireProtection = fireProtection;

  get getConstructionClass => this.constructionClass;

  set setConstructionClass(constructionClass) =>
      this.constructionClass = constructionClass;

  get getRiskClass => this.riskClass;

  set setRiskClass(riskClass) => this.riskClass = riskClass;

  get getUnitPrice => this.unitPrice;

  set setUnitPrice(unitPrice) => this.unitPrice = unitPrice;

  get getInsuredType => this.insuredType;

  set setInsuredType(insuredType) => this.insuredType = insuredType;

  get getDevaluationPercentage => this.devaluationPercentage;

  set setDevaluationPercentage(devaluationPercentage) =>
      this.devaluationPercentage = devaluationPercentage;

  get getValue => this.value;

  set setValue(value) => this.value = value;

  get getSumInsured => this.sumInsured;

  set setSumInsured(sumInsured) => this.sumInsured = sumInsured;

  get getMeasurments => measurements;

  set setMeasurments(measurments) => measurements = measurments;
}
