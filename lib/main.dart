import 'package:flutter/material.dart';

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
                      // Added to prevent text overflow in case of limited horizontal space.
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
                      // Added to prevent text overflow in case of limited horizontal space.
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
                              maxLines: null, // Allows for an unlimited number of lines
                              minLines: 8, // Sets an initial height of 8 lines
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Szöveg bevitele',
                                hintText: 'Írja be vagy illessze be ide a megvizsgálandó szöveget',
                                alignLabelWithHint: true, // Centers the label text vertically with the hint text
                              ),
                      ),

                      const SizedBox(height: 16),

                      // -------- GOMB --------
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            debugPrint('Visszajelzés: ${feedbackController.text}');
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
                        // Fixed invalid value. value must be between 0.0 and 1.0.
                        value: 0.0, 
                        minHeight: 20,
                        backgroundColor: Colors.grey[300],
                        color: Colors.red,
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
                      // Added to prevent text overflow in case of limited horizontal space.
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
                      // Added to prevent text overflow in case of limited horizontal space.
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                },
                body: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Ide jön a negyedik panel tartalma.",
                    style: TextStyle(fontSize: 16),
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