import 'package:flutter/material.dart';

class CustomMenu extends StatelessWidget {
  final Widget child;

  const CustomMenu({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: double.infinity,
          width: 100,
          color: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Image.asset("assets/images/Logo SGPI-Photoroom 1.png"),
            
              Expanded(
                child: Column(spacing: 40,children: [Text("NIT"),
                Icon(Icons.home),
                Icon(Icons.person),],),
              ),
              Column(children: [
                CircleAvatar(backgroundColor: Theme.of(context).colorScheme.tertiary,child: Text("W"),),
                Text("Usuario", style: Theme.of(context).textTheme.bodySmall,),
                TextButton(onPressed: (){
                  // Get.toNamed("/login");
                }, child:Text("SAIR", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.amber),) )
              ],)
             
            ],
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
