import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrintPage extends StatefulWidget {
  const PrintPage({super.key, required this.purchasedList});

  final List<Map<String, dynamic>> purchasedList;

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> _device = [];
  late String _deviceMsg;
  final f = NumberFormat("\$ ###,###.00", "en-us");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initPrinter());
  }

  Future<void> initPrinter() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 2));

    if (!mounted) return;
    bluetoothPrint.scanResults.listen((event) {
      if (!mounted) return;
      setState(() {
        _device = event;
      });

      if (_device.isEmpty) {
        _deviceMsg = 'No Devices';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bluetooth Printer"),
      ),
      body: _device.isEmpty
          ? Center(
              child: Text(_deviceMsg ?? ''),
            )
          : ListView.builder(
              itemCount: _device.length,
              itemBuilder: (context, index) => ListTile(
                leading: Icon(Icons.print),
                title: Text(_device[index].name.toString()),
                subtitle: Text(
                  _device[index].address.toString(),
                ),
                onTap: () {
                  _startPrint(_device[index]);
                },
              ),
            ),
    );
  }

  Future<void> _startPrint(BluetoothDevice device) async {
    if (device != null && device.address != null) {
      await bluetoothPrint.connect(device);

      Map<String, dynamic> config = Map();

      List<LineText> list = [];

      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'Purchased Items',
          width: 2,
          height: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1));

      for (int i = 0; i < widget.purchasedList.length; i++) {
        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: widget.purchasedList[i]['title'],
            width: 0,
            linefeed: 1,
            align: LineText.ALIGN_LEFT));

        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content:
                "${f.format(this.widget.purchasedList[i]['price'])} X ${this.widget.purchasedList[i]['qty']}",
            linefeed: 1,
            align: LineText.ALIGN_RIGHT,
            width: 0));
      }
    }
  }
}
