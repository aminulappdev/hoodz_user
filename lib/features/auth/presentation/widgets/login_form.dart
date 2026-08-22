// import 'package:flutter/material.dart';

// import '../../../../core/constants/app_strings.dart';
// import '../../../../core/widgets/app_primary_button.dart';
// import '../controllers/login_controller.dart';

// class LoginForm extends StatefulWidget {
//   const LoginForm({
//     super.key,
//     required this.controller,
//     required this.onSuccess,
//   });

//   final LoginController controller;
//   final ValueChanged<String> onSuccess;

//   @override
//   State<LoginForm> createState() => _LoginFormState();
// }

// class _LoginFormState extends State<LoginForm> {
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   String? _message;

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() {
//       _message = null;
//     });

//     await widget.controller.login(
//       phone: _phoneController.text.trim(),
//       password: _passwordController.text.trim(),
//     );

//     if (!mounted) {
//       return;
//     }

//     setState(() {
//       _message = 'Logged in as ${widget.controller.lastRole}';
//     });

//     final role = widget.controller.lastRole;
//     if (role != null) {
//       widget.onSuccess(role);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             AppStrings.loginTitle,
//             style: Theme.of(context).textTheme.headlineSmall,
//           ),
//           const SizedBox(height: 8),
//           Text(
//             AppStrings.loginSubtitle,
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//           const SizedBox(height: 24),
//           TextFormField(
//             controller: _phoneController,
//             decoration: const InputDecoration(
//               labelText: 'Phone',
//               hintText: '01XXXXXXXXX',
//             ),
//             validator: (value) {
//               if (value == null || value.trim().isEmpty) {
//                 return 'Phone is required';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 16),
//           TextFormField(
//             controller: _passwordController,
//             obscureText: true,
//             decoration: const InputDecoration(
//               labelText: 'Password',
//             ),
//             validator: (value) {
//               if (value == null || value.trim().isEmpty) {
//                 return 'Password is required';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 20),
//           AppPrimaryButton(
//             label: 'Login',
//             onPressed: _submit,
//           ),
//           if (_message != null) ...[
//             const SizedBox(height: 16),
//             Text(_message!),
//           ],
//         ],
//       ),
//     );
//   }
// }
