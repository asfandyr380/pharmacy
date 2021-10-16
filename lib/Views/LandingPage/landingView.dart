import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_store/Config/const.dart';
import 'package:medical_store/Views/LandingPage/landingViewModel.dart';
import 'package:medical_store/Views/Purchase/NewPurchase/newpurchase.dart';
import 'package:medical_store/Views/Sales/NewSales/newSales.dart';
import 'package:stacked/stacked.dart';
import "package:velocity_x/velocity_x.dart";

class LandingPage extends StatelessWidget {
  ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LandingPageViewModel>.reactive(
      viewModelBuilder: () => LandingPageViewModel(),
      onModelReady: (model) => model.init(context),
      builder: (ctx, model, child) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          backgroundColor: primaryColor,
          title: 'Pharmacy'.text.xl3.make(),
          actions: [
            CircleAvatar(
              backgroundColor: Vx.white,
              child: "${model.name[0]}".text.make(),
            ),
            SizedBox(
              width: context.percentWidth * 1,
            ),
            Container(
              margin: EdgeInsets.only(right: context.percentWidth * 1),
              alignment: Alignment.center,
              child: "${model.name}".text.xl.make(),
            )
          ],
        ),
        drawer: context.mdWindowSize == VxWindowSize.small ||
                context.mdWindowSize == VxWindowSize.xsmall
            ? Drawer(
                child: Column(
                  children: [
                    for (var item in model.role == 'Admin'
                        ? model.drawerItems
                        : model.drawerItemsEmployee)
                      DrawerTile(
                        label: item['label'],
                        icon: item['icon'],
                        isActive: item['isActive'],
                        onTap: (page) =>
                            model.navigate(page, item['content'], item),
                      ),
                  ],
                ),
              )
            : null,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            context.mdWindowSize == VxWindowSize.small ||
                    context.mdWindowSize == VxWindowSize.xsmall
                ? Container()
                : Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      controller: _controller,
                      child: Material(
                        child: Column(
                          children: [
                            for (var item in model.role == 'Admin'
                                ? model.drawerItems
                                : model.drawerItemsEmployee)
                              DrawerTile(
                                label: item['label'],
                                icon: item['icon'],
                                isActive: item['isActive'],
                                onTap: (page) =>
                                    model.navigate(page, item['content'], item),
                              ),
                            DrawerTile(
                              label: 'Logout',
                              icon: FontAwesomeIcons.doorOpen,
                              isActive: false,
                              onTap: (_) => model.signOut(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            Expanded(
              flex: 8,
              child: Container(
                color: accentColor,
                height: double.infinity,
                child: Stack(
                  children: [
                    Visibility(
                      visible: model.isVisible,
                      maintainState: true,
                      child: NewPurchaseView(),
                    ),
                    Visibility(
                      visible: model.isVisible1,
                      maintainState: true,
                      child: NewSalesView(),
                    ),
                    model.content.hide(
                        isVisible: model.isVisible
                            ? !model.isVisible
                            : !model.isVisible1)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final bool? isActive;
  final Function(String)? onTap;
  const DrawerTile({this.icon, this.isActive, this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    bool _isActive = isActive ?? false;
    return GestureDetector(
      onTap: () => onTap!(label!),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          color: _isActive ? accentColor : null,
          height: context.percentHeight * 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Spacer(),
              Container(
                width: context.percentWidth * 4,
                child: Icon(
                  icon,
                  color: _isActive ? primaryColor : textColor,
                  size: context.percentWidth * 2,
                ),
              ),
              SizedBox(
                width: context.percentWidth * 2,
              ),
              Container(
                width: context.percentWidth * 10,
                child: Text(
                  "$label",
                  style: TextStyle(color: _isActive ? primaryColor : textColor),
                ).text.xl2.normal.make(),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
