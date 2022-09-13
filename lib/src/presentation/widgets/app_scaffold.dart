import 'package:bloc_base_core/bloc_base_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AppScaffold extends Scaffold {
  const AppScaffold({
    Key? key,
    super.appBar,
    super.body,
    super.floatingActionButton,
    super.floatingActionButtonLocation,
    super.floatingActionButtonAnimator,
    super.persistentFooterButtons,
    super.drawer,
    super.onDrawerChanged,
    super.endDrawer,
    super.onEndDrawerChanged,
    super.bottomNavigationBar,
    super.bottomSheet,
    super.backgroundColor,
    super.resizeToAvoidBottomInset,
    super.primary = true,
    super.drawerDragStartBehavior = DragStartBehavior.start,
    super.extendBody = false,
    super.extendBodyBehindAppBar = false,
    super.drawerScrimColor,
    super.drawerEdgeDragWidth,
    super.drawerEnableOpenDragGesture = true,
    super.endDrawerEnableOpenDragGesture = true,
    super.restorationId,
  }) : super(key: key);

  @override
  ScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends ScaffoldState {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Column(
      children: [
        Expanded(child: super.build(context)),
        if (_resizeToAvoidBottomInset)
          KeyboardSpacing(
            color: widget.backgroundColor ?? themeData.scaffoldBackgroundColor,
          )
      ],
    );
  }

  bool get _resizeToAvoidBottomInset {
    return widget.resizeToAvoidBottomInset ?? true;
  }
}
