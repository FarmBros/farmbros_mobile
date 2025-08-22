import 'package:farmbros_mobile/common/widgets/farmbros_bottomsheet.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class FarmLogger extends StatelessWidget {
  const FarmLogger({super.key});

  void _openBottomsheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FarmbrosBottomsheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {},
          child: Icon(
            FluentIcons.ios_arrow_24_regular,
            color: ColorUtils.secondaryColor,
          ),
        ),
        title: Text(
          "Farm Logger",
          style: TextStyle(
            color: ColorUtils.secondaryTextColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/alt_background.png"),
          ),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height / 3,
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorUtils.secondaryBackgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DefaultTabController(
            length: 4,
            child: Column(
              children: [
                TabBar(
                  indicatorColor: ColorUtils.secondaryColor,
                  labelStyle:
                      TextStyle(color: ColorUtils.secondaryColor, fontSize: 14),
                  unselectedLabelStyle:
                      TextStyle(color: ColorUtils.inActiveColor, fontSize: 12),
                  tabs: const [
                    Tab(text: "Animals"),
                    Tab(text: "Crops"),
                    Tab(text: "Equipment"),
                    Tab(text: "Structures"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildAnimalLogger(context),
                      _buildCropLogger(context),
                      _buildEquipmentLogger(context),
                      _buildStructureLogger(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openBottomsheet(context),
        child: const Icon(FluentIcons.filter_24_regular),
      ),
    );
  }

  Widget _buildAnimalLogger(BuildContext context) => Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 1.5,
          width: MediaQuery.of(context).size.width / 1.5,
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Ooops!",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: ColorUtils.secondaryColor,
                    fontSize: 24),
              ),
              Image(image: AssetImage("assets/images/empty.png")),
              Text(
                  textAlign: TextAlign.center,
                  "How Empty, Add some "
                  "animals to log them on this screen. "
                  "Use “Drag to Show” below.")
            ],
          ),
        )
      ]);
  Widget _buildCropLogger(BuildContext context) => Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 1.5,
          width: MediaQuery.of(context).size.width / 1.5,
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Ooops!",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: ColorUtils.secondaryColor,
                    fontSize: 24),
              ),
              Image(image: AssetImage("assets/images/empty.png")),
              Text(
                  textAlign: TextAlign.center,
                  "How Empty, Add some "
                  "animals to log them on this screen. "
                  "Use “Drag to Show” below.")
            ],
          ),
        )
      ]);
  Widget _buildStructureLogger(BuildContext context) => Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 1.5,
          width: MediaQuery.of(context).size.width / 1.5,
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Ooops!",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: ColorUtils.secondaryColor,
                    fontSize: 24),
              ),
              Image(image: AssetImage("assets/images/empty.png")),
              Text(
                  textAlign: TextAlign.center,
                  "How Empty, Add some "
                  "animals to log them on this screen. "
                  "Use “Drag to Show” below.")
            ],
          ),
        )
      ]);
  Widget _buildEquipmentLogger(BuildContext context) => Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 1.5,
          width: MediaQuery.of(context).size.width / 1.5,
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Ooops!",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: ColorUtils.secondaryColor,
                    fontSize: 24),
              ),
              Image(image: AssetImage("assets/images/empty.png")),
              Text(
                  textAlign: TextAlign.center,
                  "How Empty, Add some "
                  "animals to log them on this screen. "
                  "Use “Drag to Show” below.")
            ],
          ),
        )
      ]);
}
