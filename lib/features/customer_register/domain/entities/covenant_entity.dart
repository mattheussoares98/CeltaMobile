// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class CovenantEntity extends Equatable {
  final String? Codigo_Convenio;
  final String? Cnpj_Convenio;
  final String? InscricaoEstadual_Convenio;
  final String? Nome_Convenio;
  final String? NomeFantasia_Convenio;
  final String? DataCadastro_Convenio;
  final String? EMail_Convenio;
  final String? Contato_Convenio;
  final String? DataNascimentoContato_Convenio;
  final String? Logradouro_Convenio;
  final String? NumEndereco_Convenio;
  final String? Cep_Convenio;
  final String? Cidade_Convenio;
  final String? Bairro_Convenio;
  final String? Estado_Convenio;
  final String? Complemento_Convenio;
  final String? Referencia_Convenio;
  final String? LogradouroEntrega_Convenio;
  final String? NumEnderecoEntrega_Convenio;
  final String? CepEntrega_Convenio;
  final String? CidadeEntrega_Convenio;
  final String? BairroEntrega_Convenio;
  final String? EstadoEntrega_Convenio;
  final String? ComplementoEntrega_Convenio;
  final String? ReferenciaEntrega_Convenio;
  final String? LogradouroCobranca_Convenio;
  final String? NumEnderecoCobranca_Convenio;
  final String? CepCobranca_Convenio;
  final String? CidadeCobranca_Convenio;
  final String? BairroCobranca_Convenio;
  final String? EstadoCobranca_Convenio;
  final String? ComplementoCobranca_Convenio;
  final String? ReferenciaCobranca_Convenio;
  final String? CodigoAreaTel1_Convenio;
  final String? Telefone1_Convenio;
  final String? CodigoAreaTel2_Convenio;
  final String? Telefone2_Convenio;
  final String? CodigoAreaTel3_Convenio;
  final String? Telefone3_Convenio;
  final String? NumeroConta_Convenio;
  final String? NomeConta_Convenio;
  final String? DigitoConta_Convenio;
  final String? AgenciaInstFinan_Convenio;
  final String? DigitoAgenciaInstFinan_Convenio;
  final String? CodigoLegado_Convenio;
  final int? CodigoInterno_Convenio;
  final int? CodigoInterno_GrupoFinanReceita;
  final int? CodigoInterno_CategFinanReceita;
  final int? CodigoInterno_SubCategFinanReceita;
  final int? CodigoInterno_InstFinan;
  final int? FlagCodigoPersonalizado_Convenio;
  final int? FlagObrigaMatriculaConvd_Convenio;
  final int? FlagPermCompraAdicional_Convenio;
  final int? FlagEnderecoContemNum_Convenio;
  final int? FlagEnderecoContemNumEntrega_Convenio;
  final int? FlagEnderecoContemNumCobranca_Convenio;

  const CovenantEntity({
    required this.Codigo_Convenio,
    required this.Cnpj_Convenio,
    required this.InscricaoEstadual_Convenio,
    required this.Nome_Convenio,
    required this.NomeFantasia_Convenio,
    required this.DataCadastro_Convenio,
    required this.EMail_Convenio,
    required this.Contato_Convenio,
    required this.DataNascimentoContato_Convenio,
    required this.Logradouro_Convenio,
    required this.NumEndereco_Convenio,
    required this.Cep_Convenio,
    required this.Cidade_Convenio,
    required this.Bairro_Convenio,
    required this.Estado_Convenio,
    required this.Complemento_Convenio,
    required this.Referencia_Convenio,
    required this.LogradouroEntrega_Convenio,
    required this.NumEnderecoEntrega_Convenio,
    required this.CepEntrega_Convenio,
    required this.CidadeEntrega_Convenio,
    required this.BairroEntrega_Convenio,
    required this.EstadoEntrega_Convenio,
    required this.ComplementoEntrega_Convenio,
    required this.ReferenciaEntrega_Convenio,
    required this.LogradouroCobranca_Convenio,
    required this.NumEnderecoCobranca_Convenio,
    required this.CepCobranca_Convenio,
    required this.CidadeCobranca_Convenio,
    required this.BairroCobranca_Convenio,
    required this.EstadoCobranca_Convenio,
    required this.ComplementoCobranca_Convenio,
    required this.ReferenciaCobranca_Convenio,
    required this.CodigoAreaTel1_Convenio,
    required this.Telefone1_Convenio,
    required this.CodigoAreaTel2_Convenio,
    required this.Telefone2_Convenio,
    required this.CodigoAreaTel3_Convenio,
    required this.Telefone3_Convenio,
    required this.NumeroConta_Convenio,
    required this.NomeConta_Convenio,
    required this.DigitoConta_Convenio,
    required this.AgenciaInstFinan_Convenio,
    required this.DigitoAgenciaInstFinan_Convenio,
    required this.CodigoLegado_Convenio,
    required this.CodigoInterno_Convenio,
    required this.CodigoInterno_GrupoFinanReceita,
    required this.CodigoInterno_CategFinanReceita,
    required this.CodigoInterno_SubCategFinanReceita,
    required this.CodigoInterno_InstFinan,
    required this.FlagCodigoPersonalizado_Convenio,
    required this.FlagObrigaMatriculaConvd_Convenio,
    required this.FlagPermCompraAdicional_Convenio,
    required this.FlagEnderecoContemNum_Convenio,
    required this.FlagEnderecoContemNumEntrega_Convenio,
    required this.FlagEnderecoContemNumCobranca_Convenio,
  });

  @override
  List<Object?> get props => [
    CodigoInterno_Convenio,
    Codigo_Convenio,
    Cnpj_Convenio,
    InscricaoEstadual_Convenio,
    Nome_Convenio,
    NomeFantasia_Convenio,
    DataCadastro_Convenio,
    EMail_Convenio,
    Contato_Convenio,
    DataNascimentoContato_Convenio,
    Logradouro_Convenio,
    NumEndereco_Convenio,
    Cep_Convenio,
    Cidade_Convenio,
    Bairro_Convenio,
    Estado_Convenio,
    Complemento_Convenio,
    Referencia_Convenio,
    LogradouroEntrega_Convenio,
    NumEnderecoEntrega_Convenio,
    CepEntrega_Convenio,
    CidadeEntrega_Convenio,
    BairroEntrega_Convenio,
    EstadoEntrega_Convenio,
    ComplementoEntrega_Convenio,
    ReferenciaEntrega_Convenio,
    LogradouroCobranca_Convenio,
    NumEnderecoCobranca_Convenio,
    CepCobranca_Convenio,
    CidadeCobranca_Convenio,
    BairroCobranca_Convenio,
    EstadoCobranca_Convenio,
    ComplementoCobranca_Convenio,
    ReferenciaCobranca_Convenio,
    CodigoInterno_GrupoFinanReceita,
    CodigoInterno_CategFinanReceita,
    CodigoInterno_SubCategFinanReceita,
    CodigoAreaTel1_Convenio,
    Telefone1_Convenio,
    CodigoAreaTel2_Convenio,
    Telefone2_Convenio,
    CodigoAreaTel3_Convenio,
    Telefone3_Convenio,
    CodigoInterno_InstFinan,
    NumeroConta_Convenio,
    NomeConta_Convenio,
    DigitoConta_Convenio,
    AgenciaInstFinan_Convenio,
    DigitoAgenciaInstFinan_Convenio,
    FlagCodigoPersonalizado_Convenio,
    FlagObrigaMatriculaConvd_Convenio,
    FlagPermCompraAdicional_Convenio,
    CodigoLegado_Convenio,
    FlagEnderecoContemNum_Convenio,
    FlagEnderecoContemNumEntrega_Convenio,
    FlagEnderecoContemNumCobranca_Convenio,
  ];

  CovenantEntity copyWith({
    String? Codigo_Convenio,
    String? Cnpj_Convenio,
    String? InscricaoEstadual_Convenio,
    String? Nome_Convenio,
    String? NomeFantasia_Convenio,
    String? DataCadastro_Convenio,
    String? EMail_Convenio,
    String? Contato_Convenio,
    String? DataNascimentoContato_Convenio,
    String? Logradouro_Convenio,
    String? NumEndereco_Convenio,
    String? Cep_Convenio,
    String? Cidade_Convenio,
    String? Bairro_Convenio,
    String? Estado_Convenio,
    String? Complemento_Convenio,
    String? Referencia_Convenio,
    String? LogradouroEntrega_Convenio,
    String? NumEnderecoEntrega_Convenio,
    String? CepEntrega_Convenio,
    String? CidadeEntrega_Convenio,
    String? BairroEntrega_Convenio,
    String? EstadoEntrega_Convenio,
    String? ComplementoEntrega_Convenio,
    String? ReferenciaEntrega_Convenio,
    String? LogradouroCobranca_Convenio,
    String? NumEnderecoCobranca_Convenio,
    String? CepCobranca_Convenio,
    String? CidadeCobranca_Convenio,
    String? BairroCobranca_Convenio,
    String? EstadoCobranca_Convenio,
    String? ComplementoCobranca_Convenio,
    String? ReferenciaCobranca_Convenio,
    String? CodigoAreaTel1_Convenio,
    String? Telefone1_Convenio,
    String? CodigoAreaTel2_Convenio,
    String? Telefone2_Convenio,
    String? CodigoAreaTel3_Convenio,
    String? Telefone3_Convenio,
    String? NumeroConta_Convenio,
    String? NomeConta_Convenio,
    String? DigitoConta_Convenio,
    String? AgenciaInstFinan_Convenio,
    String? DigitoAgenciaInstFinan_Convenio,
    String? CodigoLegado_Convenio,
    int? CodigoInterno_Convenio,
    int? CodigoInterno_GrupoFinanReceita,
    int? CodigoInterno_CategFinanReceita,
    int? CodigoInterno_SubCategFinanReceita,
    int? CodigoInterno_InstFinan,
    int? FlagCodigoPersonalizado_Convenio,
    int? FlagObrigaMatriculaConvd_Convenio,
    int? FlagPermCompraAdicional_Convenio,
    int? FlagEnderecoContemNum_Convenio,
    int? FlagEnderecoContemNumEntrega_Convenio,
    int? FlagEnderecoContemNumCobranca_Convenio,
  }) {
    return CovenantEntity(
      Codigo_Convenio: Codigo_Convenio ?? this.Codigo_Convenio,
      Cnpj_Convenio: Cnpj_Convenio ?? this.Cnpj_Convenio,
      InscricaoEstadual_Convenio:
          InscricaoEstadual_Convenio ?? this.InscricaoEstadual_Convenio,
      Nome_Convenio: Nome_Convenio ?? this.Nome_Convenio,
      NomeFantasia_Convenio:
          NomeFantasia_Convenio ?? this.NomeFantasia_Convenio,
      DataCadastro_Convenio:
          DataCadastro_Convenio ?? this.DataCadastro_Convenio,
      EMail_Convenio: EMail_Convenio ?? this.EMail_Convenio,
      Contato_Convenio: Contato_Convenio ?? this.Contato_Convenio,
      DataNascimentoContato_Convenio:
          DataNascimentoContato_Convenio ?? this.DataNascimentoContato_Convenio,
      Logradouro_Convenio: Logradouro_Convenio ?? this.Logradouro_Convenio,
      NumEndereco_Convenio: NumEndereco_Convenio ?? this.NumEndereco_Convenio,
      Cep_Convenio: Cep_Convenio ?? this.Cep_Convenio,
      Cidade_Convenio: Cidade_Convenio ?? this.Cidade_Convenio,
      Bairro_Convenio: Bairro_Convenio ?? this.Bairro_Convenio,
      Estado_Convenio: Estado_Convenio ?? this.Estado_Convenio,
      Complemento_Convenio: Complemento_Convenio ?? this.Complemento_Convenio,
      Referencia_Convenio: Referencia_Convenio ?? this.Referencia_Convenio,
      LogradouroEntrega_Convenio:
          LogradouroEntrega_Convenio ?? this.LogradouroEntrega_Convenio,
      NumEnderecoEntrega_Convenio:
          NumEnderecoEntrega_Convenio ?? this.NumEnderecoEntrega_Convenio,
      CepEntrega_Convenio: CepEntrega_Convenio ?? this.CepEntrega_Convenio,
      CidadeEntrega_Convenio:
          CidadeEntrega_Convenio ?? this.CidadeEntrega_Convenio,
      BairroEntrega_Convenio:
          BairroEntrega_Convenio ?? this.BairroEntrega_Convenio,
      EstadoEntrega_Convenio:
          EstadoEntrega_Convenio ?? this.EstadoEntrega_Convenio,
      ComplementoEntrega_Convenio:
          ComplementoEntrega_Convenio ?? this.ComplementoEntrega_Convenio,
      ReferenciaEntrega_Convenio:
          ReferenciaEntrega_Convenio ?? this.ReferenciaEntrega_Convenio,
      LogradouroCobranca_Convenio:
          LogradouroCobranca_Convenio ?? this.LogradouroCobranca_Convenio,
      NumEnderecoCobranca_Convenio:
          NumEnderecoCobranca_Convenio ?? this.NumEnderecoCobranca_Convenio,
      CepCobranca_Convenio: CepCobranca_Convenio ?? this.CepCobranca_Convenio,
      CidadeCobranca_Convenio:
          CidadeCobranca_Convenio ?? this.CidadeCobranca_Convenio,
      BairroCobranca_Convenio:
          BairroCobranca_Convenio ?? this.BairroCobranca_Convenio,
      EstadoCobranca_Convenio:
          EstadoCobranca_Convenio ?? this.EstadoCobranca_Convenio,
      ComplementoCobranca_Convenio:
          ComplementoCobranca_Convenio ?? this.ComplementoCobranca_Convenio,
      ReferenciaCobranca_Convenio:
          ReferenciaCobranca_Convenio ?? this.ReferenciaCobranca_Convenio,
      CodigoAreaTel1_Convenio:
          CodigoAreaTel1_Convenio ?? this.CodigoAreaTel1_Convenio,
      Telefone1_Convenio: Telefone1_Convenio ?? this.Telefone1_Convenio,
      CodigoAreaTel2_Convenio:
          CodigoAreaTel2_Convenio ?? this.CodigoAreaTel2_Convenio,
      Telefone2_Convenio: Telefone2_Convenio ?? this.Telefone2_Convenio,
      CodigoAreaTel3_Convenio:
          CodigoAreaTel3_Convenio ?? this.CodigoAreaTel3_Convenio,
      Telefone3_Convenio: Telefone3_Convenio ?? this.Telefone3_Convenio,
      NumeroConta_Convenio: NumeroConta_Convenio ?? this.NumeroConta_Convenio,
      NomeConta_Convenio: NomeConta_Convenio ?? this.NomeConta_Convenio,
      DigitoConta_Convenio: DigitoConta_Convenio ?? this.DigitoConta_Convenio,
      AgenciaInstFinan_Convenio:
          AgenciaInstFinan_Convenio ?? this.AgenciaInstFinan_Convenio,
      DigitoAgenciaInstFinan_Convenio:
          DigitoAgenciaInstFinan_Convenio ??
          this.DigitoAgenciaInstFinan_Convenio,
      CodigoLegado_Convenio:
          CodigoLegado_Convenio ?? this.CodigoLegado_Convenio,
      CodigoInterno_Convenio:
          CodigoInterno_Convenio ?? this.CodigoInterno_Convenio,
      CodigoInterno_GrupoFinanReceita:
          CodigoInterno_GrupoFinanReceita ??
          this.CodigoInterno_GrupoFinanReceita,
      CodigoInterno_CategFinanReceita:
          CodigoInterno_CategFinanReceita ??
          this.CodigoInterno_CategFinanReceita,
      CodigoInterno_SubCategFinanReceita:
          CodigoInterno_SubCategFinanReceita ??
          this.CodigoInterno_SubCategFinanReceita,
      CodigoInterno_InstFinan:
          CodigoInterno_InstFinan ?? this.CodigoInterno_InstFinan,
      FlagCodigoPersonalizado_Convenio:
          FlagCodigoPersonalizado_Convenio ??
          this.FlagCodigoPersonalizado_Convenio,
      FlagObrigaMatriculaConvd_Convenio:
          FlagObrigaMatriculaConvd_Convenio ??
          this.FlagObrigaMatriculaConvd_Convenio,
      FlagPermCompraAdicional_Convenio:
          FlagPermCompraAdicional_Convenio ??
          this.FlagPermCompraAdicional_Convenio,
      FlagEnderecoContemNum_Convenio:
          FlagEnderecoContemNum_Convenio ?? this.FlagEnderecoContemNum_Convenio,
      FlagEnderecoContemNumEntrega_Convenio:
          FlagEnderecoContemNumEntrega_Convenio ??
          this.FlagEnderecoContemNumEntrega_Convenio,
      FlagEnderecoContemNumCobranca_Convenio:
          FlagEnderecoContemNumCobranca_Convenio ??
          this.FlagEnderecoContemNumCobranca_Convenio,
    );
  }
}
