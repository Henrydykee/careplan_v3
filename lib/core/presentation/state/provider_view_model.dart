import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ViewModelProvider<T extends ChangeNotifier> extends StatefulWidget {
  final T viewModel;
  final Widget Function(BuildContext context, T value, Widget? child) builder;
  final Function(T)? onModelReady;

  const ViewModelProvider({
    super.key,
    required this.viewModel,
    required this.builder,
    this.onModelReady,
  });

  @override
  _ViewModelProviderState<T> createState() => _ViewModelProviderState<T>();
}

class _ViewModelProviderState<T extends ChangeNotifier>
    extends State<ViewModelProvider<T>> {
  late T model;

  @override
  void initState() {
    super.initState();
    model = widget.viewModel;
    widget.onModelReady?.call(model);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer<T>(
        builder: (context, model, child) {
          return widget.builder(context, model, child);
        },
      ),
    );
  }
}


class DualViewModelProvider<A extends ChangeNotifier, B extends ChangeNotifier> extends StatefulWidget {
  final A viewModelA;
  final B viewModelB;
  final Function(A, B)? onModelsReady;
  final Widget Function(BuildContext context, A modelA, B modelB, Widget? child) builder;

  const DualViewModelProvider({
    super.key,
    required this.viewModelA,
    required this.viewModelB,
    required this.builder,
    this.onModelsReady,
  });

  @override
  State<DualViewModelProvider<A, B>> createState() => _DualViewModelProviderState<A, B>();
}

class _DualViewModelProviderState<A extends ChangeNotifier, B extends ChangeNotifier>
    extends State<DualViewModelProvider<A, B>> {
  late A modelA;
  late B modelB;

  @override
  void initState() {
    super.initState();
    modelA = widget.viewModelA;
    modelB = widget.viewModelB;
    widget.onModelsReady?.call(modelA, modelB);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<A>.value(value: modelA),
        ChangeNotifierProvider<B>.value(value: modelB),
      ],
      child: Consumer2<A, B>(
        builder: (context, modelA, modelB, child) {
          return widget.builder(context, modelA, modelB, child);
        },
      ),
    );
  }
}
