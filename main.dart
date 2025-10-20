
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(PayUIDemoApp());
}

class PayUIDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaytmUI Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade800),
        scaffoldBackgroundColor: Color(0xFFF5F7FB),
        primaryColor: Colors.indigo.shade800,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => LoginScreen(),
        '/otp': (_) => OTPScreen(),
        '/home': (_) => HomeScreen(),
        '/recharge': (_) => RechargeScreen(),
        '/payment': (_) => PaymentScreen(),
      },
    );
  }
}


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _valid = false;

  void _check() {
    setState(() {
      _valid = RegExp(r"^[0-9]{10}").hasMatch(_phoneController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Row(
                children: [
                  CircleAvatar(child: Icon(Icons.person), backgroundColor: Colors.indigoAccent),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome back', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                        Text('Sign in or create an account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Text('Login with phone', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  prefixText: '+91 ',
                  hintText: 'Enter mobile number',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                onChanged: (_) => _check(),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _valid
                    ? () {
                  Navigator.pushNamed(context, '/otp', arguments: _phoneController.text);
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Send OTP'),
              ),
              SizedBox(height: 18),
              Center(child: Text('Or continue with', style: TextStyle(color: Colors.grey[600]))),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _socialButton(Icons.mail_outline, 'Email'),
                  _socialButton(Icons.fingerprint, 'Biometric'),
                  _socialButton(Icons.lock_outline, 'Password'),
                ],
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('By continuing you agree to our Terms & Privacy.', style: TextStyle(fontSize: 12, color: Colors.grey[600]), textAlign: TextAlign.center),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(backgroundColor: Colors.white, child: Icon(icon, color: Colors.indigo)),
        SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }
}

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  late String phone;
  bool _enabled = false;
  Timer? _timer;
  int _seconds = 30;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    phone = ModalRoute.of(context)!.settings.arguments as String? ?? '';
    _startTimer();
  }

  void _startTimer() {
    _seconds = 30;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        if (_seconds > 0) _seconds--; else t.cancel();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _check() {
    setState(() {
      _enabled = RegExp(r"^[0-9]{4}").hasMatch(_otpController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify '+phone),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text('Enter the 4-digit code sent to your number', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, letterSpacing: 8),
              decoration: InputDecoration(counterText: ''),
              onChanged: (_) => _check(),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _enabled
                  ? () {
                
                Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
              }
                  : null,
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: Text('Verify & Continue'),
            ),
            SizedBox(height: 12),
            if (_seconds > 0) Text('Resend OTP in $_seconds s', style: TextStyle(color: Colors.grey[600])),
            if (_seconds == 0)
              TextButton(onPressed: () { _startTimer(); }, child: Text('Resend OTP'))
          ],
        ),
      ),
    );
  }
}


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_selectedTab) {
      case 0:
        body = HomeContent();
        break;
      case 1:
        body = Center(child: Text('Scan (mock)', style: TextStyle(fontSize: 18)));
        break;
      case 2:
        body = HistoryScreen();
        break;
      default:
        body = HomeContent();
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(86),
        child: AppBar(
          flexibleSpace: Container(
            padding: EdgeInsets.fromLTRB(16, 32, 16, 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.indigo.shade900, Colors.indigo.shade600], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
            ),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: Colors.white.withOpacity(0.2), child: Icon(Icons.location_on, color: Colors.white)),
                SizedBox(width: 12),
                Expanded(child: Text('B-297 New Ashok Nagar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                IconButton(onPressed: () {}, icon: Icon(Icons.search, color: Colors.white)),
                Stack(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.notifications, color: Colors.white)),
                    Positioned(right: 10, top: 10, child: CircleAvatar(radius: 6, backgroundColor: Colors.orange))
                  ],
                )
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (i) => setState(() => _selectedTab = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: CircleAvatar(backgroundColor: Colors.indigo, child: Icon(Icons.qr_code, color: Colors.white)), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // made by Laraib Hussain
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.indigo.shade700, Colors.indigo.shade400]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.qr_code_scanner, size: 48, color: Colors.white),
                  SizedBox(height: 8),
                  Text('Quick Scan To Pay', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text('Tap to scan a merchant QR', style: TextStyle(color: Colors.white70))
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
      
          Row(
            children: [
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Credit Card-9685', style: TextStyle(fontWeight: FontWeight.w600)), ElevatedButton(onPressed: () {}, child: Text('Pay'))]),
                      SizedBox(height: 8),
                      Text('₹1200 due on Wed, 25 Jan', style: TextStyle(color: Colors.grey[700]))
                    ]),
                  ),
                ),
              ),
              SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(width: 100, height: 72, color: Colors.white, child: Center(child: Text('My Bills'))),
              )
            ],
          ),
          SizedBox(height: 16),
          
          Text('Money Transfers', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _serviceIcon(Icons.person, 'Pay to\nContact'),
                  _serviceIcon(Icons.account_balance, 'To Bank/\nUPI ID'),
                  _serviceIcon(Icons.sync_alt, 'Self\nAccount'),
                  _serviceIcon(Icons.account_balance_wallet, 'Check\nBalance'),
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
          
          Text('Popular', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _smallIcon(Icons.phone_android, 'Mobile\nRecharge'),
                  _smallIcon(Icons.directions_car, 'FASTag\nRecharge'),
                  _smallIcon(Icons.satellite, 'DTH'),
                  _smallIcon(Icons.money_off, 'Loan\nRepayment'),
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
          // Wallet & Offers row
          Row(
            children: [
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Wallet', style: TextStyle(fontWeight: FontWeight.w700)), Text('₹2,399')]),
                      SizedBox(height: 8),
                      Row(children: [Expanded(child: ElevatedButton(onPressed: () {}, child: Text('Add Money'))), SizedBox(width: 8), OutlinedButton(onPressed: () {}, child: Text('Send'))])
                    ]),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Container(height: 112, child: Center(child: Text('Offers\nand Cashbacks', textAlign: TextAlign.center))),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
        
          Text('Offers for you', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          SizedBox(height: 8),
          SizedBox(
            height: 110,
            child: PageView(
              controller: PageController(viewportFraction: 0.85),
              children: List.generate(4, (i) => _offerCard(i)),
            ),
          ),
          SizedBox(height: 18),
          
          Text('Utilities', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _smallIcon(Icons.lightbulb_outline, 'Electricity'),
                  _smallIcon(Icons.water_drop, 'Water'),
                  _smallIcon(Icons.gas_meter, 'Gas'),
                  _smallIcon(Icons.security, 'Insurance'),
                ],
              ),
            ),
          ),
          SizedBox(height: 32),
          
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/recharge'),
            style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: Text('Recharge / Pay'),
          ),
          SizedBox(height: 36)
        ],
      ),
    );
  }

  Widget _serviceIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(backgroundColor: Colors.indigo.shade50, child: Icon(icon, color: Colors.indigo)),
        SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _smallIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.indigo),
        SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _offerCard(int i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), gradient: LinearGradient(colors: [Colors.deepPurple.shade300, Colors.indigo.shade300])),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Flat ${10 + i * 5}% OFF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 6),
              Text('On mobile & DTH recharges', style: TextStyle(color: Colors.white70))
            ])),
            Icon(Icons.local_offer, color: Colors.white, size: 36)
          ]),
        ),
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemBuilder: (context, index) => ListTile(
        leading: CircleAvatar(child: Icon(Icons.receipt)),
        title: Text('Payment to Merchant ${index + 1}'),
        subtitle: Text('12 Jan 2025 • UPI'),
        trailing: Text('- ₹${(index + 1) * 120}'),
      ),
      separatorBuilder: (_, __) => Divider(),
      itemCount: 8,
    );
  }
}

