import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill with admin credentials for demo
    _emailController.text = 'admin@vehicleservice.com';
    _passwordController.text = 'Password@123';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        context.go(AppRoutes.dashboard);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 400,
            margin: const EdgeInsets.all(AppSizes.lg),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.xl),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo and title
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.build_circle,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: AppSizes.lg),
                      
                      Text(
                        'Vehicle Service Center',
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      
                      Text(
                        'Management System',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.xl),
                      
                      // Login form
                      Text(
                        'Sign in to your account',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.lg),
                      
                      // Email field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          hintText: 'Enter your email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.md),
                      
                      // Password field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _handleLogin(),
                      ),
                      const SizedBox(height: AppSizes.xl),
                      
                      // Login button
                      SizedBox(
                        height: AppSizes.buttonHeight,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Sign In'),
                        ),
                      ),
                      const SizedBox(height: AppSizes.lg),
                      
                      // Demo credentials info
                      Container(
                        padding: const EdgeInsets.all(AppSizes.md),
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: AppTheme.primaryColor,
                                ),
                                const SizedBox(width: AppSizes.xs),
                                Text(
                                  'Demo Credentials',
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSizes.xs),
                            Text(
                              'Email: admin@vehicleservice.com\nPassword: Password@123',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}