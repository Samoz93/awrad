import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

const mailString = "khaledammar12.12@gmail.com";

class FirstPage extends StatelessWidget {
  const FirstPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      direction: Axis.vertical,
      children: [
        Expanded(
          flex: 13,
          child: Stack(
            children: <Widget>[
              ExtendedImage.network(
                "https://image.alkawthartv.com/image/855x495/2018/08/09/636694235577070039.jpg",
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: LayoutBuilder(
                  builder: (context, constraints) => Container(
                    height: constraints.maxHeight * 0.3,
                    width: constraints.maxWidth,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "عننا",
                          style: AppThemes.titleTextStyle,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(gradient: AppThemes.linearTitle),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(child: SizedBox()),
        Expanded(
          flex: 5,
          child: InkWell(
            onTap: () async {
              final Email email = Email(
                body: 'يرجى ذكر إقتراحاتكم\n',
                subject: " أذكار الصالحين",
                recipients: [mailString],
                // cc: ['cc@example.com'],
                // bcc: ['bcc@example.com'],
                // attachmentPaths: ['/path/to/attachment.zip'],
                isHTML: false,
              );

              await FlutterEmailSender.send(email);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "تم عمل هذا التطبيق تحت إشراف د. عمار العصير",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      "للاقتراحات والدعم الفني التواصل على الايميل الآتي",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      mailString,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                Align(alignment: Alignment.center, child: Icon(Icons.email)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