class RechargeScreen extends StatefulWidget {
  @override
  _RechargeScreenState createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  String _operator = 'Auto-detect';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mobile Recharge'), backgroundColor: Colors.indigo.shade700, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _mobile, keyboardType: TextInputType.phone, maxLength: 10, decoration: InputDecoration(labelText: 'Mobile number', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
          SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _operator,
            items: ['Auto-detect', 'Jio', 'Airtel', 'Vodafone'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => _operator = v!),
            decoration: InputDecoration(labelText: 'Operator', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
          ),
          SizedBox(height: 12),
          TextField(controller: _amount, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Amount', hintText: '₹', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
          SizedBox(height: 18),
          ElevatedButton(
            onPressed: () {
              if (_mobile.text.length == 10 && _amount.text.isNotEmpty) {
                Navigator.pushNamed(context, '/payment', arguments: {'to': _mobile.text, 'amount': _amount.text, 'type': 'recharge'});
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter valid details')));
              }
            },
            style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: Text('Proceed to Pay'),
          )
        ]),
      ),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _useWallet = false;
  String to = '';
  String amount = '';
  String type = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};
    to = args['to']?.toString() ?? '';
    amount = args['amount']?.toString() ?? '0';
    type = args['type']?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confirm Payment'), backgroundColor: Colors.indigo.shade700, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ListTile(leading: CircleAvatar(child: Icon(Icons.phone)), title: Text(type == 'recharge' ? 'Recharge to $to' : 'Pay to $to'), subtitle: Text('Operator / Merchant')),
          SizedBox(height: 12),
          Text('Amount', style: TextStyle(color: Colors.grey[700])),
          SizedBox(height: 6),
          Text('₹$amount', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          SizedBox(height: 14),
          Row(children: [
            Checkbox(value: _useWallet, onChanged: (v) => setState(() => _useWallet = v!)),
            Text('Use Wallet (₹2399 available)')
          ]),
          SizedBox(height: 18),
          Text('Payment Methods', style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(height: 12),
          Card(
            child: ListTile(leading: Icon(Icons.account_balance_wallet), title: Text('Paytm Wallet'), subtitle: Text('Instant'), trailing: Radio(value: 'wallet', groupValue: _useWallet ? 'wallet' : 'upi', onChanged: (_) {})),
          ),
          Card(child: ListTile(leading: Icon(Icons.account_balance), title: Text('UPI / Bank'), trailing: Radio(value: 'upi', groupValue: _useWallet ? 'wallet' : 'upi', onChanged: (_) {}))),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              showDialog(context: context, builder: (_) => AlertDialog(title: Text('Payment Success'), content: Text('Paid ₹$amount successfully'), actions: [TextButton(onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/home')), child: Text('Done'))]));
            },
            style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: Text('Pay ₹$amount'),
          )
        ]),
      ),
    );
  }
}
