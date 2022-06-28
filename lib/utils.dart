import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:stream_transform/stream_transform.dart';

import 'config.dart';

/// Transformer for BLoC which permit only one event by `duration`.
EventTransformer<E> eventThrottler<E>([
  Duration duration = C.defaultEventThrottleDuration,
]) =>
    (events, mapper) => droppable<E>().call(events.throttle(duration), mapper);
