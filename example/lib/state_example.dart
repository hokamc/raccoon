import 'dart:math';

import 'package:flutter/material.dart';
import 'package:raccoon/raccoon.dart';

class StateExample extends Module {
  @override
  Future<void> initial() async {
    bind(ColorsBloc());
  }

  @override
  Widget build(BuildContext context) {
    final ColorsBloc colorsBloc = inject();

    LOG.debug('build');
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: colorsBloc.boxes.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return DataBuilder(
                  data: colorsBloc.boxes[index],
                  builder: (context, color) {
                    LOG.debug('build$index');
                    return Container(color: color, width: 200, height: 200);
                  },
                );
              },
            ),
          ),
          MultiDataBuilder(
            datas: [colorsBloc.boxes[0], colorsBloc.boxes[1]],
            converter: (datas) => TwoColor(datas[0], datas[1]),
            builder: (context, TwoColor colors) {
              return Row(
                children: [
                  Expanded(child: Container(color: colors.first, height: 100)),
                  Expanded(child: Container(color: colors.second, height: 100)),
                ],
              );
            },
          ),
          FlatButton(
            onPressed: () {
              colorsBloc.changeColor();
            },
            child: Text('Change Colors'),
          ),
        ],
      ),
    );
  }
}

class ColorsBloc implements Disposable {
  final List<Data<Color>> boxes = List.generate(100, (index) => Data(Colors.red));

  void changeColor() {
    for (var i = 0; i < 50; i++) {
      boxes[Random().nextInt(boxes.length)].push(Color(Random().nextInt(0xFFFFFFFF)));
    }
  }

  @override
  void dispose() {
    boxes.forEach((box) {
      box.dispose();
    });
  }
}

class TwoColor {
  final Color first;
  final Color second;

  const TwoColor(this.first, this.second);
}
