import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/penaltyvalues.dart';
import 'package:qr_app/state/penaltyValues.dart';
import 'package:qr_app/utils/formUtils/customtextField.dart';

class PenaltyValuesScreen extends StatefulWidget {
  const PenaltyValuesScreen({super.key});

  @override
  State<PenaltyValuesScreen> createState() => _PenaltyValuesScreenState();
}

class _PenaltyValuesScreenState extends State<PenaltyValuesScreen> {
  @override
  void initState() {
    Provider.of<PenaltyValuesProvider>(context, listen: false).penaltyInit();
    Provider.of<PenaltyValuesProvider>(context, listen: false)
        .getPenaltyValues();
    super.initState();
  }

  //split
  List getPenaltyValuesSpit(String penalty) {
    List<String> penalties = penalty.split(",");

    return penalties;
  }

  //controller
  TextEditingController _penaltyValueController = TextEditingController();
  TextEditingController _penaltyEquivalentController = TextEditingController();

  //dialog
  showPenaltyDialog(
      String penaltyEquivalent, int penaltyValue, int id, bool isOpen) {
    setState(() {
      _penaltyValueController.text = penaltyValue.toString();
      _penaltyEquivalentController.text = penaltyEquivalent;
    });
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 200,
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Penalty Price',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  CustomTextField(
                      hintext: 'Penalty Price',
                      controller: _penaltyValueController,
                      keyBoardType: TextInputType.number,
                      isReadOnly: false,
                      height: 20),
                  Text(
                    'Penalty Equivalent',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextField(
                    controller: _penaltyEquivalentController,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Provider.of<PenaltyValuesProvider>(
                                    context,
                                    listen: false)
                                .updatePenaltyEquivalent(
                                    id,
                                    PenaltyValues(
                                        id: id,
                                        penaltyvalue:
                                            _penaltyEquivalentController.text,
                                        penaltyprice: int.parse(
                                            _penaltyValueController.text),
                                        isOpen: isOpen));

                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.deepPurpleAccent,
                                borderRadius: BorderRadius.circular(4.0)),
                            child: Center(child: Text('Save')),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Penalty Values'),
          centerTitle: true,
        ),
        body: Consumer<PenaltyValuesProvider>(
          builder: (context, provider, child) {
            List<PenaltyValues> penalty = provider.penaltyList;
            return Container(
              decoration: BoxDecoration(color: Colors.grey),
              child: ListView.builder(
                  itemCount: penalty.length,
                  itemBuilder: (context, index) {
                    var item = penalty.elementAt(index);
                    List itemPenalty = getPenaltyValuesSpit(item.penaltyvalue);

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            item.isOpen = !item.isOpen;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(30.0),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                      "${item.penaltyprice.toString()} ₱")),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                    child: !item.isOpen
                                        ? Text(
                                            item.penaltyvalue,
                                            style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: itemPenalty
                                                .map((e) => Text(e))
                                                .toList(),
                                          )),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                    onTap: () => showPenaltyDialog(
                                        item.penaltyvalue,
                                        item.penaltyprice,
                                        item.id,
                                        item.isOpen),
                                    child: Icon(Icons.edit_note)),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            );
          },
        ));
  }
}
