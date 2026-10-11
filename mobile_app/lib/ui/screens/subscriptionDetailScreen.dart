import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:nizvpn/core/provider/adsProvider.dart';
import 'package:nizvpn/core/provider/purchaseProvider.dart';
import 'package:nizvpn/core/provider/vpnProvider.dart';
import 'package:nizvpn/core/resources/warna.dart';
import 'package:nizvpn/ui/components/customDivider.dart';
import 'package:provider/provider.dart';

class SubscriptionDetailScreen extends StatefulWidget {
  @override
  _SubscriptionDetailScreenState createState() => _SubscriptionDetailScreenState();
}

class _SubscriptionDetailScreenState extends State<SubscriptionDetailScreen> {
  String _selectedId;
  @override
  Widget build(BuildContext context) {
    return Consumer<VpnProvider>(
      builder: (context, value, child) {
        if (value.isPro ?? false)
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(LineIcons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/vpnshare.png",
                      height: 200,
                    ),
                    Text(
                      "Great!",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "You've purchase premium subscription!",
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        else
          return _subscribeBody(context);
      },
    );
  }

  Widget _subscribeBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Go Premium"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(LineIcons.angle_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 80),
        children: [
          _infoTable(context),
          ColumnDivider(),
          _listPremium(),
          Text(
            "This subscription gives you unlimited access to all app features. If you don't cancel before trial ends, you will be charged the amount chosen above until you cancel",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )
        ],
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 50,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: _selectedId != null ? primaryColor.withOpacity(.3) : Colors.grey.withOpacity(.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: FlatButton(
          padding: EdgeInsets.symmetric(horizontal: 20),
          color: primaryColor,
          disabledColor: Colors.grey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Text(
            "Subscribe",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: _selectedId != null ? _subscribeClick : null,
        ),
      ),
      bottomNavigationBar: AdsProvider.adbottomSpace(),
    );
  }

  Widget _listPremium() {
    return Consumer<PurchaseProvider>(
      builder: (context, value, child) {
        if (value?.subscriptionProducts != null && (value?.subscriptionProducts?.length ?? 0) > 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: value.subscriptionProducts.map(
              (e) {
                String harga = e.currency + " " + (e.price.contains(".") ? e.price.split(".").first : e.price);
                String duration = e.subscriptionPeriodAndroid.toLowerCase().replaceAll("p", " / ").replaceAll("w", " Week").replaceAll("m", " Month").replaceAll("y", "Year").replaceAll("d", "Days");

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedId = e.productId;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            e.title,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(text: harga, style: GoogleFonts.poppins(color: Colors.black)),
                              TextSpan(text: duration, style: GoogleFonts.poppins(color: Colors.grey)),
                            ]),
                          ),
                          Text(
                            e.description,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _selectedId == e.productId ? primaryColor : grey, width: 2),
                  ),
                );
              },
            ).toList(),
          );
        } else {
          return Container(
            height: 150,
            alignment: Alignment.center,
            child: Text(
              "Not Available!",
              textAlign: TextAlign.center,
            ),
          );
        }
      },
    );
  }

  Widget _infoTable(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: greyMuchWhite, borderRadius: BorderRadius.only(topLeft: Radius.circular(10))),
                child: Text("Location"),
              ),
              ColumnDivider(space: 2),
              Container(
                padding: EdgeInsets.all(10),
                height: 40,
                color: greyMuchWhite,
                child: Text("Encryption"),
              ),
              ColumnDivider(space: 2),
              Container(
                padding: EdgeInsets.all(10),
                color: greyMuchWhite,
                height: 40,
                child: Text("High Speed"),
              ),
              ColumnDivider(space: 2),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: greyMuchWhite, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                child: Text("Ad-free"),
                height: 40,
              ),
            ],
          ),
        ),
        RowDivider(space: 3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                decoration: BoxDecoration(color: greyMuchWhite, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                child: Text(
                  "Free\n4",
                  textAlign: TextAlign.center,
                ),
              ),
              ColumnDivider(space: 2),
              CustomInfoWidget(
                child: _activeWidget(context),
              ),
              ColumnDivider(space: 2),
              CustomInfoWidget(
                child: SizedBox(
                  height: 20,
                ),
              ),
              ColumnDivider(space: 2),
              CustomInfoWidget(
                child: SizedBox(
                  height: 20,
                ),
              ),
            ],
          ),
        ),
        RowDivider(space: 3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 10),
                decoration: BoxDecoration(color: greyMuchWhite, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                child: Text(
                  "Premium\n12",
                  textAlign: TextAlign.center,
                ),
              ),
              ColumnDivider(space: 2),
              CustomInfoWidget(
                child: _activeWidget(context),
              ),
              ColumnDivider(space: 2),
              CustomInfoWidget(
                child: _activeWidget(context),
              ),
              ColumnDivider(space: 2),
              CustomInfoWidget(
                child: _activeWidget(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _activeWidget(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 15,
        ),
      ),
    );
  }

  void _subscribeClick() async {
    PurchaseProvider purchaseProvider = Provider.of<PurchaseProvider>(context, listen: false);
    await purchaseProvider.subscribe(_selectedId);
  }
}

class CustomInfoWidget extends StatelessWidget {
  final double leftTop;
  final double leftBottom;
  final double rightTop;
  final Widget child;

  const CustomInfoWidget({Key key, this.leftTop, this.leftBottom, this.rightTop, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 40,
      decoration: BoxDecoration(
        color: greyMuchWhite,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(leftBottom ?? 0), topRight: Radius.circular(rightTop ?? 0), topLeft: Radius.circular(leftTop ?? 0)),
      ),
      child: child,
    );
  }
}
