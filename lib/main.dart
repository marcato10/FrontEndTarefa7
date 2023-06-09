import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:login_page/GeneralPage/HomePage.dart';
import 'package:http/http.dart' as http;
import 'package:login_page/model/Values.dart';
import 'AdmPages/RegisterPage.dart';
import 'GeneralPage/RegisterUser.dart';
import 'model/User.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login",
      //Define tema escuro
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.lightGreenAccent,

        ),

      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget{
  @override
  State<MainPage> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<MainPage>{

  void showTextField(BuildContext context,String url) {
    TextEditingController addressController = TextEditingController(text: url);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Configuração'),
          actions: [
            TextField(
              controller: addressController,
              decoration: inputDefaultDecoration('Digite um novo endereço para o sistema'),
            ),
            TextButton(onPressed: (){
              setState(() {
                setUrl(addressController.text);
                Navigator.of(context).pop();
              });
            }, child: const Text('Confirmar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final altura = MediaQuery.of(context).size.height;
    final errorMessage error = errorMessage();

    final userController = TextEditingController();
    final passwordController = TextEditingController();
    final url = Uri.parse('$mainURL/public/login');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){
              showTextField(context,mainURL);
          }, icon: const Icon(Icons.settings_outlined))
        ],
      ),
      body: Container(
        width: largura,
        height: altura,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Image.asset(
                'images/pato.jpg',
                fit: BoxFit.fill,
                height: altura,
              ),
            ),
            Container(
              color: Colors.black38,
              width: 350,
              height: altura,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Login'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
                    child: TextFormField(
                      controller: userController,
                      decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder()
                      ),
                      validator: (user) {
                        if(user == null || user.isEmpty){
                          return 'Digite um email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: 'Senha',
                          border: OutlineInputBorder()
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20.0),
                    child: SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          String username = userController.text;
                          String password = passwordController.text;

                          String loginJSON = json.encode({
                            "email": username,
                            "password": password
                          });
                          try{
                            var response = await http.post(url,
                                headers: {"Content-Type": "application/json"},
                                body: loginJSON
                            );
                            if(response.statusCode == 202){
                              final jsonBody = json.decode(response.body);
                              User logged = User.fromJson(jsonBody);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomePage(loggedUser: logged),)
                              );
                            }
                            else {
                              error.setError("Usuário ou senha incorretos");
                            }
                          }catch(e){
                            if(e is SocketException){
                              error.setError("Não foi possível se conectar com o servidor");
                            }
                          }

                            },
                          child: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                        valueListenable: error.error,
                      builder: (context, String value,_) => Text(value,
                      style: TextStyle(
                        color: const ColorScheme.dark().error
                      ),),
                    ),
                    TextButton(onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => RegisterUserPage()
                          )
                      );
                    }, child: const Text('Cadastrar novo usuário'))
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class errorMessage extends ChangeNotifier{
  final ValueNotifier<String> error = ValueNotifier("");

  setError(String message){
    error.value = message;
    notifyListeners();
  }
}