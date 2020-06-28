import 'package:flutter/material.dart';
import 'package:custos/widgets/reusable_app_bar.dart';
import 'package:custos/widgets/customised_bottom_navbar.dart';

class PrivacyPolicyScreen extends StatelessWidget {

  static String id = 'PrivacyPolicyScreen';

  Widget policyTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
        color: Color(0xFF434343),
      ),
      textAlign: TextAlign.justify,
    );
  }
  
  Widget policyDescription(String description, double lineHeight) {
    return Text(
      description,
      style: TextStyle(
        color: Color(0xFF434343),
        height: lineHeight * 0.0025
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget bulletList(String text) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF434343),
            shape: BoxShape.circle,
          ),
          height: 5,
          width: 5,
          margin: EdgeInsets.only(left: 21, right: 4),
        ),
        Text(text),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: ReusableAppBar(
        title: Text('Privacy Policy'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                policyTitle('Privacy Policy'),

                SizedBox(height: screenHeight * 0.015),

                policyDescription('Custos app is built for a graduation project as an [open source/free] app. This SERVICE is provided by a group of students in Ahram Canadian University at no cost and is intended for use as is.', screenHeight),

                SizedBox(height: screenHeight * 0.015),

                policyDescription('This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.', screenHeight),

                SizedBox(height: screenHeight * 0.015),

                policyDescription('If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.', screenHeight),

                SizedBox(height: screenHeight * 0.05),

                policyTitle('Information Collection and Use'),

                SizedBox(height: screenHeight * 0.015),

                policyDescription('For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to Email, Name, Password, Phone Number, Accessing Contacts, Accessing Gallery, Accessing Location, Accessing Storage, Ability to Call a Number, Ability to Send SMS. The information that we request will be retained by us and used as described in this privacy policy.', screenHeight),

                SizedBox(height: screenHeight * 0.015),

                policyDescription('The app does use third party services that may collect information used to identify you.', screenHeight),

                SizedBox(height: screenHeight * 0.015),

                bulletList('Google Play Services'),

                SizedBox(height: screenHeight * 0.015),

                bulletList('Google Analytics for Firebase'),

                SizedBox(height: screenHeight * 0.05),

                policyTitle('Log Data'),

                SizedBox(height: screenHeight * 0.015),

                policyDescription('We want to inform you that whenever you use our Service, in a case of an error in the app we collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.', screenHeight),

                SizedBox(height: screenHeight * 0.05),

                policyTitle('Service Providers'),

                SizedBox(height: screenHeight * 0.015),

                policyDescription('We may employ third-party companies and individuals due to the following reasons:', screenHeight),

                SizedBox(height: screenHeight * 0.015),

                bulletList('To facilitate our Service;'),

                SizedBox(height: screenHeight * 0.015),

                bulletList('To provide the Service on our behalf;'),

                SizedBox(height: screenHeight * 0.015),

                bulletList('To perform Service-related services; or'),

                SizedBox(height: screenHeight * 0.015),

                bulletList('To assist us in analyzing how our Service is used.'),

                SizedBox(height: screenHeight * 0.015),

                policyDescription('We want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.', screenHeight),

                SizedBox(height: screenHeight * 0.05),

                policyTitle('Security'),

                SizedBox(height: screenHeight * 0.015),

                policyDescription('We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.', screenHeight),

                SizedBox(height: screenHeight * 0.05),

                policyTitle('Children’s Privacy'),

                SizedBox(height: screenHeight * 0.015),

                policyDescription('These Services do not address anyone under the age of 10. We do not knowingly collect personally identifiable information from children under 10. In the case we discover that a child under 10 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do necessary actions.', screenHeight),

                SizedBox(height: screenHeight * 0.05),

                policyTitle('Changes to This Privacy Policy'),

                SizedBox(height: screenHeight * 0.015),

                policyDescription('We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page.', screenHeight),

                SizedBox(height: screenHeight * 0.015),
                
                policyDescription('This policy is effective as of 2020-08-10', screenHeight),

                SizedBox(height: screenHeight * 0.05),

                policyTitle('Contact Us'),

                SizedBox(height: screenHeight * 0.015),

                policyDescription('If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at bavleymourad@gmail.com.', screenHeight),

                SizedBox(height: screenHeight * 0.015),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomisedBottomNavigationBar(
        index: 0,
        isBottomNavItem: false,
      ),
    );
  }
}
