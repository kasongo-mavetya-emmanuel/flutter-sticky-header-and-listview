import 'package:bloc/bloc.dart';

class ScrollCubit extends Cubit<double>{
  ScrollCubit():super(0.0);

  void setOffSet(double offset){
    emit(offset);
  }

}