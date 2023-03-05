import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps/business_logic/phone_auth/phone_auth_state.dart';
import 'package:flutter_maps/constants/my_colors.dart';
import 'package:flutter_maps/presentation/screens/login_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: 290,
        elevation: 0,
        backgroundColor: Colors.grey[250],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 320,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                ),
                child: buildDrawerHeader(),
              ),
            ),
            buildDrawerListItem(leadingIcon: Icons.person, title: 'My profile'),
            myDivider(),
            buildDrawerListItem(
              leadingIcon: Icons.history,
              title: 'Places history',
              onTap: () {},
            ),
            myDivider(),
            buildDrawerListItem(
              leadingIcon: Icons.settings,
              title: 'Settings',
              onTap: () {},
            ),
            myDivider(),
            buildDrawerListItem(
              leadingIcon: Icons.help,
              title: 'Help',
              onTap: () {},
            ),
            myDivider(),
            BlocBuilder<PhoneAuthCubit, PhoneAuthState>(
              builder: (context, state) {
                return buildDrawerListItem(
                  leadingIcon: Icons.logout,
                  trailing: const SizedBox(
                    width: 1,
                    height: 1,
                  ),
                  title: 'logout',
                  onTap: () async {
                    await PhoneAuthCubit.get(context).logOut();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                          (route) => false,
                    );
                  },
                );
              },
            ),
            SizedBox(height: 50),
            ListTile(
              leading: Text(
                'Follow us',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            buildSocialMediaIcons(),
          ],
        ),
        // shadowColor: Colors.red,
      ),
    );
  }

  Widget buildDrawerHeader() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            // borderRadius: BorderRadius.circular(100),
            color: Colors.blue[100],
          ),
          child: CircleAvatar(
            radius: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: Image.asset("assets/images/me.jpeg"),
            ),
          ),
        ),
        BlocBuilder<PhoneAuthCubit, PhoneAuthState>(
          builder: (context, state) {
            return Text(
              PhoneAuthCubit.get(context).getLoggedInUser().phoneNumber!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        SizedBox(height: 5),
        Text(
          '01029410206',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildDrawerListItem({
    required IconData leadingIcon,
    required String title,
    Widget? trailing,
    Function()? onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        leadingIcon,
        color: color ?? MyColors.myBlue,
      ),
      trailing: trailing ??
          Icon(
            Icons.arrow_right,
            color: MyColors.myBlue,
          ),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget myDivider() {
    return const Divider(
      height: 0,
      thickness: 1,
      indent: 18,
      endIndent: 24,
    );
  }

  void _launchURL(String url) async {
    var uri = Uri.parse(url);
    await canLaunchUrl(uri)
        ? await launchUrl(uri)
        : throw 'could not lunch $url';
  }

  Widget buildIcon(IconData icon, String url, Color? color) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: Icon(
        icon,
        color: color ?? MyColors.myBlue,
        size: 35.0,
      ),
    );
  }

  Widget buildSocialMediaIcons() {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 16),
      child: Row(
        children: [
          buildIcon(FontAwesomeIcons.facebook,
              'https://www.facebook.com/AhmadAbbas08', null),
          SizedBox(width: 15),
          buildIcon(
            FontAwesomeIcons.linkedin,
            'https://www.linkedin.com/in/ahmadabbas8/',
            null,
          ),
          SizedBox(width: 15),
          buildIcon(
            FontAwesomeIcons.github,
            'https://github.com/AhmadAbbas8',
            MyColors.myBlack,
          ),
        ],
      ),
    );
  }
}
