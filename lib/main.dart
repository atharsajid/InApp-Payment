import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const platform = MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/1.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          // appBar: AppBar(
          //   title: const Text(''),
          //   backgroundColor: Colors.blue.shade900,
          // ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                margin: EdgeInsets.only(top: 100),
                child: Text(
                  
                  'InApp Payment',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                    letterSpacing: 2,
                  
                      
                    
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 80),
                width: double.infinity,
                child: Text(
                  'Click Here to Pay',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                    letterSpacing: 2,
                  
                      
                    
                  ),
                ),
              ),
            ],
          ),

          floatingActionButton: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(220, 50),
              backgroundColor: Colors.lightBlue,
              side: const BorderSide(color: Colors.transparent, width: 2),
            ),
            onPressed: () {
              openCheckout();
            },
            icon: const Icon(
              Icons.payment,
              color: Colors.white,
              size: 28,
            ),
            label: const Text(
              'Pay',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_live_ILgsfZCZoFIKMb',
      'amount': 1000,
      'name': 'Nike Shoe.',
      'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'atharsajid@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }
}
