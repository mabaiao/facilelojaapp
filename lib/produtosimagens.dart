import 'dart:convert';
import 'dart:io';

import 'package:facilelojaapp/dados/produto.dart';
import 'package:facilelojaapp/dados/produtoimagem.dart';
import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/produtosimagensavancado.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utilpost.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:share/share.dart';
import 'package:image/image.dart' as img;
import 'package:insta_image_viewer/insta_image_viewer.dart';

///
/// Editar imagens do produto
///

class ProdutosImagens extends StatefulWidget {
  final Produto produto;
  final PopReturns popReturns;
  final String svgSemFoto;

  const ProdutosImagens({
    super.key,
    required this.produto,
    required this.popReturns,
    required this.svgSemFoto,
  });

  @override
  State<ProdutosImagens> createState() => _ProdutosImagensState();
}

class _ProdutosImagensState extends State<ProdutosImagens> {
  List<Widget> bg = [];
  bool isLoad = true;

  late List<ProdutoImagem> listImagensProduto = List.empty();

  @override
  void initState() {
    load(context);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void load(context) async {
    isLoad = true;
    setState(() {});

    Map<String, String> params = {
      'Funcao': 'LeProduto',
      'ID': widget.produto.id,
    };

    var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: false);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
      String imagens = aResult['registro']['jsonImagens'];

      if (imagens.isNotEmpty) {
        Iterable lp = jsonDecode(imagens);
        listImagensProduto = lp.map((model) => ProdutoImagem.fromMap(model)).toList();
      }

      if (mounted) {
        isLoad = false;
        setState(() {});
      }
    } else {
      facileSnackBarError(context, 'Ops!', aResult['Msg']);
    }
  }

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      debugPrint('ProdutosImagens::onFocusKey::$s');

      if (s == 'Escape') {
        Navigator.pop(context, PopReturns('cancelClick', ''));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bg.isEmpty) {
      bg = getBackground(context, minimize: true);
    }

    List<FormFloatingActionButton> listFloatingActionButton = [];

    listFloatingActionButton.add(
      FormFloatingActionButton(
        icon: Icons.share_outlined,
        caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Compartilhar', 'F2'),
        onTap: () {
          compartilhar(context);
        },
      ),
    );

    listFloatingActionButton.add(
      FormFloatingActionButton(
          icon: Icons.add_a_photo_outlined,
          caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Adicionar', 'F1'),
          onTap: () {
            final action = CupertinoActionSheet(
              title: FacileTheme.headlineSmall(context, 'CARREGAR IMAGEM'),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                    getImageFromDevice(context, ImageSource.camera);
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
                    getImageFromDevice(context, ImageSource.gallery);
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
          }),
    );

    int iPage = 0;
    int ind = 0;
    for (var item in listImagensProduto) {
      if (item.fotoPrincipal == 'S') {
        iPage = ind;
      }
      ind++;
    }

    List<Widget> w1 = [
      getEspacador(),
      Row(
        children: [
          Expanded(
            child: FacileTheme.displaySmall(context, widget.produto.nome),
          ),
        ],
      ),
      Container(
        //width: getMaxSizedBoxLottie(context) * .9,
        //height: 300,
        margin: const EdgeInsets.all(8),
        // child: widget.produto.imagemPrincipal.contains('sem-foto')
        //     ? SvgPicture.string(
        //         widget.svgSemFoto.replaceAll(
        //           '#B0BEC5',
        //           gTema.colorArray[gTema.cor].toHex().replaceAll('#ff', '#'),
        //         ),
        //         width: getMaxSizedBoxLottie(context) * .8,
        //       )
        //     : ClipRRect(
        //         borderRadius: BorderRadius.circular(10.0),
        //         child: Image.network(widget.produto.imagemPrincipal),
        //       ),

        child: widget.produto.imagemPrincipal.contains('sem-foto')
            ? SvgPicture.string(
                widget.svgSemFoto.replaceAll(
                  '#B0BEC5',
                  gTema.colorArray[gTema.cor].toHex().replaceAll('#ff', '#'),
                ),
                width: getMaxSizedBoxLottie(context) * .8,
              )
            : listImagensProduto.isEmpty
                ? null
                : FlutterCarousel(
                    options: CarouselOptions(
                      initialPage: iPage,
                      height: gDevice.isTabletAll || gDevice.isWindows ? 500 : 300,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      viewportFraction: 1.0,
                      showIndicator: true,
                      floatingIndicator: false,
                      enlargeStrategy: CenterPageEnlargeStrategy.scale,
                      slideIndicator: CircularSlideIndicator(
                        indicatorBackgroundColor: FacileTheme.getColorPrimary(context),
                        currentIndicatorColor: FacileTheme.getColorButton(context),
                      ),
                    ),
                    items: listImagensProduto.map(
                      (item) {
                        return Builder(
                          builder: (BuildContext context) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: DottedBorder(
                                radius: const Radius.circular(12),
                                borderType: BorderType.RRect,
                                strokeWidth: item.fotoPrincipal == 'S' ? 6 : 6,
                                color: item.fotoPrincipal == 'S' ? FacileTheme.getColorPrimary(context) : Colors.grey.withOpacity(.3),
                                dashPattern: const [6, 6],
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: InstaImageViewer(
                                    backgroundColor: gTema.modo == 'dark' ? Colors.white : Colors.white,
                                    child: Image.network(
                                      item.url,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ).toList(),
                  ),
      ),
      getEspacadorDuplo(),
    ];

    List<Widget> w2 = [
      FacileTheme.displayMedium(context, 'Imagens (${listImagensProduto.length})'),
      getEspacadorDuplo(),
      SizedBox(
        height: listImagensProduto.isEmpty
            ? 0
            : gDevice.isTabletAll || gDevice.isWindows
                ? 400
                : 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: listImagensProduto.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  FacileTheme.displaySmall(context, '${listImagensProduto[i].altura}A x ${listImagensProduto[i].largura}L'),
                  getImage(context, listImagensProduto[i], i),
                  FacileTheme.displaySmall(context, '${(listImagensProduto[i].tamanho / 1024).toStringAsFixed(0)} Kb'),
                ],
              ),
            );
          },
        ),
      ),
      getEspacadorTriplo(),
      getEspacadorTriplo(),
      getEspacadorTriplo(),
    ];

    return Focus(
      autofocus: true,
      onKey: (node, event) {
        onFocusKey(context, event);
        return KeyEventResult.ignored;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: getCupertinoAppBar(context, 'PRODUTO ID ${widget.produto.id}', []),
          floatingActionButton: getFormFloatingActionButtonList(listFloatingActionButton, isLoad: isLoad),
          body: SingleChildScrollView(
            child: getStackCupertino(
              context,
              bg,
              getBody(
                context,
                w1,
                w2,
                flex1: 5,
                flex2: 5,
                mainAxisAlignment: MainAxisAlignment.start,
                delay: false,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getImage(context, ProdutoImagem item, index) {
    return DottedBorder(
      radius: const Radius.circular(12),
      borderType: BorderType.RRect,
      strokeWidth: item.fotoPrincipal == 'S' ? 3 : 1,
      color: item.fotoPrincipal == 'S' ? FacileTheme.getColorPrimary(context) : Colors.grey,
      dashPattern: const [6, 6],
      child: GestureDetector(
        onTap: () {
          final action = CupertinoActionSheet(
            title: FacileTheme.headlineSmall(context, 'IMAGEM'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.pop(context);

                  ///
                  ///Envio
                  ///
                  Map<String, String> params = {
                    'Funcao': 'DefineFotoPrincipalProduto',
                    'ID': widget.produto.id,
                    'idImagem': item.id,
                  };

                  var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: true);

                  if (aResult == null) {
                  } else if (aResult != null && aResult['Status'] == 'OK') {
                    widget.produto.imagemPrincipal = item.url;
                    widget.popReturns.param = 'alterado';
                    facileSnackBarSucess(context, 'Show!', aResult['Msg']);
                    load(context);
                  } else {
                    facileSnackBarError(context, 'Ops!', aResult['Msg']);
                  }
                },
                child: FacileTheme.displaySmall(context, "DEFINIR COMO PRINCIPAL"),
              ),
              CupertinoActionSheetAction(
                isDefaultAction: false,
                onPressed: () async {
                  Navigator.pop(context);

                  showSimNao(context, 'TEM CERTEZA QUE DESEJA REMOVER FUNDO DA FOTO ?', '', () async {
                    Navigator.pop(context);

                    ///
                    ///Envio
                    ///
                    Map<String, String> params = {
                      'Funcao': 'RemoveFundoFoto',
                      'ID': widget.produto.id,
                      'idImagem': item.id,
                    };

                    var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: true);

                    if (aResult == null) {
                    } else if (aResult != null && aResult['Status'] == 'OK') {
                      widget.popReturns.param = 'alterado';
                      facileSnackBarSucess(context, 'Show!', aResult['Msg']);
                      load(context);
                    } else {
                      facileSnackBarError(context, 'Ops!', aResult['Msg']);
                    }
                  });
                },
                child: FacileTheme.displaySmall(context, "REMOVER FUNDO IMAGEM"),
              ),
              CupertinoActionSheetAction(
                isDefaultAction: false,
                onPressed: () async {
                  Navigator.pop(context);

                  showSimNao(context, 'REMOVER IMAGEM ?', '', () async {
                    Navigator.pop(context);

                    ///
                    ///Envio
                    ///
                    Map<String, String> params = {
                      'Funcao': 'RemoverFotoProduto',
                      'ID': widget.produto.id,
                      'idImagem': item.id,
                    };

                    var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: true);

                    if (aResult == null) {
                    } else if (aResult != null && aResult['Status'] == 'OK') {
                      widget.popReturns.param = 'alterado';
                      facileSnackBarSucess(context, 'Show!', aResult['Msg']);
                      load(context);
                    } else {
                      facileSnackBarError(context, 'Ops!', aResult['Msg']);
                    }
                  });
                },
                child: FacileTheme.displaySmall(context, "REMOVER"),
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
        },
        child: Container(
          width: gDevice.isTabletAll || gDevice.isWindows ? 250 : 100,
          height: gDevice.isTabletAll || gDevice.isWindows ? 250 : 100,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(0),
            ),
            image: DecorationImage(
              fit: BoxFit.contain,
              image: NetworkImage(
                item.url,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getImageFromDevice(context, imgsrc) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      preferredCameraDevice: CameraDevice.rear,
      source: imgsrc,
      // maxHeight: 1080,
      // maxWidth: 1080,
      imageQuality: 50,
    );

    if (image != null) {
      var file = File(image.path);

      final fileBytes = file.readAsBytesSync();
      final decodedImage = await decodeImageFromList(file.readAsBytesSync());

      String baseimage = base64Encode(fileBytes);

      ///
      ///Envio
      ///
      Map<String, String> params = {
        'Funcao': 'AdicionaFotoProduto',
        'ID': widget.produto.id,
        'fileName': image.name,
        'fileBytes': baseimage,
        'fileSize': baseimage.length.toString(),
        'largura': decodedImage.width.toString(),
        'altura': decodedImage.height.toString(),
      };

      var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: true);

      if (aResult == null) {
      } else if (aResult != null && aResult['Status'] == 'OK') {
        widget.popReturns.param = 'alterado';
        load(context);
      } else {
        facileSnackBarError(context, 'Ops!', aResult['Msg']);
      }
    }
  }

  void compartilhar(context) {
    final action = CupertinoActionSheet(
      title: FacileTheme.headlineSmall(context, 'COMPARTILHAR IMAGENS'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);

            Map<String, String> params = {
              'Funcao': 'LeImagem64Totas',
              'id': widget.produto.id,
            };

            var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: true);

            if (aResult == null) {
            } else if (aResult != null && aResult['Status'] == 'OK') {
              String vendaTextoCompartilhamentoProdutos = aResult['opcoesGlobais']['_compartilhamentoTextoPadrao'];

              vendaTextoCompartilhamentoProdutos = vendaTextoCompartilhamentoProdutos.replaceAll(';', '\n');

              Iterable lp = aResult['listImagensProduto'];
              List<String> result = [];

              for (final element in lp) {
                var sbytes = element['bytes'];
                var arquivo = element['arquivo'];
                Uint8List bytes = base64Decode(sbytes);

                final image = img.decodeImage(bytes);
                img.drawString(
                  image!,
                  gUsuario.subdominio.toUpperCase(),
                  font: img.arial14,
                );

                // img.drawCircle(
                //   image,
                //   x: 0,
                //   y: 0,
                //   radius: 50,
                //   color: getColor(0,0,255),
                // );

                final modifiedImageBytes = img.encodeJpg(image);

                final appDir = await syspaths.getTemporaryDirectory();
                File file = File('${appDir.path}/$arquivo');
                await file.writeAsBytes(modifiedImageBytes);

                result.add('${appDir.path}/$arquivo');
              }
              Share.shareFiles(result, text: '$vendaTextoCompartilhamentoProdutos\n\n');
            } else {
              facileSnackBarError(context, 'Ops!', aResult['Msg']);
            }
          },
          child: FacileTheme.displaySmall(context, "TODAS AS IMAGENS"),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);

            Map<String, String> params = {
              'Funcao': 'LeImagem64principal',
              'id': widget.produto.id,
            };

            var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: true);

            if (aResult == null) {
            } else if (aResult != null && aResult['Status'] == 'OK') {
              String vendaTextoCompartilhamentoProdutos = aResult['opcoesGlobais']['_compartilhamentoTextoPadrao'];

              vendaTextoCompartilhamentoProdutos = vendaTextoCompartilhamentoProdutos.replaceAll(';', '\n');

              var sbytes = aResult['bytes'];
              var arquivo = aResult['arquivo'];

              Uint8List bytes = base64Decode(sbytes);

              debugPrint('BYTES::');
              debugPrint(sbytes);
              debugPrint(arquivo);

              final appDir = await syspaths.getTemporaryDirectory();
              File file = File('${appDir.path}/$arquivo');
              await file.writeAsBytes(bytes);

              Share.shareFiles(['${appDir.path}/$arquivo'], text: '$vendaTextoCompartilhamentoProdutos\n\n');
            } else {
              facileSnackBarError(context, 'Ops!', aResult['Msg']);
            }
          },
          child: FacileTheme.displaySmall(context, "SOMENTE A PRINCIPAL"),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);

            showCupertinoModalBottomSheet(
              duration: getCupertinoModalBottomSheetDuration(),
              context: context,
              builder: (context) => ProdutosImagensAvancadoPage(
                produto: widget.produto,
              ),
            ).then(
              (value) {},
            );
          },
          child: FacileTheme.displaySmall(context, "AVANÇADO"),
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
}
