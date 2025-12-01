import '../../../utils/common_snackbar.dart';
import '../../splash_screen/splash_screen.dart';

applyLoginCheck(void Function() onTap)async {
  if(isLogin == false){
    showSnackbar(message: "Login Required!");
  }
  else{
    onTap();
  }
}