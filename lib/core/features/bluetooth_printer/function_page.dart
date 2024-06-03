import 'dart:convert';

import 'package:bluetooth_print_plus/bluetooth_print_model.dart';
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexus_estoque/core/features/bluetooth_printer/command_tool.dart';

enum CmdType { Tsc, Cpcl, Esc }

class FunctionPage extends StatefulWidget {
  final BluetoothDevice device;

  const FunctionPage(this.device, {super.key});

  @override
  State<FunctionPage> createState() => _FunctionPageState();
}

class _FunctionPageState extends State<FunctionPage> {
  CmdType cmdType = CmdType.Tsc;

  @override
  void dispose() {
    super.dispose();

    //BluetoothPrintPlus.instance.disconnect();
    print("FunctionPage dispose");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name ?? ""),
      ),
      body: Column(
        children: [
          buildRadioGroupRowWidget(),
          const SizedBox(
            height: 20,
          ),
          if (cmdType == CmdType.Tsc)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      final cmd = await CommandTool.tscSelfTestCmd();
                      BluetoothPrintPlus.instance.write(cmd);
                    },
                    child: const Text("selfTest")),
                ElevatedButton(
                    onPressed: () async {
                      String source = """

^^XA
~TA000
~JSN
^LT0
^MNW
^MTT
^PON
^PMN
^LH0,0
^JMA
^PR4,4
~SD15
^JUS
^LRN
^CI27
^PA0,1,1,0
^XZ
^XA
^MMT
^PW799
^LL799
^LS0
^FT24,76^A0N,28,23^FH^CI28^FDData Geração:^FS^CI27
^FT24,117^A0N,28,23^FH^CI28^FDCódigo do Produto: ^FS^CI27
^FT24,443^A0N,28,33^FH^CI28^FDDescrição do Produto:^FS^CI27
^FT24,171^A0N,28,23^FH^CI28^FDValidade:^FS^CI27
^FT535,76^A0N,28,28^FH^CI28^FDCódigo da Caixa: ^FS^CI27
^FT19,315^A0N,43,51^FH^CI28^FDPicking: ^FS^CI27
^FO208,265^GB110,101,2^FS
^FO317,265^GB111,101,2^FS
^FO428,265^GB116,101,2^FS
^FO544,265^GB111,101,2^FS
^FO654,265^GB117,101,2^FS
^FT24,215^A0N,28,23^FH^CI28^FDUsuário: ^FS^CI27
^FT0,532^A0N,66,35^FB753,1,17,C^FH^CI28^FDLUBRAX TOP TURBO ESSEN 15W40 CI4 BB 20L5C&^FS^CI27 
^BY3,3,107^FT208,692^BCN,,Y,N
^FH^FD>;789134401613>69^FS
^BY2,3,55^FT517,153^BCN,,Y,N
^FH^FD>;789134401613>69^FS
^FT208,339^A0N,61,117^FH^CI28^FD0211120008^FS^CI27
^FT169,77^A0N,24,30^FH^CI28^FD06/05/2024^FS^CI27
^FT219,118^A0N,24,30^FH^CI28^FD1025002^FS^CI27
^FT134,172^A0N,24,30^FH^CI28^FD06/05/2024^FS^CI27
^FT117,215^A0N,28,23^FH^CI28^FDWMS^FS^CI27
^PQ1,0,1,Y
^XZ

 """;

                      List<int> list = utf8.encode(source);
                      Uint8List bytes = Uint8List.fromList(list);
                      BluetoothPrintPlus.instance.write(bytes);
                    },
                    child: const Text("zpl")),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    final ByteData bytes =
                        await rootBundle.load("assets/dithered-image.png");
                    final Uint8List image = bytes.buffer.asUint8List();
                    Uint8List? cmd;
                    switch (cmdType) {
                      case CmdType.Cpcl:
                        cmd = await CommandTool.tscImageCmd(image);
                        break;
                      case CmdType.Cpcl:
                        cmd = await CommandTool.cpclImageCmd(image);
                        break;
                      case CmdType.Esc:
                        cmd = await CommandTool.escImageCmd(image);
                        break;
                    }
                    BluetoothPrintPlus.instance.write(cmd);
                  },
                  child: const Text("image")),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    Uint8List? cmd;
                    switch (cmdType) {
                      case CmdType.Tsc:
                        cmd = await CommandTool.tscTemplateCmd();
                        break;
                      case CmdType.Cpcl:
                        cmd = await CommandTool.cpclTemplateCmd();
                        break;
                      case CmdType.Esc:
                        break;
                    }

                    BluetoothPrintPlus.instance.write(cmd);
                    print("getCommand $cmd");
                  },
                  child: const Text("text/QR_code/barcode")),
            ],
          )
        ],
      ),
    );
  }

  Row buildRadioGroupRowWidget() {
    return Row(children: [
      const Text("command type"),
      ...CmdType.values
          .map((e) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    value: e,
                    groupValue: cmdType,
                    onChanged: (v) {
                      setState(() {
                        cmdType = e;
                      });
                    },
                  ),
                  Text(e.toString().split(".").last)
                ],
              ))
          .toList()
    ]);
  }
}
