import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_learn/boxes.dart';
import 'package:hive_learn/person.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  boxPersons = await Hive.openBox<Person>('personBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Hive',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 13, 31, 57),
      appBar: AppBar(title: const Text('RY Hive App')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Name',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Age',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: // put data when press on this button
                          () {
                        setState(() {
                          boxPersons.put(
                            'key_${nameController.text}',
                            Person(
                              age: int.parse(ageController.text),
                              name: nameController.text,
                            ),
                          );
                        });
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),

                  child: ListView.builder(
                    itemCount: boxPersons.keys.length,
                    itemBuilder: (context, index) {
                      final key = boxPersons.keys.elementAt(index);
                      Person person = boxPersons.get(key);
                      return ListTile(
                        leading: IconButton(
                          onPressed: () {
                            // deleteat
                            setState(() {
                              boxPersons.deleteAt(index);
                            });
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        title: Text(person.name),
                        subtitle: const Text('Name'),
                        trailing: Text('age: ${person.age.toString()}'),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              setState(() {
                boxPersons.clear();
              });
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete all'),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
