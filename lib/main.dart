import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AI Syllabus",
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      home: SplashScreen(
        toggleTheme: () {
          setState(() {
            isDark = !isDark;
          });
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final VoidCallback? toggleTheme;
  const SplashScreen({super.key, this.toggleTheme});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(toggleTheme: widget.toggleTheme),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/logo/logo.png", height: 120),
              const SizedBox(height: 20),
              const Text(
                "AI Syllabus",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final VoidCallback? toggleTheme;
  const HomeScreen({super.key, this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/girl.png", height: 200),
            const SizedBox(height: 20),
            const Text(
              "Welcome to AI Syllabus",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MenuScreen(toggleTheme: toggleTheme)),
                );
              },
              child: const Text("Start"),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuScreen extends StatefulWidget {
  final VoidCallback? toggleTheme;
  const MenuScreen({super.key, this.toggleTheme});
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String searchQuery = "";

  final List<Map<String, dynamic>> menuItems = [
    {"title": "AI Book", "page": const BookPage()},
    {"title": "Important Questions", "page": const ImportantQuestionsPage()},
    {"title": "Quiz", "page": const QuizPage()},
    {"title": "About Us", "page": const AboutUsPage()},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredItems = menuItems
        .where((item) => item["title"]
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("AI Syllabus"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/logo/logo.png"),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search syllabus, book, notes",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: filteredItems.map((item) {
                  return ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => item["page"]),
                      );
                    },
                    child: Text(item["title"]),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BookPage extends StatelessWidget {
  const BookPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("AI Book"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/logo/logo.png"),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          bookButton(context, "Unit 1", "assets/pdfs/unit1.pdf"),
          bookButton(context, "Unit 2", "assets/pdfs/unit2.pdf"),
          bookButton(context, "Unit 3", "assets/pdfs/unit3.pdf"),
          bookButton(context, "Unit 4", "assets/pdfs/unit4.pdf"),
          bookButton(context, "Unit 5", "assets/pdfs/unit5.pdf"),
        ],
      ),
    );
  }

  Widget bookButton(BuildContext context, String title, String path) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.picture_as_pdf),
        label: Text(title),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PdfViewerPage(pdfPath: path)),
          );
        },
      ),
    );
  }
}

class ImportantQuestionsPage extends StatelessWidget {
  const ImportantQuestionsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Important Questions"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/logo/logo.png"),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          questionButton(
              context, "Anna University", "assets/pdfs/anna_university.pdf"),
          questionButton(context, "Additional Questions",
              "assets/pdfs/additional_questions.pdf"),
        ],
      ),
    );
  }

  Widget questionButton(BuildContext context, String title, String path) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.library_books),
        label: Text(title),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PdfViewerPage(pdfPath: path)),
          );
        },
      ),
    );
  }
}

class PdfViewerPage extends StatelessWidget {
  final String pdfPath;
  const PdfViewerPage({super.key, required this.pdfPath});

  Future<void> sharePDF() async {
    try {
      final byteData = await rootBundle.load(pdfPath);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${pdfPath.split("/").last}');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      await Share.shareFiles([file.path]);
    } catch (e) {
      debugPrint("Error sharing PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pdfPath.split("/").last),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: sharePDF,
          )
        ],
      ),
      body: SfPdfViewer.asset(pdfPath),
    );
  }
}

  Future<void> sharePDF() async {
    try {
      final byteData = await rootBundle.load(widget.pdfPath);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${widget.pdfPath.split("/").last}');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      await Share.shareFiles([file.path]);
    } catch (e) {
      debugPrint("Error sharing PDF: $e");
    }
  }

  Future<void> readNotes() async {
    if (!isSpeaking) {
      await flutterTts.setLanguage("en-IN");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak("Reading your AI syllabus notes.");
      setState(() {
        isSpeaking = true;
      });
    } else {
      await flutterTts.stop();
      setState(() {
        isSpeaking = false;
      });
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pdfPath.split("/").last),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: sharePDF,
          ),
          IconButton(
            icon: Icon(isSpeaking ? Icons.stop : Icons.volume_up),
            onPressed: readNotes,
          ),
        ],
      ),
      body: SfPdfViewer.asset(widget.pdfPath),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestion = 0;
  int score = 0;
  bool quizFinished = false;
  String? selectedAnswer;

  final List<Map<String, Object>> questions = [
    {
      "question": "1. What does AI stand for?",
      "options": ["Artificial Intelligence", "Automated Input", "Advanced Internet"],
      "answer": "Artificial Intelligence"
    },
    {
      "question": "2. Which is a type of Machine Learning?",
      "options": ["Supervised", "Random", "Sequential"],
      "answer": "Supervised"
    },
    {
      "question": "3. What is the main goal of AI?",
      "options": ["Mimic human intelligence", "Store data", "Build hardware"],
      "answer": "Mimic human intelligence"
    },
  ];

  void checkAnswer() {
    if (selectedAnswer == questions[currentQuestion]["answer"]) score++;
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
      });
    } else {
      setState(() {
        quizFinished = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (quizFinished) {
      return Scaffold(
        appBar: AppBar(title: const Text("Quiz Completed")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Your Score: $score / ${questions.length}",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentQuestion = 0;
                    score = 0;
                    quizFinished = false;
                  });
                },
                child: const Text("Restart Quiz"),
              )
            ],
          ),
        ),
      );
    }

    final currentQ = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(title: const Text("AI Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentQ["question"] as String,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...(currentQ["options"] as List<String>).map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value;
                  });
                },
              );
            }),
            const Spacer(),
            ElevatedButton(
              onPressed: selectedAnswer == null ? null : checkAnswer,
              child: const Text("Next"),
            )
          ],
        ),
      ),
    );
  }
}

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Presented by\nARUNAI ENGINEERING COLLEGE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Department of CSE (AI & ML)",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                "Faculty:",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "• Prof. S. Noorul Hassan (HOD - AI&DS, AI&ML)\n"
                "• Mrs. V. Anitha (AP/AI&DS)",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "Students (Pre-Final Year):",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "• R. Abinaya\n"
                "• S. Dharshini\n"
                "• S. Jeevitha\n"
                "• P. Pooja",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}