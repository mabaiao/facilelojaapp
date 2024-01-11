import 'dart:math';
import 'package:facilelojaapp/configuraimpressoraex.dart';
import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/produtos.dart';
import 'package:facilelojaapp/profile.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'caixa.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool isLoad = false;
  List<Widget> bg = [];

  @override
  void initState() {
    super.initState();
    load(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void load(context) async {}

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      //log('AberturaPage::onFocusKey::$s');

      if (s == 'Escape') {
        Navigator.pop(context);
      }
      if (s == 'F6') {
        goProdutos(context);
      }
      if (s == 'F10') {
        gTema.changeColor(context);
      }
      if (s == 'F11') {
        gTema.changeTheme(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bg.isEmpty) {
      bg = getBackground(context);
    }

    List<Widget> w1 = [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  blurRadius: gDevice.isTabletAll ? 18 : 18,
                  color: FacileTheme.getColorPrimary(context),
                  offset: const Offset(0, 0),
                )
              ],
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () async {
                showCupertinoModalBottomSheet(
                  duration: getCupertinoModalBottomSheetDuration(),
                  context: context,
                  builder: (context) => const ProfilePage(),
                ).then(
                  (value) {
                    setState(() {});
                  },
                );
              },
              child: Hero(
                tag: 'imageProfile',
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(
                      getMaxSizedImagemProfile(context),
                    ),
                    child: Image.network(
                      gUsuario.imagem,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          getEspacadorVertical(),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    FacileTheme.headlineMedium(context, 'Olá ${gUsuario.primeiroNome}'),
                  ],
                ),
                Row(
                  children: [
                    FacileTheme.displaySmall(context, gUsuario.nomeCargo),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ];

    List<FormIconButton> listFormIconButton = [];

    listFormIconButton.add(
      FormIconButton(
        caption: getTextWindowsKey('Dash', 'F1'),
        icon: Icons.dashboard_outlined,
        onTap: () {},
      ),
    );
    listFormIconButton.add(
      FormIconButton(
        caption: getTextWindowsKey('Caixa', 'F2'),
        icon: Icons.point_of_sale_outlined,
        onTap: () {
          goCaixa(context);
        },
      ),
    );
    listFormIconButton.add(
      FormIconButton(
        caption: getTextWindowsKey('Pedidos', 'F3'),
        icon: Icons.app_registration_outlined,
        onTap: () {},
      ),
    );
    listFormIconButton.add(
      FormIconButton(
        caption: getTextWindowsKey('Mesas', 'F4'),
        icon: Icons.restaurant_menu_outlined,
        onTap: () {},
      ),
    );
    listFormIconButton.add(
      FormIconButton(
        caption: getTextWindowsKey('Delivery', 'F5'),
        icon: Icons.delivery_dining_outlined,
        onTap: () {},
      ),
    );
    listFormIconButton.add(
      FormIconButton(
        caption: getTextWindowsKey('Produtos', 'F6'),
        icon: CupertinoIcons.barcode,
        onTap: () {
          goProdutos(context);
        },
      ),
    );
    listFormIconButton.add(
      FormIconButton(
        caption: getTextWindowsKey('Inventário', 'F7'),
        icon: Icons.inventory_outlined,
        onTap: () {},
      ),
    );
    listFormIconButton.add(
      FormIconButton(
        caption: getTextWindowsKey('Impressora', 'F8'),
        icon: Icons.print_outlined,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ConfiguraImpressoraExPage(),
            ),
          ).then((value) {});
        },
      ),
    );
    listFormIconButton.add(
      FormIconButton(
        caption: getTextWindowsKey('Configurações', 'F9'),
        icon: Icons.settings_outlined,
        onTap: () {},
      ),
    );
    listFormIconButton.add(
      FormIconButton(
        caption: getTextWindowsKey('Cor', 'F10'),
        icon: Icons.color_lens_outlined,
        onTap: () {
          gTema.changeColor(context);
        },
      ),
    );
    listFormIconButton.add(
      FormIconButton(
        caption: getTextWindowsKey('Escuro/Claro', 'F11'),
        icon: Icons.mode_night_outlined,
        onTap: () {
          gTema.changeTheme(context);
        },
      ),
    );

    List<Widget> w2 = [
      SizedBox(
        width: getMaxSizedBoxWidth(context),
        height: getMaxSizedBoxHeight(context) *
            (gDevice.isTabletLandscape
                ? 0.9
                : gDevice.isWindows
                    ? 1
                    : 0.8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 15,
                crossAxisCount: gDevice.isPhoneAll ? 2 : 3,
                mainAxisSpacing: 5,
                mainAxisExtent: gDevice.isTabletLandscape ? 150 : 170,
              ),
              itemCount: listFormIconButton.length,
              itemBuilder: (BuildContext context, int index) {
                var boxShadow = const [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.transparent,
                    offset: Offset(3, 3),
                  )
                ];

                Widget card = Card(
                  shadowColor: Colors.transparent,
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FacileTheme.displaySmall(context, listFormIconButton[index].caption),
                      Hero(
                        tag: 'heroPad$index',
                        child: Icon(
                          listFormIconButton[index].icon,
                          size: 60,
                        ),
                      ),
                    ],
                  ),
                );

                if (index == 0) {
                  var gradient = const LinearGradient(
                    colors: [
                      Colors.orange,
                      Colors.red,
                      Colors.pink,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  );

                  card = Container(
                    padding: getPaddingDefault(context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: gradient,
                      boxShadow: boxShadow,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FacileTheme.displaySmall(context, listFormIconButton[index].caption),
                        Hero(
                          tag: 'heroPad$index',
                          child: Icon(
                            listFormIconButton[index].icon,
                            size: 60,
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate(
                        onPlay: (controller) => controller.repeat(),
                      )
                      .shimmer(delay: 1500.ms, duration: 2000.ms);
                }

                return SizedBox(
                  width: getMaxSizedBoxWidth(context) * 0.2,
                  height: getMaxSizedBoxHeight(context) * 0.5,
                  child: InkWell(
                    onTap: listFormIconButton[index].onTap,
                    child: card,
                  ),
                );
              }),
        ),
      ),
    ];

    return Focus(
      autofocus: true,
      onKey: (node, event) {
        onFocusKey(context, event);
        return KeyEventResult.ignored;
      },
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: SafeArea(
          child: Scaffold(
            body: getStackCupertino(
              context,
              getBackground(context),
              getBody(context, w1, w2, flex1: 4, flex2: 6, mainAxisAlignment: MainAxisAlignment.center),
            ),
          ),
        ),
      ),
    );
  }

  void goCaixa(context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const CaixaPage(),
      ),
    ).then((value) {
      //log('value=$value');
    });
  }

  void goProdutos(context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const ProdutosPage(modo: ProdutosModo.editar, find: ''),
      ),
    ).then((value) {
      //log('value=$value');
    });
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step), halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep), halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
