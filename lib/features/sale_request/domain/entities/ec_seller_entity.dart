import 'package:celta_inventario/features/sale_request/domain/entities/bsf/bsf_employee_entity.dart';
import 'package:equatable/equatable.dart';

class EcSellerEntity extends Equatable {
  final int Id;
  final String Name;

  const EcSellerEntity({required this.Id, required this.Name});

  @override
  List<Object?> get props => [Id, Name];

  BSFEmployeeEntity toBsfEmployee() {
    return BSFEmployeeEntity(
      code: Id,
      name: Name,
      personalizedCode: null,
      buyer: null,
      seller: true,
      sellerType: null,
      providerService: null,
      pdvOperator: null,
      observations: null,
      paysBank: null,
      driverInfos: null,
      admissionDate: null,
      dismissalDate: null,
      dateOfBirth: null,
      cpfNumber: null,
      formatedCpfNumber: null,
      rgNumber: null,
      pisNumber: null,
      formatedRgNumber: null,
      nameReduced: null,
      email: null,
      isFired: null,
      jobRoleString: null,
      accountEmails: null,
    );
  }
}

