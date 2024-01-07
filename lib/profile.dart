// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utilpost.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoad = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> w1 = [
      FacileTheme.headlineLarge(context, gUsuario.nomeLojaFisica).animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 400.ms, duration: 4000.ms, color: Colors.grey),
      FacileTheme.headlineMedium(context, gUsuario.nome),
      FacileTheme.displaySmall(context, gUsuario.nomeCargo),
      FacileTheme.headlineMedium(context, 'TERMINAL'),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FacileTheme.displaySmall(context, gUsuario.terminalHost),
        ],
      ),
      getEspacadorDuplo(),
    ];

    List<Widget> w2 = [
      Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: FacileTheme.getColorButton(context),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              blurRadius: gDevice.isTabletAll ? 30 : 30,
              color: FacileTheme.getColorHard(context),
              offset: const Offset(10, 10),
            )
          ],
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            menuFotoPerfil(context);
          },
          child: Hero(
            tag: 'imageProfile',
            child: ClipOval(
              child: SizedBox.fromSize(
                size: Size.fromRadius(
                  getMaxSizedImagemProfile(context) * 4,
                ),
                child: Image.network(
                  gUsuario.imagem,
                  fit: BoxFit.cover,
                ).animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 3400.ms, duration: 1000.ms, color: Colors.white.withOpacity(.1)),
              ),
            ),
          ),
        ),
      ),
      getEspacadorDuplo(),
      getEspacadorDuplo(),
      getEspacadorDuplo(),
      getEspacadorDuplo(),
    ];

    return Focus(
      autofocus: true,
      onKey: (node, event) {
        onFocusKey(context, event);
        return KeyEventResult.ignored;
      },
      child: WillPopScope(
        onWillPop: () async {
          return !isLoad;
        },
        child: SafeArea(
          child: Scaffold(
            appBar: getCupertinoAppBar(context, 'PROFILE', []),
            body: getStackCupertino(
              context,
              getBackgroundColor(context, minimize: true),
              getBody(
                context,
                w1,
                w2,
                flex1: 5,
                flex2: 5,
                delay: false,
                cardSuave: true,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      debugPrint('AberturaPage::onFocusKey::$s');

      if (s == 'Escape') {
        //Navigator.pop(context);
      }
    }
  }

  menuFotoPerfil(context) {
    if (gDevice.isWindows) {
      showAlertWarning(context, 'Aviso', 'Mudança da foto do seu perfil somente pelo APP !');
      return;
    }

    final action = CupertinoActionSheet(
      title: FacileTheme.headlineSmall(context, 'FOTO DO PERFIL'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            isLoad = true;
            Navigator.pop(context);
            getImageFromDevice(context, ImageSource.camera, gUsuario.idFuncionario);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              FacileTheme.displaySmall(context, "CÂMERA"),
            ],
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            getImageFromDevice(context, ImageSource.gallery, gUsuario.idFuncionario);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.collections_bookmark_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              FacileTheme.displaySmall(context, "GALERIA"),
            ],
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: FacileTheme.displaySmall(context, 'CANCELA'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  void getImageFromDevice(context, imgsrc, idFuncionario) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: imgsrc,
      maxHeight: 1080,
      maxWidth: 1080,
      imageQuality: 50,
    );

    if (image != null) {
      var file = File(image.path);

      final fileBytes = file.readAsBytesSync();
      final decodedImage = await decodeImageFromList(file.readAsBytesSync());

      String baseimage = base64Encode(fileBytes);

      debugPrint(image.name);
      debugPrint(image.path);
      debugPrint('size:${baseimage.length}');

      ///
      ///Envio
      ///
      Map<String, String> params = {
        'Funcao': 'AtualizaFoto',
        'fileName': image.name,
        'fileBytes': baseimage,
        'largura': decodedImage.width.toString(),
        'altura': decodedImage.height.toString(),
      };

      var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: true);

      isLoad = false;
      if (aResult == null) {
      } else if (aResult != null && aResult['Status'] == 'OK') {
        gUsuario.imagem = aResult['novaImagem'];
        if (mounted) {
          setState(() {});
        }
      } else {
        facileSnackBarError(context, 'Ops!', aResult['Msg']);
      }
    }
  }
}
