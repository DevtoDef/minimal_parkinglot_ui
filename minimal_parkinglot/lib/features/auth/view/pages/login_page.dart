import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimal_parkinglot/core/theme/app_pallete.dart';
import 'package:minimal_parkinglot/features/auth/model/user_model.dart';
import 'package:minimal_parkinglot/features/auth/view/pages/signup_page.dart';
import 'package:minimal_parkinglot/features/auth/view/widgets/custom_textfield.dart';
import 'package:minimal_parkinglot/features/auth/view/widgets/gradient_button.dart';
import 'package:minimal_parkinglot/features/auth/view/widgets/loader.dart';
import 'package:minimal_parkinglot/features/auth/view/widgets/utils.dart';
import 'package:minimal_parkinglot/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:minimal_parkinglot/features/home/view/pages/home_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      authViewmodelProvider.select((val) => val?.isLoading == true),
    );
    ref.listen(authViewmodelProvider, (_, next) {
      next?.when(
        data: (UserModel data) {
          showSnackBar(
            context,
            '${data.username} đã đăng nhập thành công!',
            backgroundColor: Pallete.whiteColor,
          );
          //Navigate to HomePage or any other page after successful login
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (_) => false,
          );
        },
        error: (error, stackTrace) {
          showSnackBar(context, error.toString(), backgroundColor: Colors.red);
        },
        loading: () {},
      );
    });
    return Scaffold(
      appBar: AppBar(),
      body:
          isLoading
              ? const Loader()
              : Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Login',
                        style: TextStyle(
                          color: Pallete.gradient2,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomTextfield(
                        controller: usernameController,
                        hintText: 'Username',
                      ),
                      const SizedBox(height: 20),
                      CustomTextfield(
                        controller: passwordController,
                        hintText: 'Password',
                        isObscureText: true,
                      ),
                      const SizedBox(height: 20),
                      GradientButton(
                        buttonText: 'Login',
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            // Handle login logic here
                            await ref
                                .read(authViewmodelProvider.notifier)
                                .login(
                                  username: usernameController.text,
                                  password: passwordController.text,
                                );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account? ',
                          style: const TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                              text: 'Sign Up',
                              style: const TextStyle(
                                color: Pallete.gradient2,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      // Navigate to Sign Up page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const SignupPage(),
                                        ),
                                      );
                                    },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
