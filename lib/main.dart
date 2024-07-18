import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UPI to QR Code Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,

      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 221, 252),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 229, 197, 222),
        title: Text('UPI to QR Code Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            UPIForm(),
            SizedBox(height: 20),
            QRCodeDisplay(),
          ],
        ),
      ),
    );
  }
}

final upiFormProvider = StateNotifierProvider<UPIFormNotifier, UPIFormState>((ref) {
  return UPIFormNotifier();
});

class UPIFormNotifier extends StateNotifier<UPIFormState> {
  UPIFormNotifier() : super(UPIFormState());

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateUpiId(String upiId) {
    state = state.copyWith(upiId: upiId);
  }

  void updateAmount(String amount) {
    state = state.copyWith(amount: amount);
  }
}

class UPIFormState {
  final String name;
  final String upiId;
  final String amount;

  UPIFormState({
    this.name = '',
    this.upiId = '',
    this.amount = '',
  });

  UPIFormState copyWith({
    String? name,
    String? upiId,
    String? amount,
  }) {
    return UPIFormState(
      name: name ?? this.name,
      upiId: upiId ?? this.upiId,
      amount: amount ?? this.amount,
    );
  }

  String generateUPIString() {
    return 'upi://pay?pa=$upiId&pn=$name&am=$amount';
  }
}

class UPIForm extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(upiFormProvider);

    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Merchant / Payee Name',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)
                ),
              ),
            ),
          onChanged: (value) => ref.read(upiFormProvider.notifier).updateName(value),
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'UPI ID',
            prefixIcon: Icon(Icons.payment),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)
                ),
              ),
            ),
          onChanged: (value) => ref.read(upiFormProvider.notifier).updateUpiId(value),
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Transaction Amount',
            prefixIcon: Icon(Icons.monetization_on),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)
                ),
              ),
            ),
          keyboardType: TextInputType.number,
          onChanged: (value) => ref.read(upiFormProvider.notifier).updateAmount(value),
        ),
        
      ],
    );
  }
}

class QRCodeDisplay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(upiFormProvider);
    final upiString = formState.generateUPIString();

    return Container(
    
      //margin: EdgeInsetsDirectional.all(10),
    decoration: BoxDecoration(
    border: Border.all(
      color: Colors.black,
      width: 5.0,
    ),
    borderRadius: BorderRadius.circular(15.0),
  ),
      child: Center(
        child: QrImageView(
        data: upiString,
        version: QrVersions.auto,
        size: 200.0,
      ),
      ),
    );
  }
}
