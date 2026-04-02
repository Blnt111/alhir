import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<bool> isOpen = [false, false, false, false];
  final TextEditingController feedbackController = TextEditingController();

  late final WebViewController docsController;

  double prediction = 0.0;
  bool isLoading = false;


  Future<void> detectText() async {
    final url = Uri.parse("http://www.inf.u-szeged.hu/~gencsi/static/classify.php");


    try {
      final response = await http.post(
        url,
        body: {
          "text": feedbackController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        double score = data[1]["score"] * 100;

        setState(() {
          prediction = score / 100;
        });

      } else {
        debugPrint("Server error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("POST error: $e");
    }

  }


  @override
  void initState() {
    super.initState();

    docsController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
          "https://docs.google.com/forms/d/e/1FAIpQLSf5iT4D0cMqS5F0Hk3uBWkDZQlr_ThAZozmTNxKy9rUzUtAQw/viewform?embedded=true",
        ),
      );
  }

  
  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Álhírkereső",
          style: TextStyle(
            color: Colors.white
          )
        ),
        backgroundColor: const Color.fromRGBO(33, 8, 26, 1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ExpansionPanelList(
            animationDuration: const Duration(milliseconds: 250),
            expandedHeaderPadding: EdgeInsets.zero,

            expansionCallback: (index, expanded) {
              setState(() {
                isOpen[index] = !isOpen[index];
              });
            },

            children: <ExpansionPanel>[
              // ------------ PANEL 1 ------------
              ExpansionPanel(
                isExpanded: isOpen[0],
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) {
                  return const ListTile(
                    title: Text(
                      "Használati útmutató",
                      style: TextStyle(fontSize: 20),
                      overflow: TextOverflow.ellipsis, 
                      maxLines: 1, 
                    ),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("1. Másolja be vagy írja le a megvizsgálandó szöveget!", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Text("2. Ellenőrizze, hogy a szöveg megfelel-e a tudnivalók minden alpontjának!", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Text("3. Kattintson a felismerés gombra!", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Text("4. Nézze meg az eredményt!", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Text("5. Téves felismerés esetén küldjön visszajelzést!", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              // ------------ PANEL 2 ------------
              ExpansionPanel(
                isExpanded: isOpen[1],
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) {
                  return const ListTile(
                    title: Text(
                      "Egészségügyi álhírfelismerő alkalmazás",
                      style: TextStyle(fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "• A felismerő magyar nyelvű egészségügyi szövegen működik.",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "• A rendszer 20 és 500 szó közötti hosszúságú szövegre ad megbízható eredményt.",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "• A hosszabb szövegeknek csak az elejét dolgozza fel.",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "• Minimális technikai szerkesztést hajt végre a szövegen.",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "• A rendszer véletlenszerűen választ felismerőt.",
                        style: TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 20),

                      // -------- INPUT MEZŐ --------
                      TextField(
                        controller: feedbackController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              minLines: 8,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Szöveg bevitele',
                                hintText: 'Írja be vagy illessze be ide a megvizsgálandó szöveget',
                                alignLabelWithHint: true,
                              ),
                      ),

                      const SizedBox(height: 16),

                      // -------- GOMB --------
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            detectText();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            "Küldés",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // -------- EREDMÉNY --------
                      const Text(
                        "Eredmény",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // -------- PROGRESS BAR --------
                      LinearProgressIndicator(
                        value: prediction, 
                        minHeight: 20,
                        backgroundColor: Colors.grey[300],
                        color: prediction > 0.5 ? Colors.red : Colors.green,
                      ),

                      const SizedBox(height: 10),

                      // -------- EREDMÉNY SZÖVEG --------

                      Text(
                        prediction == 0
                            ? "Nincs eredmény"
                            : prediction > 0.5
                                ? "Álhír"
                                : "Valós hír",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: prediction > 0.5 ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ------------ PANEL 3 ------------
              ExpansionPanel(
                isExpanded: isOpen[2],
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) {
                  return const ListTile(
                    title: Text(
                      "Feldolgozott szöveg",
                      style: TextStyle(fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                },
                body: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Ez a funkció jelenleg nem működik!",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              // ------------ PANEL 4 ------------
              ExpansionPanel(
                isExpanded: isOpen[3],
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) {
                  return const ListTile(
                    title: Text(
                      "Visszajelzés küldése a felismerésről",
                      style: TextStyle(fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 1500,
                    child: WebViewWidget(controller: docsController),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}