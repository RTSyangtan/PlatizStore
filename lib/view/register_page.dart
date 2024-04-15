
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:platiz_store/provider/auth_provider.dart';
import 'package:platiz_store/view/login_page.dart';

class RegisterPage extends ConsumerWidget{
  final _formKey = GlobalKey<FormBuilderState>();
  final String temp = '';
  RegisterPage({super.key});

  @override
  Widget build(BuildContext context,ref) {
  final state = ref.watch(signUpProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top:20),
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
                  if (_formKey.currentState?.saveAndValidate() ?? true) {
                    final js = _formKey.currentState?.value!;
                    if(state.hasError){
                      if(state.error=='email-already-in-use'){
                        print('----------------');
                      }
                      print(state.asError);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error.toString()),
                        ),
                      );
                      print(state.error);
                    }else{
                      ref.read(signUpProvider.notifier).signUp(json: js!);
                      //Get.to(()=>LoginPage());
                    }

                  }
                }, child: Text('SignUp')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                  Text('Already have an account? '),
                  TextButton(onPressed: (){
                    Get.back();
                  }, child: Text('Login')),
                ],)
              ],
            ),
          ),
        ),
      )
    );
  }
}
