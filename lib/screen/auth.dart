import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen ({super.key});

@override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

  class _AuthScreenState extends State<AuthScreen> {
    final _formKey = GlobalKey<FormState>();

    var _isLogin = true;
    var _enteredEmail = '';
    var _enteredPassword = '';

    void _submit () async {
      final isValid = _formKey.currentState!.validate();

      if(!isValid) {
        return;
      }
        _formKey.currentState!.save();

      try{
        if(_isLogin) {
        await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);
      } else {
          await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);
        } 
        } on FirebaseAuthException catch (e) {
          if(e.code == 'email-already-in-use') {
          
          }
          if (!mounted) return;
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.message ?? 'Authentication Faild.')));
      } 
    }

    @override
    Widget build (BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top:30,
                    bottom: 30,
                    left: 20,
                    right: 20,
                  ),
                  width: 250,
                  child: Image.asset('assets/image/logo.png'),
                ),
                Card(
                  margin: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email Address'
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty || !value.contains('@')) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredEmail = value!;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                              ),
                              obscureText: true,
                              validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                  return 'Password must be at 6 characters long.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredPassword = value!;
                              },
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                .colorScheme.primaryContainer
                              ),
                              child: Text( _isLogin ? 'Login' : 'Singup'),
                              ),
                            TextButton(
                              onPressed: (){
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              }, 
                              child: Text( _isLogin ? 'Create an account' : 'I already have an account.')
                              ),
                          ],
                        )))
                  )
                ),
              ],
            ),
          )
        ),
      );
    }
  }