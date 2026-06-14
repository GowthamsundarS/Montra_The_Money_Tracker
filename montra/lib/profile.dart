
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:montra/login.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage({
    super.key,
    required this.username,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker picker = ImagePicker();

  XFile? pickedImage;

  String username = "";
  String email = "";
  String dob = "";

  late int userIndex;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> usernames = prefs.getStringList('usernames') ?? [];
    List<String> emails    = prefs.getStringList('emails') ?? [];
    List<String> dobs      = prefs.getStringList('dobs') ?? [];

    userIndex = usernames.indexOf(widget.username);

    if (userIndex != -1) {
      setState(() {
        username = usernames[userIndex];
        email    = emails.length > userIndex ? emails[userIndex] : "";
        dob      = dobs.length > userIndex ? dobs[userIndex] : "";
      });
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => pickedImage = image);
    }
  }

  void openEditBottomSheet() {
    final TextEditingController usernameController =
        TextEditingController(text: username);
    final TextEditingController emailController =
        TextEditingController(text: email);
    final TextEditingController passwordController =
        TextEditingController();
    final TextEditingController dobController =
        TextEditingController(text: dob);

    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xff0B3D2E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: usernameController,
                  style: const TextStyle(
    color: Colors.white,
  ),
                  decoration: const InputDecoration(
                    labelText: "Username",
                    labelStyle: TextStyle(
      color: Colors.white70,
    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: emailController,
                  style: const TextStyle(
    color: Colors.white,
  ),
                  decoration: const InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
      color: Colors.white70,
    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: passwordController,
                  style: const TextStyle(
    color: Colors.white,
  ),
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
      color: Colors.white70,
    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: dobController,
                  style: const TextStyle(
    color: Colors.white,
  ),
                  decoration: const InputDecoration(
                    labelText: "DOB",
                    labelStyle: TextStyle(
      color: Colors.white70,
    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();

                    List<String> usernames =
                        prefs.getStringList('usernames') ?? [];
                    List<String> passwords =
                        prefs.getStringList('passwords') ?? [];
                    List<String> emails =
                        prefs.getStringList('emails') ?? [];
                    List<String> dobs =
                        prefs.getStringList('dobs') ?? [];

                    if (userIndex != -1) {
                      final String oldUsername = usernames[userIndex];
                      final String newUsername =
                          usernameController.text.trim();

                     
                      if (oldUsername != newUsername &&
                          newUsername.isNotEmpty) {
                        final incomeData =
                            prefs.getString('income_$oldUsername');
                        final expenseData =
                            prefs.getString('expense_$oldUsername');

                        if (incomeData != null) {
                          await prefs.setString(
                              'income_$newUsername', incomeData);
                          await prefs.remove('income_$oldUsername');
                        }
                        if (expenseData != null) {
                          await prefs.setString(
                              'expense_$newUsername', expenseData);
                          await prefs.remove('expense_$oldUsername');
                        }
                      }

                      usernames[userIndex] = newUsername;

                      if (passwordController.text.trim().isNotEmpty) {
                        passwords[userIndex] =
                            passwordController.text.trim();
                      }

                      emails[userIndex] = emailController.text.trim();
                      dobs[userIndex]   = dobController.text.trim();

                      await prefs.setStringList('usernames', usernames);
                      await prefs.setStringList('passwords', passwords);
                      await prefs.setStringList('emails', emails);
                      await prefs.setStringList('dobs', dobs);

                      setState(() {
                        username = usernames[userIndex];
                        email    = emails[userIndex];
                        dob      = dobs[userIndex];
                      });
                    }

                    Navigator.pop(context);
                  },
                  child: const Text("Save Changes",style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),),
                  
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color darkGreen = Color(0xff0B3D2E);

    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0F111A),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // AVATAR
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(

                  radius: 65,

                  backgroundColor: darkGreen,

                  backgroundImage:
                  pickedImage != null

                      ? NetworkImage(
                    pickedImage!.path,
                  )

                      : null,

                  child: pickedImage == null

                      ? const Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.white,
                  )

                      : null,
                ),

                GestureDetector(

                  onTap: pickImage,

                  child: Container(

                    padding: const EdgeInsets.all(8),

                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const SizedBox(height: 20),

            Text(
              username,
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),

            const SizedBox(height: 8),

            Text(
              email,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade400),
            ),

            const SizedBox(height: 35),

            // INFO CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF322F2D),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.greenAccent,
                      child: Icon(Icons.person),
                    ),
                    title: const Text("Username",
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(username,
                        style: const TextStyle(color: Colors.grey)),
                  ),
                  Divider(color: Colors.grey.shade700),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.greenAccent,
                      child: Icon(Icons.calendar_month),
                    ),
                    title: const Text("DOB",
                        style: TextStyle(color: Colors.white)),
                    subtitle:
                        Text(dob, style: const TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: openEditBottomSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
                child: const Text("Edit Profile",
                    style: TextStyle(fontSize: 20,color: Colors.white)),
              ),
            ),

            const SizedBox(height: 15),

            
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
                child: const Text("Logout", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}