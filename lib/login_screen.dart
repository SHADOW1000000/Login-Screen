import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loginscreen/animation_enum.dart';
import 'package:rive/rive.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {

  late Artboard riveArtBoard;
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerLookRight;
  late RiveAnimationController controllerLookLeft;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;
  bool isLookingLeft = false;
  bool isLookingRight = false;
  String email = "marwan@gmail.com";
  String password = "Marwan";
  final passwordFocusNode = FocusNode();

  void removeAllControllers(){
    riveArtBoard.artboard.removeController(controllerIdle);
    riveArtBoard.artboard.removeController(controllerHandsUp);
    riveArtBoard.artboard.removeController(controllerHandsDown);
    riveArtBoard.artboard.removeController(controllerLookLeft);
    riveArtBoard.artboard.removeController(controllerLookRight);
    riveArtBoard.artboard.removeController(controllerSuccess);
    riveArtBoard.artboard.removeController(controllerFail);
    isLookingLeft = false;
    isLookingRight = false;
  }
  void checkPasswordFocusNode(){
    passwordFocusNode.addListener(() {
      if(passwordFocusNode.hasFocus){
        addHandsUPControllers();
      }else if(!passwordFocusNode.hasFocus){
        addHandsDownControllers();
      }
    }
    );
  }
  void validation(){
    Future.delayed(const Duration(seconds: 1),(){
      if(formKey.currentState!.validate()){
        addSuccessControllers();
      }else{
        addFailControllers();
      }
    });
  }

  void addIdleControllers(){
    removeAllControllers();
    riveArtBoard.artboard.addController(controllerIdle);
  }
  void addHandsUPControllers(){
    removeAllControllers();
    riveArtBoard.artboard.addController(controllerHandsUp);
  }
  void addHandsDownControllers(){
    removeAllControllers();
    riveArtBoard.artboard.addController(controllerHandsDown);
  }
  void addLookLeftControllers(){
    removeAllControllers();
    isLookingLeft = true;
    riveArtBoard.artboard.addController(controllerLookLeft);
  }
  void addLookRightControllers(){
    removeAllControllers();
    isLookingRight = true;
    riveArtBoard.artboard.addController(controllerLookRight);
  }
  void addSuccessControllers(){
    removeAllControllers();
    riveArtBoard.artboard.addController(controllerSuccess);
  }
  void addFailControllers(){
    removeAllControllers();
    riveArtBoard.artboard.addController(controllerFail);
  }


  @override
  void initState(){
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerLookRight = SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerLookLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);
    checkPasswordFocusNode();


    rootBundle.load("assets/animated_login_screen.riv").then((value){
      final file = RiveFile.import(value);
      final artBoard = file.mainArtboard;
      artBoard.addController(controllerIdle);
      setState(() {
        riveArtBoard = artBoard ;
      });
    });
  }
  bool obs = true;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(child: Text("Login Screen")),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 10,
            vertical: MediaQuery.of(context).size.height / 20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height/3,
                    child:
                    Rive(artboard: riveArtBoard)),
                TextFormField(
                  onChanged: (value){
                    if( value.length < 10 && !isLookingLeft){
                      addLookLeftControllers();
                    }else if(value.length > 10 && !isLookingRight){
                      addLookRightControllers();
                    }else{
                      addIdleControllers();
                    }
                  },
                  validator: (value) {
                    if (value != email) {
                      return "Wrong Email";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.person,color: Colors.blue,),
                      label: const Text("Email"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 20),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  focusNode: passwordFocusNode,
                  validator: (value) {
                    if (value != password) {
                      return "Wrong Password";
                    }
                    return null;
                  },
                  obscureText: obs,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obs = !obs;
                            });
                          },
                          icon: const Icon(Icons.remove_red_eye,color: Colors.blue,)),
                      label: const Text("Password"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 20),
                TextButton(
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.blue),
                  onPressed: () {
                    passwordFocusNode.unfocus();
                    validation();
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
