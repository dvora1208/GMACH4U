import 'package:flutter/material.dart';
import 'package:gmach1/utils/const.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class PurchaseProductScreen extends StatefulWidget {
  @override
  _PurchaseProductScreenState createState() => _PurchaseProductScreenState();
}

class _PurchaseProductScreenState extends State<PurchaseProductScreen> {

  CountdownController _countDownController;

  @override
  void initState() {
    super.initState();
    _countDownController = CountdownController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Purchase Item")),
      body: Column(
        children: [
          _timer(),
          _details(),
          _purchaseButton(),
        ],
      ),
    );
  }

  Widget _timer() {
    return Countdown(
      controller: _countDownController,
      seconds: Consts.TIME_To_PURCHASE,
      build: (BuildContext context, double time) {
        return Text(time.toString());
      },
      interval: Duration(milliseconds: 1000),
      onFinished: () {
        print('Timer is done!');
      },
    );
  }

  Widget _details(){
    return Text("details");
  }

  Widget _purchaseButton(){
    return Center(
      child: ElevatedButton(
        onPressed: () => _purchase(),
        child: Text("Ask to save product"),
      ),
    );
  }

  _purchase(){
    // check if can borrow
  }
}
