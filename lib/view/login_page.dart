
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:platiz_store/provider/auth_provider.dart';
import 'package:platiz_store/view/home_page.dart';
import 'package:platiz_store/view/register_page.dart';

class LoginPage extends ConsumerWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  LoginPage({super.key});

  @override
  Widget build(BuildContext context,ref) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: FormBuilder(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'email',
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ]),
                  ),
                  SizedBox(height: 10,),
                  FormBuilderTextField(
                    name: 'password',
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(onPressed: (){
                    FocusScope.of(context).unfocus();
                    print(_formKey.currentState?.value);
                    if (_formKey.currentState?.saveAndValidate() ?? true) {
                      final js = _formKey.currentState?.value!;
                      ref.read(signUpProvider.notifier).signIn(json: js!);
                    }
                  }, child: Text('SignIn')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Don\'t have an account? '),
                      TextButton(onPressed: (){
                        Get.to(()=>RegisterPage());
                      }, child: Text('SignUp')),
                    ],)
                ],
              ),
            ),
          ),
        )
    );
  }
}
