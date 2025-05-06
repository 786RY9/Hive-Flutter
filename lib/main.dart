import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_learn/boxes.dart';
import 'package:hive_learn/person.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  Box<Person> boxPersons = await Hive.openBox<Person>('personBox');

  runApp(MyApp(boxPersons: boxPersons));
}

class MyApp extends StatelessWidget {
  final Box<Person> boxPersons;

  const MyApp({super.key, required this.boxPersons});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'Flutter Demo Home Page', boxPersons: boxPersons),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final Box<Person> boxPersons;

  const MyHomePage({super.key, required this.title, required this.boxPersons});

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
            child: Image.asset('assets/image.jpg'),
          ),
          const SizedBox(height: 4,),

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
                      onPressed: () {
                        setState(() {
                          widget.boxPersons.put(
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
                  child: ValueListenableBuilder<Box<Person>>(
                    valueListenable: widget.boxPersons.listenable(),
                    builder: (
                      BuildContext context,
                      Box<Person> box,
                      Widget? child,
                    ) {
                      return ListView.builder(
                        itemCount: box.keys.length,
                        itemBuilder: (BuildContext context, int index) {
                          final person = box.getAt(index);
                          return ListTile(
                            leading: IconButton(
                              onPressed: () {
                                setState(() {
                                  box.deleteAt(index);
                                });
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            title: Text(person?.name ?? 'Unknown'),
                            subtitle: const Text('Name'),
                            trailing: Text(
                              'age: ${person?.age.toString() ?? 'N/A'}',
                            ),
                          );
                        },
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
                widget.boxPersons.clear();
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
