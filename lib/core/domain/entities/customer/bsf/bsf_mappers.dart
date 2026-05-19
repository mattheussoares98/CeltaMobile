import '../../entities.dart';

extension SoapCustomerEntityToBsf on SoapCustomerEntity {
  BSFCustomerEntity toBSFCustomerEntity() {
    return BSFCustomerEntity(
      code: Code,
      personalizedCode: PersonalizedCode,
      name: Name,
      nameReduced: ReducedName,
      cnpjCpfNumber: CpfCnpjNumber,
      suframaCode: null,
      limitOfPurchase: null,
      inscriptionRgNumber: RegistrationNumber,
      paymentFinalizations: null,
      paymentConditions: null,
      saleBlockade: saleBlockade?.toBsf(),
      saleBlockadeInstruction: saleBlockadeInstruction?.toBsf(),
      covenants: CustomerCovenants?.map((e) => e.toBsf()).toList(),
      covenantCode: null,
    );
  }
}

extension CustomerSaleBlockadeEntityToBsf on CustomerSaleBlockadeEntity {
  BsfSaleBlockadeEntity toBsf() {
    return BsfSaleBlockadeEntity(
      code: Code,
      personalizedCode: PersonalizedCode,
      legacyCode: LegacyCode,
      description: Description,
      allowSale: AllowSale,
      allowSaleRequest: AllowSaleRequest,
      allowSaleWithPaymentFinalizationTypeCheckOrPortion:
          AllowSaleWithPaymentFinalizationTypeCheckOrPortion,
      stringAllowSale: null,
      stringAllowSaleRequest: null,
      stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion: null,
    );
  }
}

extension CustomerSaleBlockadeInstructionEntityToBsf
    on CustomerSaleBlockadeInstructionEntity {
  BsfSaleBlockadeInstructionEntity toBsf() {
    return BsfSaleBlockadeInstructionEntity(
      code: Code,
      personalizedCode: PersonalizedCode,
      legacyCode: LegacyCode,
      description: Description,
    );
  }
}

extension CustomerCovenantEntityToBsf on CustomerCovenantEntity {
  BsfCovenantEntity toBsf() {
    return BsfCovenantEntity(
      code: covenant?.Code,
      personalizedCode: covenant?.PersonalizedCode,
      legacyCode: null,
      name: covenant?.Name ?? '',
      fantasyName: covenant?.Name,
      cnpjNumber: null,
      formatedCnpjNumber: null,
      stateRegistration: null,
      formatedStateRegistration: null,
      dateOfCadaster: null,
      email: null,
      dateOfBirthContact: null,
      nameOfContact: null,
      haveObservations: null,
      requiredConveneMatriculate: null,
      allowSaleAdditional: null,
      address: null,
      deliveryAddress: null,
      collectAddress: null,
      saleBlockade: null,
      saleBlockadeInstruction: null,
    );
  }
}
