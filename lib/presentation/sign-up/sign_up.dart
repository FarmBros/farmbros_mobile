import 'package:farmbros_mobile/common/bloc/form/comnined_form_state.dart';
import 'package:farmbros_mobile/common/bloc/form/combined_form_cubit.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_notification_banner.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_button.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_input.dart';
import 'package:farmbros_mobile/data/models/sign_up_req_params.dart';
import 'package:farmbros_mobile/domain/usecases/sign_up_use_case.dart';
import 'package:farmbros_mobile/routing/routes.dart';
import 'package:farmbros_mobile/service_locator.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TapGestureRecognizer _tapGestureRecognizer;
  final TextEditingController username = TextEditingController();
  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()..onTap = _handlePress;
  }

  @override
  void dispose() {
    username.dispose();
    firstname.dispose();
    lastname.dispose();
    email.dispose();
    phoneNumber.dispose();
    password.dispose();
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  void _handlePress() {
    HapticFeedback.vibrate();
    context.go(Routes.signIn);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CombinedFormCubit, CombinedFormState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background-two.png"),
                    fit: BoxFit.cover)),
            child: Column(
              children: [
                // Notification Banner
                if (state is FormErrorState && state.generalError != null)
                  FarmbrosNotificationBanner(
                    message: state.generalError!,
                    color: ColorUtils.failureColor,
                  )
                else if (state is FormSuccessState)
                  const FarmbrosNotificationBanner(
                    message: "Account Created Successfully",
                    color: ColorUtils.successColor,
                  ),

                // Scrollable Form Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),

                        // Logo
                        Center(
                          child: Image(
                            height: 120,
                            width: 120,
                            image:
                                AssetImage("assets/images/farmbros-logo.png"),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Title
                        const Text(
                          "Create your Account",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Sign up to get started",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 32),

                        // Form Fields
                        FarmbrosInput(
                          controller: email,
                          label: "Email Address",
                          icon: FluentIcons.mail_48_regular,
                          isPassword: false,
                          isTextArea: false,
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: FarmbrosInput(
                                controller: firstname,
                                label: "First Name",
                                icon: FluentIcons.person_48_regular,
                                isPassword: false,
                                isTextArea: false,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FarmbrosInput(
                                controller: lastname,
                                label: "Last Name",
                                icon: FluentIcons.person_48_regular,
                                isPassword: false,
                                isTextArea: false,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        FarmbrosInput(
                          controller: username,
                          label: "Username",
                          icon: FluentIcons.person_48_regular,
                          isPassword: false,
                          isTextArea: false,
                        ),

                        const SizedBox(height: 16),

                        FarmbrosInput(
                          controller: phoneNumber,
                          label: "Phone Number",
                          icon: FluentIcons.call_48_regular,
                          isPassword: false,
                          isTextArea: false,
                        ),

                        const SizedBox(height: 16),

                        FarmbrosInput(
                          controller: password,
                          label: "Password",
                          icon: FluentIcons.key_32_regular,
                          isPassword: true,
                          isTextArea: false,
                        ),

                        const SizedBox(height: 24),

                        // Sign Up Button
                        FarmbrosButton(
                          label: "Sign Up",
                          buttonColor: ColorUtils.secondaryColor,
                          textColor: ColorUtils.primaryTextColor,
                          fontWeight: FontWeight.bold,
                          onPressed: () {
                            final signUpParams = SignUpReqParams(
                              username: username.text.trim(),
                              firstName: firstname.text.trim(),
                              lastName: lastname.text.trim(),
                              fullName:
                                  "${firstname.text.trim()} ${lastname.text.trim()}",
                              email: email.text.trim().toLowerCase(),
                              phoneNumber: phoneNumber.text.trim(),
                              password: password.text,
                            );

                            context.read<CombinedFormCubit>().execute(
                                  signUpParams,
                                  sl<SignUpUseCase>(),
                                );
                          },
                          elevation: 2,
                        ),

                        const SizedBox(height: 24),

                        // Divider with text
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade300,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "or continue with",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade300,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Google Sign In
                        InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Image(
                                height: 32,
                                width: 32,
                                image:
                                    AssetImage("assets/images/google_logo.png"),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Sign In Link
                        Center(
                          child: Text.rich(
                            TextSpan(
                              text: "Already have an account? ",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              children: [
                                TextSpan(
                                  text: "Sign In",
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: _tapGestureRecognizer,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
