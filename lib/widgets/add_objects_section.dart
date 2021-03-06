import 'package:flutter/material.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/BuildingPart/building_part.dart';
import 'package:msg/models/Database/database_helper.dart';
import 'package:msg/screens/measurement_form.dart';
import 'package:msg/screens/building_part_form.dart';
import 'package:msg/services/navigator_service.dart';
import 'package:msg/services/state_service.dart';
import 'package:msg/widgets/custom_popup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/storage_service.dart';

enum ObjectType { buildingPart, measurement }

class AddObjectsSection extends StatefulWidget {
  final dynamic onPressed;
  final ObjectType objectType;
  final double width;
  final VoidCallback? deleteNotifier;

  const AddObjectsSection(
      {Key? key,
      this.onPressed,
      required this.objectType,
      required this.width,
      this.deleteNotifier})
      : super(key: key);

  @override
  State<AddObjectsSection> createState() => _AddObjectsSectionState();
}

class _AddObjectsSectionState extends State<AddObjectsSection> {
  BuildingAssessment buildingAssessment = StateService.buildingAssessment;
  BuildingPart buildingPart = StateService.buildingPart;
  List<ListTile> objects = [];

  Icon getIcon(BuildingPart e) {
    return e.validated == true
        ? const Icon(Icons.done, color: Colors.green)
        : const Icon(Icons.access_time_outlined,
            color: Color.fromARGB(255, 197, 179, 24));
  }

  _getFromDB() async {
    if (ObjectType.buildingPart == widget.objectType) {
      if (buildingAssessment.id != null) {
        int buildingAssessmentId = buildingAssessment.id!;
        await DatabaseHelper.instance
            .readAssessment(buildingAssessmentId)
            .then((value) => buildingAssessment = value);
      }
    } else {
      if (buildingPart.id != null) {
        int buildingPartId = buildingPart.id!;
        await DatabaseHelper.instance
            .readBuildingPart(buildingPartId)
            .then((value) => buildingPart = value);
      }
    }

    setState(() {
      _fillObjects();
    });
  }

  _fillObjects() {
    objects = widget.objectType == ObjectType.buildingPart
        ? buildingAssessment.buildingParts
            .map(
              (buildingPart) => ListTile(
                leading: getIcon(buildingPart),
                title: Transform.translate(
                  offset: const Offset(-20, 0),
                  child: Text(buildingPart.description!),
                ),
                trailing: IconButton(
                  onPressed: () async => await showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomDialog(
                        title:
                            Text(AppLocalizations.of(context)!.dialog_delete),
                        twoButtons: true,
                        titleButtonOne:
                            Text(AppLocalizations.of(context)!.dialog_no),
                        onPressedButtonOne: () =>
                            {Navigator.pop(context, true)},
                        titleButtonTwo:
                            Text(AppLocalizations.of(context)!.dialog_yes),
                        onPressedButtonTwo: () async => {
                              await DatabaseHelper.instance
                                  .deleteBuildingPart(buildingPart.id!),
                              await _getFromDB(),
                              if (widget.deleteNotifier != null)
                                {widget.deleteNotifier!()},
                              Navigator.pop(context, true),
                            }),
                  ),
                  icon: const Icon(Icons.delete),
                ),
                onTap: () => {
                  StateService.buildingPart = buildingPart,
                  NavigatorService.navigateTo(context, const BuildingPartForm())
                },
              ),
            )
            .toList()
        : buildingPart.measurements
            .map(
              (measurement) => ListTile(
                title: Text(measurement.description!),
                trailing: IconButton(
                  onPressed: () async => await showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomDialog(
                        title:
                            Text(AppLocalizations.of(context)!.dialog_delete),
                        twoButtons: true,
                        titleButtonOne:
                            Text(AppLocalizations.of(context)!.dialog_no),
                        onPressedButtonOne: () =>
                            {Navigator.pop(context, true)},
                        titleButtonTwo:
                            Text(AppLocalizations.of(context)!.dialog_yes),
                        onPressedButtonTwo: () async => {
                              await DatabaseHelper.instance.deleteMeasurement(
                                  measurement.measurementId!),
                              _getFromDB(),
                              if (widget.deleteNotifier != null)
                                {widget.deleteNotifier!()},
                              Navigator.pop(context, true),
                            }),
                  ),
                  icon: const Icon(Icons.delete),
                ),
                onTap: () => {
                  StateService.measurement = measurement,
                  NavigatorService.navigateTo(context, const MeasurementForm())
                },
              ),
            )
            .toList();
  }

  @override
  void initState() {
    _getFromDB();
    _fillObjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.transparent)),
          onPressed: widget.onPressed,
          label: Text(
            widget.objectType == ObjectType.buildingPart
                ? AppLocalizations.of(context)!.buildingPartForm_add
                : AppLocalizations.of(context)!.measurementForm_add,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          icon: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        SizedBox(
          height: 500,
          width: widget.width,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            color: const Color.fromRGBO(255, 255, 255, 0.05),
            child: ListView(
              children: objects,
            ),
          ),
        )
      ],
    );
  }
}
