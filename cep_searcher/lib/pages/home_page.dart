import 'package:cep_searcher/models/endereco_model.dart';
import 'package:flutter/material.dart';

import '../repositories/cep_repository.dart';
import '../repositories/cep_repository_impl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryImpl();
  EnderecoModel? enderecoModel;

  final formKey = GlobalKey<FormState>();
  final cepController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    cepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar CEP'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: cepController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  final isValid = formKey.currentState?.validate() ?? false;
                  if (isValid) {
                    try {
                      setState(() {
                        loading = true;
                      });
                      final endereco =
                          await cepRepository.getCep(cepController.text);
                      setState(() {
                        enderecoModel = endereco;
                        loading = false;
                      });
                    } catch (e) {
                      setState(() {
                        enderecoModel = null;
                        loading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Erro ao buscar CEP'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Buscar'),
              ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: loading,
                child: const CircularProgressIndicator(),
              ),
              Visibility(
                visible: enderecoModel != null,
                child: Text(
                    '${enderecoModel?.logradouro} - ${enderecoModel?.complemento} - ${enderecoModel?.cep}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
