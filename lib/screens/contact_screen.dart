import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  Future<void> _abrirWhatsApp(BuildContext context) async {
    final Uri url = Uri.parse(
      'https://wa.me/573000000000?text=Hola%20BookStore,%20necesito%20ayuda%20con%20mi%20pedido.',
    );

    try {
      final abierto = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!abierto && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No fue posible abrir WhatsApp.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No fue posible abrir WhatsApp.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacto y soporte'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),

            const Icon(
              Icons.support_agent,
              size: 90,
              color: Colors.indigo,
            ),

            const SizedBox(height: 20),

            const Text(
              'Â¿Necesitas ayuda?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Nuestro equipo de BookStore estÃ¡ disponible '
              'para ayudarte con tus pedidos y resolver tus dudas.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 35),

            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.chat,
                      size: 50,
                      color: Colors.green,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'WhatsApp',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'ContÃ¡ctanos directamente por WhatsApp '
                      'para recibir atenciÃ³n.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _abrirWhatsApp(context);
                        },
                        icon: const Icon(Icons.chat),
                        label: const Text(
                          'Contactar por WhatsApp',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.email,
                      size: 40,
                      color: Colors.indigo,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Correo electrÃ³nico',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'soporte@bookstore.com',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

