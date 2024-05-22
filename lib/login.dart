import 'package:flutter/material.dart';
import 'colors.dart'; 
import 'imput_text.dart';
import 'home.dart';
import 'forgot_password.dart';
import 'social_login_buttons.dart';
import 'package:frontend_marketplus/services/api_service.dart';
import 'package:frontend_marketplus/utils/validators.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService(baseUrl: 'http://localhost:9090'); 
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final response = await apiService.loginUser(
        emailController.text,
        passwordController.text,
      );
      if (response.statusCode == 200) {
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar sesión. Por favor, verifica tus credenciales.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(150.0),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), 
        flexibleSpace: ClipRRect(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(120),
              ),
            ),
            child: Stack(
              children: [
                _buildLeftImage(),
                _buildCenterText('Iniciar sesión', 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeftImage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 100),
        child: Image.asset(
          'assets/carrito_compras.png',
          width: 50,
          height: 50,
        ),
      ),
    );
  }

  Widget _buildCenterText(String text, double fontSize) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(  
      padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 0.0),  
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImputText(
              label: "Correo Electrónico",
              hintText: "correo@example.com",
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: Validators.validateEmail, 
            ),
            ImputText(
              label: 'Contraseña',
              hintText: "***********",
              controller: passwordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              validator: Validators.validatePassword, 
            ),
            _buildForgotPasswordButton(context),
            _buildLoginButton(context),
            const SizedBox(height: 40.0),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: SocialLoginButtons(
                onFacebookPressed: () {
                  
                },
                onGmailPressed: () {
                  
                },
                onLinkedInPressed: () {
                  
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
            );
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            foregroundColor: AppColors.black,  
          ),
          child: const Text(
            'Olvidaste tu contraseña',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Center(
        child: SizedBox(
          width: 218.0,
          child: OutlinedButton(
            onPressed: _login,
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.secondaryColor,
              foregroundColor: Colors.black,
              side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            child: const Text('Iniciar sesión'),
          ),
        ),
      ),
    );
  }
}
