import 'package:flutter/material.dart';

import '../models/db_user_model.dart';
import '../services/database_helper.dart';

class UserScreen extends StatelessWidget {
  final User? user;
  const UserScreen({
    super.key,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    if (user != null) {
      titleController.text = "${user!.fName} ${user!.lName}";
      descriptionController.text = "Username: ${user!.username}\n"
          "Email: ${user!.email}\n"
          "Is Admin?: ${user!.isAdmin}";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(user == null ? 'Add a user' : 'Edit user'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Center(
                child: Text(
                  'What are you thinking about?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: TextFormField(
                controller: titleController,
                maxLines: 1,
                decoration: const InputDecoration(
                    hintText: 'Title',
                    labelText: 'Note title',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 0.75,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ))),
              ),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                  hintText: 'Type here the note',
                  labelText: 'Note description',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 0.75,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ))),
              keyboardType: TextInputType.multiline,
              onChanged: (str) {},
              maxLines: 5,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () async {
                      final title = titleController.value.text;
                      final description = descriptionController.value.text;

                      if (title.isEmpty || description.isEmpty) {
                        return;
                      }

                      final User model = User(
                        userID: 0,
                        username: 'estesj10',
                        password: '1234',
                        fName: 'Jack',
                        lName: 'Etses',
                        email: 'estesj10@byu.edu',
                        // 0 -> false
                        isAdmin: 0,
                      );
                      if (user == null) {
                        await DatabaseHelper.insertUser(model);
                      } else {
                        await DatabaseHelper.updateUser(model);
                      }

                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.white,
                                  width: 0.75,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                )))),
                    child: Text(
                      user == null ? 'Save' : 'Edit',
                      style: const TextStyle(fontSize: 20),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
