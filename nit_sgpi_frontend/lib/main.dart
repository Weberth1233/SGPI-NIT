import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'presentation/core/my_widget.dart';

void main() async { // <--- 2. ADICIONE O 'async' AQUI
  WidgetsFlutterBinding.ensureInitialized(); // Recomendado quando usa async no main
  
  await initializeDateFormatting('pt_BR', null); // <--- 3. ADICIONE ESSA LINHA
  
  runApp(const MyWidget());
}


