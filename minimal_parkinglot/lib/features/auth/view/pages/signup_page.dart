import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal_parkinglot/core/theme/app_pallete.dart';
import 'package:minimal_parkinglot/features/auth/view/pages/login_page.dart';
import 'package:minimal_parkinglot/features/auth/view/widgets/custom_textfield.dart';
import 'package:minimal_parkinglot/features/auth/view/widgets/gradient_button.dart';
import 'package:minimal_parkinglot/features/auth/view/widgets/loader.dart';
import 'package:minimal_parkinglot/features/auth/view/widgets/utils.dart';
import 'package:minimal_parkinglot/features/auth/viewmodel/auth_viewmodel.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
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
        data: (data) {
          showSnackBar(
            context,
            '${data.username} đã đăng ký thành công!',
            backgroundColor: Pallete.whiteColor,
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
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
              ? Loader()
              : Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Pallete.gradient2,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomTextfield(
                        controller: emailController,
                        hintText: 'Email',
                      ),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 30),
                      GradientButton(
                        buttonText: 'Sign Up',
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            // Handle sign up logic here
                            await ref
                                .read(authViewmodelProvider.notifier)
                                .signup(
                                  email: emailController.text,
                                  username: usernameController.text,
                                  password: passwordController.text,
                                );
                          }
                        },
                      ),
                      const SizedBox(height: 15),
                      RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: const TextStyle(
                                color: Pallete.gradient2,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      // Navigate to login page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const LoginPage(),
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
