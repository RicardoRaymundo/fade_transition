import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(title: 'Estudando FadeTransition'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  //Controlador de animação
  AnimationController _animationController;
  Animation<double> _buttonAnimation;
  bool _isPlaying = false;

  //Setando os parametros dos controles de animação, como a duracao, o tipo de
  //animação, etc.
  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _buttonAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInBack);

    //Método responsável pela animação constante do ícone
    //Quando o status da animação é 'completed' ou 'dismissed'
    //a função realiza a animação de ida ou volta.
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.forward();
  }

  //Função que descarta o objeto controlador da animação após a mesma ser realizada
  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  //Função para o botão, que alterna entre ambos os estados de animação do ícone
  void _onButtonAnimation() {
    setState(() {
      _isPlaying = !_isPlaying;
      _isPlaying
          ? _animationController.forward()  //Faz aparecer
          : _animationController.reverse(); //Faz desaparecer
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  color: Colors.white,
                  child: FadeTransition(
                      opacity: animation,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.all_inclusive,
                              size: 100.0,
                              color: Colors.green,
                            ),
                          ]))),
              SizedBox(
                height: 20,
              ),
              Container(
                  color: Colors.white,
                  child: FadeTransition(
                      opacity: _buttonAnimation,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check,
                              size: 100.0,
                              color: Colors.green,
                            ),
                          ]))),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onButtonAnimation,
          tooltip: 'clique para a animação',
          child: Icon(Icons.check),
        ));
  }
}