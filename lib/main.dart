import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Translator',

        theme: ThemeData(

          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),

        home: Scaffold(
          appBar: AppBar(
            title: Text("Speech to Text",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            backgroundColor: Colors.indigo,


          ),
          body: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                TextToSpeech(),
                lang_convert(),
              ],
            ),
          ),
        )
    );
  }
}

class TextToSpeech extends StatelessWidget {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textEditingController = TextEditingController();

  speek(String text) async
  {
    await flutterTts.setLanguage("hi");
    await flutterTts.setPitch(0.6);
    await flutterTts.speak(text);

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        child:   Padding(
          padding: const EdgeInsets.all(27),
          child: Column(
            children: [
              TextFormField(
                controller: textEditingController,
                showCursor: true,

                decoration: InputDecoration(
                  labelText: "Write somthing to make me speak ",
                  prefixIcon: Icon(Icons.speaker_phone_outlined),
                  border: OutlineInputBorder(),
                  focusColor: Colors.green,
                  hoverColor: Colors.red.shade50,
                  fillColor: Colors.green.shade50,
                  filled: true,

                ),
              ),
              const   SizedBox(height: 12,),




              ElevatedButton(

                style:ElevatedButton.styleFrom(
                  primary: Colors.red.shade500,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
                onPressed:()=> speek(textEditingController.text),
                child:  const Icon(Icons.mic),
              )

            ],
          ),
        ),

      ),
    );
  }
}



class lang_convert extends StatefulWidget {



  @override
  State<lang_convert> createState() => _lang_convertState();
}

class _lang_convertState extends State<lang_convert> {
  final GoogleTranslator translator = GoogleTranslator();
  final TextEditingController lngTextEditingController = TextEditingController();
  var output;
  String? dropdownValue;
  static const Map<String, String> lang={
    "Hindi":"hi",
    "English":"en"
  };
  void trans()
  {
    translator.translate(lngTextEditingController.text,to:"$dropdownValue")
        .then((value) {
      setState((){
        output = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(27),
          child: TextFormField(
            style: TextStyle(fontSize: 14),
            controller: lngTextEditingController,
            onTap: (){trans();},
            decoration: InputDecoration(
              labelText: "Enter Text to be converted",
              prefixIcon: Icon(Icons.language_rounded),
              border: OutlineInputBorder(),
              focusColor: Colors.green,
              hoverColor: Colors.red.shade50,
              fillColor: Colors.purple.shade50,
              filled: true,

            ),

          ),
        ),
        SizedBox(height: 50,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const   Text("Select your Language from here => ",style: TextStyle(fontWeight: FontWeight.bold),),
              DropdownButton<String>(
                  hint: const Text("Select"),
                  value: dropdownValue,
                  borderRadius: BorderRadius.circular(16),
                  elevation: 24,
                  style: const TextStyle(color: Colors.black87,),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  icon: const Icon(Icons.arrow_downward),
                  items: lang
                      .map((string, value) {
                    return MapEntry(
                      string,
                      DropdownMenuItem<String>(
                        value: value,

                        child: Text(string),
                      ),
                    );
                  })
                      .values
                      .toList(),
                  onChanged: (value){
                    setState((){
                      dropdownValue = value.toString();
                      trans();
                    });
                  }
              ),

              const SizedBox(height: 20,),

            ],

          ),

        ),
        ElevatedButton(onPressed: (){
          if(output==null && lngTextEditingController.text.isEmpty)
          {
            setState((){ output = "!!! Please enter some text !!!";});
          }else if(output == null) {
            setState((){ output = "!!! Please Select a language !!!";});

          }else{ trans();}

        }, child: Text("Convert")),

        const Divider(thickness: 3,color: Colors.black,),
        const SizedBox(height: 50,),
        output==null? const Text("Convered text will appera here!!") : Text("$output",style: const TextStyle(
            fontSize: 17,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500),
        ),
        const  SizedBox(height: 100,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.arrow_upward_outlined),
            Text(" 👆 Your Converted text will be displayed here 👆 "),
            Icon(Icons.arrow_upward),
          ],
        ),
      ],
    );
  }
}
