import 'package:dsc_task/login_screen.dart';
import 'package:dsc_task/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final UserModel userModel;
  const HomeScreen(this.userModel, {Key? key}) : super(key: key);
  static final List<String> images = [
    'https://images.unsplash.com/photo-1633177317976-3f9bc45e1d1d?ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxMHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    'https://images.unsplash.com/photo-1633113093730-47449a1a9c6e?ixid=MnwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxMXx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    'https://images.unsplash.com/photo-1633209942287-701d44019290?ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw3N3x8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    'https://images.unsplash.com/photo-1633287387306-f08b4b3671c6?ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxNHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    'https://images.unsplash.com/photo-1633269540827-728aabbb7646?ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1OXx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'chat'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        onPressed: () {},
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                widget.userModel.name!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                widget.userModel.email!,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://avatars.githubusercontent.com/u/64502335?v=4'),
              ),
              otherAccountsPictures: const <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHBj-LrXHsS-dprAlSuCegGuydxu-KdVwujRNLXkO6IBXo4_pm0j0C3-l-VBw_Jwh00hw&usqp=CAU'),
                ),
              ],
            ),
            const ListTile(
              title: Text("Sent"),
              leading: Icon(Icons.send),
            ),
            const Divider(
              thickness: 1,
            ),
            const ListTile(
              title: Text("Inbox"),
              leading: Icon(Icons.inbox),
            ),
            const ListTile(
              title: Text("Stared"),
              leading: Icon(Icons.star),
            ),
            const Divider(
              thickness: 1,
            ),
            const ListTile(
              title: Text("Archive"),
              leading: Icon(Icons.archive),
            ),
            const ListTile(
              title: Text("Chat"),
              leading: Icon(Icons.chat),
            ),
            const Divider(
              thickness: 1,
            ),
            ListTile(
              title: const Text("Log out"),
              leading: const Icon(Icons.logout),
              onTap: () {
                _auth.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            buildItemImage(HomeScreen.images[0]),
            const Divider(thickness: 2),
            buildItemImage(HomeScreen.images[1]),
            const Divider(thickness: 2),
            buildItemImage(HomeScreen.images[2]),
            const Divider(thickness: 2),
            buildItemImage(HomeScreen.images[3]),
            const Divider(thickness: 2),
            buildItemImage(HomeScreen.images[4]),
          ],
        ),
      )),
    );
  }

  Widget buildItemImage(urlImage) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Image.network(
        urlImage,
        fit: BoxFit.fill,
      ),
    );
  }
}
