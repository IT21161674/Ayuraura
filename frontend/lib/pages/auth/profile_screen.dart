import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../widgets/profile_widgets/profile_widget.dart';
import '../../../widgets/profile_widgets/accout_settings_widget.dart';
import '../../../widgets/profile_widgets/contact_info_widget.dart';
import '../../../widgets/profile_widgets/subscription_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool notificationsEnabled = true;
  bool locationEnabled = true;
  bool analyticsEnabled = true;
  double logoutScale = 1.0;
  bool _isLoading = true;
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<Map<String, dynamic>> _getUserData(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data() ?? {};
  }

  Future<void> loadUserData() async {
    if (user != null) {
      try {
        final data = await _getUserData(user!.uid);
        setState(() {
          userData = data;
          _isLoading = false;
        });
      } catch (e) {
        print("Error loading user data: $e");
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/icons/lucide_bell.svg',
              height: 22,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ProfileCard(
                    userName: userData['name'] ?? 'User',

                  ),
                  const SizedBox(height: 24),
                  ContactInfoCard(
                    email: userData['email'] ?? user?.email ?? 'No email',
                    age: userData['age'].toString() ?? 'No age',
                    address: 'piliyandala',
                  ),
                  const SizedBox(height: 24),
                  AccountSettingsCard(),
                  const SizedBox(height: 24),

                  SubscriptionPlanCard(
                                     currentPlan: "Premium Plan",
                                     description:
                                         'Access to all premium features including unlimited plant scans and detailed treatment plans.',
                                     renewalDate: 'June 15, 2025',
                                     plan: "Annual (\$59.99/year)",
                                     active: true,
                                     onTap: () {},
                                   ),
                  const SizedBox(height: 24),

                  const Text(
                    "AyurAura v1.0.0",
                    style: TextStyle(color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ),
    );
  }
}