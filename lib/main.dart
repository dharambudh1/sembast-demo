import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast_demo/sembast_user_repository.dart';
import 'user_repository.dart';
import 'create.dart';
import 'init.dart';
import 'model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future _init = Init.initialize();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sembast Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: _init,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const MyHomePage(
              title: 'Sembast Demo',
            );
          } else {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final UserRepository _userRepository = GetIt.I.get();
  List<Details> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  _loadUsers() async {
    final users = await _userRepository.getAllUsers();
    setState(() => _users = users);
  }

  @override
  void dispose() {
    SembastUserRepository.database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateEntry(
                  detailsChangeCallBack: (localObject) async {
                    final details = Details(
                      firstName: localObject.firstName,
                      lastName: localObject.lastName,
                      gender: localObject.gender,
                      age: localObject.age,
                    );
                    await _userRepository.insertUser(details);
                    _loadUsers();
                  },
                  userRepository: _userRepository,
                  editMode: false,
                  detailsValues: const Details(
                    id: null,
                    firstName: '',
                    lastName: '',
                    gender: '',
                    age: 0,
                  ),
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerFloat,
        body: SafeArea(
          child: ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            reverse: true,
            itemCount: _users.length,
            itemBuilder: (context, index) {
              Details? detailsValues = _users[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonRichTextWidget(
                                label: 'ID number',
                                value: detailsValues.id.toString()),
                            commonRichTextWidget(
                                label: 'First name',
                                value: detailsValues.firstName),
                            commonRichTextWidget(
                                label: 'Last name',
                                value: detailsValues.lastName),
                            commonRichTextWidget(
                                label: 'Age',
                                value: detailsValues.age.toString()),
                            commonRichTextWidget(
                                label: 'Gender', value: detailsValues.gender),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateEntry(
                                detailsChangeCallBack: (localObject) async {
                                  final details = Details(
                                    firstName: localObject.firstName,
                                    lastName: localObject.lastName,
                                    gender: localObject.gender,
                                    age: localObject.age,
                                  );
                                  await _userRepository.insertUser(details);
                                  _loadUsers();
                                },
                                userRepository: _userRepository,
                                editMode: true,
                                detailsValues: detailsValues,
                              ),
                            ),
                          );
                        },
                        child: const Icon(Icons.edit),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await _userRepository
                              .deleteUser(detailsValues.id ?? 0);
                          _loadUsers();
                        },
                        child: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget commonRichTextWidget({
    required String label,
    required String value,
  }) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      maxLines: 1,
      text: TextSpan(
        text: '$label: ',
        style: Theme.of(context).textTheme.bodyMedium,
        children: <TextSpan>[
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
