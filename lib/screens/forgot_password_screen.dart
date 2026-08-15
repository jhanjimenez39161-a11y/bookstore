import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _correoController =
      TextEditingController();

  bool _enviando = false;

  @override
  void dispose() {
    _correoController.dispose();
    super.dispose();
  }

  Future<void> _enviarRecuperacion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _enviando = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
          'http://10.0.2.2:3000/api/recuperar-password',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'correo': _correoController.text.trim(),
        }),
      );

      if (!mounted) {
        return;
      }

      if (response.statusCode == 200) {
        final datos =
            jsonDecode(response.body)
                as Map<String, dynamic>;

        setState(() {
          _enviando = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              datos['mensaje']?.toString() ??
                  'Solicitud enviada correctamente.',
            ),
          ),
        );

        Navigator.pop(context);
      } else {
        setState(() {
          _enviando = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No fue posible procesar la solicitud.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _enviando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No fue posible conectarse con el servidor.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar contraseña'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),

                const Icon(
                  Icons.lock_reset,
                  size: 80,
                  color: Colors.indigo,
                ),

                const SizedBox(height: 20),

                const Text(
                  'Recuperar contraseña',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Ingresa tu correo electrónico y '
                  'te enviaremos un enlace para '
                  'recuperar tu contraseña.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: _correoController,
                  keyboardType:
                      TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    hintText: 'ejemplo@correo.com',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final correo =
                        value?.trim() ?? '';

                    if (correo.isEmpty) {
                      return 'Ingresa tu correo electrónico';
                    }

                    if (!correo.contains('@') ||
                        !correo.contains('.')) {
                      return 'Ingresa un correo válido';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 28),

                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _enviando
                        ? null
                        : _enviarRecuperacion,
                    icon: _enviando
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.email),
                    label: Text(
                      _enviando
                          ? 'Enviando...'
                          : 'Enviar enlace',
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: _enviando
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  child: const Text(
                    'Volver al inicio de sesión',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}