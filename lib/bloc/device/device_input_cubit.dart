import 'package:bloc/bloc.dart';
import 'package:buttplug/buttplug.dart';

abstract class DeviceInputState {}

class DeviceInputStateInitial extends DeviceInputState {}

class DeviceInputStateUpdate extends DeviceInputState {
  dynamic value;

  DeviceInputStateUpdate(this.value);
}

class DeviceInputReadEvent {}

class DeviceSubscribeSensorEvent {}

class DeviceSubscribeSensorEventSubscribe extends DeviceSubscribeSensorEvent {}

class DeviceSubscribeSensorEventUnsubscribe
    extends DeviceSubscribeSensorEvent {}

abstract class DeviceInputBloc<T> extends Bloc<T, DeviceInputState> {
  final ButtplugClientDevice _device;
  final String descriptor;
  final List<List<int>> sensorRange;
  final InputType inputType;
  dynamic _currentData = 0;

  DeviceInputBloc(
    this._device,
    this.descriptor,
    this.sensorRange,
    this.inputType,
  ) : super(DeviceInputStateInitial());

  dynamic get currentData => _currentData;
}

class InputReadBloc extends DeviceInputBloc<DeviceInputReadEvent> {
  InputReadBloc(
    super.device,
    super.descriptor,
    super.sensorRange,
    super.inputType,
  ) {
    on<DeviceInputReadEvent>(((event, emit) async {
      var newData = await _device.readInput(inputType);
      // for lists, we might need a deep equality check or just re-emit
      if (_currentData.toString() != newData.toString()) {
        _currentData = newData;
        return emit(DeviceInputStateUpdate(_currentData));
      }
    }));
  }
}
