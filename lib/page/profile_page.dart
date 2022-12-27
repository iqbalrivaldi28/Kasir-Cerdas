import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kasir_cerdas/constant/assets.dart';
import 'package:kasir_cerdas/constant/colors.dart';
import 'package:kasir_cerdas/constant/shapes.dart';
import 'package:kasir_cerdas/model/profile.dart';
import 'package:kasir_cerdas/page/edit_profile_page.dart';

import 'package:kasir_cerdas/page/main_page.dart';
import 'package:kasir_cerdas/page/on_boarding.dart';
import 'package:kasir_cerdas/services/session.dart';

import 'package:kasir_cerdas/widget/text_link.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static const route = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Profile profile = Session.user;

  Future _getdataFromDatabase<Profil>() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          profile = profile.copyWith(
            name: snapshot.data()!["name"],
            email: snapshot.data()!["email"],
            image: snapshot.data()!["image"],
            phone: snapshot.data()!["phone"],
            address: snapshot.data()!["address"],
          );
        });
      } else {}
    });
  }

  @override
  void initState() {
    super.initState();
    _getdataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        leading: IconButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, MainPage.route),
            icon: const Icon(Icons.arrow_back)),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: profile.image != null && profile.image!.isNotEmpty
                ? Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl: profile.image!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(profileImage),
                          );
                        },
                      ),
                    ),
                  )
                : const CircleAvatar(
                    radius: 50,
                    child: Center(
                      child: Icon(Icons.person),
                    ),
                  ),
          ),
          TextLink(
            'Edit Profil',
            onTap: () {
              Navigator.pushNamed(context, EditProfilePage.route);
            },
          ),
          mvDivider,
          ProfileTile('nama', '${profile.name}'),
          ProfileTile('email', profile.email.toString()),
          ProfileTile('phone', '${profile.phone}'),
          ProfileTile('address', '${profile.address}'),
          mvDivider,
          TextLink(
            'Logout',
            onTap: () {
              FirebaseAuth.instance.signOut().then((_) {
                Session.logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  OnBoardingPage.route,
                  (route) => false,
                );
              });
            },
          )
        ],
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  const ProfileTile(
    this.title,
    this.subtitle, {
    Key? key,
  }) : super(key: key);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      tileColor: primaryColor,
      textColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(fontSize: 12),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
