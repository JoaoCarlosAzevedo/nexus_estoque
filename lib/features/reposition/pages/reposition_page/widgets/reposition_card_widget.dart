import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/features/reposition/data/model/reposition_model.dart';
import 'package:nexus_estoque/features/reposition/pages/reposition_page/widgets/timeline_widget.dart';
import 'package:timeline_tile/timeline_tile.dart';

class RepositionCard extends StatelessWidget {
  const RepositionCard({super.key, required this.reposition});
  final RepositionModel reposition;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title:
                  Text('${reposition.codProduto} - ${reposition.descProduto}'),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('UM: ${reposition.um}'),
                  Text('Local: ${reposition.local}'),
                  Text('Vol.: ${reposition.volume}'),
                ],
              ),
            ),
            const Divider(
              height: 1,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TimelineTile(
                        axis: TimelineAxis.vertical,
                        alignment: TimelineAlign.start,
                        isFirst: true,
                        //beforeLineStyle: LineStyle(color: Colors.red),
                        indicatorStyle: IndicatorStyle(
                          width: 30,
                          //color: Colors.orange,
                          //padding: const EdgeInsets.all(8),
                          //indicator: FaIcon(FontAwesomeIcons.circleArrowDown),
                          iconStyle: IconStyle(
                            fontSize: 30,
                            color: Colors.white,
                            iconData: Icons.radio_button_checked,
                          ),
                        ),
                        endChild: Container(
                          constraints: const BoxConstraints(
                            minHeight: 50,
                          ),
                          //color: Colors.amberAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${reposition.codEnderecoRetira} - ${reposition.descEnderecoRetira}'),
                                Text(
                                  'Dispo. ${reposition.disponivel}',
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      TimelineTile(
                        axis: TimelineAxis.vertical,
                        alignment: TimelineAlign.start,
                        isFirst: false,
                        isLast: true,
                        //beforeLineStyle: LineStyle(color: Colors.red),
                        indicatorStyle: IndicatorStyle(
                          drawGap: false,
                          width: 30,
                          //color: Colors.green,
                          //padding: const EdgeInsets.all(8),
                          iconStyle: IconStyle(
                            fontSize: 30,
                            color: Colors.white,
                            iconData: Icons.arrow_circle_right_rounded,
                          ),
                          //indicator: FaIcon(FontAwesomeIcons.circleArrowRight),
                        ),
                        endChild: Container(
                          constraints: const BoxConstraints(
                            minHeight: 50,
                          ),
                          //color: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${reposition.codEndereco} - ${reposition.descEndereco}'),
                                Text(
                                  'Saldo. ${reposition.quant}',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const Text(
                      'Abast.',
                    ),
                    Text(
                      '${reposition.quantAbastecer}',
                      style: const TextStyle(color: Colors.green, fontSize: 25),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
