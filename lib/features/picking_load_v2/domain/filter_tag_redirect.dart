import '../data/model/shippingv2_model.dart';

class FilterTagRedirectUseCase {
  static bool isDepartmentEndig(
      String department, String load, List<Shippingv2Model> loadList) {
    int indexDepartment;
    int indexLoad = loadList.indexWhere((element) => element.codCarga == load);

    if (indexLoad == -1) {
      //se a carga ja foi encerrada
      indexDepartment = -1;
    } else {
      //caso contrario verifica se tem produtos do deposito 03
      indexDepartment = loadList[indexLoad]
          .pedidos
          .indexWhere((element) => element.deposito == department);
    }

    //se a carga nao retornou significa q terminou
    //ou quando ainda existe carga porem produtos do deposito 03 ja separam
    if (indexLoad == -1 || indexDepartment == -1) {
      return true;
    }
    return false;
  }
}
