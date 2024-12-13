// import 'package:flutter/material.dart';
// // import 'login_screen.dart'; // Import LoginScreen
// import '../services/api_services.dart';
// import '../widgets/custom_text_field.dart';
// import '../widgets/custom_button.dart';
//
// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});
//
//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool isHovered = false;
//
//   String selectedRole = 'Admin';
//   bool isLoading = false;
//   bool isAgreedToTerms = false; // Tracks whether the user agrees to the terms and conditions
//
//   void _register() async {
//     String username = usernameController.text.trim();
//     String password = passwordController.text.trim();
//
//     if (username.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("All fields are required")),
//       );
//       return;
//     }
//
//     if (password.length < 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Password must be at least 6 characters long")),
//       );
//       return;
//     }
//
//     if (!isAgreedToTerms) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("You must agree to the terms and conditions")),
//       );
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       await ApiService.register(context, username, password, selectedRole);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: ${e.toString()}")),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [const Color(0xff7b1113), Colors.white],
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 32.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: 50),
//                 // Replacing "Create Account" text with a logo
//                 Image.asset(
//                   'assets/fdsap-logo.png', // Update this path to the correct logo location
//                   height: 200, // Adjust height as needed
//                   width: 200,  // Adjust width as needed
//                 ),
//                 // SizedBox(height: 10),
//                 // Text(
//                 //   "Register to get started",
//                 //   style: TextStyle(
//                 //     fontSize: 16,
//                 //     color: const Color.fromARGB(255, 3, 8, 18),
//                 //   ),
//                 // ),
//                 SizedBox(height: 40),
//                 CustomTextField(
//                   controller: usernameController,
//                   hintText: 'Username',
//                   prefixIcon: Icons.person_add_alt_1,
//                   prefixIconColor: const Color.fromARGB(255, 0, 0, 0),
//                   width: MediaQuery.of(context).size.width * 0.3, fillColor: ,
//                 ),
//                 SizedBox(height: 16),
//                 CustomTextField(
//                   controller: passwordController,
//                   hintText: 'Password',
//                   obscureText: true,
//                   prefixIcon: Icons.lock,
//                   prefixIconColor: const Color.fromARGB(255, 0, 0, 0),
//                   width: MediaQuery.of(context).size.width * 0.3,
//                 ),
//                 SizedBox(height: 24),
//                 Container(
//                   width: MediaQuery.of(context).size.width * 0.10, // Match TextField width
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Add padding for consistent height
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(color: Colors.grey, width: 1.0),
//                     borderRadius: BorderRadius.circular(8.0),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 4,
//                         offset: Offset(2, 2),
//                       ),
//                     ],
//                   ),
//                   child: DropdownButton<String>(
//                     value: selectedRole,
//                     isExpanded: true,
//                     underline: SizedBox(),
//                     icon: Icon(Icons.arrow_drop_down, color: Colors.black),
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                     ),
//                     items: <String>['Admin', 'Tech']
//                         .map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Center(
//                           child: Text(
//                             value,
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedRole = newValue!;
//                       });
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 24),
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Checkbox(
//                       value: isAgreedToTerms,
//                       onChanged: (bool? newValue) {
//                         setState(() {
//                           isAgreedToTerms = newValue!;
//                         });
//                       },
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: Text("Terms and Conditions"),
//                               content: SingleChildScrollView(
//                                 child: Text(
//                                   "Here are the terms and conditions of use. You must accept them to register. [Terms and conditions text here.]",
//                                 ),
//                               ),
//                               actions: [
//                                 TextButton(
//                                   child: Text("Close"),
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       },
//                       child: Text(
//                         "I agree to the terms and conditions",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 24),
//                 isLoading
//                     ? CircularProgressIndicator()
//                     : CustomButton(
//                   text: 'Register',
//                   onPressed: _register,
//                   width: MediaQuery.of(context).size.width * 0.3,
//                 ),
//                 SizedBox(height: 16),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, '/login');
//                   },
//                   child: Text(
//                     "Already have an account? Login",
//                     style: TextStyle(color: const Color.fromARGB(255, 3, 8, 18)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
